# Client Side - Functions

Funcoes disponiveis para scripts que rodam no Main/cliente.

Para scripts novos, prefira `Client.X`.

## Texto

### Client.RenderText

```lua
Client.RenderText(x, y, text, width, height, sort, red, green, blue, alpha)
```

Desenha texto na tela.

Parametros:

- `x`, `y`: posicao.
- `text`: texto.
- `width`, `height`: area.
- `sort`: alinhamento.
- `red`, `green`, `blue`, `alpha`: cor.

Exemplo:

```lua
Client.RenderText(20, 90, "Ola mundo", 200, 0, 1, 255, 255, 255, 255)
```

### Client.SetTextColor / SetTextBg / SetFontType

```lua
Client.SetTextColor(red, green, blue, alpha)
Client.SetTextBg(red, green, blue, alpha)
Client.SetFontType(fontType)
Client.RenderBox(x, y, width, height, alpha)
Client.RenderColorBox(x, y, width, height, red, green, blue, alpha)
```

Define estado de texto para renderizacoes seguintes.
Em `SetFontType`, use `0` normal, `1` negrito, `2` grande, `3` fixo ou `4` titulo da interface configurado em `UI\\CustomFont.txt`. Para aplicar o tipo escolhido, chame `RenderText` com cores `-1`, como no exemplo. O tipo `4` e exclusivo de texto desenhado por `RenderText`; os estilos de nome sobre personagem mantem suas opcoes proprias.

Exemplo:

```lua
Client.SetFontType(1)
Client.SetTextColor(255, 220, 80, 255)
Client.RenderText(20, 120, "Texto destacado", 220, 0, 1, -1, -1, -1, -1)
```

## Imagens e som

### Client.LoadImage

```lua
Client.LoadImage(path, imageId)
Client.GetImageWidth(imageId)
Client.GetImageHeight(imageId)
```

Carrega imagem do cliente.

Exemplo:

```lua
Client.LoadImage("Custom\\Lua\\Cache\\banner.jpg", 92010)
```

Em assets convertidos do cliente, e comum o script apontar para `.tga` enquanto o arquivo fisico esta em `.ozt`. Exemplo:

```lua
Client.LoadImage("Custom\\Interface\\HP\\hp.tga", 73001)
```

Arquivo fisico esperado:

```text
Data\Custom\Interface\HP\hp.ozt
```

### Client.RenderImage

```lua
Client.RenderImage(imageId, x, y, width, height)
```

Renderiza imagem carregada. A chamada estabelece internamente cor branca e transparência alpha; portanto, a imagem não herda blend/cor deixados por tooltips ou por outro callback desenhado antes dela.

Exemplo:

```lua
Client.RenderImage(92010, 120, 90, 300, 120)
```

### Client.RenderImageTinted

```lua
Client.RenderImageTinted(imageId, x, y, width, height, red, green, blue, alpha)
```

Disponível na 4.0.0, também como `ClientAPI.RenderImageTinted`. Desenha uma
imagem carregada com multiplicação RGBA (canais de 0 a 255). Uma imagem branca
com transparência permite colorir ícones e máscaras conforme o tema. Preserva
a transparência, usa as mesmas coordenadas de `RenderImage` e restaura a cor
branca ao terminar. Não modifica a textura nem os desenhos seguintes.
Retorna `false` para imagem inexistente ou dimensões inválidas; canais fora
do intervalo são limitados. Para manter as cores originais, use 255 nos quatro.

### Client.RenderImageUV

```lua
Client.RenderImageUV(imageId, x, y, width, height, u, v, uWidth, vHeight)
```

Renderiza parte de uma imagem com o mesmo isolamento de cor/transparência de `Client.RenderImage`.

### Client.UnloadImage

```lua
Client.UnloadImage(imageId)
```

Remove imagem da memoria.

### Client.LoadSound

```lua
soundId = Client.LoadSound(path [, soundId])
```

Carrega um efeito sonoro personalizado em formato **WAV PCM**. O caminho e relativo a pasta do cliente.

Retorna o ID carregado ou `-1` em caso de erro. Se o ID for omitido, o cliente escolhe automaticamente um ID livre entre `10000` e `10127`.

Exemplo:

```lua
local soundId = Client.LoadSound("Data\\Custom\\Sound\\reward.wav")

if soundId ~= -1 then
    Client.PlaySound(soundId)
end
```

Quando o sistema nao precisar mais do som:

```lua
Client.StopSound(soundId)
Client.UnloadSound(soundId)
```

Para escolher o ID manualmente:

```lua
local soundId = Client.LoadSound("Data\\Custom\\Sound\\reward.wav", 10000)
```

O ID manual deve estar entre `10000` e `10127`. Se ele ja estiver em uso, descarregue-o antes de reutilizar. Podem existir ate 128 sons personalizados carregados ao mesmo tempo.

### Client.UnloadSound

```lua
Client.UnloadSound(soundId)
```

Para e remove da memoria um som personalizado. Os sons tambem sao liberados automaticamente ao recarregar os scripts ou fechar o cliente.

### Client.PlaySound / StopSound

```lua
Client.PlaySound(soundId [, loop])
Client.StopSound(soundId)
```

Toca ou para um som carregado. Use `loop = true` para repetir continuamente ate chamar `Client.StopSound(soundId)`. Se omitido, o som toca uma vez. Retorna `true` em caso de sucesso e `false` se o ID nao estiver carregado.

Exemplo de som ambiente continuo:

```lua
local ambientId = Client.LoadSound("Data\\Custom\\Sound\\ambient.wav")
Client.PlaySound(ambientId, true)

-- Ao encerrar a cena:
Client.StopSound(ambientId)
```

Use o ID retornado por `Client.LoadSound`. Estas funcoes podem ser usadas em botoes, alertas, recompensas, eventos, NPCs e outros sistemas Lua.

### Client.BeginSoundFocus / EndSoundFocus

```lua
Client.BeginSoundFocus(soundId)
Client.EndSoundFocus()
```

Cria uma cena de audio exclusiva. Enquanto estiver ativa, a musica e os efeitos normais do jogo ficam silenciados e somente o `soundId` informado pode tocar. As preferencias de volume do jogador nao sao alteradas.

