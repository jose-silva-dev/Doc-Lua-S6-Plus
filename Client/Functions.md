# Client Side - Functions

Funcoes disponiveis para scripts que rodam no Main/cliente.

Para scripts novos, prefira `Client.X`.

## Texto

### Client.RenderText

```lua
Client.RenderText(x, y, text, width, height, sort, red, green, blue, alpha)
```

Desenha texto na tela.

Parametros:

- `x`, `y`: posicao.
- `text`: texto.
- `width`, `height`: area.
- `sort`: alinhamento.
- `red`, `green`, `blue`, `alpha`: cor.

Exemplo:

```lua
Client.RenderText(20, 90, "Ola mundo", 200, 0, 1, 255, 255, 255, 255)
```

### Client.SetTextColor / SetTextBg / SetFontType

```lua
Client.SetTextColor(red, green, blue, alpha)
Client.SetTextBg(red, green, blue, alpha)
Client.SetFontType(fontType)
Client.RenderBox(x, y, width, height, alpha)
Client.RenderColorBox(x, y, width, height, red, green, blue, alpha)
```

Define estado de texto para renderizacoes seguintes.

Exemplo:

```lua
Client.SetFontType(1)
Client.SetTextColor(255, 220, 80, 255)
Client.RenderText(20, 120, "Texto destacado", 220, 0, 1, -1, -1, -1, -1)
```

## Imagens e som

### Client.LoadImage

```lua
Client.LoadImage(path, imageId)
Client.GetImageWidth(imageId)
Client.GetImageHeight(imageId)
```

Carrega imagem do cliente.

Exemplo:

```lua
Client.LoadImage("Custom\\Lua\\Cache\\banner.jpg", 92010)
```

Em assets convertidos do cliente, e comum o script apontar para `.tga` enquanto o arquivo fisico esta em `.ozt`. Exemplo:

```lua
Client.LoadImage("Custom\\Interface\\HP\\hp.tga", 73001)
```

Arquivo fisico esperado:

```text
Data\Custom\Interface\HP\hp.ozt
```

### Client.RenderImage

```lua
Client.RenderImage(imageId, x, y, width, height)
```

Renderiza imagem carregada.

Exemplo:

```lua
Client.RenderImage(92010, 120, 90, 300, 120)
```

### Client.RenderImageUV

```lua
Client.RenderImageUV(imageId, x, y, width, height, u, v, uWidth, vHeight)
```

Renderiza parte de uma imagem.

### Client.UnloadImage

```lua
Client.UnloadImage(imageId)
```

Remove imagem da memoria.

### Client.LoadSound

```lua
soundId = Client.LoadSound(path [, soundId])
```

Carrega um efeito sonoro personalizado em formato **WAV PCM**. O caminho e relativo a pasta do cliente.

Retorna o ID carregado ou `-1` em caso de erro. Se o ID for omitido, o cliente escolhe automaticamente um ID livre entre `10000` e `10127`.

Exemplo:

```lua
local soundId = Client.LoadSound("Data\\Custom\\Sound\\reward.wav")

if soundId ~= -1 then
    Client.PlaySound(soundId)
end
```

Quando o sistema nao precisar mais do som:

```lua
Client.StopSound(soundId)
Client.UnloadSound(soundId)
```

Para escolher o ID manualmente:

```lua
local soundId = Client.LoadSound("Data\\Custom\\Sound\\reward.wav", 10000)
```

O ID manual deve estar entre `10000` e `10127`. Se ele ja estiver em uso, descarregue-o antes de reutilizar. Podem existir ate 128 sons personalizados carregados ao mesmo tempo.

### Client.UnloadSound

```lua
Client.UnloadSound(soundId)
```

Para e remove da memoria um som personalizado. Os sons tambem sao liberados automaticamente ao recarregar os scripts ou fechar o cliente.

### Client.PlaySound / StopSound

```lua
Client.PlaySound(soundId)
Client.StopSound(soundId)
```

