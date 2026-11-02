# Tutorial: Configurar o Daily Reward

Este tutorial mostra como configurar o sistema Daily Reward, um calendario mensal de recompensas (uma por dia do mes, 1 a 31). O jogador pode resgatar apenas no dia exato. Dia perdido fica marcado como `MISS` na janela. Ao virar o mes, o calendario reseta automaticamente.

O sistema funciona com duas partes:

- Servidor: valida o dia e reserva o resgate em SQL por conta + mes antes de solicitar a entrega do item.
- Cliente: janela mensal, modelos 3D dos itens, tooltips e acesso pelo Atalho Rápido (Ctrl+F10).

Na 4.0.0, `[DailyReward] panels=1` em `MuServer\Tools\MainInfo\UI\ui.ini` utiliza o visual ETERNAL LEGENDS. `panels=0` conserva a janela tradicional. O calendário mantém cinco colunas, com rolagem conforme a resolução e a quantidade de dias do mês. Selecionar um dia preserva a posição da rolagem.

A janela tem até 900 px de largura e uma coluna de 280 px para a recompensa selecionada e o prêmio final. Em telas menores, o layout se adapta ao espaço disponível; em janelas muito baixas, a coluna de detalhes também permite rolagem. Os títulos usam Cormorant SC, os textos usam Lato e os detalhes visuais preservam as cores originais do ETERNAL LEGENDS. O botão Resgatar é compacto e possui efeito dourado; os estados indisponíveis não enviam solicitação de resgate.

Para atualizar, utilize o Main, UI.bin e DailyReward.lua da mesma versão, além das texturas fornecidas em `Data\Custom\Interface\DailyReward`. Preserve também as pastas compartilhadas Login e ServiceMenu, as fontes e as licenças entregues com a nova interface. Mantenha o Lua em texto aberto e idêntico na pasta do cliente e em `MuServer\Tools\LuaCryptTool\ClientDecrypted`. Não é necessário alterar `config.bin` se a opção `panels=1` já estiver ativa.

Os modelos 3D dos dias, do detalhe e do prêmio final continuam usando a calibração de `Local\System\MarketplaceItemPosition.txt`, sem uma tabela separada para o Daily Reward. A interface aplica uma ampliação local de 1,5 vez às joias pequenas conhecidas para melhorar sua leitura; armas, asas e itens customizados desconhecidos mantêm a escala da calibração compartilhada. Essa ampliação não altera a aparência no Marketplace. O Lua conserva o estado enviado pelo servidor: somente o dia atual pode ser resgatado, dias perdidos continuam expirados e o prêmio final exige todos os dias coletados. Não houve mudança no protocolo ou nas regras de entrega.

### Tradução da janela moderna