O foco tambem funciona quando a musica do cliente esta desativada ou quando nenhuma faixa esta tocando. Nesses casos nao existe stream de musica para interromper, mas o som exclusivo informado continua sendo controlado normalmente.

```lua
local ambientId = Client.LoadSound("Data\\Custom\\Sound\\travel.wav")

Client.BeginSoundFocus(ambientId)
Client.PlaySound(ambientId, true)

-- Ao encerrar a cena:
Client.StopSound(ambientId)
Client.EndSoundFocus()
```

Sempre finalize o foco ao concluir ou cancelar a cena.

## Janela/interface

```lua
Client.IsWindowOpen(windowId)
Client.OpenWindow(windowId)
Client.CloseWindow(windowId)
Client.ToggleWindow(windowId)
Client.HideAllInterfaces()
Client.LockInterface()
Client.UnlockInterface()
Client.LockPlayerWalk()
Client.UnlockPlayerWalk()
Client.IsInterfaceLocked()
Client.IsPlayerWalkLocked()
Client.BlockMouse()
Client.ConsumeKey(vk)
```

Exemplo:

```lua
if not Client.IsWindowOpen(ClientAPI.Windows.Inventory) then
	Client.OpenWindow(ClientAPI.Windows.Inventory)
end
```

### Render nativo de janelas

```lua
Client.RenderNativeWindow(x, y, width, height)
Client.RenderNativeCloseButton(x, y, state)
Client.RenderNativeArrowButton(x, y, direction, state)
```

`Client.RenderNativeWindow` monta uma janela no padrão visual do cliente. Os cantos permanecem fixos e as partes centrais se adaptam ao tamanho informado. O tamanho mínimo é `150 x 252`.

A partir da 3.2.0 o mínimo de largura caiu de `228` para `150`, o que permite janelas com a mesma largura do inventário (`190`) — útil para janelas que encostam nele. Abaixo de `150` a moldura sai rasgada, porque o topo tem duas pontas fixas de 60 pixels que passariam a se sobrepor.

Em `Client.RenderNativeArrowButton`, use `direction = -1` para esquerda e `direction = 1` para direita. Em botões, `state = 0` representa o estado normal e `state = 1` o pressionado.

### Lista de skills e atalhos (janela de skills)

Disponível a partir da 3.1.0. Estas funções alimentam a janela de skills em grade (`MainInfo.ini` → `SkillWindowNew = 1`) e podem ser usadas por qualquer script do cliente.

Na implementação fornecida, o ícone de Skills funciona como alternância: um clique abre a janela e o clique seguinte fecha. Clicar fora, no X ou pressionar Escape também fecha a lista.

```lua
Client.IsSkillListOpen()                 -- true se a lista de skills está aberta (exige SkillWindowNew = 1)
Client.CloseSkillList()                  -- fecha a lista de skills
Client.GetSkillListCount()               -- quantidade de skills utilizáveis (mesmos filtros da fileira nativa)
Client.GetSkillListSlot(index)           -- slot da skill na posição index (1..count); -1 se inválido
Client.RenderSkillSlot(slot, x, y)       -- desenha a caixa (32x38) com o ícone da skill; destaca a skill atual
Client.SelectSkillSlot(slot)             -- seleciona a skill do slot e fecha a lista (igual ao clique nativo)
Client.GetSkillHotkeyCount()             -- total de slots de atalho de skill (10)
Client.GetSkillHotkeySlot(index)         -- slot da skill no atalho index (1..count); -1 se vazio
Client.SetSkillHotkeyBySlot(index, slot) -- põe a skill do slot no atalho index; remove de outro atalho se já existir
Client.GetSkillHotkeyPage()              -- página da barra de atalhos do HUD: 0 = atalhos 1..5, 1 = atalhos 6..9 e 0
Client.SetSkillHotkeyPage(page)          -- muda a página da barra do HUD (0 ou 1)
Client.RenderSkillTooltip(slot, x, y)    -- tooltip nativo da skill do slot (nome, dano real, alcance, mana, AG)
```

`slot` é o índice interno da skill do personagem (o mesmo devolvido por `Client.GetSkillListSlot`), não o tipo da skill. A barra de atalhos do HUD usa os mesmos dados, então `Client.SetSkillHotkeyBySlot` atualiza as duas ao mesmo tempo.

Em `Client.SetSkillHotkeyBySlot`, `index` é o número do atalho como o jogador vê (teclas `1`..`9` e `0`), que coincide com o índice interno do array. Com `SkillWindowNew = 1`, a página do HUD deixa de ser recalculada a cada frame: ela ainda acompanha a skill atual quando a seleção muda, mas passa a aceitar `Client.SetSkillHotkeyPage` no meio tempo.

Para sistemas novos, prefira a biblioteca `GenesysUI`, que já centraliza título, botão de fechar, conteúdo, limites da tela e interações:

```lua
local x, y = GenesysUI.CenterWindow(420, 360)
local layout = GenesysUI.Window("Minha janela", x, y, 420, 360)

if layout ~= nil then
	-- desenhe o conteúdo dentro de layout.contentX/layout.contentY
end
```

Componentes disponíveis:

```lua
GenesysUI.RenderNativeCard(x, y, width, height, red, green, blue, alpha)
GenesysUI.RenderNativeSmallButton(text, x, y, options)
GenesysUI.RenderNativeWideButton(text, x, y, options)
GenesysUI.RenderNativePanel(x, y, width, height)
GenesysUI.RenderNativeScrollBar(trackX, trackY, trackHeight, percent, active)
GenesysUI.IsCloseHit(layout, mouseX, mouseY)
GenesysUI.IsHeaderHit(layout, mouseX, mouseY)
GenesysUI.BlockMouse(layout)
GenesysUI.BeginDrag(state, layout, mouseX, mouseY)
GenesysUI.UpdateDrag(state, width, height, mouseX, mouseY)
GenesysUI.EndDrag(state)
```

Disponíveis a partir da 3.2.0:

`GenesysUI.RenderNativePanel` desenha o painel afundado que o jogo usa em volta das listas de item — o contorno do inventário e do baú. O miolo fica vazio de propósito: pinte o fundo que quiser antes de chamar, e a moldura entra por cima. Largura e altura mínimas são `28 x 28`, porque os quatro cantos têm 14 pixels cada.

