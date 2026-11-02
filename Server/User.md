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

## Nomes de personagens (4.0.0)

`player:getName()` retorna UTF-8. As buscas `User.getByName`, `GetUserByName`,
`GetUserIndexByName`, `User.SendCharacterRender` e `User.CreateBotStatue` recebem
UTF-8. Nomes ASCII continuam iguais. Nomes chineses exigem a migração SQL opcional
no servidor e Main, GS/GSCS, DataServer e JoinServer atualizados juntos.

O protocolo mantém 10 bytes em CP936: até 5 ideogramas comuns representáveis,
ou letras/números misturados dentro desse limite. Hífen e sublinhado seguem a
política do servidor na criação. Não corte nomes com `string.sub` por quantidade
de caracteres: o comprimento de uma string Lua UTF-8 é medido em bytes.

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
player:isMarketplaceBusy()
player:canUseCustomNpc()
```

## Disponibilidade para serviços customizados (3.5.0)

`player:canUseCustomNpc()` retorna `true` quando o personagem está online, vivo e disponível para usar um serviço. Retorna `false` durante morte/regeneração, transferência de servidor, viagem de Airship, trade, interface nativa ocupada, loja pessoal, aposta de duelo ou transação pendente do Marketplace, loja pessoal ou compra de VIP.

```lua
local player = User.new(playerIndex)
if not player:canUseCustomNpc() then return end
```

O método apenas consulta o estado. Não autoriza acesso a um NPC, não confere distância e não reserva moedas ou itens. BuffSeller e Lucky Wheel também usam `Data\Scripts\LuaSystem\NpcAccess.lua` para verificar a abertura pelo servidor, o NPC, mapa, distância e sessão do personagem antes de aceitar uma ação.

## Espera de transação do Marketplace (3.4.0)

`player:isMarketplaceBusy()` retorna boolean: true enquanto **esse personagem**
aguarda confirmação de uma operação nativa do Marketplace. Na 3.5.0 também abrange a compra protegida da loja pessoal e a compra de VIP. Outros personagens
continuam disponíveis. Consultas de inventário e atributos permanecem permitidas.

Durante essa espera, métodos de alteração de User (itens, moedas, atributos,
buffs e teleporte) levantam erro Lua `marketplace_busy` antes de alterar o estado.
O mesmo vale para GiveItem, TakeItem, TakeInventorySlot e CreateItemMap, incluindo
ItemSerialCreate/ItemSerialCreatePeriodic. Não são executados automaticamente depois.

Verifique antes de debitar, consumir ou marcar uma entrega como concluída:

```lua
local player = User.new(playerIndex)
if not player:isPlaying() then return end
if player:isMarketplaceBusy() then
    return -- deixe a recompensa pendente e tente de novo no próximo ciclo
end
-- Continue aqui seu fluxo de validação e entrega.
```

Em loops com vários jogadores, ignore somente o personagem ocupado. Uma rotina
adiada deve validar novamente conta/personagem/sessão: o índice pode ser reutilizado
após desconexão. Tratar o erro via pcall não torna uma sequência de chamadas atômica.

Este método não reserva itens nem fornece uma transação SQL ao script. SQL arbitrário
não é bloqueado por esse método; não grave inventário/saldos do marketplace fora das
procedures coordenadas. A API Lua pública de anunciar/comprar/retirar ainda está em
implementação futura. O getter de item e GiveItem não fazem transferência completa.

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

`getGuildName()` retorna o nome da guilda em UTF-8, inclusive nomes chineses.
O protocolo mantém até 8 bytes CP936 (até quatro ideogramas comuns); o tamanho
em bytes da string UTF-8 no Lua pode ser maior. Para consultas SQL, use
`DataBase.StringLiteral(nome)` e não converta o nome para a página de código local.

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
player:setTravelHidden(hidden)
player:isTravelHidden()
```

`setTravelHidden(true)` oculta o personagem durante uma viagem cinematografica e bloqueia suas acoes. Use `setTravelHidden(false)` ao concluir ou cancelar. `isTravelHidden()` informa o estado atual.

```lua
local player = User.new(playerIndex)
player:setTravelHidden(true)

-- Ao concluir a viagem:
player:setTravelHidden(false)
```

## Economia e pontos

```lua
player:getMoney()
player:setMoney(value)
player:addMoney(value)

player:getCoin1()
player:getCoin2()
player:getCoin3()
player:refreshCoins()
player:setCoin1(value, origin)
player:setCoin2(value, origin)
player:setCoin3(value, origin)
player:addCoin1(value, origin)
player:addCoin2(value, origin)
player:addCoin3(value, origin)

player:getLevelUpPoint()
player:setLevelUpPoint(value)
player:addLevelUpPoint(value)
```