Título, meses, progresso, calendário, estados, botões, ajuda e os 31 nomes de prêmios mais o prêmio final usam `UI/Text/Eng.ini`, `Por.ini`, `Spn.ini` e `Cne.ini`, no `MainInfo` do Encoder. As chaves são `dailyreward.*`; os nomes configurados usam `dailyreward.reward.01` até `.31` e `dailyreward.reward.final`. Ao personalizar `DailyRewardConfig.lua`, ajuste as chaves correspondentes nos idiomas desejados para que o nome exibido coincida com o item entregue. A ausência de uma chave conserva o `label` do Lua. Depois de editar os textos, gere novamente o `config.bin` e reinicie o Main. O `UI.bin` inclui uma cópia padrão, mas o `config.bin` do administrador tem prioridade. As mensagens enviadas no chat pelo GameServer continuam configuradas separadamente em `messages` do Lua do servidor; não são texto da janela RmlUi. `panels=0` mantém a interface tradicional.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\DailyReward.lua
Data\Scripts\Custom\Configs\DailyRewardConfig.lua
```

Cliente:

```text
Data\Custom\Lua\Systems\DailyReward.lua
Data\Custom\Lua\Customs\Configs\DailyRewardConfig.lua
Data\Custom\Interface\MainMenu\daily.ozt
Data\Custom\Interface\glow.ozt
```

SQL:

```text
MuServer\SQL\Lua\Update1.6.5 - DailyReward.sql
```

## Proteção do resgate (3.5.0)

Atualize o GameServer/GameServerCS e o `DailyReward.lua` do servidor e execute `MuServer\SQL\Update3.5.0 - DailyReward.sql` na base configurada pelo Lua. A migration acrescenta a procedure de reserva e o registro de entregas; a tabela de calendário continua sendo a de `tableName`.

O servidor confirma a reserva SQL antes de solicitar os itens. Falha na leitura ou na reserva bloqueia o resgate; pedidos repetidos, inclusive simultâneos, não reservam o mesmo dia ou prêmio final novamente. Consultas e tentativas de resgate aceitam no máximo uma solicitação por segundo, separadamente, por personagem. Trade, morte e outras operações incompatíveis também bloqueiam o resgate.

`GX_DailyRewardDelivery` registra a reserva e quantos itens foram encaminhados para criação. `dispatched` significa que as solicitações foram enviadas, não uma confirmação individual de persistência dos itens. Se houver interrupção, erro ou entrega parcial, a reserva permanece bloqueada para impedir duplicação. O administrador deve conferir os registros e inventário antes de qualquer compensação manual; não limpe a reserva ou a marca do calendário para tentar novamente sem essa conferência. O log informa o identificador das reservas com falha detectada.

A mensagem de indisponibilidade pode ser personalizada com `messages.databaseError` no `DailyRewardConfig.lua` do servidor.

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

Joias e outros itens simples que tenham stack ativo em
`MuServer\Data\Item\ItemStack.txt` chegam acumulados ate o limite desse
arquivo e completam stacks existentes quando houver espaco. Por exemplo,
`count = 30` de Bless entrega uma stack de 30; quantidades maiores que o
limite sao divididas. Itens sem stack ou com durabilidade, tempo ou opcoes
proprias continuam individuais. O servidor confere o espaco necessario antes
de liberar o resgate.

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

A janela usa o padrao nativo `GenesysUI`, abre acima do HUD e pode ser movida pela barra superior. Moldura, titulo, botao de fechar, cards e botao de resgate seguem o visual do cliente. A posicao fica em memoria ate fechar o cliente e volta ao padrao ao reiniciar. Clique fora da moldura para fechar a janela.

O calendario usa 7 colunas. Meses de 28 dias ocupam quatro linhas; meses de 29, 30 ou 31 dias usam cinco, com a ultima linha centralizada. As coordenadas ja sao as coordenadas logicas da interface, sem multiplicar novamente toda a janela pelo `UIScale`; por isso o tamanho permanece consistente entre resolucoes e modos widescreen.

Cada slot mostra:

- Numero do dia no canto superior esquerdo.
- Banner no topo: `RESGATADO`, `RESGATAR`, `EXPIRADO` ou `BLOQUEADO`. Cada estado possui cor e contorno proprios no mesmo padrao visual do Battle Pass.
- Icone do item centralizado por ancora, com perfil visual para cada familia de item.
- Label da recompensa.

O hover exibe o tooltip nativo do MU usando os atributos definidos no config do cliente, incluindo `level`, `skill`, `luck`, `option`, `excellent` e `duration`. O preview deve representar exatamente os mesmos atributos que o servidor entrega.

## Espelhar Config no Cliente

A configuracao visual fica em:

```text
Data\Custom\Lua\Customs\Configs\DailyRewardConfig.lua
```

Replique os campos cosmeticos (`section`, `index`, `count`, `label`, e opcionais `level`, `skill`, `luck`, `option`, `excellent`, `duration`) das 30 recompensas do servidor. Quem entrega o item e o servidor. O cliente usa esses campos so para a preview da tooltip.

Sempre que alterar a lista do servidor, atualize o cliente tambem. Tooltip preview deve casar com o item real entregue.

## Acesso pelo menu principal (4.0.0)

Abra o menu pelo botão **Menu** ou por **Ctrl+F10** e selecione **Daily Reward**.
O acesso ao **Battle Pass** também está nesse menu.

O antigo `DailyRewardButton.lua` desenhava os dois botões laterais e não é
mais necessário. Remova-o de `Data\Custom\Lua\Systems` e de
`Data\Custom\Lua\Examples`, inclusive nas cópias correspondentes em
`MuServer\Tools\LuaCryptTool\ClientDecrypted`. Remova também as antigas
imagens `Data\Custom\Interface\dailyre.ozt` e `battlepass.ozt` do cliente.
Mantenha `DailyReward.lua`, `BattlePass.lua` e suas configurações.
Feche e reabra o cliente para descarregar os callbacks antigos.

O ícone do menu fica em `Data\Custom\Interface\MainMenu\daily.ozt`.
As opções do menu são descritas em [GenesysUI](../GenesysUI/README.md#menu-principal-400).

## Premio Final

Alem dos rewards diarios, existe um **premio final** entregue **uma vez por mes** a quem
coletar **todos os dias** do mes. Ele aparece em uma faixa integrada abaixo do calendario,
ao lado do bloco da recompensa do dia. Fica bloqueado ate o jogador coletar todos os dias
e entao recebe borda dourada para resgate.

Configuracao (nas DUAS configs, server e cliente, mantendo iguais):

```lua
-- mesmo formato de um reward
finalReward = { section = 14, index = 13, count = 30, label = "30x Bless (Premio Final)" },
```

Funcionamento:
- O estado e guardado na coluna `FinalClaimed` da tabela `LuaDailyReward` (criada/adicionada
  automaticamente pelo `ensureTable`; reseta por mes junto com a `ClaimedMask`).
- "Coletou todos" = todos os dias `1..(dias do mes)` que tem reward configurado estao marcados.
- O resgate segue a regra de seguranca DB->item: marca `FinalClaimed=1` antes de entregar e
  reverte se a entrega falhar.
- Packet proprio: `DailyRewardClaimFinal`. O estado enviado ao cliente ganhou o campo `f=` (0/1).

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
3. Reinicie o Main se o script client-side foi alterado.
4. Entre no jogo.
5. Clique na imagem `Daily Reward`. A janela abre e o dia atual mostra `HOJE`.
6. Passe o mouse no dia atual. Confira o tooltip preview.
7. Clique em `Resgatar`.
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