`GenesysUI.RenderNativeWideButton` é o botão largo do jogo, com os três estados (normal, mouse em cima, apertado). Aceita as mesmas `options` do botão pequeno — `width`, `height`, as cores do texto — mais `enabled = false`, que deixa o texto apagado e ignora o mouse. Devolve uma tabela com `hovered` e `pressed`, ou `nil` se a textura não carregar.

```lua
GenesysUI.RenderNativePanel(x + 12, y + 195, 165, 209)

local botao = GenesysUI.RenderNativeWideButton("Confirmar", x + 40, y + 165, {
	width = 110,
	height = 25,
	enabled = temEscolha,
})

if botao ~= nil and botao.hovered and Client.IsMouseLeftButtonPush() then
	-- clique
end
```

Um exemplo completo e descriptografado fica em `Data\Custom\Lua\Examples\GenesysUIWindowExample.lua`.

### A roda do mouse e a câmera

Com o cursor sobre a sua janela, chame `Client.BlockMouse()` para o jogo ignorar o mouse ali. A partir da 3.2.0 ele **também zera a roda**, o que impede a câmera 3D de dar zoom por trás da janela.

Por isso vale a ordem: **leia a roda antes de chamar `Client.BlockMouse()`**. Invertido, a sua lista deixa de rolar.

```lua
if Client.IsMouseInRect(x, y, width, height) then
	local wheel = Client.GetMouseWheel()   -- primeiro a roda
	if wheel ~= 0 then
		scroll = scroll + (wheel > 0 and -1 or 1)
	end

	Client.BlockMouse()                    -- depois o bloqueio
	return true
end
```

### Cinematica de viagem por dirigivel

```lua
Client.AirshipSetDock(map, x, y, angle, scale)
Client.AirshipBeginTakeoff(scale, ascentHeight, lateralDistance, durationMs, cruiseDurationMs, cameraYaw, flightHeading)
Client.AirshipPrepareLanding(scale, ascentHeight, lateralDistance, durationMs, map, dockX, dockY, dockAngle, revealDelayMs)
Client.AirshipGetPhase()
Client.AirshipCancel()
```

`Client.AirshipSetDock` configura o dirigivel local que permanece estacionado no mapa. Somente o jogador que iniciou a viagem ve esse objeto decolar; nos demais clientes ele continua parado.

Estas funcoes controlam somente a parte visual local do dirigivel. A validacao do destino e o teleporte devem continuar no GameServer.

Fases retornadas por `Client.AirshipGetPhase()`:

- `0`: inativo;
- `1`: decolagem;
- `2`: aguardando a escolha do destino;
- `3`: aguardando o teleporte autorizado pelo GameServer;
- `4`: pouso;
- `5`: dirigivel estacionado, aguardando o momento de revelar o personagem.

Exemplo resumido:

```lua
Client.LockPlayerWalk()
Client.AirshipSetDock(0, 115, 120, 90, 20.00)
Client.AirshipBeginTakeoff(20.00, 1800, 1200, 3500, 5000, 0, 0)

-- Depois da escolha validada pelo GameServer:
Client.AirshipPrepareLanding(20.00, 1800, 1200, 3500, 0, 115, 120, 90, 700)

-- Use somente para cancelar a cinematica:
Client.AirshipCancel()
Client.UnlockPlayerWalk()
```

O sistema oficial ja esta incorporado ao `Main.exe` e aos GameServers. O administrador configura estacoes, NPCs e requisitos em `Data\Scripts\Custom\Configs\AirshipTravelConfig.lua`; escala, modelo, camera e tempos da cinematica ficam em `Tools\MainInfo\Local\CustomAirship.txt` e sao incorporados ao `av-code45.pak` pelo Encoder. As funcoes acima permanecem publicas para a criacao de outras cinematicas em scripts proprios.

## Mouse e teclado

```lua
Client.IsKeyDown(vk)
Client.ConsumeKey(vk)
Client.IsKeyboardInputCaptured()
Client.GetMouseX()
Client.GetMouseY()
Client.GetMouseWheel()
Client.PeekMouseWheel()
Client.IsMouseLeftButton()
Client.IsMouseLeftButtonHeld()
Client.IsMouseRightButton()
Client.IsMouseLeftButtonPush()
Client.IsMouseRightButtonPush()
Client.IsMouseLeftButtonPop()
Client.IsMouseRightButtonPop()
Client.IsWindowActive()
```

`Client.IsWindowActive()` indica se esta instância está com o foco de entrada. No modo de abas, retorna `false` para as outras abas, mesmo quando aparecem na tela dividida.

`Client.IsKeyboardInputCaptured()` retorna `true` quando o teclado esta focado em chat/editbox nativo, quando uma janela Lua travou a interface ou enquanto o menu principal (Ctrl+F10) esta aberto, incluindo a busca. Na 4.0.0, tambem protege o breve intervalo de fechamento do menu para evitar que a mesma tecla acione outra janela. Use antes de atalhos globais lidos por `Client.IsKeyDown`.

`Client.IsMouseLeftButtonHeld()` lê o estado físico contínuo do botão esquerdo. Use em arraste de janelas, sliders e barras de rolagem. Diferente de `Client.IsMouseLeftButton()`, ele continua retornando `true` depois de `Client.BlockMouse()` proteger a interface; retorna `false` quando o cliente perde o foco.

Exemplo:

```lua
if Client.IsKeyDown(0x78) then -- F9
	MyWindow.open = not MyWindow.open
end

if MyWindow.open and Client.IsKeyDown(0x1B) then -- ESC
	Client.ConsumeKey(0x1B)
	MyWindow.open = false
end
```

`Client.ConsumeKey(vk)` deve ser chamado quando a janela Lua tratou uma tecla que tambem possui acao nativa. Para `ESC`, isso impede que o mesmo pressionamento continue abrindo o menu de opcoes ou fechando outras janelas nativas; a tecla permanece bloqueada ate ser solta.

### Reload do Lua do cliente

Quando o servidor/cliente distribuido tiver a opcao abaixo ativada no `MainInfo`, o `F6` recarrega o Lua do cliente sem fechar o Main:

```ini
[Lua]
ClientLuaReload = 1
```

Esse atalho e restrito a personagem GM/Admin. Com `ClientLuaReload = 0`, o atalho fica desativado.

Para janelas acima do HUD, registre o desenho em `ClientHooks.RegisterRenderTop(name, callback)` ou implemente o callback global `RenderTop()`.

## Dados do personagem local

```lua
Client.GetName()
Client.GetLevel()
Client.GetClass()
Client.GetMap()
Client.GetX()
Client.GetY()
Client.GetLife()
Client.GetMaxLife()
Client.GetMana()
Client.GetMaxMana()
Client.GetBP()
Client.GetMaxBP()
Client.GetShield()
Client.GetMaxShield()
Client.GetStatsPoint()
Client.GetStrength()
Client.GetDexterity()
Client.GetVitality()
Client.GetEnergy()
Client.GetLeadership()
Client.GetExperience()
Client.GetNextExperience()
Client.GetBaseExperience()
Client.GetMasterLevel()
Client.GetMasterPoint()
Client.GetMasterExperience()
Client.GetMasterNextExperience()
```

Exemplo:

```lua
local text = string.format("%s Level %d", Client.GetName(), Client.GetLevel())
Client.RenderText(20, 80, text, 240, 0, 1, 255, 255, 255, 255)
```

## Informacoes globais do cliente

```lua
Client.GetLanguage()
Client.GetCodePage()
Client.GetResolution()
ClientAPI.GetResolutionInfo()
Client.GetVolume()
Client.SetVolume(level)
Client.GetWindowWidth()
Client.GetWindowHeight()
Client.GetInterfaceWidth()
Client.GetInterfaceHeight()
Client.GetOpenGLWindowWidth()
Client.GetOpenGLWindowHeight()
Client.GetFPS()
Client.GetGlobalText(textId)
Client.GetMapName(mapId)
Client.GetMonsterName(monsterId)
Client.GetPartyCount()
Client.GetPing()
Client.GetCamera3D()
ClientAPI.IsLuckyWheelModernUI()
ClientAPI.IsDailyRewardModernUI()
Client.GetUIThemeColorHex(key)
Client.SetGlowVisible(enabled)
Client.IsGlowVisible()
Client.SetEquipmentVisible(enabled)
Client.IsEquipmentVisible()
```

`Client.GetWindowWidth()` e `Client.GetWindowHeight()` retornam as dimensões físicas atuais da área do jogo. No modo de abas, correspondem à área daquela aba, inclusive em tela dividida; não ao tamanho do host inteiro nem necessariamente ao preset salvo.

Para posicionar e centralizar janelas Lua na mesma escala das interfaces nativas, use `Client.GetInterfaceWidth()` e `Client.GetInterfaceHeight()`. Na 4.0.0, a escala se adapta às áreas pequenas: esses valores são dimensões lógicas e podem ser maiores que a quantidade de pixels da aba. Recalcule as posições quando as dimensões mudarem. Não aplique novamente um fator de redução ao desenho nativo nem misture pixels físicos com coordenadas lógicas de desenho/clique. Scripts que usam coordenadas fixas baseadas na resolução anterior precisam atualizar esse cálculo.

`ClientAPI.IsLuckyWheelModernUI()` retorna `true` quando `[LuckyWheel] panels=1` em `UI\ui.ini` foi incorporado ao `config.bin` pelo Encoder; caso contrario, retorna `false`. Disponivel a partir da 3.5.0; scripts que tambem devem funcionar em Main antigo precisam verificar se a funcao existe antes de chama-la.

Na 4.0.0, a Lucky Wheel moderna utiliza o documento `LuckyWheel/luckywheel.rml`
de `UI.bin`. A ponte interna `Client.LuckyWheelRmlRender(html, items, highlight, vault)`
apresenta o conteúdo UTF-8 e os modelos 3D; cada item recebe `slot`, `itemIndex`,
`level` (nível codificado, nível do item × 8), `excellent` e `ancient`.
`slot` usa 1–16 para a roleta e 1001–1080 para as linhas do cofre.
`LuckyWheelRmlUpdateInput()` retorna uma ação que o sistema Lua valida antes
de enviar qualquer pedido ao servidor; `LuckyWheelRmlHoveredReward()` identifica
o item sob o mouse e `LuckyWheelRmlClose()` oculta a apresentação.
Essas funções são internas ao sistema fornecido, não substituem `LuckyWheel.Open()`
e `LuckyWheel.Close()` nem autorizam giros ou resgates. Scripts compatíveis com
Main antigo devem verificar a existência das funções antes de utilizá-las.

`ClientAPI.IsDailyRewardModernUI()` consulta `[DailyReward] panels=1` no mesmo `UI\ui.ini` do Encoder. `false` (ou função ausente em Main antigo) mantém o calendário Lua tradicional. A revisão moderna em teste usa um documento RmlUi de `UI.bin` e a ponte interna `Client.DailyRewardRmlRender`, `DailyRewardRmlUpdateInput`, `DailyRewardRmlHoveredReward` e `DailyRewardRmlClose`; o Lua continua responsável por validar as ações antes de enviar ao servidor. Os poços 3D do RmlUi passam pelo mesmo renderizador e pela mesma `Local\System\MarketplaceItemPosition.txt` do Marketplace. Se o documento não estiver disponível, o Lua mantém a janela tradicional.

`ClientAPI.IsBattlePassModernUI()` consulta `[BattlePass] panels = 1` no `UI\ui.ini`
incorporado pelo Encoder. A chave ausente ou `0` mantém a janela original.
Disponível na 4.0.0; verifique a existência da função ao suportar Main antigo.

A ponte interna `Client.BattlePassRmlRender(html, items, selected)` apresenta o
documento `BattlePass/battlepass.rml` de `UI.bin`. Os itens usam `slot` de 1 a 28,
`itemIndex`, `level` codificado (nível × 8), `excellent` e `ancient`.
`BattlePassRmlUpdateInput()` devolve a ação para validação no script;
`BattlePassRmlHoveredReward()` identifica o nível sob o mouse e
`BattlePassRmlClose()` oculta a janela. São funções internas do sistema, não
substituem `BattlePass.Open()`/`BattlePass.Close()` nem autorizam compra ou resgate.
Sem o documento disponível, o script preserva a apresentação original.