Toca ou para um som carregado. Retorna `true` em caso de sucesso e `false` se o ID nao estiver carregado.

Use o ID retornado por `Client.LoadSound`. Estas funcoes podem ser usadas em botoes, alertas, recompensas, eventos, NPCs e outros sistemas Lua.

## Janela/interface

```lua
Client.IsWindowOpen(windowId)
Client.OpenWindow(windowId)
Client.CloseWindow(windowId)
Client.ToggleWindow(windowId)
Client.HideAllInterfaces()
Client.LockInterface()
Client.UnlockInterface()
Client.LockPlayerWalk()
Client.UnlockPlayerWalk()
Client.IsInterfaceLocked()
Client.IsPlayerWalkLocked()
Client.BlockMouse()
Client.ConsumeKey(vk)
```

Exemplo:

```lua
if not Client.IsWindowOpen(ClientAPI.Windows.Inventory) then
	Client.OpenWindow(ClientAPI.Windows.Inventory)
end
```

## Mouse e teclado

```lua
Client.IsKeyDown(vk)
Client.ConsumeKey(vk)
Client.IsKeyboardInputCaptured()
Client.GetMouseX()
Client.GetMouseY()
Client.GetMouseWheel()
Client.PeekMouseWheel()
Client.IsMouseLeftButton()
Client.IsMouseRightButton()
Client.IsMouseLeftButtonPush()
Client.IsMouseRightButtonPush()
Client.IsMouseLeftButtonPop()
Client.IsMouseRightButtonPop()
Client.IsWindowActive()
```

`Client.IsKeyboardInputCaptured()` retorna `true` quando o teclado esta focado em chat/editbox nativo ou quando uma janela Lua travou a interface. Use antes de atalhos globais lidos por `Client.IsKeyDown`.

Exemplo:

```lua
if Client.IsKeyDown(0x78) then -- F9
	MyWindow.open = not MyWindow.open
end

if MyWindow.open and Client.IsKeyDown(0x1B) then -- ESC
	Client.ConsumeKey(0x1B)
	MyWindow.open = false
end
```

`Client.ConsumeKey(vk)` deve ser chamado quando a janela Lua tratou uma tecla que tambem possui acao nativa. Para `ESC`, isso impede que o mesmo pressionamento continue abrindo o menu de opcoes ou fechando outras janelas nativas; a tecla permanece bloqueada ate ser solta.

### Reload do Lua do cliente

Quando o servidor/cliente distribuido tiver a opcao abaixo ativada no `MainInfo`, o `F6` recarrega o Lua do cliente sem fechar o Main:

```ini
[Lua]
ClientLuaReload = 1
```

Esse atalho e restrito a personagem GM/Admin. Com `ClientLuaReload = 0`, o atalho fica desativado.

Para janelas acima do HUD, registre o desenho em `ClientHooks.RegisterRenderTop(name, callback)` ou implemente o callback global `RenderTop()`.

## Dados do personagem local

```lua
Client.GetName()
Client.GetLevel()
Client.GetClass()
Client.GetMap()
Client.GetX()
Client.GetY()
Client.GetLife()
Client.GetMaxLife()
Client.GetMana()
Client.GetMaxMana()
Client.GetBP()
Client.GetMaxBP()
Client.GetShield()
Client.GetMaxShield()
Client.GetStatsPoint()
Client.GetStrength()
Client.GetDexterity()
Client.GetVitality()
Client.GetEnergy()
Client.GetLeadership()
Client.GetExperience()
Client.GetNextExperience()
Client.GetBaseExperience()
Client.GetMasterLevel()
Client.GetMasterPoint()
Client.GetMasterExperience()
Client.GetMasterNextExperience()
```

Exemplo:

```lua
local text = string.format("%s Level %d", Client.GetName(), Client.GetLevel())
Client.RenderText(20, 80, text, 240, 0, 1, 255, 255, 255, 255)
```

## Informacoes globais do cliente

