# Client Side - Bridges

Bridges sao eventos/callbacks usados pelos scripts do Main.

Os callbacks principais do client-side sao protegidos no Main para evitar crash por erro comum de Lua. Em `Client.OnPacket`, cada handler e isolado; se um handler falhar, os demais continuam sendo chamados.

## Render

```lua
function Render()
end
```

Chamado continuamente para desenhar interface.

Exemplo:

```lua
function Render()
	Client.RenderText(20, 90, "Texto na tela", 200, 0, 1, 255, 255, 255, 255)
end
```

## RenderTop

```lua
function RenderTop()
end
```

Chamado depois da interface principal e das informacoes do jogo. Use para janelas Lua que precisam ficar acima do HUD e de textos nativos. O cursor do jogo continua sendo desenhado depois.

Exemplo:

```lua
function RenderTop()
	Client.RenderText(20, 110, "Janela em camada superior", 240, 0, 1, 255, 255, 255, 255)
end
```

## Update

```lua
function Update()
end
```

Chamado continuamente para atualizar logica.

Exemplo:

```lua
local ticks = 0

function Update()
	ticks = ticks + 1
end
```

## UpdateKey

```lua
function UpdateKey()
end
```

Chamado para leitura de teclas.

Exemplo:

```lua
function UpdateKey()
	if Client.IsKeyDown(0x78) then -- F9
		-- abrir janela
	end
end
```

## ScrollMouse

```lua
function ScrollMouse(value)
	return false
end
```

Chamado ao usar scroll do mouse.

Retorno:

```text
true  = script consumiu o scroll
false = deixa o cliente continuar fluxo normal
```

## ClickEvent / RightClickEvent

```lua
function ClickEvent()
	return false
end

function RightClickEvent()
	return false
end
```

Chamado ao clicar com mouse.

## Client.OnPacket

```lua
Client.OnPacket(function(packetName, data)
end)
```

Recebe pacote custom enviado pelo GameServer.

Use nomes estaveis em vez de opcodes numericos quando a comunicacao passar pelo bridge Lua.

Exemplo:

```lua
Client.OnPacket(function(packetName, data)
	if packetName == "OpenNotice" then
		Notice.Open(data)
	end
end)
```

No servidor, o envio equivalente e:

```lua
User.SendClientPacket(playerIndex, "OpenNotice", "open=1")
```

## Client.OnHttpResponse

```lua
Client.OnHttpResponse(function(response)
end)
```

Recebe resposta de `Client.HttpRequestAsync`.

Exemplo:

```lua
Client.OnHttpResponse(function(response)
	if response.requestId == "news" and response.ok then
		LogPrint(response.data)
	end
end)
```

## ClientHooks

```lua
ClientHooks.RegisterUpdate(name, callback)
ClientHooks.RegisterRender(name, callback)
ClientHooks.RegisterUpdateMouse(name, callback)
ClientHooks.RegisterUpdateKey(name, callback)
ClientHooks.RegisterScrollMouse(name, callback)
ClientHooks.RegisterClick(name, callback)
ClientHooks.RegisterRightClick(name, callback)
ClientHooks.UnregisterRender(name)
ClientHooks.UnregisterUpdateMouse(name)
ClientHooks.UnregisterUpdate(name)
ClientHooks.UnregisterUpdateKey(name)
ClientHooks.UnregisterScrollMouse(name)
ClientHooks.UnregisterClick(name)
ClientHooks.UnregisterRightClick(name)
```

Wrapper para registrar handlers sem sobrescrever globais.

Callbacks de teclado podem retornar `true` para consumir a tecla. Para teclas com acao nativa, chame `Client.ConsumeKey(vk)`. Para `ESC` (`0x1B`), a janela Lua tem prioridade sobre o menu nativo ate a tecla ser solta. Para atalhos globais lidos via `Client.IsKeyDown(vk)`, consulte `Client.IsKeyboardInputCaptured()` antes.

Exemplo:

```lua
ClientHooks.RegisterRender("MinhaJanela", function()
	Client.RenderText(20, 100, "Minha janela", 200, 0, 1, 255, 255, 255, 255)
end)

ClientHooks.RegisterUpdateKey("MinhaJanela", function(key, down, wasDown)
	if MinhaJanela.open and key == 0x1B and down then
		Client.ConsumeKey(0x1B)
		MinhaJanela.open = false
		return true
	end

	return false
end)
```

Para janelas moveis, prefira `GenesysUI.BeginDrag`, `GenesysUI.UpdateDrag`, `GenesysUI.EndDrag` e `GenesysUI.BlockMouse` dentro de `RegisterUpdateMouse`. Em controles próprios, use `Client.GetMouseX()`, `Client.GetMouseY()` e `Client.IsMouseLeftButtonHeld()`; esse último mantém o estado contínuo mesmo depois de `Client.BlockMouse()` proteger a interface. Guarde `x` e `y` em uma tabela Lua para manter a posição.
