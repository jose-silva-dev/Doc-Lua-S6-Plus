# Tutorial: Configurar a Lucky Wheel

A Lucky Wheel permite criar uma ou mais roletas de premios. O sorteio, a cobranca e a entrega sao validados pelo GameServer; a animacao do cliente apenas mostra o resultado recebido.

## Interface ETERNAL LEGENDS (4.0.0)

Com `[LuckyWheel] panels = 1` em `MuServer\Tools\MainInfo\UI\ui.ini`,
a janela usa uma roleta circular de 8 ou 16 posições, modalidades na lateral
e um Cofre de Prêmios com lista rolável e visualização do item selecionado.
O botão Girar mantém as ondas da imagem azul em movimento contínuo; a moldura,
o texto e o custo permanecem fixos. Abrir cofre e Voltar à roleta usam o mesmo
botão azul animado, sem ícones.
A seta acompanha o prêmio destacado e para na posição do resultado enviado
pelo servidor, tanto nas roletas de 8 como nas de 16 posições. O centro usa
uma única moldura. Ao passar o mouse sobre Girar, aparece um reflexo suave
de vidro; ao pressionar, o botão escurece levemente. Esse retorno visual
fica desativado enquanto o giro está em andamento.

Os modelos 3D continuam usando a calibração de
`Local\System\MarketplaceItemPosition.txt`. As joias pequenas conhecidas
recebem o mesmo ajuste local de escala 1,5 usado no Daily Reward; os demais
itens preservam a escala compartilhada como referência. Nos círculos da roleta,
o cliente centraliza o contorno projetado do modelo e reduz apenas os modelos
que ultrapassariam o espaço disponível. Esse enquadramento é exclusivo dos
prêmios circulares da Lucky Wheel: não altera a tabela de calibração, o
Marketplace, o Daily Reward nem o Cofre. O tooltip mantém os atributos do prêmio.
O GameServer continua responsável pelo sorteio, cobrança, permissões e resgate.

Atualize o Main, `Data\Custom\UI.bin`, `Data\Custom\Lua\Systems\LuckyWheel.lua`
e as texturas de `Data\Custom\Interface\LuckyWheel` fornecidas no update.
Os recursos compartilhados de Login, System e DailyReward também devem estar
atualizados. Mescle as chaves `luckywheel.*` dos quatro exemplos de idiomas,
gere o `config.bin` no Encoder e reabra o cliente. A nova chave
`luckywheel.button.back` nomeia o retorno do Cofre à roleta.
Não é necessário alterar SQL nem reiniciar o GameServer por esta revisão visual.
Com `panels = 0`, a janela tradicional permanece disponível. Se o novo Main ou
documento RmlUi não estiver disponível, o script mantém a apresentação anterior.

## Tradução da janela moderna (3.5.0)

Com `[LuckyWheel] panels=1`, Lucky Wheel e Cofre usam `UI/Text/<idioma>.ini` do `MainInfo`, nos idiomas Eng, Por, Spn e Cne. As chaves `luckywheel.*` cobrem títulos, saldo, custo, botões, lista, detalhe, estados e mensagens exibidas dentro da janela. As mensagens do GameServer levam uma chave estável no pacote, mas preservam o texto configurado em `messages` para Main antigo e `panels=0`. Nome de roleta ou prêmio vindo de `LuckyWheelConfig.lua` usa a chave `luckywheel.name.<nome_normalizado>`; por exemplo, `Jewel of Bless` usa `luckywheel.name.jewel_of_bless`. Os 68 nomes da configuração padrão já têm chaves nos quatro idiomas. Para nomes próprios novos, adicione as chaves nos INIs desejados; na ausência delas, o nome enviado pelo servidor permanece. Edite os INIs, gere novamente o `config.bin` no Encoder e reinicie o Main. O `UI.bin` tem textos padrão, mas o `config.bin` do administrador tem prioridade. Anúncios e mensagens no chat global são controlados pelo Lua do servidor, não por estes textos da janela.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\LuckyWheel.lua
Data\Scripts\Custom\Configs\LuckyWheelConfig.lua
```

Cliente:

```text
Data\Custom\Lua\Systems\LuckyWheel.lua
Data\Custom\Lua\Definitions\Client.lua
Data\Custom\Lua\Definitions\GenesysUI.lua
Data\Custom\Lua\Assets\MarketplaceClose.png
```

SQL:

```text
SQL\Lua\Update2.2.0 - LuckyWheel.sql
```

## Menu principal (4.0.0)

Abra o Atalho Rápido por **Ctrl+F10** ou pelo botão **Atalho** e selecione o trevo
**Roleta da Sorte**. O servidor envia o catálogo antes de autorizar a janela;
o botão não inicia um giro nem cobra moedas.

Atualize `MuServer\Data\Scripts\Custom\System\LuckyWheel.lua` e sua cópia em
`MuServer\Tools\LuaCryptTool\ServerDecrypted\Data\Scripts\Custom\System`.
Mantenha as cópias iguais e em texto aberto. Aplique Reload Lua no GS/GSCS
ou reinicie o serviço para carregar a alteração; repita nas demais salas.

O menu respeita `commandEnable=true` no `LuckyWheelConfig.lua`, assim como
o comando remoto, inclusive se o nome do comando foi personalizado.
Com `commandEnable=false`, a abertura pelo menu é recusada; o acesso por
NPC permanece configurável. As permissões de conta, bloqueios de operação,
cooldowns e regras de giros/resgates continuam sendo verificadas pelo servidor.

A entrada pode ser ocultada com `ShowLuckyWheel = 0` em `[Features]` do
`UI\Config\ShortcutMenu.ini`. A ativação do Atalho Rápido permanece no `ui.ini`.
O ícone está em `Data\Custom\Interface\MainMenu\luckywheel.ozt`.

## Abrir por NPC ou Comando

No `LuckyWheelConfig.lua`:

```lua
npcEnable = true,
npcClass = 255,
npcMap = 0,
npcX = 145,
npcY = 140,
npcDir = 1,