`Client.BattlePassRmlTime()` fornece segundos monotônicos para os intervalos
internos do Battle Pass. O script não depende de `os.time()` ou `os.clock()`:
o Lua do Main disponibiliza as bibliotecas base, string, table e math, sem os,
io, debug ou package. Se essa ponte estiver ausente, use a janela original.

`Client.GetUIThemeColorHex(key)` devolve `#RRGGBB` ou `#RRGGBBAA` para uma chave conhecida de `[Theme]`, usando a mesma validação e os mesmos valores do RmlUi; chave desconhecida devolve texto vazio. Exemplo: `Client.GetUIThemeColorHex("accent")`. `GenesysUI.ThemeColor(key)` converte isso em `{r, g, b, a}`, `GenesysUI.RenderThemeBox` desenha uma cor da paleta e `GenesysUI.RenderThemeGradient` usa `gradientstart` e `gradientend`. Essas funções atendem às janelas Lua modernas; os desenhos tradicionais continuam como antes. Edite `MuServer\Tools\MainInfo\UI\ui.ini`, gere o `config.bin` pelo Encoder e reinicie o Main. Repetir as duas cores do degradê cria um preenchimento uniforme.

`Client.GetVolume()` retorna o volume mestre atual entre `0` e `10`. `Client.SetVolume(level)` altera em conjunto os efeitos nativos, sons personalizados carregados por Lua e músicas do cliente. O nível `0` silencia o áudio e `10` usa o volume máximo. A configuração também é compartilhada com o slider de volume do Menu do Sistema.

`ClientAPI.GetResolutionInfo()` retorna todos esses valores em uma tabela:

```lua
{
	resolution = string,
	windowWidth = number,
	windowHeight = number,
	interfaceWidth = number,
	interfaceHeight = number,
	openGLWidth = number,
	openGLHeight = number,
}
```

## Inventario e tooltip

```lua
Client.GetInventoryMouseSlot()
Client.GetInventoryMouseItemSlot()
Client.GetInventoryMouseItemIndex()
Client.GetInventoryMouseItemLevel()
Client.GetInventoryMouseItemOption()
Client.GetInventoryMouseItemExcellent()
Client.GetInventoryMouseItemDurability()
ClientAPI.GetInventoryMouseItemInfo()
Client.GetItemName(itemIndex, level)
Client.GetItemWidth(itemIndex)
Client.GetItemHeight(itemIndex)
Client.GetItemSlot(itemIndex)
Client.ShowInventoryMouseItemTooltip(x, y)
Client.ShowItemTooltip(x, y, itemIndex, level, option1, extOption)
Client.ShowItemTooltipFull(x, y, itemIndex, level, skill, luck, option, extOption, setOption, harmony, itemOptionEx, [duration])
Client.RenderItemScaled(x, y, width, height, itemIndex, level, option1, extOption, scale)
```

Exemplo:

```lua
local itemIndex = Client.GetInventoryMouseItemIndex()
if itemIndex > 0 then
	local name = Client.GetItemName(itemIndex, Client.GetInventoryMouseItemLevel())
	Client.RenderText(20, 100, name, 240, 0, 1, 255, 255, 255, 255)
end
```

## Render de item/personagem/monstro

### Client.RenderItem

```lua
Client.RenderItem(x, y, width, height, itemIndex, level, option1, extOption[, rotation])
Client.RenderItemScaled(x, y, width, height, itemIndex, level, option1, extOption, scale[, rotation])
Client.RenderItemCentered(x, y, width, height, itemIndex, level, option1, extOption, scale[, rotation])
Client.RenderMarketplaceItem(x, y, width, height, itemIndex, level, excellent, ancient[, rotation])
```

Desenha preview 3D de item.

Exemplo:

```lua
Client.RenderItem(100, 120, 40, 40, 7181, 0, 0, 0)
Client.RenderItemScaled(100, 120, 18, 18, 7181, 0, 0, 0, 0.30)
Client.RenderItemCentered(100, 120, 40, 40, 7181, 0, 0, 0, 0.50)
```

Use `RenderItemScaled` para itens em listas compactas. `scale` multiplica a escala nativa.

**`width` e `height` não são o tamanho do item.** Eles multiplicam a posição do modelo, que sai de `posição = (width × pos[X]) + x`, com `pos` vindo do item. Diminuir a largura para encolher um ícone só **desloca** o modelo para a esquerda, até sair da caixa — foi feito para encaixe fino, não para tamanho.

Quem muda o tamanho é o `scale` do `RenderItemScaled`, onde `1` é o tamanho natural:

```lua
-- ERRADO: quer encolher e acaba movendo o item para fora do lugar
Client.RenderItem(x, y, 11, 11, 7213, 0, 0, 0)

-- CERTO: mantém a caixa e encolhe de verdade
Client.RenderItemScaled(x, y, 13, 13, 7213, 0, 0, 0, 0.70)
```

Isso importa em lista: itens de modelo mais largo, como a Gemstone, enchem a caixa e encostam no texto ao lado. A saída é `scale`, não `width`.

**`level` aqui é o BYTE do nível, e não o nível.** Por dentro o desenho faz `(level >> 3) & 15`, e no mesmo byte moram a skill, a sorte e a opção. Passar `13` desenha um `+1`. Multiplique por 8 e some os bits:

```lua
local byte = level * 8
if skill ~= 0 then byte = byte + 128 end
if luck  ~= 0 then byte = byte + 4   end
byte = byte + (option % 4)

Client.RenderItemScaled(x, y, 40, 40, itemIndex, byte, option, excellent, 1.0)
```

Repare que `Client.ShowItemTooltipFull` faz o **contrário**: recebe o nível puro (0 a 15) e monta o byte sozinho. Desenhando e mostrando a descrição do mesmo item, os dois recebem valores diferentes — se a descrição disser `+13` e o desenho parecer outro nível, é este byte.

`RenderItemCentered` centraliza o item no bounding box, ignorando `pos[X]/pos[Y]` em `CustomItemPosition`. Mesmos parametros de `RenderItemScaled`. Hit-test usa `(x, y, width, height)` original.

