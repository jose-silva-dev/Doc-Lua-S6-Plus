# Server Side - Bridges

Bridges sao eventos chamados pelo GameServer. O script registra uma funcao e o servidor chama quando o evento acontecer.

Callbacks registrados via `GameServerFunctions` executam sob `LuaCore`. Erros sao registrados em `LOGS\LOG\LuaCore_YYYY-MM-DD.txt`; demais callbacks continuam executando.

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

## EnterCharacter / OnPlayerLogin

```lua
GameServerFunctions.EnterCharacter(function(playerIndex)
end)

GameServerFunctions.OnPlayerLogin(function(playerIndex)
end)
```

Chamado quando o jogador entra no jogo/personagem (login completo, viewport
e items ja enviados). `OnPlayerLogin` e alias de `EnterCharacter`.

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

## PlayerDie / OnPlayerKill / RespawnUser

```lua
GameServerFunctions.PlayerDie(function(killerIndex, deadIndex)
end)

GameServerFunctions.OnPlayerKill(function(killerIndex, deadIndex)
end)

GameServerFunctions.RespawnUser(function(playerIndex)
end)
```

`PlayerDie` dispara em qualquer morte (PvP, PvE, evento). `OnPlayerKill` e
alias de `PlayerDie`. Para filtrar so PvP, valide no callback que
`gObj[killerIndex].Type == OBJECT_USER`. `RespawnUser` dispara ao renascer.

## OnUserDamage

```lua
GameServerFunctions.OnUserDamage(function(playerIndex, targetIndex, damage, damageType, skill)
	return damage
end)
```

Chamado quando um jogador causa dano antes do dano ser aplicado ao alvo. Retornar um numero altera o dano aplicado. Retornar `nil` mantem o valor atual.

Parametros:

- `playerIndex`: jogador atacante.
- `targetIndex`: alvo atingido.
- `damage`: dano calculado ate aquele ponto.
- `damageType`: tipo do dano. `0` = normal, `4` = elemental.
- `skill`: ID da skill, ou `0` quando nao houver skill.

Exemplo:

```lua
GameServerFunctions.OnUserDamage(function(playerIndex, targetIndex, damage, damageType, skill)
	if damageType == 0 then
		return math.floor(damage * 1.10)
	end

	return damage
end)
```

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

> Alem das lojas de jogador, agora tambem dispara na compra em **loja nativa de NPC** (inclusive itens empilhaveis, como joias). Nesse caso `sellerIndex` e o numero da loja (o mesmo de `Npc.OpenShop` / `ShopManager.txt`).

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

## OnMonsterReload

```lua
GameServerFunctions.OnMonsterReload(function()
end)
```

Disparado quando os monstros do mapa sao recarregados (inicializacao do servidor
ou apos `RequestReloadScripts()`). Cada chamada adiciona um handler; todos os
registrados sao executados em ordem.

```lua
MyShop.SpawnNpc()
GameServerFunctions.OnMonsterReload(MyShop.SpawnNpc)
```

> **Migracao 1.6.4 -> 1.6.5:** antes era preciso editar `GameServer.lua` e adicionar
> uma chamada manual em `MonsterReload()`. Se voce tinha feito isso, mova a linha
> pro proprio arquivo do sistema usando `GameServerFunctions.OnMonsterReload`.

## OnUserItemPick *(1.6.5)*

```lua
GameServerFunctions.OnUserItemPick(function(playerIndex, mapItemIndex, itemIndex, itemLevel)
    return false
end)
```

Chamado quando o jogador clica em um item no chao, ANTES do servidor entregar o
item ao inventario. Retornando `true` o pickup e bloqueado (item permanece no
chao) e o cliente recebe `result = 0xFF` (falha generica).

Parametros:

- `playerIndex`: index do jogador.
- `mapItemIndex`: index do item dentro de `gMap[].m_Item[]`.
- `itemIndex`: item GET_ITEM-style (`group * 512 + index`).
- `itemLevel`: nivel do item no chao.