commandEnable = true,
command = "/roleta",
```

Use `false` para desativar o NPC ou o comando.

Na 3.5.0, instale também `Data\Scripts\LuaSystem\NpcAccess.lua` e atualize GS/GSCS. Giros e ações do cofre exigem uma abertura autorizada pelo servidor. Ao abrir pelo NPC, o jogador precisa permanecer no mesmo mapa e a até 5 coordenadas em cada eixo do NPC; a restrição `npcServerCode` é conferida novamente em cada ação. A autorização expira após 5 minutos sem uso ou ao sair do personagem.

Com `commandEnable=true`, o comando configurado continua permitindo abertura e uso remoto, como antes. Desativá-lo invalida esse acesso. Pacotes enviados diretamente sem abertura autorizada são recusados. Trade, morte, viagem e transações pendentes também impedem as ações.

## Criar uma Roleta

Cada entrada de `wheels` cria uma categoria na lateral da janela:

```lua
{
	id = 1,
	name = "Roleta Joias",
	spinCurrency = "coin1",
	spinPrice = 30,
	prizes = {
		{ id = 1, type = "item", name = "Jewel of Bless", section = 14, index = 13, weight = 200 },
		{ id = 2, type = "item", name = "Jewel of Soul", section = 14, index = 14, weight = 200 },
		{ id = 3, type = "currency", name = "5.000.000 Zen", currency = "zen", amount = 5000000, weight = 100 },
		-- Complete a lista com exatamente 8 ou 16 premios.
	},
},
```

- `id`: identificador unico da roleta.
- `spinCurrency`: `zen`, `coin1`, `coin2` ou `coin3`.
- `spinPrice`: valor cobrado por giro.
- `weight`: peso do premio no sorteio. A chance e o peso dividido pela soma de todos os pesos da roleta.
- `announce = true`: anuncia o premio no chat global.

## Posicao dos Premios

Com 8 premios:

```text
1 2 3
4 G 5
6 7 8
```

Com 16 premios:

```text
 1  2  3  4  5
