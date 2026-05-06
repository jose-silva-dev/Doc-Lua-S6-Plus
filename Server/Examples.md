# Server Side - Exemplos Disponiveis

Os exemplos ficam em `Data\Scripts\Examples` e servem como modelos prontos de uso.

Essa pasta nao e carregada automaticamente. Para testar, copie o exemplo desejado para `Data\Scripts\Custom\System` e use `/reloadscripts` ou reinicie o GameServer.

## Lista

```text
ExampleCommand.lua              comando custom
ExampleTimer.lua                timer de servidor
ExampleLoginLogout.lua          entrada e saida de personagem
ExampleNpcAndMonsterLog.lua     NpcTalk e MonsterDieGiveItem
ExampleMonsterDie.lua           morte de monstro
ExampleNpcTeleport.lua          NPC com custo em Zen e teleport
ExampleUserInfo.lua             leitura de dados do personagem
ExampleMoney.lua                leitura e alteracao de Zen
ExampleLevelUpPoint.lua         pontos para distribuir
ExampleStats.lua                atributos principais
ExampleTeleport.lua             teleport por Lua
ExampleVitals.lua               vida, mana e shield
ExamplePK.lua                   PK level, PK count e clear PK
ExampleChecks.lua               connected, playing, VIP e GM
ExampleFindUser.lua             busca de jogador online
ExampleAdminTarget.lua          comandos GM em alvo online
ExampleGiveItem.lua             criar item para jogador
ExampleInventoryItem.lua        contar e remover item por tipo
ExampleInventorySpace.lua       checar espaco no inventario
ExampleCreateItemMap.lua        criar item no mapa
ExampleDataBase.lua             consulta simples no banco
ExampleDataBaseAsync.lua        consulta assincrona
ExampleCustomPacket.lua         pacote custom server/client
ExampleLuaPacket.lua            packet builder server-side
ExampleMove.lua                 movimento de personagem
ExamplePlayerDropItem.lua       drop de item
ExamplePlayerDieRespawn.lua     morte e respawn
ExampleMoveItemEquip.lua        mover/equipar item
ExampleUseItem.lua              uso de item
ExampleTrade.lua                convite e OK de trade
ExampleVault.lua                abrir/fechar bau
ExamplePersonalShop.lua         personal shop
ExamplePersonalShopBuyLog.lua   compra em personal shop
ExampleParty.lua                convite de party
ExampleSellRepair.lua           venda e reparo de item
ExampleCloseChar.lua            fechar personagem
ExampleClass.lua                alterar classe
ExampleLevel.lua                alterar level
ExampleLevelUpPointAdd.lua      callback ao adicionar ponto
ExampleReset.lua                reset e master reset
ExampleCoins.lua                moedas
ExampleCombatStats.lua          bonus de combate
ExampleCombatStatsFull.lua      exemplo completo de bonus
ExampleCharacterSet.lua         recalculo de atributos
ExampleUserExtra.lua            informacoes extras do personagem
```

## Uso recomendado

```lua
OpenExtension("Custom\\System\\ExampleCommand.lua")
```

Use exemplos apenas para teste ou como base para criar um sistema proprio em `Data\Scripts\Custom\System`.
