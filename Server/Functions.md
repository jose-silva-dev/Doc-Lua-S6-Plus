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
```

Executa uma funcao repetidamente.

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

Use consultas SQL com cuidado. Nunca confie em texto digitado pelo jogador sem validar.

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

## Packet server -> client

```lua
User.SendClientPacket(playerIndex, packetName, data)
```

Envia pacote custom do GameServer para o Main Lua.

Exemplo:

```lua
User.SendClientPacket(playerIndex, "OpenNotice", "vip")
```

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

Use `GiveItem` para criar item direto no inventario e `CreateItemMap` para criar item no mapa.

`FireworksSend` dispara o efeito visual de fogos na posicao informada. Se `x` e `y` forem omitidos, usa a posicao atual do personagem.

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
