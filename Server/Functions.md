# Server Side - Functions

Funcoes disponiveis para scripts que rodam no GameServer.

## LogPrint

```lua
LogPrint(text)
```

Escreve uma mensagem no log do GameServer.

Exemplo:

```lua
LogPrint("Sistema iniciado")
```

## LogAddC / LogColor

```lua
LogAddC(type, text)
LogColor(type, text)
```

Escreve mensagem colorida no log.

Exemplo:

```lua
LogAddC(4, "Mensagem azul")
```

## SendMessage

```lua
SendMessage(text, playerIndex, type)
```

Envia mensagem para um jogador.

Parametros:

- `text`: texto.
- `playerIndex`: index do jogador.
- `type`: tipo/cor da mensagem.

Exemplo:

```lua
SendMessage("Ola jogador!", playerIndex, 1)
```

## SendMessageGlobal

```lua
SendMessageGlobal(text, type)
```

Envia mensagem global.

Exemplo:

```lua
SendMessageGlobal("Evento iniciado!", 1)
```

> `SendMessage`/`SendMessageGlobal` usam o sistema de **notice** (aparece no frame de aviso, geralmente no topo). Para o estilo do **`/post` nativo** (aparece embaixo, no chat global), use `SendGlobalPost` abaixo.

## SendGlobalPost

```lua
SendGlobalPost(nome, mensagem [, tipo])
```

Publica um **post global** identico ao comando `/post` nativo (a linha `[POST]` que aparece no chat de todos os jogadores). `nome` e o autor exibido; `tipo` (opcional, padrao `0`) seleciona o estilo do post — deixe `0` para o mesmo estilo do `/post` do seu servidor.

Exemplo:

```lua
SendGlobalPost(player:getName(), "Vendendo itens raros!", 0)
```

Usado, por exemplo, pelo sistema AutoPost (`/post auto`) para repetir o anuncio no mesmo estilo do `/post` comum.

## GetServerCode

```lua
GetServerCode()
```

Retorna o code do servidor atual (o mesmo do ConnectServer). Serve para um script rodar so em um servidor quando ha varios. Ex.: `0` = GameServer, `19` = GameServerCS.

Exemplo:

```lua
if GetServerCode() == 0 then
	SendMessageGlobal("Rodando so no servidor principal", 1)
end
```

## OpenFolder

```lua
OpenFolder(path)
```

Carrega todos os scripts Lua de uma pasta.

Exemplo:

```lua
OpenFolder("LuaSystem")
OpenFolder("Custom\\Configs")
OpenFolder("Custom\\System")
```

## OpenExtension

```lua
OpenExtension(path)
```

Carrega um arquivo Lua especifico.

Exemplo:

```lua
OpenExtension("Custom\\MeuSistema.lua")
```

## LuaAPI / LuaSecurity

```lua
LuaAPI.GetVersion()
LuaAPI.GetInfo()

LuaSecurity.StrictMode
LuaSecurity.WarnOnly
LuaSecurity.MaxCallbackMs
LuaSecurity.LogSlowCallbacks
```

`LuaAPI` informa a versao da API Lua carregada pelo GameServer.

`LuaSecurity` concentra configuracoes de seguranca em modo compativel.

Exemplo:

```lua
local info = LuaAPI.GetInfo()
LogPrint(string.format("LuaAPI %s compat=%s", info.version, info.compatibility))
```

Campos retornados por `LuaAPI.GetInfo()`:

- `version`: versao da API Lua.
- `buildDate`: data da base Lua.
- `compatibility`: familia de compatibilidade atual.

Configuracoes iniciais:

```lua
LuaSecurity.StrictMode = false
LuaSecurity.WarnOnly = true
LuaSecurity.MaxCallbackMs = 100
LuaSecurity.LogSlowCallbacks = true
```

Quando `LuaSecurity.LogSlowCallbacks` esta ativo, callbacks protegidos que passam de `MaxCallbackMs` geram log em `LOGS\LOG\LuaCore_YYYY-MM-DD.txt`, mas continuam funcionando.

## LuaCore

```lua
LuaCore.SafeCall(context, callback, ...)
LuaCore.RegisterCallback(list, eventName, callback)
```

`LuaCore` protege callbacks com `xpcall`; erros vao para `LOGS\LOG\LuaCore_YYYY-MM-DD.txt` e demais scripts continuam executando. Uso direto reservado para sistemas avancados.

Exemplo:

```lua
local ok = LuaCore.SafeCall("MeuSistema.Teste", function()
	error("erro de teste")
end)

if not ok then
	LogPrint("erro capturado")
end
```

