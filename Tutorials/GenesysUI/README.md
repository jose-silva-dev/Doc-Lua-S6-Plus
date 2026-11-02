# GenesysUI

`GenesysUI` monta interfaces Lua com o padrão visual nativo do cliente. Cantos e laterais permanecem fixos, enquanto topo, fundo e centro se adaptam ao tamanho da janela.

Arquivo necessário:

```text
Data\Custom\Lua\Definitions\GenesysUI.lua
```

## Janela básica

```lua
local width = 420
local height = 360
local x, y = GenesysUI.CenterWindow(width, height)

local layout = GenesysUI.Window("Minha janela", x, y, width, height)

if layout ~= nil then
	Client.RenderText(
		layout.contentX,
		layout.contentY,
		"Conteudo",
		layout.contentWidth,
		12,
		3,
		255,
		255,
		255,
		255)
end
```

Use as medidas retornadas em `layout` para posicionar o conteúdo. O tamanho mínimo da janela nativa é `150 x 252` (era `228 x 252` até a 3.1.1). Com `150` de mínimo cabe uma janela da largura do inventário, que é `190`.

## Componentes prontos

```lua
GenesysUI.RenderNativeCard(x, y, width, height, red, green, blue, alpha)
GenesysUI.RenderNativeSmallButton(text, x, y, options)
GenesysUI.RenderNativeWideButton(text, x, y, options)
GenesysUI.RenderNativePanel(x, y, width, height)
GenesysUI.RenderNativeScrollBar(trackX, trackY, trackHeight, percent, active)
GenesysUI.RenderIconControl("close", x, y)
```

`RenderNativePanel` e `RenderNativeWideButton` existem a partir da 3.2.0.

`RenderIconControl("close", x, y)` retorna `true` quando o mouse está sobre
o botão. Na 4.0.0, usa o padrão compartilhado `.ui-close-control`: caixa externa
de 28 × 28, raio de 5 e ícone Lucide X de 18 × 18 centralizado. Use
`GenesysUI.IconControlSize` no posicionamento e no hit-test; a ação de fechar
continua a cargo da janela chamadora. Daily Reward e Lucky Wheel modernas
usam esse componente, incluindo o cofre de prêmios.

As cores vêm de `[Theme]` do UI.ini via config.bin: `control`, `border` e `text`
no estado normal; `accent`, `accentborder` e `accenttext` no hover;
`accenthover` ao pressionar. As imagens brancas com transparência em
`Data\Custom\Lua\Assets\Common` recebem a cor por `Client.RenderImageTinted`.
Não altere as medidas de clique separadamente do desenho. Interfaces nativas
continuam com `RenderNativeCloseButton` e suas medidas próprias.

`RenderNativePanel` e o painel afundado que o jogo desenha em volta das listas de item. O miolo fica vazio: pinte o fundo antes de chamar e a moldura entra por cima. Minimo `28 x 28`, porque os quatro cantos tem 14 pixels cada.

## Arquivos da interface RmlUi (3.5.0)

O Main exige `Data\Custom\UI.bin` e `Data\Custom\UI\config.bin` válidos. Ausência, adulteração ou conteúdo incompleto impede a inicialização e exibe uma mensagem para restaurar os arquivos. O `config.bin` deve ser gerado pelo Encoder com o CustomerName correto e conter o `ui.ini`.

Arquivos RML, RCSS, INI e imagens soltos dentro da pasta da UI não substituem o conteúdo dos pacotes. Fontes externas e as texturas nativas do jogo continuam suportadas. Para personalizar opções e traduções, edite os arquivos de `MuServer\Tools\MainInfo\UI`, gere novamente o `config.bin` e copie a saída para o cliente. Esta regra não altera o fluxo normal de scripts Lua abertos.

A proteção dos pacotes não substitui as verificações do servidor: preço, prêmio, saldo e permissão de uso continuam sendo decididos pelo GameServer.

## Fundos e logo do login/loading (4.0.0)