Para quadrados de itens na nova UI, use `RenderMarketplaceItem`. Ele chama o mesmo
renderizador dos poços do Marketplace: escala e âncora por categoria, compensação
do posicionamento nativo, recorte no quadrado e ajustes individuais de escala,
deslocamento e rotações de `Local\System\MarketplaceItemPosition.txt` (empacotado no
PAK). A mesma calibração vale no catálogo, nos detalhes, na Lucky Wheel e em outros
scripts que chamarem esta função. Passe o retângulo completo do quadrado; a escala
e os deslocamentos são proporcionais ao tamanho. Não é necessário copiar os ajustes
por item para cada script. `level` é o byte compactado descrito acima.

```lua
Client.RenderMarketplaceItem(x, y, 54, 54, itemIndex, byte, excellent, ancient)
```

O arquivo de calibração continua sendo salvo no editor do Marketplace. Após salvar,
copie-o da raiz do cliente para `Tools\MainInfo\Local\System`, gere o PAK no Encoder
e distribua-o; a prévia local do editor é aplicada imediatamente. Sem entrada para
um item, valem as regras padrão do próprio Marketplace.

O que `RenderItemCentered` centraliza e o **ponto de ancora** do item, e nao a massa visivel do modelo. Cada modelo e desenhado a partir de um ponto proprio — um cajado nasce no cabo, uma joia na base —, entao itens diferentes ainda parecem tortos dentro da mesma caixa. Em codigo legado que usa essa funcao, o acabamento exige um deslocamento por item. Para sistemas novos com quadrados, prefira `RenderMarketplaceItem` e a calibracao compartilhada descrita acima.

```lua
-- offsetX/offsetY guardados no seu config, um par por item
Client.RenderItemCentered(x + offsetX, y + offsetY, 40, 40, itemIndex, byte, option, excellent, 1.0)
```

`ShowItemTooltipFull` representa item composto no servidor:

- Skill e codificada no byte de level; excellent/opcao alta no campo separado.
- Em itens ancient, informe `setOption` completo para o preview incluir a opcao individual.

Parametro opcional `duration` em segundos a partir de agora. Maior que `0` ativa a linha `Dia de Expiracao` no tooltip. Use `604800` para 7 dias.

### Rotação de itens (4.0.0)

As quatro funções acima aceitam uma tabela opcional `rotation` no último argumento.
Os colchetes nas assinaturas indicam um argumento opcional; não são parte da chamada Lua.
As funções globais equivalentes (`ClientRenderItem`, `ClientRenderItemScaled`,
`ClientRenderItemCentered`, `ClientRenderMarketplaceItem` e `CreateItem`) também
aceitam a tabela. Os auxiliares existentes `ClientAPI.RenderItem` e
`ClientAPI.RenderItemScaled` repassam as mesmas opções.

| Campo | Tipo | Padrão | Uso |
| --- | --- | --- | --- |
| `angle` | número | `0` | Ângulo adicional em graus no eixo Y do item. Aceita valores negativos e voltas completas. |
| `autoRotate` | booleano | `false` | Ativa o giro automático calculado pelo cliente. |
| `rotationSpeed` | número | `30` | Graus por segundo quando `autoRotate = true`. Aceita de `-3600` a `3600`; negativo inverte o sentido e zero mantém o ângulo. |

Sem o argumento, com `nil` ou com uma tabela vazia, o comportamento anterior é
preservado, inclusive a rotação nativa por seleção quando aplicável. Informar
qualquer um dos três campos passa a controlar a rotação dessa chamada: o mouse
não substitui o ângulo. Use `{ angle = 0 }` ou `{ autoRotate = false }` para manter
a orientação calibrada sem giro por seleção. `rotationSpeed` sozinho não ativa o giro.

```lua
-- Chamada existente: continua funcionando sem alterações.
Client.RenderMarketplaceItem(x, y, 96, 96, itemIndex, byte, excellent, ancient)

-- Orientação calibrada, sem giro ao passar o mouse.
Client.RenderMarketplaceItem(x, y, 96, 96, itemIndex, byte, excellent, ancient,
    { angle = 0 })

-- Ângulo fixo adicional de 45 graus.
Client.RenderMarketplaceItem(x, y, 96, 96, itemIndex, byte, excellent, ancient,
    { angle = 45 })

-- Giro automático: uma volta a cada 12 segundos.
Client.RenderMarketplaceItem(x, y, 96, 96, itemIndex, byte, excellent, ancient,
    { autoRotate = true, rotationSpeed = 30 })

-- Mesmo controle nos renderizadores tradicionais: tabela depois de scale.
Client.RenderItemScaled(x, y, 40, 40, itemIndex, byte, excellent, ancient, 0.7,
    { angle = 90, autoRotate = true, rotationSpeed = -30 })
```

Continue chamando a função em cada quadro, dentro do callback de renderização da
janela. Você pode criar a tabela uma vez fora do callback e reutilizá-la. O giro
usa um relógio comum do cliente e mantém a velocidade independentemente do FPS
ou da quantidade de itens. Itens com a mesma velocidade e o mesmo `angle` ficam
na mesma fase; `angle` acrescenta uma diferença entre eles. Esconder a janela,
trocar o item ou recarregar o Lua não reinicia esse relógio. Para controlar uma
sequência própria, forneça `angle` e deixe `autoRotate` desligado.

A rotação é somada à orientação nativa e à calibração do Marketplace, sem alterar
o arquivo de posicionamento. O recorte do Marketplace continua no retângulo
informado: confira a volta completa de modelos largos, como armas e asas.
A função não cria itens no inventário e não exige identificador, criação ou
limpeza de um objeto persistente. `level`, opções e efeitos mantêm o formato atual.

Uma tabela com tipos incorretos, números não finitos ou velocidade fora do limite
faz a chamada retornar `false`, sem desenhar. Os campos conhecidos são lidos
diretamente da tabela; campos desconhecidos são ignorados.

O [exemplo de rotação de itens](../Tutorials/ItemRotation/README.md) permite comparar
as quatro funções, ângulo fixo e giros em sentidos opostos.

### Client.RenderCharacter

```lua
Client.RenderCharacter(id, x, y, width, height, angle, zoom, animation)
```