## User.new

```lua
local player = User.new(playerIndex)
```

Cria um objeto para acessar dados e acoes do jogador/objeto.

Exemplo:

```lua
local player = User.new(playerIndex)
SendMessage("Seu nome: " .. player:getName(), playerIndex, 1)
```

## User.getByName

```lua
local player = User.getByName(name)
```

Busca jogador online pelo nome.

Exemplo:

```lua
local player = User.getByName("Admin")
if player ~= nil then
	SendMessage("Encontrado: " .. player:getName(), player:getIndex(), 1)
end
```

## User - leitura comum

```lua
player:getIndex()
player:getName()
player:getAccount()
player:getLevel()
player:getClass()
player:getMap()
player:getX()
player:getY()
player:getMoney()
player:getStrength()
player:getDexterity()
player:getVitality()
player:getEnergy()
player:getLeadership()
```

Exemplo:

```lua
local player = User.new(playerIndex)
local msg = string.format("Level %d Map %d %d/%d", player:getLevel(), player:getMap(), player:getX(), player:getY())
SendMessage(msg, playerIndex, 1)
```

## User - escrita comum

```lua
player:setMoney(value)
player:setLevelUpPoint(value)
player:addMoney(value)
player:addLevelUpPoint(value)
player:addStrength(value)
player:addDexterity(value)
player:addVitality(value)
player:addEnergy(value)
player:addLeadership(value)
```

Exemplo:

```lua
local player = User.new(playerIndex)
player:addMoney(1000000)
SendMessage("Zen adicionado.", playerIndex, 1)
```

## Teleport

```lua
player:teleport(map, x, y)
```

Move o jogador para um mapa/posicao.

Exemplo:

```lua
local player = User.new(playerIndex)
player:teleport(0, 125, 125)
```

## Command

```lua
command:add(commandText, callback)
```

Registra comando custom.

Os callbacks de comandos sao protegidos pelo LuaCore. Um erro dentro de um comando e registrado em `LOGS\LOG\LuaCore_YYYY-MM-DD.txt` e nao derruba os demais callbacks Lua.

Exemplo:

```lua
command:add("/info", function(playerIndex, args, message)
	local player = User.new(playerIndex)
	SendMessage("Ola, " .. player:getName(), playerIndex, 1)
end)
```

### Ceder o comando ao nativo (retornar `false`)

Se o callback retornar **`false`**, o comando e tratado como "nao tratado" e o **comando nativo** do GameServer assume. Util para reaproveitar um comando nativo e so interceptar um subcomando. Retornar `nil`/`true` (o padrao) mantem o comando tratado pelo Lua.

```lua
-- intercepta apenas "/post auto ..."; qualquer outro /post cai no nativo
command:add("/post", function(playerIndex, args, message)
	if (args[1] or ""):lower() ~= "auto" then
		return false   -- deixa o /post nativo agir
	end
	-- ... trata o auto post aqui ...
	return true
end)
```

## Timer

```lua
Timer.Interval(seconds, callback)
```

Executa uma funcao repetidamente.

Os callbacks de timer sao protegidos pelo LuaCore. Um erro dentro de um timer e registrado em `LOGS\LOG\LuaCore_YYYY-MM-DD.txt` e nao interrompe o restante da base Lua.

Exemplo:

```lua
Timer.Interval(60, function()
	SendMessageGlobal("Mensagem a cada 60 segundos", 1)
end)
```

## DataBase

```lua
DataBase.Connect(dbType, odbc, user, password)
DataBase.Close()
DataBase.Clear()
DataBase.Exec(sql)
DataBase.Query(sql)
DataBase.QueryGetNumber(sql, column)
DataBase.QueryGetString(sql, column)
DataBase.GetValue(tableName, columnName, whereColumn, whereValue)
DataBase.GetString(tableName, columnName, whereColumn, whereValue)
DataBase.SetValue(tableName, columnName, value, whereColumn, whereValue)
DataBase.SetString(tableName, columnName, value, whereColumn, whereValue)
DataBase.SetAddValue(tableName, columnName, value, whereColumn, whereValue)
DataBase.SetDecreaseValue(tableName, columnName, value, whereColumn, whereValue)
DataBase.CreateColumn(tableName, columnName, definition)
DataBase.RunAfterLoad(callback)
```

Executa consultas SQL.

Callbacks registrados em `DataBase.RunAfterLoad(callback)` sao executados com protecao do `LuaCore` apos a conexao do banco. Se o callback gerar erro, o erro vai para `LOGS\LOG\LuaCore_YYYY-MM-DD.txt`.

