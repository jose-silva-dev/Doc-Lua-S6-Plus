# Tutorial - Chaos Machine

Este tutorial mostra como configurar uma combinacao simples no Chaos Machine.

## 1. Ativar o Sistema

No servidor, abra:

```text
Data\Scripts\Custom\Configs\ChaosMachineConfig.lua
```

Confirme:

```lua
enabled = true
```

## 2. Escolher Como Abrir

Para abrir por comando:

```lua
commands = { "/chaosmix" }
```

Para abrir por NPC:

```lua
npc = {
	enabled = true,
	class = 238,
	map = 3,
	x = 185,
	y = 105,
	checkPosition = true,
}
```

Se usar um NPC que ja abre uma tela original do jogo, mantenha `checkPosition = true`. Assim somente o NPC dessa coordenada abre o Chaos Machine Lua; os outros NPCs iguais continuam funcionando normalmente.

## 3. Criar uma Combinacao

Em `mixes`, adicione uma entrada:

```lua
{
	id = 1,
	enabled = true,
	name = "Leather Set Full",
	rate = 100,
	rates = {
		[0] = 50,
		[1] = 60,
		[2] = 70,
		[3] = 80,
	},
	zen = 0,
	failText = "Em caso de falha: perde a Jewel of Chaos.",
	ingredients = {
		{ section = 12, index = 15, level = -1, count = 1, name = "Jewel of Chaos" },
	},
	rewards = {
		{ section = 7, index = 0, level = 15, skill = 0, luck = 1, option = 7, excellent = 63, name = "Leather Helm +15 Full" },
		{ section = 8, index = 0, level = 15, skill = 0, luck = 1, option = 7, excellent = 63, name = "Leather Armor +15 Full" },
		{ section = 9, index = 0, level = 15, skill = 0, luck = 1, option = 7, excellent = 63, name = "Leather Pants +15 Full" },
		{ section = 10, index = 0, level = 15, skill = 0, luck = 1, option = 7, excellent = 63, name = "Leather Gloves +15 Full" },
		{ section = 11, index = 0, level = 15, skill = 0, luck = 1, option = 7, excellent = 63, name = "Leather Boots +15 Full" },
	},
}
```

A configuracao padrao inclui dez modelos neutros, de `Combinacao 1` ate
`Combinacao 10`, para o administrador editar sem precisar montar a estrutura
do zero. A dificuldade cresce progressivamente:

| Combinacao | Chance base | Custo em Zen |
|---|---:|---:|
| 1 | 100% | 0 |
| 2 | 90% | 50.000 |
| 3 | 80% | 100.000 |
| 4 | 70% | 200.000 |
| 5 | 60% | 350.000 |
| 6 | 50% | 500.000 |
| 7 | 40% | 750.000 |
| 8 | 30% | 1.000.000 |
| 9 | 20% | 2.000.000 |
| 10 | 10% | 5.000.000 |

Os ingredientes e premios incluidos sao exemplos editaveis. Antes de abrir o
servidor ao publico, revise `name`, `rates`, `zen`, `ingredients` e `rewards`
de cada combinacao para adequar a progressao ao seu servidor.

Para desligar uma combinacao sem apagar:

```lua
enabled = false
```

Para cobrar Zen:

```lua
zen = 1000000
```

O servidor valida o Zen antes de remover ingredientes. Se faltar Zen, o mix nao inicia.

Para configurar chance por VIP, use `rates`:

```lua
rates = {
	[0] = 50, -- free
	[1] = 60, -- vip 1
	[2] = 70, -- vip 2
	[3] = 80, -- vip 3
}
```

O numero usado e o retorno de `User:getAccountLevel()`. Se o VIP do jogador nao existir em `rates`, o sistema usa `rate` como fallback.

## 4. Reiniciar ou Recarregar

Depois de alterar a configuracao, reinicie o GameServer ou use o comando de reload disponivel no servidor.

## 5. Testar

No jogo:

1. coloque o ingrediente no inventario;
2. abra com `/chaosmix` ou fale com o NPC;
3. selecione a combinacao;
4. passe o mouse nos itens para conferir o tooltip;
5. clique em `Mixar`.

Se o inventario nao tiver espaco para todos os premios, o servidor recusa o mix antes de remover ingredientes.

## 6. Ajustar a Janela

No cliente, abra:

```text
Data\Custom\Lua\Customs\Configs\ChaosMachineConfig.lua
```

O tamanho padrao da janela e:

```lua
window = {
	width = 480,
	height = 440,
	maxMixes = 6,
	maxItems = 5,
	maxIngredients = 5,
	maxRewards = 5,
	itemIconSize = 42,
	itemIconScale = 0.50,
}
```

`maxMixes`, `maxIngredients` e `maxRewards` definem quantas entradas aparecem
simultaneamente, e nao o limite total cadastrado. Quando houver mais entradas
que o limite visivel, a coluna recebe uma barra nativa. A configuracao padrao
mantem seis das dez combinacoes visiveis e permite acessar as demais pela roda
do mouse, clique na trilha ou arraste do marcador. Os cards mantem o contorno
completo mesmo quando a barra esta visivel.

A janela usa o padrao nativo `GenesysUI`, com moldura, titulo, `X`, cards
`character_ex`, botao pequeno e barras de rolagem iguais as do cliente. O
tamanho e logico e permanece consistente entre resolucoes e modos widescreen.
A lista de combinacoes, os ingredientes e os resultados aceitam roda do mouse,
clique na trilha e arraste direto do marcador.

Ingredientes e resultados ficam em duas colunas independentes. Cada item usa
um card com area quadrada para o preview, nome e quantidade. Joias, armas,
armaduras, asas e consumiveis possuem perfis de escala diferentes para manter
os modelos centralizados e dentro do card. `itemIconScale` funciona como
multiplicador global desses perfis. Apenas combinacoes e itens realmente
recebidos do servidor geram cards; os limites `maxMixes`, `maxIngredients` e
`maxRewards` controlam a quantidade maxima visivel, sem criar espacos vazios.

A janela usa `RenderTop`, pode ser movida pela barra superior e fecha pelo `X`,
com `ESC` ou ao clicar fora da moldura. O fechamento tambem encerra o inventario
aberto em conjunto com o sistema.

Ao abrir o Chaos Machine, o inventario tambem e aberto automaticamente. Se o jogador fechar o inventario, o Chaos Machine fecha junto. Se o jogador fechar o Chaos Machine, o inventario tambem e fechado.

O cliente exibe:

- lista de combinacoes;
- chance de sucesso ja calculada para o VIP do jogador;
- Zen necessario;
- resumo de sucesso/falha;
- ingredientes;
- resultados;
- tooltip nativo dos itens.

Enquanto o servidor processa o pedido, o botao `Mixar` fica em estado de espera para evitar clique duplicado.

O cliente nao valida ingredientes, nao remove itens e nao cria premios. Toda validacao e feita pelo GameServer.

## Tooltips

Os itens exibidos na lista usam tooltip nativo quando `ClientAPI.ShowItemTooltipFull` esta disponivel. O preview recebe os mesmos campos usados na entrega do item:

```text
section, index, level, skill, luck, option, excellent, setOption, harmony, itemOptionEx
```

Isso permite conferir o resultado do mix antes de executar a combinacao.

## 7. Logs de Auditoria

No servidor:

```lua
auditLog = true
```

Com essa opcao ativa, o GameServer registra jogador, VIP, mix, rate usada, ingredientes removidos, sucesso/falha e premios entregues.