Desenha preview do personagem local e acompanha as trocas de equipamento.
Quando o Inventario Visual esta habilitado, usa a aparencia visual equipada
compativel, sem alterar o equipamento real ou seus atributos.

### Client.RenderCharacterPacket

```lua
Client.RenderCharacterPacket(id, x, y, width, height, classType, change, equipment, angle, zoom, animation)
```

Desenha personagem a partir de dados informados pelo script. O array
`equipment` define a aparencia; esta chamada nao herda os visuais do
personagem local automaticamente.

### Client.RenderStoredCharacter

```lua
Client.RenderStoredCharacter(renderId, x, y, width, height, angle, zoom, animation)
Client.HasStoredCharacter(renderId)
Client.ClearStoredCharacter(renderId)
```

Desenha personagem cujos dados foram empacotados pelo servidor com
`User.SendCharacterRender(playerIndex, renderId, name)`.

O servidor inclui os visuais equipados compativeis quando o Inventario
Visual esta habilitado. Os dados ficam guardados ate uma nova resposta ou
`ClearStoredCharacter`; para atualizar a aparencia, envie novamente com
`User.SendCharacterRender`. Calcas com tecido nativo e calcas customizadas
usam a mesma camera da previa, sem flags adicionais no script.

Exemplo:

```lua
Client.RenderStoredCharacter(2001, 80, 200, 120, 160, 90, 0.8, 0)
```

`HasStoredCharacter` checa se ja chegou. `ClearStoredCharacter` libera o slot.

### Client.RenderMonster

```lua
Client.RenderMonster(id, x, y, width, height, monsterIndex, angle, zoom, heightOffset, action)
```

Desenha preview de monstro por classe de monstro.

### Client.RenderModel / RenderMonsterModel

```lua
Client.RenderModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
Client.RenderMonsterModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
```

Desenha preview usando model id final.

### Client.GetMonsterModelInfo

```lua
local info = Client.GetMonsterModelInfo(monsterIndex)
Client.GetModelPlayer()
Client.GetModelMonsterBase()
Client.GetModelMonsterEnd()
Client.GetKindPlayer()
Client.GetKindMonster()
```

Retorna dados para renderizar monstro com `RenderModel`.

Exemplo:

```lua
local info = Client.GetMonsterModelInfo(91)
if info.ok then
	Client.RenderModel(1, 200, 120, 100, 160, info.modelType, info.kind, info.scale, 90, 0.8, 0, 0)
end
```

## Packet client -> server

```lua
Client.IsConnected()
Client.IsReady()
Client.Send(packetName, data)
Client.SendPacket(packetName, data)
```

Envia pacote custom para o GameServer.

Exemplo:

```lua
Client.Send("MeuPacote", "texto")
```

Use nomes estaveis para pacotes de sistemas Lua, evitando depender de opcodes numericos que podem existir no cliente nativo.

## ClientPacket builder

```lua
ClientPacket.Create(name, subHead)
ClientPacket.SetByte(name, value)
ClientPacket.SetWord(name, value)
ClientPacket.SetDword(name, value)
ClientPacket.SetChar(name, text)
ClientPacket.SetCharLength(name, text, length)
ClientPacket.Size(name)
ClientPacket.GetData(name)
ClientPacket.Send(name)
ClientPacket.Clear(name)
```

Usado para montar payload simples byte a byte.

Aliases globais tambem estao disponiveis:

```lua
CreatePacket(name, subHead)
ClearPacket(name)
SendPacket(name, packetName)
SetBytePacket(name, value)
SetWordPacket(name, value)
SetDwordPacket(name, value)
SetCharPacket(name, text)
SetCharPacketLength(name, text, length)
GetBytePacket(name, position)
GetWordPacket(name, position)
GetDwordPacket(name, position)
GetCharPacket(name, position)
GetCharPacketLength(name, position, length)
```

## HTTP e conteudo remoto

O cliente possui funcoes HTTP para baixar textos, JSON, HTML simples e imagens.

Limites:

- nao e navegador embutido;
- nao executa JavaScript;
- nao interpreta CSS completo;
- o script Lua deve ler o conteudo e desenhar a interface com `Client.RenderText`, `Client.RenderImage`, botoes Lua e controles nativos.

### Client.HttpGet

```lua
Client.HttpGet(url, maxBytes)
```

Baixa texto remoto curto.

Retorno:

```lua
{
	ok = true,
	url = "...",
	status = 200,
	size = 1234,
	data = "...",
	error = "",
	truncated = false,
}
```

### Client.HttpRequest

```lua
Client.HttpRequest(options)
ClientAPI.HttpPost(url, body, headers, maxBytes)
```

Opcoes:

- `method`: `"GET"` ou `"POST"`;
- `url`: endereco remoto;
- `body`: corpo do POST;
- `headers`: tabela de headers permitidos;
- `maxBytes`: limite de resposta;
- `timeoutMs`: timeout em milissegundos;
- `httpsOnly`: `true` por padrao;
- `allowedDomains`: lista de dominios permitidos.

Headers permitidos:

```text
Accept
Accept-Language
Authorization
Content-Type
User-Agent
X-Requested-With
X-Lua-Client
X-Api-Key
```

Exemplo:

```lua
local result = Client.HttpRequest({
	method = "GET",
	url = "https://site.com/api/",
	maxBytes = 65536,
	timeoutMs = 5000,
	httpsOnly = true,
	allowedDomains = {
		"site.com",
	},
	headers = {
		["Accept"] = "application/json",
	},
})
```

### Client.HttpRequestAsync

```lua
Client.HttpRequestAsync(requestId, options)
```

Executa request em segundo plano. A resposta chega pela bridge `Client.OnHttpResponse`, documentada em `Client\Bridges.md`.

### Client.DownloadFile

```lua
Client.DownloadFile(url, fileName)
```

Baixa arquivo remoto para:

```text
Data\Custom\Lua\Cache
```

Retorno:

```lua
{
	ok = true,
	url = "...",
	fileName = "banner.jpg",
	path = ".\\Data\\Custom\\Lua\\Cache\\banner.jpg",
	hresult = 0,
	packed = true,
	packedPath = ".\\Data\\Custom\\Lua\\Cache\\banner.OZJ",
	error = "",
}
```