16           6
15     G     7
14           8
13 12 11 10  9
```

`G` representa o botao `Girar`. A janela muda de tamanho automaticamente ao alternar entre uma roleta de 8 e uma de 16 premios.

## Premio de Item

```lua
{
	id = 1,
	type = "item",
	name = "Sword Full",
	section = 0,
	index = 14,
	level = 11,
	skill = 1,
	luck = 1,
	option = 7,
	excellent = 63,
	setOption = 0,
	count = 1,
	weight = 20,
}
```

## Premio de Moeda

```lua
{
	id = 2,
	type = "currency",
	name = "100 WCoinC",
	currency = "coin1",
	amount = 100,
	weight = 100,
}
```

## Cofre de Premios

```lua
prizeToVault = true,
vaultMaxEntries = 50,
```

Com `prizeToVault = true`, todo premio fica no cofre ate o jogador clicar em `Resgatar`. Com `false`, o sistema tenta entregar diretamente e usa o cofre quando o inventario ou o limite da moeda impedir a entrega.

A janela do cofre permite selecionar um premio e resgatar apenas ele. Com
`[LuckyWheel] panels=1`, o cofre usa a lista e o painel de detalhe: o primeiro
premio recebido fica selecionado, itens aparecem no mesmo renderizador e
posicionamento do Marketplace (poços de 46×46 e 92×92), e o tooltip nativo
continua disponivel ao passar o mouse. O texto da quantia permanece completo
na lista; no preview de Zen ele e abreviado. A lista mostra quatro entradas por
vez e aceita roda do mouse, clique na trilha e arraste do marcador. Com
`panels=0`, o cofre conserva a moldura, as linhas e os botoes nativos anteriores.
O pedido de resgate e a entrega continuam validados pelo GameServer.

## Interface Padrao

Na 3.5.0, `Tools\MainInfo\UI\ui.ini` permite escolher a janela principal:

```ini
[LuckyWheel]
panels=1
```

`panels=1` usa o layout **Anel lateral** com a paleta de `[Theme]`, com as categorias à direita,
saldo/custo/cofre no topo e os mesmos itens 3D e tooltips nativos. `0` mantém a
janela original. A escolha é incorporada ao `config.bin` pelo Encoder. Após mudar o valor, gere o `config.bin` novamente e reinicie o
Main. O cofre acompanha o tema escolhido; os pacotes de rede e as regras de
sorteio não mudam.

O Anel lateral e o Cofre consultam as mesmas cores do RmlUi pelo Main. Em
`[Theme]`, `gradientstart` e `gradientend` controlam o degradê dos cabeçalhos;
se forem iguais, o fundo fica uniforme. Os demais fundos, bordas e destaques
seguem `window`, `control`, `border`, `accent` e as outras chaves da paleta.
Depois de editar `Tools\MainInfo\UI\ui.ini`, gere novamente o `config.bin` e
reinicie o Main. O modo tradicional (`panels=0`) mantém seu desenho anterior.

No layout novo, o painel central ocupa apenas o vão interno do anel; não cobre
os prêmios inferiores. Moedas grandes aparecem abreviadas no slot (`100M` / `Zen`),
mas o nome e a quantia completos continuam no destaque e ao passar o mouse.
Os itens do anel e do destaque usam `Client.RenderMarketplaceItem` nos respectivos
quadrados. Assim respeitam a mesma escala, âncora, posição e rotação configuradas
em `Local\System\MarketplaceItemPosition.txt` pelo editor do Marketplace, sem nova
lista de ajustes para a Lucky Wheel. Para levar a calibração a outros clientes,
copie o TXT exportado pelo editor para o MainInfo e gere o PAK. Sem entrada para
um item, a regra padrão do Marketplace continua valendo. O botão de fechar usa `GenesysUI.RenderIconControl("close", x, y)`
com o mesmo ícone do Marketplace, carregado de `MarketplaceClose.png`.
O título moderno é texto `LUCKY WHEEL`, desenhado com a fonte `Title` definida em
`Tools\MainInfo\Local\System\CustomFont.txt`. Os arquivos `.ttf` dessa configuração
ficam abertos em `Data\Custom\UI\Fonts` do cliente. Não há ícone/subtítulo nem
imagem separada para o título. Na 3.5.0, os títulos `LUCKY WHEEL` e
`COFRE DE PREMIOS` do modo moderno usam a mesma fonte `Title` ampliada e são
alinhados à esquerda, com margem de 9 unidades igual à margem direita do X,
e centralizados verticalmente na faixa de 38 unidades do cabeçalho.
O `height` de `RenderText` define a caixa de alinhamento; o tamanho efetivo da
fonte `Title` vem do Main.

No Lua do cliente, `ClientAPI.IsLuckyWheelModernUI()` informa a opção carregada
do `config.bin` (booleano). Em Main antigo, a função não existe e o script usa a janela
original automaticamente.

Na versao 2.4.0, a janela principal e o cofre usam o tema nativo `GenesysUI`:

- moldura, titulo e botao de fechar do cliente;
- cards nativos para premios e categorias;
- botoes nativos sem esticar a textura;
- barra de rolagem nativa no cofre;
- janela centralizada, arrastavel e limitada a area visivel;
- clique fora fecha a janela e e consumido, sem mover o personagem.

Durante um giro ativo, o clique externo continua sendo consumido, mas a janela
permanece aberta ate o resultado chegar.

O catalogo das roletas e enviado internamente em lotes seguros. Isso permite usar
varias categorias com 16 premios sem ultrapassar a fila de rede do GameServer nem
desconectar o jogador durante a abertura. O primeiro lote ja traz todas as
categorias, os premios da primeira roleta, saldo e cofre; a janela abre nesse
lote. As outras roletas terminam de carregar nos lotes seguintes e nao podem
ser selecionadas antes de receber todos os seus premios. Sorteio e cobranca
continuam exclusivamente no GameServer.

Na janela original, os previews mantem o renderizador anterior e os perfis visuais
por familia. O anel moderno usa `Client.RenderMarketplaceItem` e a calibracao
compartilhada com o Marketplace descrita acima.

Essa alteracao e somente visual. Sorteio, cobranca, pesos, restricoes VIP, entrega e persistencia do cofre continuam processados pelo servidor.

## Aplicar e Testar

1. Salve o `LuckyWheelConfig.lua`.
2. Execute `/reload scripts` como administrador ou recarregue os scripts pelo GameServer.
   Com GS/GSCS atualizados, a tag `LuckyWheel` substitui apenas o NPC anterior
   do sistema quando classe, mapa ou posicao mudam; NPCs fixos ficam intactos.
3. Reinicie o Main quando o arquivo client-side `LuckyWheel.lua` for alterado.
4. Abra pelo NPC ou use `/roleta`.
5. Troque entre roletas de 8 e 16 premios.
6. Confira saldo, custo, tooltip, giro e premio recebido.
7. Abra `Resgatar`, teste selecao, rolagem e retirada do cofre.
