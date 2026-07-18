# Server Side - User

Objeto usado para consultar e alterar dados de personagem online.

```lua
local player = User.new(playerIndex)
```

Tambem e possivel buscar por nome:

```lua
local player = User.getByName("Admin")
if player ~= nil and player:isPlaying() then
	SendMessage("Encontrado: " .. player:getName(), player:getIndex(), 1)
end
```

## Estado

```lua
player:getIndex()
player:getConnected()
player:getType()
player:isConnected()
player:isPlayer()
player:isPlaying()
player:isVip()
player:isGM()
```

## Identificacao

```lua
player:getAccountID()
player:getName()
player:getAuthority()
player:getAccountLevel()
player:getAccountExpireDate()
player:getGuildName()
player:getGuildNumber()
```

## Posicao e personagem

```lua
player:getClass()
player:getDBClass()
player:getChangeUp()
player:getLevel()
player:getMasterLevel()
player:getReset()
player:getMasterReset()
player:setReset(value)
player:addReset(value)
player:setMasterReset(value)
player:addMasterReset(value)
player:getMap()
player:getMapNumber()
player:getX()
player:getY()
player:getDir()
player:getType()
player:setType(value)
player:setDir(value)
player:teleport(map, x, y)
```

## Economia e pontos

```lua
player:getMoney()
player:setMoney(value)
player:addMoney(value)

player:getCoin1()
player:getCoin2()
player:getCoin3()
player:setCoin1(value)
player:setCoin2(value)
player:setCoin3(value)
player:addCoin1(value)
player:addCoin2(value)
player:addCoin3(value)

player:getLevelUpPoint()
player:setLevelUpPoint(value)
player:addLevelUpPoint(value)
```

## Atributos

```lua
player:getStrength()
player:getDexterity()
player:getVitality()
player:getEnergy()
player:getLeadership()

player:addStrength(value)
player:addDexterity(value)
player:addVitality(value)
player:addEnergy(value)
player:addLeadership(value)
```

## Vida, mana, AG e shield

```lua
player:getLife()
player:getMaxLife()
player:getMana()
player:getMaxMana()
player:getBP()
player:getMaxBP()
player:getShield()
player:getMaxShield()

player:setLife(value)
player:setMaxLife(value)
player:setMana(value)
player:setMaxMana(value)
player:setBP(value)
player:setMaxBP(value)
player:setShield(value)
player:setMaxShield(value)
```

## PK

```lua
player:getPKLevel()
player:getPKCount()
player:getPKTime()
player:setPKLevel(value)
player:setPKCount(value)
player:clearPK()
```

## Informacoes de combate

```lua
player:getAttackSpeed()
player:getPhysiSpeed()
player:getMagicSpeed()
player:getMagicDamageMin()
player:getMagicDamageMax()
player:getOption()
player:getAddLife()
player:getAddMana()
player:getAddBP()
player:getVitalityToLife()
player:getEnergyToMana()
player:getAttackDamageMinLeft()
player:getAttackDamageMaxLeft()
player:getAttackDamageMinRight()
player:getAttackDamageMaxRight()
player:getPhysiDamageMinLeft()
player:getPhysiDamageMaxLeft()
player:getPhysiDamageMinRight()
player:getPhysiDamageMaxRight()
player:getExcellentDamageRate()
player:getExcellentDamage()
player:getCriticalDamageRate()
player:getCriticalDamage()
player:getDoubleDamageRate()
player:getTripleDamageRate()
player:getIgnoreDefenseRate()
player:getIgnoreShieldGaugeRate()
player:getDamageReflect()
player:getFullDamageReflectRate()
player:getResistDoubleDamageRate()
player:getResistIgnoreDefenseRate()
player:getResistIgnoreShieldGaugeRate()
player:getResistCriticalDamageRate()
player:getResistExcellentDamageRate()
player:getResistStunRate()
player:getIsFullSetItem()
player:getArmorSetBonus()
player:getDamageReduction()
```

As funcoes acima tambem possuem versoes `set...` com o mesmo nome base.

Exemplo:

```lua
player:setAttackSpeed(600)
player:setPhysiSpeed(600)
player:setMagicSpeed(600)
player:setMagicDamageMin(500)
player:setMagicDamageMax(800)
player:setCriticalDamageRate(30)
player:setTripleDamageRate(5)
player:setDamageReduction(10)
```

