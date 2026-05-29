# Tutorial: Configurar o Daily Reward

Este tutorial mostra como configurar o sistema Daily Reward, um calendario mensal de recompensas (uma por dia do mes, 1 a 31). O jogador pode resgatar apenas no dia exato. Dia perdido fica marcado como `MISS` na janela. Ao virar o mes, o calendario reseta automaticamente.

O sistema funciona com duas partes:

- Servidor: valida o dia, entrega o item, persiste o estado em SQL por conta + mes.
- Cliente: janela com 6x5 slots, tooltip preview dos itens e botao flutuante (saquinho) na tela principal.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\DailyReward.lua
Data\Scripts\Custom\Configs\DailyRewardConfig.lua
```

Cliente:

```text
Data\Custom\Lua\Systems\DailyReward.lua
Data\Custom\Lua\Systems\DailyRewardButton.lua
Data\Custom\Lua\Customs\Configs\DailyRewardConfig.lua
Data\Custom\Interface\dailyre.ozt
Data\Custom\Interface\glow.ozt
```

SQL:

```text
MuServer\SQL\Lua\Update1.6.5 - DailyReward.sql
```

## Ativar ou Desativar

No servidor, abra:

```text
Data\Scripts\Custom\Configs\DailyRewardConfig.lua
```

Para deixar ativo:

```lua
enabled = true
```

Para desativar:

```lua
enabled = false
```

Quando desativado, o servidor nao envia estado ao logar e o claim e recusado com mensagem `disabled`.

## Tabela do Banco

Com o servidor ativo, o sistema cria a tabela automaticamente no startup:

```text
LuaDailyReward
```

Campos:

- `AccountID`: login da conta.
- `YearMonth`: mes corrente no formato `2026-05`.
- `ClaimedMask`: bitmask dos dias resgatados. Bit `(dia - 1)` setado significa resgatado.

Cada conta tem uma linha por mes. Ao virar o mes, uma nova linha e criada e o calendario volta a 0.

Em instalacoes restauradas ou que nao deixaram o auto-create rodar, aplique manualmente:

```text
MuServer\SQL\Lua\Update1.6.5 - DailyReward.sql
```

## Recompensas

A lista de 30 recompensas fica em:

```lua
rewards = {
    { section = 14, index = 13, level = 0, count = 1, label = "Bless" },
    { section = 14, index = 14, level = 0, count = 1, label = "Soul" },
    -- ...
    { section = 12, index = 36, level = 15, count = 1, skill = 1, luck = 1, option = 7, excellent = 63, label = "Wings of Storm" },
}
```

O indice na lista corresponde ao dia do mes. `rewards[1]` e o brinde do dia 1, `rewards[28]` e do dia 28, e assim por diante.

Campos obrigatorios por entrada:

- `section`: secao do item.
- `index`: indice do item dentro da secao.
- `count`: quantidade.
- `label`: texto exibido na celula da janela cliente.

Campos opcionais (para item full):

- `level`: nivel do item, de `0` a `15`.
- `skill`: `1` com skill, `0` sem.
- `luck`: `1` com luck, `0` sem.
- `option`: option adicional, `0` a `7`. `4` = +16, `7` = +28.
- `excellent`: bitmask `0` a `63`. `63` = todas as 6 opcoes excellent.
- `setOption`: opcao ancient/set, `0` a `255`.
- `harmony`: opcao Jewel of Harmony, `0` a `255`.
- `itemOptionEx`: opcao extra, `0` a `255`.
- `durability`: durability inicial, `0` a `255`. `0` usa o default do item.
- `duration`: segundos ate expirar a partir da entrega. `604800` = 7 dias. `0` (ou ausente) = permanente.

## Configurar Mes com 28, 29, 30 ou 31 Dias

O servidor envia ao cliente o numero de dias do mes corrente (28-31). Slots alem do limite nao sao renderizados. Slots com mes maior que `#rewards` aparecem como sem reward.

Mantenha 30 ou 31 entradas; 31 cobre meses longos.

## Item Permanente vs Item Temporario

Item permanente:

```lua
{ section = 14, index = 13, level = 0, count = 1, label = "Bless" }
```

Item +15 full sem expiracao:

```lua
{ section = 12, index = 36, level = 15, count = 1,
  skill = 1, luck = 1, option = 7, excellent = 63,
  label = "Wings of Storm" }
```

Item +15 full com 7 dias de duracao:

```lua
{ section = 5, index = 8, level = 15, count = 1,
  skill = 1, luck = 1, option = 7, excellent = 63,
  duration = 604800,
  label = "Staff of Destruction (7d)" }
```

`duration` no config e em segundos a partir da entrega. O servidor converte para epoch absoluto antes de criar o item. Conversoes uteis:

```text
86400      = 1 dia
259200     = 3 dias
604800     = 7 dias
2592000    = 30 dias
```

## Controle de Acesso por Tipo de Conta

O bloco `allowByVip` controla quais tipos de conta podem resgatar:

```lua
allowByVip = {
    [0] = 1,  -- normal     (1 = pode resgatar, 0 = bloqueado)
    [1] = 1,  -- vip1
    [2] = 1,  -- vip2
    [3] = 1,  -- vip3
}
```

Cenarios:

| Cenario | Configuracao |
| --- | --- |
| Todos podem (padrao) | `[0]=1, [1]=1, [2]=1, [3]=1` |
| So VIPs (qualquer tier) | `[0]=0, [1]=1, [2]=1, [3]=1` |
| Exclusivo VIP3 | `[0]=0, [1]=0, [2]=0, [3]=1` |
| Bloqueia VIP3 (campanha free) | `[0]=1, [1]=1, [2]=1, [3]=0` |

