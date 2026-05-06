# Client Side - Packets

APIs para comunicacao entre Main Lua e GameServer Lua.

## Texto simples

```lua
Client.Send(packetName, data)
```

Envia texto simples para o servidor.

```lua
Client.Send("MinhaAcao", "id=1;amount=10")
```

No servidor:

```lua
GameServerFunctions.ClientPacket(function(playerIndex, packetName, data)
	if packetName == "MinhaAcao" then
		SendMessage("Recebido: " .. data, playerIndex, 1)
	end
end)
```

## Receber pacote do servidor

```lua
Client.OnPacket(function(packetName, data)
end)
```

```lua
Client.OnPacket(function(packetName, data)
	if packetName == "MinhaJanela" then
		LogPrint(data)
	end
end)
```

## ClientPacket

`ClientPacket` monta um payload byte a byte antes de enviar.

```lua
ClientPacket.Create(name, subHead)
ClientPacket.SetByte(name, value)
ClientPacket.SetWord(name, value)
ClientPacket.SetDword(name, value)
ClientPacket.SetChar(name, text)
ClientPacket.SetCharLength(name, text, length)
ClientPacket.GetByte(name, position)
ClientPacket.GetWord(name, position)
ClientPacket.GetDword(name, position)
ClientPacket.GetChar(name, position)
ClientPacket.GetCharLength(name, position, length)
ClientPacket.GetData(name)
ClientPacket.Size(name)
ClientPacket.GetSubHead(name)
ClientPacket.Send(name, packetName)
ClientPacket.Clear(name)
```

Exemplo:

```lua
ClientPacket.Create("MeuPacket", 0)
ClientPacket.SetByte("MeuPacket", 10)
ClientPacket.SetWord("MeuPacket", 500)
ClientPacket.SetChar("MeuPacket", "teste")
ClientPacket.Send("MeuPacket", "MeuPacket")
ClientPacket.Clear("MeuPacket")
```

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
