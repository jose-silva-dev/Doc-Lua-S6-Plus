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
