# Tutorial: Top 5 Ranking com personagens 3D

Ranking visual com modelos 3D dos personagens (igual ao F8 nativo), usando
`User.SendCharacterRender` no servidor e `Client.RenderStoredCharacter` no
cliente.

## Resultado

Comando `/luatop` abre uma sobreposicao com os 5 personagens de maior level,
cada um renderizado com sua classe, armadura, asas e mount. Funciona para
personagens online e offline.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\TopRanking.lua
```

Cliente:

```text
Data\Custom\Lua\Systems\TopRanking.lua
```

## Script do servidor

```lua
command:add("/luatop", function(playerIndex)
    local db = DataBase.getDb()
    if db == nil then return end

    if db:exec("SELECT TOP 5 Name, cLevel FROM Character ORDER BY cLevel DESC, ResetCount DESC") == 0 then
        return
    end

    local slot = 0
    while db:fetch() ~= SQL_NO_DATA do
        slot = slot + 1
        -- ler colunas em ordem crescente do SELECT (restricao ODBC)
        local charName = db:getStr("Name")
        local cLevel = db:getInt("cLevel")

        User.SendClientPacket(playerIndex, "TopRank",
            string.format("%d|%s|%d", slot, charName, cLevel))

        User.SendCharacterRender(playerIndex, 2000 + slot, charName)
    end
    DataBase.Clear()
end)
```

### Detalhes

- **Ordem dos `db:getX`**: o driver ODBC exige leitura em ordem crescente
  de coluna do `SELECT`. Ler ao contrario retorna string vazia.

- **`renderId`**: inteiro arbitrario, deve ser unico por slot e nao colidir
  com outros sistemas que usem PhotoViewer.

- **`User.SendCharacterRender`** valida o nome contra `[A-Za-z0-9_]{1,10}`
  antes do request ao DataServer. Nomes invalidos retornam `false`.

## Script do cliente

```lua
local entries = {}

Client.OnPacket(function(name, payload)
    if name ~= "TopRank" then return end
    local slot, charName, level = payload:match("(%d+)|([^|]+)|(%d+)")
    if slot == nil then return end
    entries[tonumber(slot)] = {
        name = charName,
        level = tonumber(level),
    }
end)

ClientHooks.RegisterRender("TopRanking", function()
    for slot = 1, 5 do
        local e = entries[slot]
        if e then
            local x = 80 + (slot - 1) * 150
            local y = 200
            Client.RenderColorBox(x - 4, y - 4, 128, 168, 0, 0, 0, 180)
            Client.RenderStoredCharacter(2000 + slot, x, y, 120, 160, 90, 0.8, 0)
            Client.RenderText(x, y + 165, string.format("#%d %s", slot, e.name),
                120, 14, 1, 255, 255, 255, 255)
            Client.RenderText(x, y + 180, string.format("Lv %d", e.level),
                120, 14, 1, 200, 200, 200, 255)
        end
    end
end)
```

### Fluxo

1. Servidor envia dois pacotes por slot:
   - `TopRank` com `slot|nome|level`.
   - Pacote interno `0xFB:0xE2` com classe + equipamento (via `SendCharacterRender`).
2. Cliente recebe `TopRank` e popula `entries[slot]`.
3. Hook de render desenha cada slot. `RenderStoredCharacter` usa o mesmo
   `PhotoViewer` do F8 nativo.

### Personagem offline

Quando o personagem esta offline, o GS consulta o DataServer. O primeiro
`/luatop` introduz um delay de 50-200 ms; o cliente desenha silhueta cinza
e atualiza quando os dados chegam. O cache do GS (TTL 30s) responde
instantaneamente nas chamadas seguintes para o mesmo nome.

## Extensoes

- **Mais slots**: troque `1..5` por `1..10`. `renderId` continua sequencial.
- **Filtros**: ajuste o `SELECT` (ex.: `ORDER BY ResetCount DESC`, `WHERE Class IN (16,17,18)`).
- **Auto-refresh**: chame `/luatop` em loop com `Timer.Interval`.
- **Toggle**: controle a renderizacao com uma flag global ligada por `ClientHooks.RegisterUpdateKey`.

## Limitacoes

- Personagens excluidos ou nunca criados: silhueta vazia (`found=0`).
- Personagens em outro server: nao aparecem (cada GS tem seu DataServer).
- Equipamento nao reflete mudancas em tempo real: cache TTL 30s. Para
  refresh imediato, chame `User.SendCharacterRender` de novo no mesmo `renderId`.
