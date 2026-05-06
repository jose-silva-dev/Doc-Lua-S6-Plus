# Server Side - Bridges

Bridges sao eventos chamados pelo GameServer. O script registra uma funcao e o servidor chama quando o evento acontecer.

## Exemplo base

```lua
GameServerFunctions.NpcTalk(function(npcIndex, playerIndex)
	local player = User.new(playerIndex)
	SendMessage("Voce clicou no NPC.", playerIndex, 1)
	return 1
end)
```

## Retorno padrao

Quando a bridge suporta bloqueio:

```text
return 0 ou false = deixa o fluxo normal continuar
return 1 ou true  = bloqueia o fluxo normal
```

Quando a bridge e apenas informativa, o retorno e ignorado.

## NpcTalk

```lua
GameServerFunctions.NpcTalk(function(npcIndex, playerIndex)
	return 0
end)
```

Chamado quando um jogador fala com um NPC.

Parametros:

- `npcIndex`: index do NPC.
- `playerIndex`: index do jogador.

Exemplo:

```lua
GameServerFunctions.NpcTalk(function(npcIndex, playerIndex)
	local player = User.new(playerIndex)
	SendMessage("Ola, " .. player:getName(), playerIndex, 1)
	return 1
end)
```

## MonsterDieGiveItem

```lua
GameServerFunctions.MonsterDieGiveItem(function(playerIndex, monsterIndex)
	return 0
end)
```

Chamado antes do drop normal do monstro.

Parametros:

- `playerIndex`: jogador que matou.
- `monsterIndex`: monstro morto.

## EnterCharacter

```lua
GameServerFunctions.EnterCharacter(function(playerIndex)
end)
```

Chamado quando o jogador entra no jogo/personagem.

Exemplo:

```lua
GameServerFunctions.EnterCharacter(function(playerIndex)
	local player = User.new(playerIndex)
	SendMessage("Bem-vindo, " .. player:getName(), playerIndex, 1)
end)
```

## PlayerLogout

```lua
GameServerFunctions.PlayerLogout(function(playerIndex, name, account)
end)
```

Chamado quando o jogador sai.

## MonsterDie

```lua
GameServerFunctions.MonsterDie(function(playerIndex, monsterIndex)
end)
```

Chamado quando um monstro morre.

## PlayerDie / RespawnUser

```lua
GameServerFunctions.PlayerDie(function(killerIndex, deadIndex)
end)

GameServerFunctions.RespawnUser(function(playerIndex)
end)
```

Chamados ao morrer e ao renascer.

## PlayerDropItem

```lua
GameServerFunctions.PlayerDropItem(function(playerIndex, x, y, slot)
	return 0
end)
```

Chamado quando o jogador tenta dropar um item.

Parametros:

- `playerIndex`: jogador.
- `x`: posicao X no mapa.
- `y`: posicao Y no mapa.
- `slot`: slot do inventario.

## PlayerMove / CharacterMove

```lua
GameServerFunctions.PlayerMove(function(playerIndex, map, x, y, startX, startY)
end)

GameServerFunctions.CharacterMove(function(playerIndex, map, x, y)
	return 0
end)
```

Chamado quando o jogador se move ou tenta mover.

## PlayerUseItem

```lua
GameServerFunctions.PlayerUseItem(function(playerIndex, sourceSlot, targetSlot)
	return 0
end)
```

Chamado quando o jogador usa item.

## PlayerMoveItem / PlayerCanEquipItem

```lua
GameServerFunctions.PlayerMoveItem(function(playerIndex, sourceSlot, targetSlot, type)
end)

GameServerFunctions.PlayerCanEquipItem(function(playerIndex, sourceSlot, targetSlot)
	return 0
end)
```

Chamado ao mover/equipar item.

## Trade / Vault / Shop

```lua
GameServerFunctions.PlayerVaultOpen(function(playerIndex)
end)

GameServerFunctions.PlayerVaultClose(function(playerIndex)
end)

GameServerFunctions.PlayerSendTrade(function(playerIndex, targetIndex)
	return 0
end)

GameServerFunctions.PlayerTradeOk(function(playerIndex, targetIndex)
	return 0
end)

GameServerFunctions.PlayerOpenShop(function(playerIndex)
	return 0
end)

GameServerFunctions.PlayerCloseShop(function(playerIndex)
end)

GameServerFunctions.PlayerBuyShopItem(function(buyerIndex, sellerIndex, slot)
	return 0
end)

GameServerFunctions.PlayerSellItem(function(playerIndex, slot)
	return 0
end)

GameServerFunctions.PlayerRepairItem(function(playerIndex, slot)
	return 0
end)
```

`PlayerBuyShopItem` recebe:

```lua
function(buyerIndex, sellerIndex, slot, itemIndex, level, value)
end
```

## Party

```lua
GameServerFunctions.PlayerSendParty(function(playerIndex, targetIndex)
	return 0
end)
```

Chamado quando um jogador envia convite de party.

## CharacterSet

```lua
GameServerFunctions.CharacterSet(function(playerIndex)
end)
```

Chamado quando o GameServer recalcula atributos do personagem.

Use para aplicar bonus custom.

## LevelUpPointAdd

```lua
GameServerFunctions.LevelUpPointAdd(function(playerIndex, type)
end)
```

Chamado quando o jogador adiciona ponto em atributo.

## ChatProc

```lua
GameServerFunctions.ChatProc(function(playerIndex, message)
	return false
end)
```

Chamado quando o jogador envia mensagem no chat. Retorne `true` para consumir a mensagem.

## ClientPacket

```lua
GameServerFunctions.ClientPacket(function(playerIndex, packetName, data)
end)
```

Recebe pacote enviado pelo Main Lua com `Client.Send` ou `ClientPacket.Send`.
