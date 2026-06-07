# Tutorial: Configurar o AutoPost

Sistema de anuncio **repetivel** no chat global, acionado por `/post auto`.

O jogador digita a mensagem uma vez e o servidor a republica em intervalo definido, no mesmo estilo do `/post` nativo (linha `[POST]` no chat de baixo). O `/post` comum (sem `auto`) continua sendo o post nativo do servidor.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\AutoPost.lua
Data\Scripts\Custom\Configs\AutoPostConfig.lua
```

Roda inteiramente no servidor. Depende da funcao `SendGlobalPost` (ver `Server/Functions.md`).

## Comando

- `/post <mensagem>` -> **post nativo** do servidor (uma vez), comportamento inalterado.
- `/post auto <mensagem>` -> liga o **auto post repetivel**.
- `/post auto off` -> desliga.

O gatilho do auto post e o **subcomando** `auto`. Qualquer `/post` que nao comece com `auto` cai no post nativo.

## Ativar ou Desativar

Em `AutoPostConfig.lua`:

```lua
SwitchOn = 1   -- 1 ativo, 0 desativado
```

Desativado, `/post auto` responde com a mensagem `Disabled` e nao publica; o `/post` nativo continua funcionando normal.

## Trocar o Subcomando

```lua
Command    = "/post",   -- comando base (mantido nativo)
SubCommand = "auto",    -- "/post auto ..." aciona o sistema
```

Para usar, por exemplo, `/post spam`, troque `SubCommand = "spam"`. Depois recarregue os scripts ou reinicie o GameServer.

## Estilo do Post

```lua
PostType = 0
```

Estilo do post publicado. Deixe `PostType = 0` para o auto post sair com o **mesmo estilo do `/post` comum** do seu servidor. Os valores `1`, `2`, `3` selecionam estilos alternativos de post, caso queira diferenciar o anuncio automatico.

## Requisitos

```lua
MinLevel       = 100,
MinReset       = 0,
MinMasterReset = 0,
MoneyCost      = 2000000,
```

| Campo | O que faz |
|---|---|
| `MinLevel` | Nivel minimo do personagem |
| `MinReset` | Resets minimos |
| `MinMasterReset` | Master Resets minimos |
| `MoneyCost` | Zen descontado (ver cobranca abaixo) |

Se o jogador nao atende um requisito, recebe a mensagem correspondente e nada e cobrado.

## Acesso por Tipo de Conta

```lua
allowByVip = {
    [0] = 1,  -- normal/free
    [1] = 1,  -- vip1
    [2] = 1,  -- vip2
    [3] = 1,  -- vip3
},
```

`1` libera, `0` bloqueia. **Tier nao declarado = bloqueado.** Exemplos:

| Quer liberar | Config |
|---|---|
| Todos (padrao) | `[0]=1,[1]=1,[2]=1,[3]=1` |
| So VIP3 | `[0]=0,[1]=0,[2]=0,[3]=1` |
| Qualquer VIP | `[0]=0,[1]=1,[2]=1,[3]=1` |
| So free | `[0]=1,[1]=0,[2]=0,[3]=0` |

## Cobranca: por ativacao ou por ciclo

```lua
ChargePerCycle = true,
```

- `true`: cobra `MoneyCost` **a cada repeticao**. Quando o jogador fica sem zen, o auto post **encerra** e avisa. (vai consumindo enquanto roda)
- `false`: cobra so **na ativacao**; as repeticoes sao gratis.

Em ambos os casos a cobranca e **avisada no topo** (mensagem `Charged`).

## Intervalo

```lua
Interval = 60
```

Segundos entre cada repeticao. Sugestoes: `30` (servidores pequenos), `60` (padrao), `120+` (reduz spam).

## Mensagens

```lua
Messages = {
    Disabled     = "[AutoPost] Sistema de auto post desativado.",
    Off          = "[AutoPost] Auto post desativado.",
    Charged      = "[AutoPost] -%.0f zen consumido. Saldo: %.0f.",
    Insufficient = "[AutoPost] Zen insuficiente para continuar. Auto post encerrado.",
    Already      = "[AutoPost] Voce ja esta usando o comando %s. Use '%s off' para parar.",
    Empty        = "[AutoPost] Digite a mensagem apos o comando. Ex: %s Minha mensagem aqui",
    Level        = "[AutoPost] Voce precisa estar acima do nivel %d.",
    Money        = "[AutoPost] Voce precisa de %d zen.",
    Vip          = "[AutoPost] Seu tipo de conta nao tem acesso ao auto post.",
    Reset        = "[AutoPost] Voce precisa de %d resets.",
    MReset       = "[AutoPost] Voce precisa de %d Master Resets.",
},
```

Mantenha o numero de placeholders (`%s`, `%d`, `%.0f`) ao traduzir. Em `Charged` use `%.0f` (e nao `%d`) para o saldo, pois o zen pode passar de 2 bilhoes e estourar `%d` na build 32 bits.

## Como o Jogador Usa

```text
/post auto Vendendo Excellent Items barato, mande PM!
```

A mensagem aparece no chat global (estilo `[POST]`, embaixo) e se repete a cada `Interval` segundos. Para parar:

```text
/post auto off
```

## Persistencia

O estado fica em memoria do servidor. Ao deslogar, e limpo. Apos relogar, o jogador precisa digitar `/post auto ...` de novo. Reiniciar o GameServer limpa todos os posts ativos.

## Teste

1. Em `AutoPostConfig.lua` use temporariamente:

   ```lua
   MinLevel  = 1,
   MoneyCost = 100,
   Interval  = 5,
   ```

2. Recarregue os scripts ou reinicie o GameServer.
3. Entre com um personagem com nivel 1+ e algum zen.
4. Digite `/post auto Teste` -> deve aparecer no chat (embaixo) e repetir a cada 5s, avisando o consumo no topo.
5. Digite `/post Teste normal` -> deve sair como o `/post` nativo, sem repetir.
6. Digite `/post auto off` para parar.
7. Volte os valores de producao e recarregue.

## Observacoes

- O `/post` comum permanece 100% nativo (anti-spam, estilo, tudo). O sistema so intercepta `/post auto`.
- Cada conta pode ter o proprio auto post ativo; nao bloqueia posts de jogadores diferentes.
- Sem persistencia em banco; nada "roda offline".
