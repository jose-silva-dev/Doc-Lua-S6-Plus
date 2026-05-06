# Client Side - Helpers e Compatibilidade

Para scripts novos, prefira o namespace `Client`.

`ClientAPI` esta disponivel como camada de compatibilidade e tambem oferece alguns helpers em Lua.

## ClientAPI

As funcoes principais possuem equivalentes em `ClientAPI`.

```lua
Client.RenderText(...)
ClientAPI.RenderText(...)

Client.HttpRequest(...)
ClientAPI.HttpRequest(...)
```

## Camadas de render

```lua
ClientHooks.RegisterRender("MinhaJanela", callback)
ClientHooks.RegisterRenderTop("MinhaJanela", callback)
```

`RegisterRender` desenha na camada normal do Lua. `RegisterRenderTop` desenha depois do HUD e das informacoes nativas, indicado para janelas que devem ficar por cima da interface inferior.

## Janelas nativas

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

## Item sob o mouse

```lua
local info = ClientAPI.GetInventoryMouseItemInfo()
```

Retorna `nil` quando nao ha item sob o mouse. Quando houver item, retorna:

```lua
{
	slot = number,
	index = number,
	level = number,
	option = number,
	excellent = number,
	durability = number,
	name = string,
	width = number,
	height = number,
	equipSlot = number,
}
```

## Resolucao

```lua
local info = ClientAPI.GetResolutionInfo()
```

Retorna:

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

Para interfaces Lua, `interfaceWidth` e `interfaceHeight` sao os melhores limites para centralizar ou mover janelas. `windowWidth` e `windowHeight` representam a resolucao fisica.

## HTTP POST rapido

```lua
ClientAPI.HttpPost(url, body, headers, maxBytes)
```

Atalho para:

```lua
ClientAPI.HttpRequest({
	method = "POST",
	url = url,
	body = body,
	headers = headers,
	maxBytes = maxBytes,
})
```

## Mouse em area

```lua
ClientAPI.IsMouseInRect(x, y, width, height)
ClientAPI.IsMouseClickInRect(x, y, width, height)
```

Exemplo:

```lua
if ClientAPI.IsMouseClickInRect(120, 90, 80, 20) then
	Client.Send("ButtonClick", "ok")
end
```

## Aliases de pacote

```lua
Client.RegisterPacket
Client.SendPacket
```

Sao aliases para `Client.OnPacket` e `Client.Send`.
