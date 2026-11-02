# Airship Travel

Sistema de teleporte com cinematica de dirigivel. O personagem conversa com um NPC, decola, escolhe um destino e pousa no mapa autorizado pelo GameServer.

## Arquivos

```text
MuServer\Data\Scripts\Custom\Configs\AirshipTravelConfig.lua
MuServer\SQL\Lua\Update3.0.0 - AirshipTravel.sql
MuServer\Tools\MainInfo\Local\CustomAirship.txt
Cliente\Data\Custom\Airship\ShipGenesys.bmd
```

O controlador oficial da viagem ja esta incorporado ao Main e ao GameServer. O administrador edita as regras em `AirshipTravelConfig.lua` e a apresentacao em `CustomAirship.txt`; nao e necessario instalar scripts do sistema no cliente ou em `Custom\System`.

Para uso normal, mantenha `debug = false`. Ative-o temporariamente somente quando precisar diagnosticar a configuracao ou uma viagem.

## Traduzir a interface

Todos os textos da janela ficam no bloco `texts` de `AirshipTravelConfig.lua`. Nele e possivel traduzir titulo, subtitulo, estados, botoes, rotulos, requisitos, moedas, limite diario e instrucao de cancelamento. Os nomes das rotas continuam no campo `name` de cada destino. Os avisos de validacao ficam logo abaixo, no bloco separado `messages`.

```lua
texts = {
	windowTitle = "Viagem de Dirigivel",
	subtitle = "Escolha onde o dirigivel deve pousar",
	available = "DISPONIVEL",
	blocked = "BLOQUEADO",
	access = "ACESSO",
	cost = "CUSTO",
	travel = "Viajar",
	closed = "Fechado",
	free = "Livre",
	noCost = "Gratuito",
	unlimited = "Sem limite",
	today = "Hoje %d/%d",
	level = "Nivel %d",
	reset = "%d Reset",
	masterReset = "%d MReset",
	account = "Conta %d",
	noPk = "Sem PK",
	consume = "%s (consome)",
	possess = "%s (possuir)",
	zenLabel = "Zen",
	wcoincLabel = "WCoinC",
	wcoinpLabel = "WCoinP",
	goblinLabel = "Goblin Points",
	mapFallback = "Mapa %d",
	cancelHint = "Clique fora ou pressione Esc para cancelar",
	destination = "Destino",
}

messages = {
	invalid = "Destino invalido.",
	expired = "A sessao de viagem expirou. Fale novamente com o NPC.",
	level = "Nivel minimo: %d.",
	reset = "Resets minimos: %d.",
	masterReset = "Master Resets minimos: %d.",
	vip = "Esta rota exige um tipo de conta superior.",
	pk = "Esta rota nao permite personagem PK.",
	zen = "Voce precisa de %d Zen.",
	wcoinc = "Voce precisa de %d WCoinC.",
	wcoinp = "Voce precisa de %d WCoinP.",
	goblin = "Voce precisa de %d Goblin Points.",
	item = "Voce precisa de %dx %s no inventario.",
	dailyLimit = "Limite diario atingido para este destino.",
	database = "Nao foi possivel consultar o limite diario.",
	chargeFailed = "Nao foi possivel cobrar os requisitos da viagem.",
	failed = "Nao foi possivel concluir a viagem.",
	wait = "Aguarde um instante.",
}
```

Os dois blocos ficam juntos no inicio da configuracao: `texts` controla o conteudo visual da janela e `messages` controla os avisos enviados ao jogador. O arquivo aceita texto UTF-8, inclusive acentos, ingles, chines e outros idiomas. Preserve os marcadores `%d` e `%s`, pois recebem valores dinamicos. Depois de salvar, use `/reload scripts`; a traducao sera enviada pelo GameServer na proxima vez que a janela for aberta, sem gerar PAK e sem reiniciar o Main.

## Configurar o NPC

Cada destino possui seu proprio bloco `npc` em `AirshipTravelConfig.lua`. Assim, o administrador escolhe uma classe e uma posicao diferentes para cada mapa:

```lua
{
	id = 1,
	name = "Lorencia",
	map = 0,
	x = 115,
	y = 120,
	-- demais requisitos da rota...
	playerLanding = {
		x = 118,
		y = 120,
		dir = 3,
	},
	npc = {
		enabled = true,
		class = 540,
		x = 117,
		y = 117,
		dir = 3,
	},
}
```

O GameServer cria automaticamente um NPC em cada estacao habilitada. A classe nao e fixa: altere `class`, `x`, `y` e `dir` separadamente em cada destino.

- `npc.enabled`: cria ou desativa o NPC desta estacao;
- `npc.class`: classe/modelo escolhido pelo administrador;
- `npc.x`, `npc.y`: posicao do NPC no mapa do destino;
- `npc.dir`: direcao do NPC;
- `npc.serverCode`: opcional; sobrescreve o servidor definido em `npcDefaults`.

Os valores omitidos de `dir` e `serverCode` usam o bloco global:

```lua
npcDefaults = {
	serverCode = 0, -- 0 = GS, 19 = GSCS, -1 = todos
	dir = 3,
}
```

Use uma posicao livre proxima ao dirigivel, sem colocar o NPC exatamente sobre o modelo. O sistema reconhece o NPC pela classe, mapa e posicao, portanto a mesma classe pode ser usada em mapas diferentes sem conflito.

## Configurar destinos

Cada rota fica em `destinations`:

```lua
{
	id = 1,
	name = "Lorencia",
	map = 0,
	x = 115,
	y = 120,
	playerLanding = {
		x = 118,
		y = 120,
		dir = 3,
	},
	npc = {
		enabled = true,
		class = 540,
		x = 117,
		y = 117,
		dir = 3,
	},
	requirements = {
		minLevel = 1,
		minReset = -1,
		minMasterReset = -1,
		accountLevel = 0,
		allowPk = true,
		cost = {
			zen = -1,
			wcoinc = 10,
			wcoinp = -1,
			goblin = -1,
		},
		items = {
			{ name = "Jewel of Soul", section = 14, index = 14, level = -1, count = 1, consume = true },
		},
		dailyLimit = {
			limit = 3,
			scope = "account",
		},
	},
},
```

- `id`: identificador unico da rota;
- `name`: nome mostrado na janela;
- `map`, `x`, `y`: local onde o dirigivel fica estacionado e pousa;
- `playerLanding.x`, `playerLanding.y`: local separado onde o personagem sera colocado;
- `playerLanding.dir`: direcao do personagem ao reaparecer;

O bloco `requirements` controla o acesso e o custo da rota:

- `minLevel`, `minReset`, `minMasterReset`: requisitos do personagem; `-1` desativa;
- `accountLevel`: nivel minimo da conta/VIP;
- `allowPk`: permite ou bloqueia personagem PK;
- `cost`: cobra `zen`, `wcoinc`, `wcoinp` e/ou `goblin`; `-1` ou `0` deixa a moeda gratuita;
- `items`: lista de itens exigidos no inventario;
- `level = -1`: aceita o item em qualquer level;
- `consume = true`: remove o item ao viajar; `false` apenas exige que ele esteja no inventario;
- `dailyLimit.limit`: viagens permitidas por dia para este destino; `-1` ou `0` deixa ilimitado;
- `dailyLimit.scope`: use `account` para contar por conta ou `character` para contar por personagem.

Execute `Update3.0.0 - AirshipTravel.sql` uma vez no banco `MuOnline` antes de ativar limites diarios. A contagem e renovada automaticamente a cada novo dia.

Todas as exigencias sao conferidas novamente pelo GameServer. Alterar o script do cliente nao libera destinos bloqueados.

Cada entrada de `destinations` tambem cria automaticamente uma estacao visual local em `map/x/y`. Ao entrar no mapa, o cliente posiciona o dirigivel no mesmo ponto usado pelo pouso, sem precisar adicionar o modelo no `MonsterSetBase`. O objeto nao existe no GameServer e nao gera processamento ou animacao para os outros jogadores.

Use preferencialmente uma estacao por mapa. Se houver varias rotas para o mesmo mapa, a primeira entrada configurada sera usada como dirigivel estacionado. Cada estacao habilitada tambem recebe seu NPC de viagem configurado no proprio destino.

## Ajustar a aparencia e a cinematica

O objeto e inteiramente local. Quando um jogador inicia a viagem, somente o cliente dele anima a decolagem; os demais continuam vendo o dirigivel estacionado. Os parametros visuais ficam em:

```text
MuServer\Tools\MainInfo\Local\CustomAirship.txt
```

A secao `0` possui uma unica linha global: escala do voo, offsets e rotacao do modelo, velocidade de animacao, enquadramento da camera, altura, distancia lateral, tempos de decolagem/sobrevoo/pouso, direcao do voo, atraso para revelar o personagem e distancia de renderizacao.

A secao `1` permite sobrescrever por mapa a escala e orientacao do navio estacionado, offsets do modelo e ajustes de camera. Use uma linha para cada mapa que possui estacao. O cabecalho do proprio arquivo identifica todas as colunas.

Depois de alterar `CustomAirship.txt`, execute o `Encoder.exe` na pasta `MuServer\Tools\MainInfo` e distribua o novo `Data\av-code45.pak` junto do `Main.exe` compativel. O TXT nao precisa ser colocado no cliente.

Durante a viagem, o cliente afasta a camera automaticamente para enquadrar o dirigivel em diferentes resolucoes. O zoom utilizado pelo jogador antes da viagem e restaurado ao pousar ou cancelar.

Durante a viagem, o personagem permanece oculto e sem realizar acoes. Ao finalizar o pouso, ele reaparece automaticamente na posicao definida em `playerLanding`.

No GameServer, use `/reload scripts` para recarregar destinos, NPCs, posicoes e requisitos de `AirshipTravelConfig.lua`. Alteracoes visuais de `CustomAirship.txt` exigem gerar novamente o PAK e reiniciar o Main.

## Som do NPC

Quando o jogador permanece a ate 5 tiles do Kael the Navigator, o cliente reproduz a cada 5 segundos o arquivo:

```text
Cliente\Data\Custom\Sound\Airship\KaelLaugh.wav
```

O som e local: somente jogadores proximos ao NPC o escutam. Ele para de ser repetido ao se afastar ou iniciar a viagem. Para personaliza-lo, substitua o arquivo por outro WAV PCM mantendo o mesmo nome e caminho. Nao e necessario gerar o PAK novamente.

Durante toda a animacao, desde a decolagem ate o fim do pouso ou cancelamento, o cliente mantem em loop o ambiente:

```text
Cliente\Data\Custom\Sound\Airship\ShipAmbience.wav
```

Ele tambem pode ser substituido por outro WAV PCM no mesmo caminho. O loop e interrompido automaticamente em todas as saidas da viagem. Durante o voo, o sistema silencia temporariamente a musica, os monstros e os demais efeitos do mapa, deixando somente o audio da viagem. As preferencias de volume do jogador sao preservadas.