Setters avancados disponiveis:

```lua
player:setClass(value)
player:setOption(value)
player:setAddLife(value)
player:setAddMana(value)
player:setAddBP(value)
player:setVitalityToLife(value)
player:setEnergyToMana(value)
player:setAttackDamageMinLeft(value)
player:setAttackDamageMaxLeft(value)
player:setAttackDamageMinRight(value)
player:setAttackDamageMaxRight(value)
player:setPhysiDamageMinLeft(value)
player:setPhysiDamageMaxLeft(value)
player:setPhysiDamageMinRight(value)
player:setPhysiDamageMaxRight(value)
player:setExcellentDamageRate(value)
player:setExcellentDamage(value)
player:setDoubleDamageRate(value)
player:setIgnoreDefenseRate(value)
player:setIgnoreShieldGaugeRate(value)
player:setDamageReflect(value)
player:setFullDamageReflectRate(value)
player:setResistDoubleDamageRate(value)
player:setResistIgnoreDefenseRate(value)
player:setResistIgnoreShieldGaugeRate(value)
player:setResistCriticalDamageRate(value)
player:setResistExcellentDamageRate(value)
player:setResistStunRate(value)
player:setIsFullSetItem(value)
player:setArmorSetBonus(value)
```

## Interface e alvo

```lua
player:getPartyNumber()
player:getTargetNumber()
player:getInterfaceUse()
player:getInterfaceType()
player:getInterfaceState()
player:getPShopOpen()
```

## Packet para o client

```lua
player:sendClientPacket(packetName, data)
User.SendClientPacket(playerIndex, packetName, data)
```

Envia um pacote custom para o Lua do Main.

```lua
local player = User.new(playerIndex)
player:sendClientPacket("MinhaJanela", "open=1")
```

## Lock e direcao

```lua
player:getLock()             -- 0 nao-locked, !=0 locked
player:setLock(value)        -- aceita 0/1
player:getDir()              -- 0..7
```

## Bonus de stats (somente leitura)

```lua
player:getAddStrength()
player:getAddDexterity()
player:getAddVitality()
player:getAddEnergy()
player:getAddLeadership()
```

Bonus vindos de itens equipados / set / option.

## Estado de auto-attack

```lua
player:getAttackCustom()           -- 1 se /attack ativo, 0 caso contrario
player:getAttackCustomOffline()    -- 1 se /offattack ativo
player:getHelperTotalTime()        -- ticks restantes do MuHelper
```

## Master Level extra

```lua
player:getMasterPoint()
player:setMasterPoint(value)       -- 0..2.000.000.000
player:getMasterExperience()       -- read-only (uint64 retornado como number)
```

`setMasterPoint` aplica clamp em 0 e 2 bilhoes.

## Fruit points

```lua
player:getFruitAddPoint()
player:getFruitSubPoint()
```

Pontos de fruta usados (add) e removidos (sub).

## Trade/Duel

```lua
player:getTradeDuel()              -- true se em trade ou duel
```

### Buffs e debuffs

```lua
player:addBuff(index, [duration], [v1], [v2], [v3], [v4])
player:removeBuff(index)
player:hasBuff(index)
player:clearAllBuffs()
player:clearDebuffs([count])
```

Manipula efeitos do `EffectManager`. `duration` em segundos (omita para
usar o tempo do config). `v1..v4` variam por efeito.

Exemplo:

```lua
player:addBuff(8, 300)   -- 5 min de Greater Life (HP)
player:clearDebuffs()    -- remove debuffs, mantem buffs
```

Indices comuns: `1` damage, `2` defense, `5` critical, `8` life, `9` mana,
`71` reflect, `129` ignore defense. Lista completa em `EffectManager.h`.

### Inventario

```lua
player:getInventoryItem(slot)               -- table ou nil
player:findItem(section, index, [level])    -- slot ou nil
player:countItem(section, index, [level])   -- int
player:hasInventorySpace(width, height)     -- bool
player:takeItem(section, index, [level], [count])  -- int removidos
player:giveItem(section, index, level, ...)        -- bool
player:clearInventory([includeEquipment])          -- int removidos
```

`getInventoryItem` retorna `{section, index, type, level, durability, serial,
option1, excellent, setOption, harmony, itemOptionEx}` ou `nil` se slot vazio.