Guarde os originais em `MuServer\Tools\MainInfo\UI\Images\Login` e configure
`MuServer\Tools\MainInfo\UI\ui.ini`. Os caminhos são relativos a `UI\Images`:

```ini
[Media]
LoginBackground=Login/LoginBackground.png
Logo=Login/logo.webp
LoadingBackground=Login/LoadingBackground.png
```

As três opções aceitam PNG, JPG/JPEG, BMP, GIF estático, TIF/TIFF de uma página,
WebP estático/animado ou MP4 (H.264). Por exemplo, use
`LoginBackground=Login/LoginBackground.mp4` para vídeo na seleção.
`LoadingBackground=` vazio mantém o fundo preto. Imagens: até 16 MiB;
vídeos MP4: até 128 MiB. Para animação, use WebP ou MP4.

Use o Main e o Encoder atualizados juntos. Execute o Encoder depois de mudar
arquivos/configuração e entregue `Data\Custom\UI\media.bin` e `config.bin`
gerados no PathExport do MainInfo.ini. Os originais não vão soltos ao cliente.
Feche e reabra o Main para aplicar. O logo preserva sua proporção; os fundos
preenchem a tela e podem ter bordas recortadas. Vídeos não reproduzem áudio.
`[Login] background=0` continua usando o cenário nativo da seleção.

## Arte da interface ETERNAL LEGENDS (4.0.0)

O loading, a seleção de servidor, o login/cadastro e o menu de configurações
usam as texturas **OZT com transparência** fornecidas em
`Data\Custom\Interface\Loading`, `Login` e `System`. Copie também as fontes
fornecidas em `Data\Custom\UI\Fonts`. Essas texturas vão diretamente ao
cliente; os fundos e o logo continuam sendo escolhidos no `[Media]` do
`ui.ini` e gerados pelo Encoder, conforme a seção anterior.

No menu de configurações, as ondas douradas ficam nas abas laterais. Os três
botões do rodapé têm somente brilho no hover. Busca, atalhos e opções
habilitadas na seção `[Panel]` continuam funcionando. As três telas usam as
cores originais da arte; as demais interfaces mantêm suas opções de tema.

As antigas imagens PNG de controles em `UI\Images\Shared\Buttons`,
`UI\Images\Loading` e os dez PNGs antigos de controles em `UI\Images\Login`
não são necessárias para essa interface. Preserve os fundos e o logo de
`UI\Images\Login`. O Encoder atualizado aceita a remoção completa dos
14 controles antigos; se mantiver o conjunto legado, ele deve estar completo.
Não remova apenas parte dele. A antiga pasta `UI\Login` pode ser retirada
depois de migrar suas mídias e configurar seus novos caminhos em `[Media]`.

## Textos da nova UI (3.5.0)

`GenesysUI.Text(chave, padrao, textoNativo)` lê a mesma tabela `UI/Text/<idioma>.ini` dos documentos RmlUi, pelo idioma escolhido no `config.bin`. Use `GenesysUI.FormatText(chave, padrao, valores, textoNativo)` para frases com `{count}`, `{name}` etc. O Main expõe `Client.GetUIString(chave, padrao, textoNativo)`. Passe `textoNativo=true` ao desenhar com `ClientAPI.RenderText`; a ponte converte o UTF-8 do INI para a codificação dessa fonte. Para HTML RmlUi, passe `false` e escape o texto antes de montar o documento. Uma chave ausente usa o texto padrão; `Eng.ini` é a base dos outros idiomas. Depois de editar os INIs do `MainInfo\UI\Text`, gere novamente o `config.bin` no Encoder e reinicie o Main.

```lua
local title = GenesysUI.Text("luckywheel.title", "LUCKY WHEEL", true)
local count = GenesysUI.FormatText("luckywheel.vault.pending",
    "{count} pendentes", { count = 3 }, true)
```

`RenderNativeWideButton` e o botao largo do jogo, com os tres estados. Alem das `options` do botao pequeno, aceita `enabled = false` para apagar o texto e ignorar o mouse. Devolve uma tabela com `hovered` e `pressed`.