A conexao usa os dados enviados no `GameServer.lua`. Mesmo que o ODBC do Windows esteja configurado como conexao confiavel, o bridge Lua força `Trusted_Connection=No` e autentica com `user` e `password` informados em `DataBase.Connect`.

Exemplo de startup:

```lua
function GameServer()
	DataBase.Connect(3, "MuOnline", "sa", "senha")
end
```

Para leitura de varias linhas, use uma conexao/cursor:

```lua
local db = DataBase.getDb()

if db:exec("SELECT Id, Name FROM MinhaTabela ORDER BY Id") == 1 then
	while db:fetch() ~= SQL_NO_DATA do
		local id = db:getInt("Id")
		local name = db:getStr("Name")
	end
end

DataBase.Clear()
```

Metodos disponiveis no cursor:

```lua
db:exec(sql)
db:fetch()
db:getInt(column)
db:getFloat(column)
db:getStr(column)
```

`db:getInt`, `db:getFloat` e `db:getStr` leem pelo nome da coluna retornada no `SELECT`. Quando usar aliases, informe o alias no metodo. Em leituras linha a linha, leia as colunas na mesma ordem do `SELECT`.

Exemplo:

```lua
local account = "genesys"
local cash = DataBase.QueryGetNumber("SELECT WCoinC FROM CashShopData WHERE AccountID='" .. account .. "'", "WCoinC")
```

Validar entrada de jogador antes de concatenar em SQL.

Padrao para economia: ver README "Padrao para sistemas com economia".

## DataBaseAsync

```lua
DataBaseAsync.Query(name, query, getResult, playerIndex)
DataBaseAsync.GetStatus(name)
DataBaseAsync.GetValue(name, column)
DataBaseAsync.Delete(name)
DataBaseAsync.SetValue(tableName, columnName, value, whereColumn, whereValue)
DataBaseAsync.SetString(tableName, columnName, value, whereColumn, whereValue)
DataBaseAsync.SetAddValue(tableName, columnName, value, whereColumn, whereValue)
DataBaseAsync.SetDecreaseValue(tableName, columnName, value, whereColumn, whereValue)
```

Executa consultas sem travar o fluxo principal do GameServer.

## Inventory

```lua
GET_ITEM(section, index)
GetItemCount(playerIndex, section, index, level)
TakeItem(playerIndex, section, index, level, count)
InventoryCheckSpaceByItem(playerIndex, itemIndex)
InventoryCheckSpaceByItems(playerIndex, itemIndexes)
InventoryCheckSpace(playerIndex, width, height)
GetInventoryItemIndex(playerIndex, slot)
GetInventoryItemLevel(playerIndex, slot)
GetInventoryItemDurability(playerIndex, slot)
TakeInventorySlot(playerIndex, slot)
```

Funcoes para consultar e consumir itens do inventario do jogador.

Parametros:

- `playerIndex`: index do jogador.
- `section`: grupo do item.
- `index`: numero do item dentro do grupo.
- `level`: level do item. Use `-1` para aceitar qualquer level nas funcoes por tipo.
- `count`: quantidade a remover.
- `slot`: posicao do item no inventario.

Retornos:

- `GET_ITEM`: item index completo, ou `-1` se `section/index` forem invalidos.
- `GetItemCount`: quantidade encontrada.
- `TakeItem`: quantidade removida, ou `0` se nao foi possivel remover.
- `InventoryCheckSpaceByItem`: `1` se ha espaco para o item informado.
- `InventoryCheckSpaceByItems`: `1` se ha espaco para todos os itens da tabela, simulando a ocupacao do lote antes da entrega.
- `InventoryCheckSpace`: `1` se ha espaco para um item com largura/altura informadas.
- `GetInventoryItemIndex`: item index completo do slot, ou `-1` se o slot estiver vazio/invalido.
- `GetInventoryItemLevel`: level do item no slot, ou `-1` se o slot estiver vazio/invalido.
- `GetInventoryItemDurability`: durabilidade do item no slot (0..255), ou `-1` se o slot estiver vazio/invalido. Util para verificar desgaste antes de oferecer reparo, consumir charges ou aplicar buff que dependa de equipamento intacto.
- `TakeInventorySlot`: `1` se removeu o item do slot informado, ou `0` se nao foi possivel remover.

Exemplo por tipo de item:

```lua
local count = GetItemCount(playerIndex, 14, 13, -1)
if count >= 1 then
	TakeItem(playerIndex, 14, 13, -1, 1)
end
```

