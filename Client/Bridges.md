# Client Side - Bridges

Bridges sao eventos/callbacks usados pelos scripts do Main.

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

Exemplo:

```lua
Client.OnPacket(function(packetName, data)
	if packetName == "OpenNotice" then
		Notice.Open(data)
	end
end)
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
ClientHooks.RegisterUpdateKey(name, callback)
ClientHooks.RegisterScrollMouse(name, callback)
ClientHooks.RegisterClick(name, callback)
ClientHooks.RegisterRightClick(name, callback)
```

Wrapper recomendado para sistemas grandes, evitando sobrescrever funcoes globais.

Exemplo:

```lua
ClientHooks.RegisterRender("MinhaJanela", function()
	Client.RenderText(20, 100, "Minha janela", 200, 0, 1, 255, 255, 255, 255)
end)
```

