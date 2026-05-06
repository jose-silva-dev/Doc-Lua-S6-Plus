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
```

Carrega imagem do cliente.

Exemplo:

```lua
Client.LoadImage("Custom\\Lua\\Cache\\banner.jpg", 92010)
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
```

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
Client.GetVolume()
Client.SetVolume(level)
Client.GetGlobalText(textId)
Client.GetMapName(mapId)
Client.GetMonsterName(monsterId)
Client.GetPartyCount()
Client.GetPing()
Client.GetCamera3D()
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
Client.GetItemName(itemIndex, level)
Client.GetItemWidth(itemIndex)
Client.GetItemHeight(itemIndex)
Client.GetItemSlot(itemIndex)
Client.ShowInventoryMouseItemTooltip(x, y)
Client.ShowItemTooltip(x, y, itemIndex, level, option1, extOption)
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
```

Desenha preview 3D de item.

Exemplo:

```lua
Client.RenderItem(100, 120, 40, 40, 7181, 0, 0, 0)
```

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
Client.Send(packetName, data)
```

Envia pacote custom para o GameServer.

Exemplo:

```lua
Client.Send("MeuPacote", "texto")
```

## ClientPacket builder

```lua
ClientPacket.Create(name, subHead)
ClientPacket.SetByte(name, value)
ClientPacket.SetWord(name, value)
ClientPacket.SetDword(name, value)
ClientPacket.SetString(name, text)
ClientPacket.Send(name)
ClientPacket.Clear(name)
```

Usado para montar payload simples byte a byte.