`giveItem` valida espaco antes de entregar (retorna `false` se nao cabe). Mesmos
parametros opcionais do `GiveItem` global (level, durability, skill, luck,
option, excellent, setOption, harmony, itemOptionEx, duration).

`duration` espera epoch absoluto (Unix timestamp). Para X dias use `os.time() + X * 86400`:

```lua
u:giveItem(5, 8, 15, 0, 1, 1, 7, 63, 0, 0, 0, os.time() + 7 * 86400)
```

`clearInventory` por padrao preserva os slots 0-11 (equipment). Passe `true`
para incluir.

Exemplo:

```lua
local u = User.new(playerIndex)
if u:countItem(14, 13) == 0 and u:hasInventorySpace(1, 1) then
    u:giveItem(14, 13)   -- da 1 Jewel of Bless
end
```

### Empacotar render de personagem para o cliente

```lua
User.SendCharacterRender(playerIndex, renderId, charName)
player:sendCharacterRender(renderId, charName)
```

Envia ao cliente `playerIndex` os dados (classe + equipamento) do
personagem `charName` indexados por `renderId`. O cliente desenha com
`Client.RenderStoredCharacter(renderId, x, y, w, h, ...)`. Funciona com
chars online (imediato) e offline (round-trip transparente).

Exemplo:

```lua
User.SendCharacterRender(playerIndex, 2001, "Patricia")
```

Nomes com caracteres fora de `[A-Za-z0-9_]` ou maiores que 10 retornam
`false`. Tutorial completo em `Tutorials/TopRanking/README.md`.

### Estatua de personagem no mundo (Bot Statue)

```lua
User.CreateBotStatue(charName, map, x, y, dir)
User.RemoveBotStatue(slot)
User.ClearBotStatues()
```

Spawna um personagem REAL no mapa como "estatua": nome em cima, classe e
equipamento verdadeiros vindos do banco (online copia da memoria; offline
busca no DataServer). A estatua nao anda, nao ataca, nao morre e nao aceita
comandos da Janela de Comando do cliente (holograma). Usos tipicos: podio
do top ranking, homenagens, decoracao de evento.

A estatua NAO renderiza montaria, mesmo que o personagem tenha uma equipada
(desde a 2.2.1). Dentro de safezone o cliente encolhe a montaria pra mini pet
ou a esconde, e como a estatua nunca sai do lugar ela ficaria congelada com um
pet minusculo no chao. Asa, set, arma e o resto do equipamento vem normal.

- `CreateBotStatue` retorna o slot da estatua (`0..63`) ou `-1` se falhou
  (nome invalido, mapa/coordenada invalidos, sem vaga). `dir` (direcao
  `0..7`) e opcional, padrao `0`. Repetir a chamada com o mesmo nome e
  mesma posicao nao duplica (retorna o slot existente).
- `RemoveBotStatue(slot)` remove a estatua do slot; retorna `true`/`false`.
- `ClearBotStatues()` remove todas. Use UMA vez por carga de script (o
  `/reloadscripts` zera o estado Lua, mas nao as estatuas), e NAO a cada
  rebuild: limpar tudo e recriar faz as estatuas sumirem e voltarem na tela
  dos jogadores toda vez. Para atualizar, mexa so no que mudou --
  `RemoveBotStatue` da posicao + `CreateBotStatue` do nome novo. Recriar a
  MESMA estatua na mesma posicao devolve o slot existente sem respawnar, entao
  posicao que nao mudou nao pisca. O `Custom\System\TopStatues.lua` faz assim.
- Limite: 64 estatuas simultaneas. As mesmas regras de nome do
  `SendCharacterRender` valem aqui (`[A-Za-z0-9_]`, ate 10 caracteres).

No boot do GameServer a conexao com o DataServer termina de subir alguns
segundos depois dos scripts. Criar estatua de personagem OFFLINE nesse
intervalo retorna `-1` — refaca com um `Timer.Interval` curto ate completar.

Exemplo:

```lua
local slot = User.CreateBotStatue("Patricia", 0, 146, 128, 2)

if slot >= 0 then
	LogPrint("estatua criada no slot " .. slot)
end
```

Sistema pronto de exemplo: `Custom\System\TopStatues.lua` +
`Custom\Configs\TopStatuesConfig.lua` — estatuas do top 1/2/3 do ranking
com query configuravel, refresh automatico quando o ranking muda e
auto-cura de boot.