```lua
Client.GetLanguage()
Client.GetCodePage()
Client.GetResolution()
ClientAPI.GetResolutionInfo()
Client.GetVolume()
Client.SetVolume(level)
Client.GetWindowWidth()
Client.GetWindowHeight()
Client.GetInterfaceWidth()
Client.GetInterfaceHeight()
Client.GetOpenGLWindowWidth()
Client.GetOpenGLWindowHeight()
Client.GetFPS()
Client.GetGlobalText(textId)
Client.GetMapName(mapId)
Client.GetMonsterName(monsterId)
Client.GetPartyCount()
Client.GetPing()
Client.GetCamera3D()
Client.SetGlowVisible(enabled)
Client.IsGlowVisible()
Client.SetEquipmentVisible(enabled)
Client.IsEquipmentVisible()
```

`Client.GetWindowWidth()` e `Client.GetWindowHeight()` retornam a resolucao fisica configurada. Para posicionar janelas Lua na mesma escala das interfaces nativas, use `Client.GetInterfaceWidth()` e `Client.GetInterfaceHeight()`.

`ClientAPI.GetResolutionInfo()` retorna todos esses valores em uma tabela:

```lua
{
	resolution = string,
	windowWidth = number,
	windowHeight = number,
	interfaceWidth = number,
	interfaceHeight = number,
	openGLWidth = number,
	openGLHeight = number,
}
```

## Inventario e tooltip

```lua
Client.GetInventoryMouseSlot()
Client.GetInventoryMouseItemSlot()
Client.GetInventoryMouseItemIndex()
Client.GetInventoryMouseItemLevel()
Client.GetInventoryMouseItemOption()
Client.GetInventoryMouseItemExcellent()
Client.GetInventoryMouseItemDurability()
ClientAPI.GetInventoryMouseItemInfo()
Client.GetItemName(itemIndex, level)
Client.GetItemWidth(itemIndex)
Client.GetItemHeight(itemIndex)
Client.GetItemSlot(itemIndex)
Client.ShowInventoryMouseItemTooltip(x, y)
Client.ShowItemTooltip(x, y, itemIndex, level, option1, extOption)
Client.ShowItemTooltipFull(x, y, itemIndex, level, skill, luck, option, extOption, setOption, harmony, itemOptionEx, [duration])
Client.RenderItemScaled(x, y, width, height, itemIndex, level, option1, extOption, scale)
```

Exemplo:

```lua
local itemIndex = Client.GetInventoryMouseItemIndex()
if itemIndex > 0 then
	local name = Client.GetItemName(itemIndex, Client.GetInventoryMouseItemLevel())
	Client.RenderText(20, 100, name, 240, 0, 1, 255, 255, 255, 255)
end
```

## Render de item/personagem/monstro

### Client.RenderItem

```lua
Client.RenderItem(x, y, width, height, itemIndex, level, option1, extOption)
Client.RenderItemScaled(x, y, width, height, itemIndex, level, option1, extOption, scale)
Client.RenderItemCentered(x, y, width, height, itemIndex, level, option1, extOption, scale)
```

Desenha preview 3D de item.

Exemplo:

```lua
Client.RenderItem(100, 120, 40, 40, 7181, 0, 0, 0)
Client.RenderItemScaled(100, 120, 18, 18, 7181, 0, 0, 0, 0.30)
Client.RenderItemCentered(100, 120, 40, 40, 7181, 0, 0, 0, 0.50)
```

Use `RenderItemScaled` para itens em listas compactas. `scale` multiplica a escala nativa.

`RenderItemCentered` centraliza o item no bounding box, ignorando `pos[X]/pos[Y]` em `CustomItemPosition`. Mesmos parametros de `RenderItemScaled`. Hit-test usa `(x, y, width, height)` original.

`ShowItemTooltipFull` representa item composto no servidor:

- Skill e codificada no byte de level; excellent/opcao alta no campo separado.
- Em itens ancient, informe `setOption` completo para o preview incluir a opcao individual.