Exemplo por slot:

```lua
local itemIndex = GetInventoryItemIndex(playerIndex, slot)
local itemLevel = GetInventoryItemLevel(playerIndex, slot)

if itemIndex > 0 and itemLevel >= 0 then
	TakeInventorySlot(playerIndex, slot)
end
```

Antes de `GiveItem`, use `InventoryCheckSpaceByItem`. Para multiplos itens, prefira `InventoryCheckSpaceByItems` (valida o lote).

Na API orientada a objeto, `User:hasInventorySpaceForItems(items)` faz a mesma
validacao de lote usando entradas `{ section, index, count }`. Consulte
`Server\User.md` para a assinatura e um exemplo completo.

## Packet server -> client

```lua
User.SendClientPacket(playerIndex, packetName, data)
```

Envia pacote custom do GameServer para o Main Lua.

Exemplo:

```lua
User.SendClientPacket(playerIndex, "OpenNotice", "vip")
```

## Render de personagem

```lua
User.SendCharacterRender(playerIndex, renderId, charName)
```

Envia classe + equipamento de um personagem para o cliente desenhar com
`Client.RenderStoredCharacter`. Veja `Server/User.md` e
`Tutorials/TopRanking/README.md`.

## Packet builder server-side

```lua
CreatePacket(name, subHead)
ClearPacket(name)
SendPacket(name, playerIndex)
SetBytePacket(name, value)
SetWordPacket(name, value)
SetDwordPacket(name, value)
SetCharPacketLength(name, text, length)
GetBytePacket(name, position)
GetWordPacket(name, position)
GetDwordPacket(name, position)
GetCharPacketLength(name, position, length)
```

Monta e envia payload binario custom para o cliente.

## Itens, monstro e personagem

```lua
GiveItem(playerIndex, section, index, level, durability, skill, luck, option, excellent, setOption, harmony, itemOptionEx, duration)
CreateItemMap(map, x, y, section, index, level, durability, skill, luck, option, excellent, setOption, harmony, itemOptionEx, duration)
ItemSerialCreate(playerIndex, map, x, y, itemIndex, level, durability, skill, luck, option, playerIndexTarget, excellent, setOption, harmony, itemOptionEx, socketOption, duration)
ItemSerialCreatePeriodic(playerIndex, map, x, y, itemIndex, level, durability, skill, luck, option, playerIndexTarget, excellent, setOption, harmony, itemOptionEx, socketOption, duration)
AddMonster(monsterClass, map, x, y, dir)
SetMonster(monsterIndex, monsterClass)
SetMapMonster(map, monsterClass, x, y, dir)
CloseChar(playerIndex)
Disconnect(playerIndex)
RequestReloadScripts()
GetUserIndexByName(name)
GetUserByName(name)
SendLuaPacket(playerIndex, packetName, data)
FireworksSend(playerIndex, x, y)
```

`FireworksSend` dispara o efeito visual de fogos na posicao informada. Se `x` e `y` forem omitidos, usa a posicao atual do personagem.

## Npc

Cria e controla um NPC em tempo real, util para eventos. O visual vem da classe informada (id de NPC/monstro).

```lua
Npc.Spawn(class, map, x, y, dir)                       -- cria; retorna o indice do NPC ou -1
Npc.Remove(index)                                      -- remove o NPC criado
Npc.OpenShop(playerIndex, shopNumber [, skipConfirm])  -- abre uma loja nativa para o jogador
Npc.CloseShop(shopNumber)                              -- fecha essa loja em quem estiver com ela aberta
```

`shopNumber` e o indice da loja no `ShopManager.txt`. Em `Npc.OpenShop`, `skipConfirm = true` pula a caixa "Deseja comprar?" (compra direta) so nessa loja.

Exemplo:

```lua
local idx = Npc.Spawn(236, 0, 135, 127, 3)   -- Golden Archer em Lorencia

GameServerFunctions.NpcTalk(function(npcIndex, playerIndex)
	if npcIndex == idx then
		Npc.OpenShop(playerIndex, 26, true)   -- abre a loja 26 sem confirmacao
		return true
	end
	return false
end)
```

## Party

```lua
GetPartyMemberCount(partyNumber)
GetPartyMemberIndex(partyNumber, memberSlot)
GetPartyMemberNumber(playerIndex)
IsMemberParty(playerIndex)
IsPartyLeader(playerIndex)
GetPartyMembers(playerIndex)
```

`GetPartyMembers` retorna uma tabela com os indices dos membros da party do jogador.
