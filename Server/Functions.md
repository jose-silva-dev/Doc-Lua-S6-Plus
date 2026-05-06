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

## OpenFolder

```lua
OpenFolder(path)
```

Carrega todos os scripts Lua de uma pasta.

Exemplo:

```lua
OpenFolder("LuaSystem")
OpenFolder("Custom\\Configs")
OpenFolder("Custom")
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
player:setStrength(value)
player:setDexterity(value)
player:setVitality(value)
player:setEnergy(value)
player:setLeadership(value)
```

Exemplo:

```lua
local player = User.new(playerIndex)
player:setMoney(player:getMoney() + 1000000)
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

Exemplo:

```lua
command:add("/info", function(playerIndex, args, message)
	local player = User.new(playerIndex)
	SendMessage("Ola, " .. player:getName(), playerIndex, 1)
end)
```

## Timer

```lua
Timer.Interval(seconds, callback)
Timer.Once(seconds, callback)
```

Executa funcao depois de um tempo ou repetidamente.

Exemplo:

```lua
Timer.Interval(60, function()
	SendMessageGlobal("Mensagem a cada 60 segundos", 1)
end)
```

## DataBase

```lua
DataBase.Query(sql)
DataBase.QueryGetNumber(sql, column)
DataBase.QueryGetString(sql, column)
```

Executa consultas SQL.

Exemplo:

```lua
local account = "genesys"
local cash = DataBase.QueryGetNumber("SELECT WCoinC FROM CashShopData WHERE AccountID='" .. account .. "'", "WCoinC")
```

Use consultas SQL com cuidado. Nunca confie em texto digitado pelo jogador sem validar.

## Packet server -> client

```lua
User.SendClientPacket(playerIndex, packetName, data)
```

Envia pacote custom do GameServer para o Main Lua.

Exemplo:

```lua
User.SendClientPacket(playerIndex, "OpenNotice", "vip")
```