Parametro opcional `duration` em segundos a partir de agora. Maior que `0` ativa a linha `Dia de Expiracao` no tooltip. Use `604800` para 7 dias.

### Client.RenderCharacter

```lua
Client.RenderCharacter(id, x, y, width, height, angle, zoom, animation)
```

Desenha preview do personagem local.

### Client.RenderCharacterPacket

```lua
Client.RenderCharacterPacket(id, x, y, width, height, classType, change, equipment, angle, zoom, animation)
```

Desenha personagem a partir de dados informados pelo script.

### Client.RenderStoredCharacter

```lua
Client.RenderStoredCharacter(renderId, x, y, width, height, angle, zoom, animation)
Client.HasStoredCharacter(renderId)
Client.ClearStoredCharacter(renderId)
```

Desenha personagem cujos dados foram empacotados pelo servidor com
`User.SendCharacterRender(playerIndex, renderId, name)`.

Exemplo:

```lua
Client.RenderStoredCharacter(2001, 80, 200, 120, 160, 90, 0.8, 0)
```

`HasStoredCharacter` checa se ja chegou. `ClearStoredCharacter` libera o slot.

### Client.RenderMonster

```lua
Client.RenderMonster(id, x, y, width, height, monsterIndex, angle, zoom, heightOffset, action)
```

Desenha preview de monstro por classe de monstro.

### Client.RenderModel / RenderMonsterModel

```lua
Client.RenderModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
Client.RenderMonsterModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
```

Desenha preview usando model id final.

### Client.GetMonsterModelInfo

```lua
local info = Client.GetMonsterModelInfo(monsterIndex)
Client.GetModelPlayer()
Client.GetModelMonsterBase()
Client.GetModelMonsterEnd()
Client.GetKindPlayer()
Client.GetKindMonster()
```

Retorna dados para renderizar monstro com `RenderModel`.

Exemplo:

```lua
local info = Client.GetMonsterModelInfo(91)
if info.ok then
	Client.RenderModel(1, 200, 120, 100, 160, info.modelType, info.kind, info.scale, 90, 0.8, 0, 0)
end
```

## Packet client -> server

```lua
Client.IsConnected()
Client.IsReady()
Client.Send(packetName, data)
Client.SendPacket(packetName, data)
```

Envia pacote custom para o GameServer.

Exemplo:

```lua
Client.Send("MeuPacote", "texto")
```

Use nomes estaveis para pacotes de sistemas Lua, evitando depender de opcodes numericos que podem existir no cliente nativo.

## ClientPacket builder

```lua
ClientPacket.Create(name, subHead)
ClientPacket.SetByte(name, value)
ClientPacket.SetWord(name, value)
ClientPacket.SetDword(name, value)
ClientPacket.SetChar(name, text)
ClientPacket.SetCharLength(name, text, length)
ClientPacket.Size(name)
ClientPacket.GetData(name)
ClientPacket.Send(name)
ClientPacket.Clear(name)
```

Usado para montar payload simples byte a byte.

Aliases globais tambem estao disponiveis:

```lua
CreatePacket(name, subHead)
ClearPacket(name)
SendPacket(name, packetName)
SetBytePacket(name, value)
SetWordPacket(name, value)
SetDwordPacket(name, value)
SetCharPacket(name, text)
SetCharPacketLength(name, text, length)
GetBytePacket(name, position)
GetWordPacket(name, position)
GetDwordPacket(name, position)
GetCharPacket(name, position)
GetCharPacketLength(name, position, length)
```

## HTTP e conteudo remoto

O cliente possui funcoes HTTP para baixar textos, JSON, HTML simples e imagens.

Limites:

- nao e navegador embutido;
- nao executa JavaScript;
- nao interpreta CSS completo;
- o script Lua deve ler o conteudo e desenhar a interface com `Client.RenderText`, `Client.RenderImage`, botoes Lua e controles nativos.

### Client.HttpGet