## OnUserItemPicked *(2.4.0)*

```lua
GameServerFunctions.OnUserItemPicked(function(playerIndex, mapItemIndex, itemIndex, itemLevel)
end)
```

Disparado somente DEPOIS que o servidor conclui a coleta com sucesso. Serve para
missoes, conquistas e contadores que nao podem progredir quando o jogador apenas
tenta pegar um item. O retorno do callback e ignorado.

Tambem e disparado para Zen; nesse caso `itemIndex` e `GET_ITEM(14, 15)`. Se o
sistema deve contar apenas itens de inventario, ignore esse indice.

Parametros:

- `playerIndex`: index do jogador que recebeu o item ou Zen.
- `mapItemIndex`: index que o item ocupava em `gMap[].m_Item[]`.
- `itemIndex`: item GET_ITEM-style (`group * 512 + index`).
- `itemLevel`: nivel do item coletado.

Exemplo:

```lua
GameServerFunctions.OnUserItemPicked(function(playerIndex, mapItemIndex, itemIndex, itemLevel)
    if itemIndex == GET_ITEM(14, 15) then
        return -- nao contar Zen
    end

    SendMessage("Voce coletou um item para a missao.", playerIndex, 1)
end)
```

Use `OnUserItemPick` quando precisar bloquear a tentativa antes da coleta. Use
`OnUserItemPicked` quando precisar confirmar que a coleta realmente aconteceu.

## PlayerLevelUp *(1.6.5)*

```lua
GameServerFunctions.PlayerLevelUp(function(playerIndex, newLevel)
end)
```

Disparado depois que o servidor envia o pacote oficial de levelup ao cliente
(`GCLevelUpSend`). Apenas notificacao -- retorno e ignorado.

Parametros:

- `playerIndex`: index do jogador.
- `newLevel`: nivel atingido (`lpObj->Level` apos o incremento).

Master Level: nao disparado.

## EventComplete *(2.4.0)*

```lua
GameServerFunctions.EventComplete(function(playerIndex, eventType, eventLevel, success)
end)
```

Disparado uma vez para cada jogador que permaneceu no evento ate o
encerramento oficial.

Parametros:

- `playerIndex`: index do jogador.
- `eventType`: `1` = Blood Castle; `2` = Devil Square.
- `eventLevel`: nivel da sala (`BC1..BC8` ou `DS1..DS7`).
- `success`: no Blood Castle, `1` para vencedor/party vencedora e `0` para os
  demais participantes; no Devil Square, `1` ao chegar ao encerramento.

Exemplo:

```lua
GameServerFunctions.EventComplete(function(playerIndex, eventType, eventLevel, success)
    if eventType == 1 and success == 1 then
        SendMessage("Voce venceu o Blood Castle " .. eventLevel .. ".", playerIndex, 1)
    elseif eventType == 2 then
        SendMessage("Devil Square concluido.", playerIndex, 1)
    end
end)
```

## OnCheckUserTarget *(1.6.5)*

```lua
GameServerFunctions.OnCheckUserTarget(function(attackerIndex, targetIndex)
    return false
end)
```

Chamado quando um jogador tenta atacar outro jogador (PvP). Roda antes da
logica de `DisablePvp` e validacao de duel/event. Retorno `true` cancela o
ataque (sem dano).

Parametros:

- `attackerIndex`: jogador que tentou atacar.
- `targetIndex`: alvo do ataque.

Exemplo:

```lua
GameServerFunctions.OnCheckUserTarget(function(attackerIndex, targetIndex)
    local attacker = User.new(attackerIndex)
    local target = User.new(targetIndex)
    if attacker:getLevel() - target:getLevel() > 30 and not attacker:isGM() then
        SendMessage("Voce esta muito acima do nivel do alvo.", attackerIndex, 1)
        return true
    end
    return false
end)
```