Para arraste contínuo, use `GenesysUI.BeginDrag`, `GenesysUI.UpdateDrag` e `GenesysUI.EndDrag`. Em controles próprios, consulte `Client.IsMouseLeftButtonHeld()` para que o arraste continue mesmo depois de bloquear o clique do jogo.

## Exemplo completo

```text
Data\Custom\Lua\Examples\GenesysUIWindowExample.lua
```

A pasta `Examples` não é carregada automaticamente. Para testar, copie o arquivo para `Data\Custom\Lua\Systems` e reinicie o Main. O exemplo abre e fecha com `F10`, pode ser arrastado pelo topo e demonstra três tamanhos de janela.

## Menu principal (4.0.0)

Abra pelo botão **Menu**, no canto inferior esquerdo acima da HUD, ou por
**Ctrl+F10**. Use a busca para localizar um recurso pelo nome, atalho ou descrição.
**Esc** e o botão de fechar encerram o menu. **F10** sozinho mantém a câmera 3D,
e os atalhos existentes continuam funcionando fora da busca.

O menu reúne Daily Reward, Battle Pass, Roleta da Sorte (Lucky Wheel), Personagem, Inventário, Jewel Bank,
Mover, Quests nativas (**T**), Eventos, Party, Buscar Party (**Ctrl+P**), Guild,
Comandos e Configurações. As entradas Lua dependem dos respectivos scripts
carregados; a opção não aparece quando o sistema não está disponível. O Jewel
Bank usa a tecla e o pedido de abertura definidos em `JewelBankConfig`.
Os pedidos passam pelas validações existentes do servidor.

A Roleta da Sorte usa o ícone de trevo e solicita ao servidor o catálogo
atual antes de abrir. Atualize o `LuckyWheel.lua` do servidor e mantenha
`commandEnable=true` no `LuckyWheelConfig.lua` para permitir o acesso pelo
menu, com as mesmas regras do comando. `commandEnable=false` mantém o
acesso remoto bloqueado; o NPC continua seguindo sua configuração.
Use `luckywheel=0` em `[MainMenu]` para ocultar essa entrada.

Em `MuServer\Tools\MainInfo\UI\ui.ini`, a seção `[MainMenu]` controla o menu:

```ini
[MainMenu]
enabled=1
button=1
daily=1
battle=1
luckywheel=1
character=1
inventory=1
jewel=1
move=1
quest=1
events=1
party=1
searchparty=1
guild=1
commands=1
settings=1
```

`enabled=0` desliga o menu; `button=0` oculta somente seu botão na tela.
As demais chaves ocultam a entrada correspondente quando recebem `0`, sem
alterar o atalho original do recurso. As cores são herdadas de `[Theme]`.
Os textos usam as chaves `mainmenu.*` em `UI\Text\Por.ini`, `Eng.ini`,
`Spn.ini` e `Cne.ini`. Depois de personalizar os INIs, gere o `config.bin`
com o Encoder, copie a saída para o cliente e reinicie o Main.

Daily Reward e Battle Pass passam a ser acessados por este menu. Remova o
antigo `DailyRewardButton.lua` das pastas `Systems` e `Examples` do cliente e
das cópias em `LuaCryptTool\ClientDecrypted`. As imagens antigas
`Data\Custom\Interface\dailyre.ozt` e `battlepass.ozt` também podem ser
removidas. Preserve os scripts dos sistemas e reabra o cliente após a remoção.

Os ícones ficam em `Data\Custom\Interface\MainMenu`, no formato **OZT** com
transparência (TGA de 32 bits). O menu usa os documentos distribuídos no
`UI.bin`; não é necessário acrescentar chamadas aos scripts Lua atuais.
Enquanto sua busca estiver aberta, `Client.IsKeyboardInputCaptured()` retorna
`true`, para que os scripts que consultam essa função não acionem atalhos
com as letras digitadas.
