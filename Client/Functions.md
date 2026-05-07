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

### Client.PlaySound / StopSound

```lua
Client.PlaySound(soundId)
Client.StopSound(soundId)
```

Toca ou para som do cliente.

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

Janelas Lua podem ser movidas mantendo `x` e `y` em memoria no proprio script. Durante o arraste, leia `Client.GetMouseX()`, `Client.GetMouseY()` e `Client.IsMouseLeftButton()`, atualize a posicao e chame `Client.BlockMouse()` para impedir clique no jogo.

Para janelas que precisam ficar acima do HUD inferior e de textos nativos, registre o desenho em `ClientHooks.RegisterRenderTop(name, callback)` ou implemente o callback global `RenderTop()`.

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
Client.ShowItemTooltipFull(x, y, itemIndex, level, skill, luck, option, extOption, setOption, harmony, itemOptionEx)
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
```

Desenha preview 3D de item.

Exemplo:

```lua
Client.RenderItem(100, 120, 40, 40, 7181, 0, 0, 0)
Client.RenderItemScaled(100, 120, 18, 18, 7181, 0, 0, 0, 0.30)
```

Use `RenderItemScaled` quando o item precisa caber em uma lista compacta. O `scale` e multiplicador da escala nativa do item.

Use `ShowItemTooltipFull` quando o tooltip precisa representar um item composto no servidor com skill, luck, option, excellent, set/ancient, harmony e `ItemOptionEx`. A skill e codificada no byte de level do item temporario, enquanto o campo interno de excellent/opcao alta permanece separado. Em itens ancient, informe o `setOption` completo usado pelo servidor para que o preview exiba tambem a opcao individual do item, como `Increase Stamina +10`.

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

O cliente possui funcoes HTTP para baixar textos, JSON, HTML simples e imagens para interfaces Lua.

Importante:

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

Quando baixa imagem, o cliente pode preparar o formato usado pelo loader do MU:

```text
.jpg  -> cria tambem .OZJ
.jpeg -> cria tambem .OZJ
.tga  -> cria tambem .OZT
```

Mesmo chamando `Client.LoadImage` com `.jpg` ou `.tga`, o cliente usa o arquivo convertido preparado por baixo.

## ClientAPI e helpers

`ClientAPI` e uma camada de compatibilidade para scripts que preferem chamadas nesse namespace.

Para scripts novos, prefira `Client.X`. Quando existir equivalente, `ClientAPI.X` chama a mesma funcao ou aplica uma protecao simples de retorno.

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
