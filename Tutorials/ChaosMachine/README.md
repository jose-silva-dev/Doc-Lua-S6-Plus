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

Mixes de teste vem na configuracao padrao para validar perda, custo e rate por VIP.

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
	width = 370,
	height = 370,
	maxMixes = 6,
	maxItems = 5,
	maxIngredients = 5,
	maxRewards = 5,
}
```

Se aumentar a quantidade de combinacoes ou de itens exibidos, ajuste `height`, `maxMixes`, `maxIngredients` e `maxRewards`. Quando houver mais itens do que o limite visivel, o jogador pode rolar a lista com o mouse.

A janela usa `RenderTop`, pode ser movida pela barra superior e fecha com `ESC` consumindo a tecla antes das janelas nativas. A interface bloqueia apenas o mouse enquanto ele esta sobre a janela.

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