Desde a 3.6.0, `origin` é opcional nos seis métodos `setCoin1/2/3` e
`addCoin1/2/3`. Use uma identificação de até 28 bytes, por exemplo
`player:addCoin1(100, "DailyReward")`. O crédito confirmado será identificado como
`Lua:DailyReward` na auditoria de Coins; sem esse argumento, a origem é `Lua`.
Quando disponível, a referência identifica o arquivo Lua que chamou a API.
O retorno desses métodos continua sendo o saldo local calculado; não é confirmação
SQL. O `COIN_LOG` registra somente aumentos efetivamente persistidos em
`CashShopData`, com os saldos antes/depois e respeitando o resultado da transação.
Requer a migração `Update3.6.0 - CoinLog.sql`, DataServer e GameServers da 3.6.0;
`WriteCoinLog=1` ativa a exportação no GS definido em `GX_CoinLogConfig`.

`refreshCoins()` solicita ao DataServer os valores atuais de WCoinC, WCoinP e
Goblin Point e sincroniza o saldo do jogador conectado. Retorna `true` quando a
solicitação foi enviada ou `false` quando o jogador/Cash Shop não está disponível
ou já existe outra operação de Cash Shop em andamento.

Exemplo após uma procedure SQL alterar `CashShopData`:

```lua
local player = User.new(playerIndex)

if player:refreshCoins() then
	LogPrint("Atualizacao de moedas solicitada")
end
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

`addBuff` retorna `true` quando aplica o efeito e `false` quando nao consegue.
Duracao omitida ou `0` mantem o tempo configurado em `MuServer/Data/Effect.txt`
quando a coluna `Count` possui um valor fixo. Duracao
informada deve ser um numero inteiro nao negativo; valores fracionarios,
negativos, nao finitos ou fora do limite suportado retornam `false` sem substituir
o efeito atual. Indices de efeito inexistentes tambem retornam `false`.
Os valores `v1..v4` so sobrescrevem campos configurados como `*` no `Effect.txt`;
valores fixos da configuracao continuam prevalecendo.

A partir da correcao da **3.5.0**, uma duracao positiva em efeitos `Type 2`
tambem recebe **segundos**: a API converte a duracao para o horario de expiracao
exigido pelo servidor. Antes, essa duracao era interpretada como uma data ja vencida.
Nao passe `os.time() + duracao`. Esses efeitos continuam contando enquanto
o personagem esta offline; efeitos `Type 0/1` mantem sua contagem nativa.
O prazo Type 2 deve caber no timestamp inteiro com sinal aceito pelo servidor.

```lua
local applied = player:addBuff(193, 28800) -- Seal: +100% EXP normal por 8 horas
if applied then
    -- Somente agora consumir o item que concedeu o bonus.
end
```

Na configuracao padrao, `193` aumenta EXP normal, `194` aumenta Master EXP
e `191` aumenta ambas. Seal `193` e Talisman `191` coexistem (grupos 60 e 115);
efeitos do mesmo grupo substituem-se conforme a regra nativa, nao se somam.
Os percentuais de EXP desses efeitos sao aditivos: base 100% + Seal 100% +
Talisman 100% = 300% nesse componente do calculo. Outros multiplicadores e
regras de nivel/mapa/party continuam valendo.

Veja [Bonus de EXP com Seal e Talisman](../Tutorials/ExperienceBuff/README.md)
para aplicar o efeito em um consumivel, preservar buffs existentes e conferir
a duracao. Requer GameServer e GameServerCS com a correcao da 3.5.0;
atualizar somente os scripts nao corrige o tratamento de `Type 2`.

Essa alteracao usa efeitos nativos. Nao adiciona `getExperience`,
`setExperience` ou `addExperience` ao objeto `User`.

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
player:getItemMaxStack(section, index, [level]) -- int; 0 sem stack
player:hasInventorySpaceForItems(items)     -- bool
player:takeItem(section, index, [level], [count])  -- int removidos
player:giveItem(section, index, level, ...)        -- bool
player:clearInventory([includeEquipment])          -- int removidos
```

`getInventoryItem` retorna `{section, index, type, level, durability, serial,
option1, skill, luck, option, excellent, setOption, harmony, itemOptionEx}`
ou `nil` se o slot estiver vazio ou invalido.

A partir da **3.4.0**, `skill`, `luck` e `option` usam os mesmos formatos
aceitos por `GiveItem` e `player:giveItem`:

| Campo | Valor |
| --- | --- |
| `skill` | 0 = sem skill; 1 = com skill |
| `luck` | 0 = sem Luck; 1 = com Luck |
| `option` | Nivel do adicional, de 0 a 7; nao e o valor exibido no tooltip (por exemplo, +28) |
| `option1` | Alias legado de `skill`, preservado para scripts existentes |

```lua
local player = User.new(playerIndex)
local item = player:getInventoryItem(12) -- primeira celula da mochila
if item then
    LogPrint(string.format("skill=%d luck=%d option=%d",
        item.skill, item.luck, item.option))
end
```