Conversoes automaticas de formato:

```text
.jpg  -> cria tambem .OZJ
.jpeg -> cria tambem .OZJ
.tga  -> cria tambem .OZT
```

O loader resolve `.jpg`/`.tga` para `.OZJ`/`.OZT` automaticamente.

## ClientAPI e helpers

`ClientAPI` e camada de compatibilidade. Quando existir equivalente, `ClientAPI.X` chama a mesma funcao ou aplica protecao simples de retorno.

Exemplos:

```lua
Client.RenderText(...)
ClientAPI.RenderText(...)

Client.HttpRequest(...)
ClientAPI.HttpRequest(...)
```

Helpers disponiveis:

```lua
ClientAPI.IsMouseInRect(x, y, width, height)
ClientAPI.IsMouseClickInRect(x, y, width, height)
ClientAPI.GetInventoryMouseItemInfo()
ClientAPI.GetResolutionInfo()
ClientAPI.HttpPost(url, body, headers, maxBytes)
Client.RegisterPacket
Client.SendPacket
```

`Client.RegisterPacket` e alias para `Client.OnPacket`.

`Client.SendPacket` e alias para `Client.Send`.

## Janelas nativas

IDs de janelas em `ClientAPI.Windows`:

```lua
ClientAPI.Windows.Friend
ClientAPI.Windows.MoveMap
ClientAPI.Windows.Party
ClientAPI.Windows.GuildInfo
ClientAPI.Windows.Trade
ClientAPI.Windows.Storage
ClientAPI.Windows.MixInventory
ClientAPI.Windows.Command
ClientAPI.Windows.Pet
ClientAPI.Windows.NpcShop
ClientAPI.Windows.Inventory
ClientAPI.Windows.Character
ClientAPI.Windows.ChatInput
ClientAPI.Windows.WindowMenu
ClientAPI.Windows.Option
ClientAPI.Windows.Help
ClientAPI.Windows.ChatLog
ClientAPI.Windows.PartyInfo
ClientAPI.Windows.MainFrame
ClientAPI.Windows.SkillList
ClientAPI.Windows.BuffWindow
ClientAPI.Windows.MasterLevel
ClientAPI.Windows.MiniMap
ClientAPI.Windows.InventoryJewel
```

Exemplo:

```lua
if not Client.IsWindowOpen(ClientAPI.Windows.Inventory) then
	Client.OpenWindow(ClientAPI.Windows.Inventory)
end
```

## Estilo de nome do personagem

Permite estilizar o **nome de um personagem** (pela string exata do nome) tanto **acima da cabeca** quanto **no chat**: cor, fonte e efeitos de "wave". O estilo fica registrado ate ser limpo ou o cliente reiniciar; vale para qualquer personagem que tenha aquele nome.

```lua
Client.SetNameStyle(nome, r, g, b, fontType, waveMode [, r2, g2, b2])
Client.SetNameStyleMulti(nome, fontType, { {r,g,b}, {r,g,b}, ... })
Client.ClearNameStyle(nome)
Client.ClearAllNameStyles()
```

Parametros:

- `r, g, b`: cor 0-255. Use `r < 0` para **manter a cor padrao** do jogo (muda so fonte/efeito).
- `fontType`: `0` normal, `1` negrito, `2` grande, `3` fixa. No nome **acima da cabeca** so o negrito tem efeito (engrossa o texto); `grande`/`fixa` so aparecem na janela de info detalhada. No **chat** todas funcionam.
- `waveMode`:
  - `0` sem efeito (cor fixa).
  - `1` arco-iris animado (efeito nativo; ignora a RGB).
  - `2` pulsa o brilho da RGB escolhida.
  - `3` oscila entre 2 cores (passe `r2, g2, b2`).
- `SetNameStyleMulti`: ciclo suave por **N cores** (lista de `{r,g,b}`).

Exemplo:

```lua
-- staff em vermelho negrito pulsando
Client.SetNameStyle("Admin", 255, 40, 40, 1, 2)

-- nome oscilando entre rosa e ciano
Client.SetNameStyle("Patricia", 255, 120, 220, 0, 3, 60, 220, 255)

-- nome ciclando por varias cores fortes
Client.SetNameStyleMulti("Gato", 1, {
    { 255, 0, 0 }, { 255, 255, 0 }, { 0, 255, 0 }, { 0, 120, 255 },
})
```

> O registro e por **nome exato**. Para aplicar por grupo (cargo, VIP, classe) o script monta a lista de nomes e chama `SetNameStyle` para cada um, na logica que o servidor quiser.

## Imagem acima da cabeca

Exibe uma imagem custom acima da cabeca de um personagem (por nome exato), no estilo do "balao" de GM. Funciona para player, monstro e NPC. Carregue a imagem antes com `Client.LoadImage` (qualquer `.tga`/`.ozt` da pasta do cliente).

```lua
Client.SetHeadImage(nome, imageId, w, h [, ox, oy])
Client.ClearHeadImage(nome)
Client.ClearAllHeadImages()
```

- `imageId`: id usado no `Client.LoadImage`.
- `w, h`: tamanho em pixels.
- `ox, oy`: ajuste fino de posicao (opcionais). `oy` maior **desce** a imagem (mais junto do nome); menor/negativo sobe. A imagem fica centralizada acima da cabeca.

Exemplo:

```lua
Client.LoadImage("Custom\\Interface\\MainMenu\\daily.tga", 70200)
Client.SetHeadImage("Admin", 70200, 32, 32, 0, -6)
```

> Para **NPC**, o nome normalmente so aparece no hover. Ao registrar uma imagem, o NPC passa a ser desenhado todo frame, entao a **imagem e o nome do NPC ficam sempre visiveis** (so para NPCs com imagem registrada). `ClearHeadImage` reverte ao normal. Para player/monstro o nome ja e sempre visivel; nada muda alem da imagem.

## Nomes multilíngues (4.0.0)

Os nomes retornados ao Lua do Main são UTF-8, independentemente do idioma selecionado.
Não reconverta esses valores pela página de código do Windows. Os nomes ASCII
permanecem iguais. O servidor precisa da migração opcional para criar nomes chineses.
