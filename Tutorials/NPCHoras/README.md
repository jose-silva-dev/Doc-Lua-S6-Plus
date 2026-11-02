# Bonus por Horas: escolher o servidor do NPC

O NPCHoras contabiliza tempo online e permite trocar horas por itens no NPC.
O controle abaixo escolhe onde o NPC aparece e aceita resgates; nao altera
a contagem de horas, os saldos ou os comandos nos demais servidores.

## Arquivos

No MuServer:

```text
Data\Scripts\Custom\Configs\NPCHorasConfig.lua
Data\Scripts\Custom\System\NPCHoras.lua
```

Atualize o script junto com a configuracao: versoes antigas do script nao
interpretam `npcServerCode`. A configuracao correspondente no cliente cuida
da interface, nao da permissao por servidor.

## Escolher por ServerCode

Dentro de `NPCHorasConfig`, configure uma unica linha `npcServerCode`:

| Valor | Onde aparece e permite resgates |
| --- | --- |
| `npcServerCode = 0,` | Somente no servidor de codigo 0; padrao do exemplo |
| `npcServerCode = 42,` | Somente no servidor de codigo 42 |
| `npcServerCode = { 0, 1 },` | Nos servidores de codigo 0 e 1 |
| `npcServerCode = -1,` | Em todos os servidores que carregam o sistema |
| `npcServerCode = {},` | Em nenhum servidor; continua contando horas |

Use o `ServerCode` real de `GameServerInfo - Common.dat`. Os codigos 1 e 42
sao exemplos: nao significam VIP ou No-PvP por si mesmos. Para um servidor
VIP/No-PvP, informe o codigo atribuido a ele na sua instalacao. Em instalacoes
com pastas Data separadas, mantenha a politica desejada em cada configuracao.

Listas usam o formato sequencial `{ 0, 1 }`, nao `{ [0] = true }`. Strings
numericas tambem sao aceitas. Lista vazia e valores invalidos nao autorizam o
NPC. O campo ausente equivale a `-1` para compatibilidade com configuracoes
antigas; por isso, adicione o campo explicitamente ao atualizar. Se nao for
possivel obter o ServerCode atual, o NPC e o resgate ficam bloqueados.

## Mapa e posicao

O servidor autorizado tambem precisa hospedar `npcMap`, conforme seu
`MapServerInfo.dat`. O ServerCode nao move mapas entre servidores nem escolhe
automaticamente um mapa diferente para cada GS.

Exemplo para o GS principal com Lorencia:

```lua
enabled = true,
npcClass = 702,
npcServerCode = 0,
npcMap = 0,
npcX = 151,
npcY = 144,
npcDir = 1,
```

Um GSCS que nao hospeda Lorencia nao pode criar o NPC nesse mapa. A selecao
por ServerCode evita a tentativa nos servidores excluidos. Uma falha real de
criacao em um servidor autorizado continua sendo registrada; nao e ocultada.

## Ocultar sem parar a contagem

```lua
enabled = true,
npcServerCode = {},
```

Assim, os jogadores continuam acumulando horas e os comandos `/horas` e
`/addhoras` continuam registrados. Nenhum NPC abre a janela ou entrega premios
nesse servidor. A permissao tambem e validada no pacote de resgate, mesmo que
`maxTalkDistance = 0` ou um cliente tente solicitar um premio diretamente.

`enabled = false` tem outro significado: desliga o sistema inteiro, incluindo
contagem e comandos. Nao o use apenas para esconder o NPC.

## Aplicar e recarregar

Depois de instalar GS/GSCS com a API `Npc.SpawnTagged`, use `/reload scripts`
para ler o arquivo alterado. O NPC do NPCHoras tem a tag propria `NPCHoras`:
classe, mapa, posicao e ServerCode podem mudar sem acumular copias; apenas a
instancia criada pelo script e substituida/removida. NPCs fixos do
`MonsterSetBase` permanecem e nao devem ser confundidos com o NPC do sistema.

`/reload monster` reconstrói os monstros e NPCs do mapa e chama o callback
Lua do NPCHoras com a configuracao ja carregada. Para aplicar uma mudanca no
arquivo Lua, use `/reload scripts`. O Main e os hashes de producao nao mudam
por uma simples edicao de config; a API com tag exige GS/GSCS atualizados.

As alteracoes e os exemplos sao entregues em Lua aberto, sem criptografia.