Em builds anteriores a 3.4.0 os tres campos novos nao existem. Atualize GS/GSCS;
reload de scripts sozinho nao adiciona campos da API nativa. Nao substitua
campos ausentes por zero ao salvar um item, pois isso perderia os atributos.

**Marketplace:** esses campos permitem ler os atributos basicos, mas o getter
nao retorna sockets, bonus de socket ou vencimento. `GiveItem` cria um novo
item com novo serial e sockets vazios; nao e uma API de transferencia do item
original. A retirada, persistencia e entrega de um Marketplace exigem um fluxo
proprio para evitar perda ou duplicacao em caso de falha.

Teste de leitura e comparacao: [InventoryOptions](../Tutorials/InventoryOptions/README.md).

`giveItem` valida espaco antes de entregar (retorna `false` se nao cabe). Mesmos
parametros opcionais do `GiveItem` global (level, durability, skill, luck,
option, excellent, setOption, harmony, itemOptionEx, duration). Um ultimo
parametro booleano opcional, `stackReward`, ativa a fusao com stacks existentes
para item simples configurado em `ItemStack.txt`; nesse caso, `durability` e a
quantidade da stack (de 1 ate o limite). Os demais usos preservam a criacao
individual. `getItemMaxStack` le o limite configurado para item e nivel.

`hasInventorySpaceForItems` verifica uma recompensa inteira antes da entrega.
Cada entrada usa `section`, `index` e `count` (opcional, padrao `1`); `level`
e `stack = true` permitem considerar a capacidade livre de stacks existentes
e reservar apenas os novos slots necessarios. A funcao
simula todos os itens sobre uma unica copia do mapa do inventario, impedindo que
itens diferentes reutilizem o mesmo espaco durante a validacao.

Se um item nao existir em `Data\Item\Item.txt`, a funcao retorna
`false, "item_missing", section, index`. Uma entrada mal formada retorna
`false, "invalid_reward"`. Falta real de espaco retorna apenas `false`.

```lua
local reward = {
    { section = 14, index = 13, count = 2 }, -- 2 Bless
    { section = 14, index = 14, count = 2 }, -- 2 Soul
}

if not player:hasInventorySpaceForItems(reward) then
    SendMessage("Inventario sem espaco.", playerIndex, 1)
    return
end

for _, item in ipairs(reward) do
    for n = 1, item.count do
        player:giveItem(item.section, item.index)
    end
end
```

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

Com o Inventario Visual habilitado, a aparencia enviada usa os visuais
equipados compativeis, mantendo o item real quando nao ha visual aplicavel.
Isso nao altera inventario, atributos ou saldos. Cada pedido para um
personagem online consulta a aparencia atual; personagens offline podem
usar o cache de ate 30 segundos. Envie novamente para atualizar a previa
que ja esta guardada no cliente. Main, GS/GSCS e DataServer devem ser
atualizados juntos para esta integracao; a assinatura Lua nao mudou.

Exemplo:

```lua
User.SendCharacterRender(playerIndex, 2001, "Patricia")
```

Nomes inválidos em UTF-8, não representáveis em CP936 ou maiores que 10 bytes
no protocolo retornam `false`. Tutorial completo em `Tutorials/TopRanking/README.md`.

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

Desde a 4.0.0, a estatua tambem usa os itens compativeis do Inventario Visual
quando `InventoryVisualSwitch = 1`, tanto online quanto offline. Sem visual
valido, mostra o equipamento normal. Isso altera somente a aparencia.
A aparencia e capturada na criacao da estatua; repetir a chamada para o
mesmo nome e posicao conserva a estatua existente. Para renovar a aparencia,
remova o slot com `RemoveBotStatue` e crie novamente. O TopStatues atualiza
as posicoes quando o ranking muda; nao acompanha trocas de itens em tempo real.

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
  `/reload scripts` zera o estado Lua, mas nao as estatuas), e NAO a cada
  rebuild: limpar tudo e recriar faz as estatuas sumirem e voltarem na tela
  dos jogadores toda vez. Para atualizar, mexa so no que mudou --
  `RemoveBotStatue` da posicao + `CreateBotStatue` do nome novo. Recriar a
  MESMA estatua na mesma posicao devolve o slot existente sem respawnar, entao
  posicao que nao mudou nao pisca. O `Custom\System\TopStatues.lua` faz assim.
- Limite: 64 estatuas simultaneas. As mesmas regras de nome do
  `SendCharacterRender` valem aqui (UTF-8 na API, até 10 bytes em CP936).
- Todas as classes nativas do personagem são convertidas internamente pela
  API, incluindo `DBClass = 50` (Duel Master). O script deve informar apenas
  o nome do personagem; não é necessário converter `Class`, `ChangeUp` ou
  escolher um modelo de monstro.

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