```lua
Client.HttpGet(url, maxBytes)
```

Baixa texto remoto curto.

Retorno:

```lua
{
	ok = true,
	url = "...",
	status = 200,
	size = 1234,
	data = "...",
	error = "",
	truncated = false,
}
```

### Client.HttpRequest

```lua
Client.HttpRequest(options)
ClientAPI.HttpPost(url, body, headers, maxBytes)
```

Opcoes:

- `method`: `"GET"` ou `"POST"`;
- `url`: endereco remoto;
- `body`: corpo do POST;
- `headers`: tabela de headers permitidos;
- `maxBytes`: limite de resposta;
- `timeoutMs`: timeout em milissegundos;
- `httpsOnly`: `true` por padrao;
- `allowedDomains`: lista de dominios permitidos.

Headers permitidos:

```text
Accept
Accept-Language
Authorization
Content-Type
User-Agent
X-Requested-With
X-Lua-Client
X-Api-Key
```

Exemplo:

```lua
local result = Client.HttpRequest({
	method = "GET",
	url = "https://site.com/api/",
	maxBytes = 65536,
	timeoutMs = 5000,
	httpsOnly = true,
	allowedDomains = {
		"site.com",
	},
	headers = {
		["Accept"] = "application/json",
	},
})
```

### Client.HttpRequestAsync

```lua
Client.HttpRequestAsync(requestId, options)
```

Executa request em segundo plano. A resposta chega pela bridge `Client.OnHttpResponse`, documentada em `Client\Bridges.md`.

### Client.DownloadFile

```lua
Client.DownloadFile(url, fileName)
```

Baixa arquivo remoto para:

```text
Data\Custom\Lua\Cache
```

Retorno:

```lua
{
	ok = true,
	url = "...",
	fileName = "banner.jpg",
	path = ".\\Data\\Custom\\Lua\\Cache\\banner.jpg",
	hresult = 0,
	packed = true,
	packedPath = ".\\Data\\Custom\\Lua\\Cache\\banner.OZJ",
	error = "",
}
```

Conversoes automaticas de formato:

```text
.jpg  -> cria tambem .OZJ
.jpeg -> cria tambem .OZJ
.tga  -> cria tambem .OZT
```

O loader resolve `.jpg`/`.tga` para `.OZJ`/`.OZT` automaticamente.

## ClientAPI e helpers

`ClientAPI` e camada de compatibilidade. Quando existir equivalente, `ClientAPI.X` chama a mesma funcao ou aplica protecao simples de retorno.

Exemplos:

```lua
Client.RenderText(...)
ClientAPI.RenderText(...)

Client.HttpRequest(...)
ClientAPI.HttpRequest(...)
```

Helpers disponiveis:

```lua
ClientAPI.IsMouseInRect(x, y, width, height)
ClientAPI.IsMouseClickInRect(x, y, width, height)
ClientAPI.GetInventoryMouseItemInfo()
ClientAPI.GetResolutionInfo()
ClientAPI.HttpPost(url, body, headers, maxBytes)
Client.RegisterPacket
Client.SendPacket
```

`Client.RegisterPacket` e alias para `Client.OnPacket`.

`Client.SendPacket` e alias para `Client.Send`.

## Janelas nativas

IDs de janelas em `ClientAPI.Windows`:

```lua
ClientAPI.Windows.Friend
ClientAPI.Windows.MoveMap
ClientAPI.Windows.Party
ClientAPI.Windows.GuildInfo
ClientAPI.Windows.Trade
ClientAPI.Windows.Storage
ClientAPI.Windows.MixInventory
ClientAPI.Windows.Command
ClientAPI.Windows.Pet
ClientAPI.Windows.NpcShop
ClientAPI.Windows.Inventory
ClientAPI.Windows.Character
ClientAPI.Windows.ChatInput
ClientAPI.Windows.WindowMenu
ClientAPI.Windows.Option
ClientAPI.Windows.Help
ClientAPI.Windows.ChatLog
ClientAPI.Windows.PartyInfo
ClientAPI.Windows.MainFrame
ClientAPI.Windows.SkillList
ClientAPI.Windows.BuffWindow
ClientAPI.Windows.MasterLevel
ClientAPI.Windows.MiniMap
ClientAPI.Windows.InventoryJewel
```

