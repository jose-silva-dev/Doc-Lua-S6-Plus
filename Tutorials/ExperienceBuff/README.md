# Bonus de EXP com Seal e Talisman — 3.5.0

`User:addBuff` permite aplicar o Seal of Ascension por uma duracao em segundos,
inclusive em efeitos `Type 2`. Requer GameServer e GameServerCS com a correcao
da **3.5.0**; atualizar somente o script nao adiciona esse suporte.

## O que mudou

Antes, uma chamada como `player:addBuff(193, 28800)` passava os segundos
diretamente ao efeito `Type 2`, que esperava uma data de expiracao. O servidor
interpretava esse valor como uma data ja vencida e nao aplicava o efeito.
Agora, a API converte os segundos para a data correta.

A assinatura de [User:addBuff](../../Server/User.md#buffs-e-debuffs) permanece
igual. Nao foram adicionados `getExperience`, `setExperience` ou `addExperience`.
O bonus participa do calculo nativo de EXP ao derrotar monstros.

## Aplicar por 8 horas

```lua
local player = User.new(playerIndex)
if not player:isPlaying() or player:isMarketplaceBusy() then return end

local applied = player:addBuff(193, 28800) -- 8 * 60 * 60 segundos
if not applied then
    SendMessage("Nao foi possivel aplicar o Seal.", playerIndex, 1)
    return
end
```

Passe `28800`, nunca `os.time() + 28800`. Para uma verificacao curta, use `60`.
Duracao omitida ou `0` mantem o valor fixo de `Count` em `MuServer/Data/Effect.txt`;
nao significa um efeito permanente. Valores negativos, fracionarios, nao finitos
ou acima do limite suportado retornam `false` sem substituir o efeito atual.

Efeitos `Type 2` contam tempo real, inclusive com o personagem desconectado.
O Seal 193 padrao possui `Save=1`: ao reconectar antes do vencimento, o efeito
mantem o prazo restante; a reconexao nao reinicia as 8 horas. Efeitos `Type 0/1`
mantem sua contagem nativa.

## Qual efeito usar

Valores da configuracao padrao de `Effect.txt`:

| Indice | Efeito | Grupo | Bonus |
| --- | --- | --- | --- |
| `193` | Seal of Ascension | `60` | +100% EXP normal |
| `194` | Master Seal of Ascension | `60` | +100% Master EXP |
| `191` | Talisman of Ascension 2 | `115` | +100% EXP normal e Master EXP |

Seal 193 e Talisman 191 podem coexistir porque pertencem a grupos diferentes.
Se o personagem ja possui o Talisman, aplique somente o Seal. Aplicar novamente
o efeito 191 nao cria um segundo Talisman acumulavel.

Efeitos do mesmo grupo seguem as regras nativas de substituicao e nao somam
seus bonus. Isso tambem vale para Seal 193 e Master Seal 194, ambos do grupo 60.
O Seal concedido pelo script compartilha o grupo com os Seals dos itens nativos.

Os percentuais sao aditivos: base 100% + Seal 100% + Talisman 100% = **300%**
nesse componente do calculo de EXP normal. O Seal 193 nao aumenta Master EXP.
Outros multiplicadores, regras de mapa, party e limites de nivel continuam valendo.

Os parametros `v1..v4` de `addBuff` so definem campos marcados como `*` no
`Effect.txt`. Valores fixos da configuracao prevalecem; passar outro `v1`
nao altera o percentual de um Seal configurado com `Value1=100`.

## Integrar a um consumivel

Use o evento [PlayerUseItem](../../Server/Bridges.md#playeruseitem) para
identificar o item escolhido pelo seu sistema. O exemplo acima apenas aplica
o efeito: nao cria nem consome itens e nao registra um consumivel automaticamente.

No fluxo de uso do item:

1. Confira o item, o nivel e as condicoes do personagem antes de aplicar o bonus.
2. Para preservar Seals existentes, recuse o uso se houver qualquer efeito do
   grupo 60 ativo. Na configuracao padrao, confira `29`, `40`, `101`, `193` e `194`
   com `player:hasBuff(index)`; ajuste a lista se personalizou os grupos.
3. Aplique `player:addBuff(193, 28800)` e confira o retorno. Em caso de `false`,
   preserve o item.
4. Consuma uma unidade somente apos aplicar o efeito e confira a quantidade
   removida. Se o consumo falhar, remova o Seal recem-aplicado com
   `player:removeBuff(193)`. Esse fluxo depende de ter bloqueado Seals anteriores.

A API nao exige que o personagem seja GM. As permissoes do item ou comando
sao definidas pelo seu script. A correcao nao acrescenta um item novo ao jogo
nem altera os grupos de `Effect.txt`.

## Conferir o funcionamento

Use um personagem de EXP normal, sem outros Seals, e aplique o efeito por 60
segundos. Consulte `player:hasBuff(193)` enquanto estiver ativo e novamente
apos a expiracao. Para conferir persistencia, reconecte antes de vencer.

Com Talisman 191 ativo, aplicar o Seal deve manter ambos os efeitos. Compare
EXP em condicoes equivalentes: mesmo tipo de monstro, nivel do personagem,
mapa, party e demais bonus. A EXP base pode variar entre abates e a subida de
nivel pode limitar o valor efetivamente creditado; a barra de EXP, sozinha,
nao comprova o percentual. O ajuste de `addBuff` preserva essas regras nativas.
