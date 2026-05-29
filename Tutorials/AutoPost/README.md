# Tutorial: Configurar o AutoPost

Configura o sistema de anuncio automatico no chat global (comando `/post`).

O jogador digita a mensagem uma vez e o servidor repete no chat global em intervalo definido.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\AutoPost.lua
Data\Scripts\Custom\Configs\AutoPostConfig.lua
```

Roda inteiramente no servidor.

## Ativar ou Desativar

No servidor, abra:

```text
Data\Scripts\Custom\Configs\AutoPostConfig.lua
```

Para deixar ativo:

```lua
SwitchOn = 1
```

Para desativar:

```lua
SwitchOn = 0
```

Quando desativado, o comando continua registrado mas vira no-op.

## Trocar o Comando

O comando padrao e `/post`. Para trocar:

```lua
Command = "/anuncio"
```

Depois de alterar, reinicie o GameServer ou use o reload de scripts.

## Configurar Requisitos

Bloco padrao em `AutoPostConfig.lua`:

```lua
MinLevel       = 100,
MinReset       = 0,
MinMasterReset = 0,
VipOnly        = false,
MoneyCost      = 2000000,
```

| Campo | O que faz |
|---|---|
| `MinLevel` | Nivel minimo do personagem para usar o comando |
| `MinReset` | Resets minimos exigidos |
| `MinMasterReset` | Master Resets minimos exigidos |
| `VipOnly` | Se `true`, apenas contas VIP podem usar |
| `MoneyCost` | Zen descontado a cada `/post` ativado |

Se o jogador nao atender algum requisito, recebe a mensagem correspondente no chat e o comando nao executa.

## Configurar Intervalo

```lua
Interval = 60
```

Valor em segundos. A mensagem global e repetida a cada `Interval` segundos enquanto o `/post` estiver ativo no personagem.

Recomendacoes:

- `30` para servidores pequenos com pouco anuncio
- `60` valor padrao, equilibrado
- `120` ou mais para reduzir spam em servidores grandes

## Formato da Mensagem

```lua
Format = "[AutoPost] %s: %s",
```

O primeiro `%s` recebe o nome do personagem. O segundo `%s` recebe o texto digitado.

Exemplos:

```lua
Format = "[Mercado] %s: %s",
Format = "[Player] %s diz: %s",
Format = ">> %s << %s",
```

## Cor da Mensagem Global

```lua
Color = 1
```

| Valor | Estilo (varia por cliente) |
|---|---|
| `0` | Mensagem de sistema, geralmente amarela |
| `1` | Anuncio destacado, geralmente vermelho |

## Mensagens Mostradas ao Jogador

Bloco `Messages` em `AutoPostConfig.lua`:

```lua
Messages = {
    Off       = "[AutoPost] Auto post desativado.",
    Already   = "[AutoPost] Voce ja esta usando o comando %s. Use '%s off' para parar.",
    Empty     = "[AutoPost] Digite a mensagem apos o comando. Ex: %s Minha mensagem aqui",
    Level     = "[AutoPost] Voce precisa estar acima do nivel %d.",
    Money     = "[AutoPost] Voce precisa de %d zen.",
    Vip       = "[AutoPost] Somente usuarios VIP podem usar este comando.",
    Reset     = "[AutoPost] Voce precisa de %d resets.",
    MReset    = "[AutoPost] Voce precisa de %d Master Resets.",
},
```

Os placeholders `%s` e `%d` recebem valores variaveis durante a execucao. Mantenha o numero de placeholders ao traduzir.

## Como o Jogador Usa

Ativar com uma mensagem:

```text
/post Vendendo Excellent Items barato, mande PM!
```

A mensagem aparece imediatamente no chat global e e repetida a cada `Interval` segundos.

Desligar a repeticao:

```text
/post off
```

Erros comuns:

- `/post` sem texto: o sistema responde com a mensagem `Empty` e nao gasta zen
- `/post` com auto-post ja ativo: responde com `Already`, nao gasta zen

## Persistencia

O estado do auto-post fica em memoria do servidor. Quando o jogador desloga, a entrada e limpa automaticamente. Apos relogar, ele precisa digitar `/post` de novo se quiser anunciar.

Nao ha persistencia em banco de dados. Reiniciar o GameServer limpa todos os posts ativos.

## Teste

Para validar sem precisar de personagem alto:

1. Abra `AutoPostConfig.lua` e use temporariamente:

   ```lua
   MinLevel  = 1,
   MoneyCost = 100,
   Interval  = 5,
   ```

2. Reinicie o GameServer ou use o reload de scripts.

3. Entre no jogo com qualquer personagem que tenha 100 de zen e nivel 1+.

4. Digite:

   ```text
   /post Teste de auto post
   ```

5. A mensagem deve aparecer em todos os clientes conectados, repetindo a cada 5 segundos.

6. Digite `/post off` para parar.

7. Volte os valores de producao em `AutoPostConfig.lua` e recarregue.

## Observacoes

- O texto do anuncio nao passa por filtro de palavras. Se voce ja tem um sistema de filtro de chat, ele e respeitado no momento que o jogador digita o `/post` original.
- O sistema nao bloqueia anuncios duplicados de jogadores diferentes; cada conta pode ter o proprio post ativo.
- Quando o personagem deslogga, o estado e descartado. Nao tem como deixar um post "rodando enquanto offline".
- O custo em zen e cobrado uma unica vez por ativacao, nao a cada repeticao.