Exemplo:

```lua
if not Client.IsWindowOpen(ClientAPI.Windows.Inventory) then
	Client.OpenWindow(ClientAPI.Windows.Inventory)
end
```

## Estilo de nome do personagem

Permite estilizar o **nome de um personagem** (pela string exata do nome) tanto **acima da cabeca** quanto **no chat**: cor, fonte e efeitos de "wave". O estilo fica registrado ate ser limpo ou o cliente reiniciar; vale para qualquer personagem que tenha aquele nome.

```lua
Client.SetNameStyle(nome, r, g, b, fontType, waveMode [, r2, g2, b2])
Client.SetNameStyleMulti(nome, fontType, { {r,g,b}, {r,g,b}, ... })
Client.ClearNameStyle(nome)
Client.ClearAllNameStyles()
```

Parametros:

- `r, g, b`: cor 0-255. Use `r < 0` para **manter a cor padrao** do jogo (muda so fonte/efeito).
- `fontType`: `0` normal, `1` negrito, `2` grande, `3` fixa. No nome **acima da cabeca** so o negrito tem efeito (engrossa o texto); `grande`/`fixa` so aparecem na janela de info detalhada. No **chat** todas funcionam.
- `waveMode`:
  - `0` sem efeito (cor fixa).
  - `1` arco-iris animado (efeito nativo; ignora a RGB).
  - `2` pulsa o brilho da RGB escolhida.
  - `3` oscila entre 2 cores (passe `r2, g2, b2`).
- `SetNameStyleMulti`: ciclo suave por **N cores** (lista de `{r,g,b}`).

Exemplo:

```lua
-- staff em vermelho negrito pulsando
Client.SetNameStyle("Admin", 255, 40, 40, 1, 2)

-- nome oscilando entre rosa e ciano
Client.SetNameStyle("Patricia", 255, 120, 220, 0, 3, 60, 220, 255)

-- nome ciclando por varias cores fortes
Client.SetNameStyleMulti("Gato", 1, {
    { 255, 0, 0 }, { 255, 255, 0 }, { 0, 255, 0 }, { 0, 120, 255 },
})
```

> O registro e por **nome exato**. Para aplicar por grupo (cargo, VIP, classe) o script monta a lista de nomes e chama `SetNameStyle` para cada um, na logica que o servidor quiser.

## Imagem acima da cabeca

Exibe uma imagem custom acima da cabeca de um personagem (por nome exato), no estilo do "balao" de GM. Funciona para player, monstro e NPC. Carregue a imagem antes com `Client.LoadImage` (qualquer `.tga`/`.ozt` da pasta do cliente).

```lua
Client.SetHeadImage(nome, imageId, w, h [, ox, oy])
Client.ClearHeadImage(nome)
Client.ClearAllHeadImages()
```

- `imageId`: id usado no `Client.LoadImage`.
- `w, h`: tamanho em pixels.
- `ox, oy`: ajuste fino de posicao (opcionais). `oy` maior **desce** a imagem (mais junto do nome); menor/negativo sobe. A imagem fica centralizada acima da cabeca.

Exemplo:

```lua
Client.LoadImage("Custom\\Interface\\dailyre.tga", 70200)
Client.SetHeadImage("Admin", 70200, 32, 32, 0, -6)
```

> Para **NPC**, o nome normalmente so aparece no hover. Ao registrar uma imagem, o NPC passa a ser desenhado todo frame, entao a **imagem e o nome do NPC ficam sempre visiveis** (so para NPCs com imagem registrada). `ClearHeadImage` reverte ao normal. Para player/monstro o nome ja e sempre visivel; nada muda alem da imagem.