Tier nao declarado e tratado como bloqueado. Se um dia for adicionado VIP4 no servidor, ele nao recebe reward ate ser liberado explicitamente.

A janela continua mostrando o calendario para contas bloqueadas. O bloqueio acontece no momento do claim, com a mensagem configurada em `messages.vipBlocked`.

## Mensagens de Chat

```lua
messages = {
    claimed = "[Daily Reward] Voce ganhou %s!",
    already = "[Daily Reward] Voce ja resgatou hoje.",
    noSpace = "[Daily Reward] Inventario sem espaco. Libere espaco e tente de novo.",
    wrongDay = "[Daily Reward] So pode resgatar o reward do dia atual.",
    disabled = "[Daily Reward] Sistema desativado.",
    available = "[Daily Reward] Voce tem 1 recompensa para resgatar hoje!",
    vipBlocked = "[Daily Reward] Sua conta nao tem acesso ao Daily Reward.",
}
```

Use `%s` em `claimed` para receber o label da recompensa entregue.

## Janela do Cliente

A janela usa `RenderTop`, abre acima do HUD e pode ser movida pela barra superior. A posicao fica em memoria ate fechar o cliente e volta ao padrao ao reiniciar.

Cada slot mostra:

- Numero do dia no canto superior esquerdo.
- Status no canto superior direito: `OK` (resgatado), `HOJE` (pode resgatar), `MISS` (perdeu) ou nada (futuro).
- Icone do item centralizado.
- Label da recompensa.

O hover exibe o tooltip nativo do MU usando os atributos definidos no config do cliente, incluindo `level`, `skill`, `luck`, `option`, `excellent` e `duration`. O preview deve representar exatamente os mesmos atributos que o servidor entrega.

## Espelhar Config no Cliente

A configuracao visual fica em:

```text
Data\Custom\Lua\Customs\Configs\DailyRewardConfig.lua
```

Replique os campos cosmeticos (`section`, `index`, `count`, `label`, e opcionais `level`, `skill`, `luck`, `option`, `excellent`, `duration`) das 30 recompensas do servidor. Quem entrega o item e o servidor. O cliente usa esses campos so para a preview da tooltip.

Sempre que alterar a lista do servidor, atualize o cliente tambem. Tooltip preview deve casar com o item real entregue.

## Botao Flutuante

A imagem do saquinho fica em:

```text
Data\Custom\Interface\dailyre.ozt
Data\Custom\Interface\glow.ozt
```

O formato OZT e `4 bytes de prefixo` + `imagem nativa` (PNG, TGA, etc). Sem encriptacao. Para trocar a imagem, gere o arquivo com seus 4 bytes de header e substitua.

O botao fica no canto superior direito. Suas posicoes seguem a escala automatica do cliente (`UIScale`). Ao abrir uma janela modal (Inventario `V`, Cash Shop `X`, Gens `B`, Trade, Storage, Friend, Move Map etc), o botao some automaticamente.

## Comandos

```text
/dailyreset
```

Apenas GM. Zera a mask do mes atual para a conta que rodou o comando. Util para liberar o claim novamente apos um problema (servidor caiu, troca de personagem em horario limite, customer service em geral). Nao destroi nada do que o jogador ja tem.

```text
/dailygive <dia>
```

Apenas GM. Entrega o reward de qualquer dia ignorando today e mask, sem marcar como resgatado. Para testar a tabela inteira antes de publicar uma nova lista.

So fica registrado quando o config tem `debug = true`. Em producao, deixe `debug = false`.

## Reload de State no Cliente

Apos `F6` no cliente, o estado local e perdido. O proximo clique no saquinho envia `DailyRewardRequest` e recebe o estado atualizado.

## Fluxo de Teste

1. Limpe a tabela:
   ```sql
   DELETE FROM LuaDailyReward;
   ```
2. Reload de scripts no servidor.
3. F6 no cliente.
4. Entre no jogo.
5. Clique no saquinho. A janela abre, dia atual mostra `HOJE`.
6. Passe o mouse no dia atual. Confira o tooltip preview.
7. Clique em `Resgatar Hoje (dia X)`.
8. Abra o inventario. Confira o tooltip do item real entregue.
9. Tooltip da janela e tooltip do inventario devem mostrar os mesmos atributos.

Se quiser testar varias recompensas em sequencia, ative `debug = true` e use `/dailygive 1`, `/dailygive 2`, ate `/dailygive 30`.

## Observacoes

- O sistema e por conta, nao por personagem. Resgatar com qualquer char marca a conta inteira.
- A mask SQL e `int` (32 bits), entao suporta ate o dia 31 (bit 30 setado).
- `duration` no config e em segundos a partir de agora. O servidor converte para epoch absoluto antes de entregar o item. Nao passe valores como `7` esperando 7 dias - o sistema interpreta como 7 segundos.
- O item com duration aparece no inventario com a linha `Dia de Expiracao: YYYY-MM-DD HH:MM` no tooltip. Quando o tempo expira, o sweep do servidor remove o item automaticamente.
- O cliente preview tambem mostra a linha de expiracao quando o reward tem `duration` no config. Mantenha o campo identico entre servidor e cliente.
- `5x Bless` (`count = 5`) entrega 5 jewels independentes (chama `giveItem` 5 vezes). Cada chamada valida espaco. Se o inventario encher no meio, a entrega para e o servidor envia `noSpace`.
- A mensagem `available` de login so e enviada para contas liberadas em `allowByVip`. Contas bloqueadas nao recebem a notificacao.
