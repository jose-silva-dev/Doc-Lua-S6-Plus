# Genesys Lua API

Documentacao da API Lua Genesys Season 6 Plus.

Use estes arquivos para consultar funcoes, bridges, parametros, retornos e exemplos.

## Estrutura

```text
Documentacao
|-- Server
|   |-- Bridges.md
|   |-- Functions.md
|   |-- User.md
|   `-- Examples.md
|-- Client
|   |-- Bridges.md
|   `-- Functions.md
|-- Tutorials
|   |-- CharFull
|   |   `-- README.md
|   |-- ChaosMachine
|   |   `-- README.md
|   `-- GiftGuardian
|       `-- README.md
`-- LuaCryptTool.md
```

## Server Side

Scripts executados pelo GameServer.

Arquivos principais:

```text
Data\Scripts\GameServer.lua
Data\Scripts\LuaSystem
Data\Scripts\Custom\Configs
Data\Scripts\Custom\System\ChaosMachine.lua
Data\Scripts\Custom\System\CharFull.lua
Data\Scripts\Custom\System\GiftGuardian.lua
Data\Scripts\Custom\System\JewelBank.lua
Data\Scripts\Custom\System\NpcExchange.lua
Data\Scripts\Custom\System\ReloadScripts.lua
```

## Client Side

Scripts executados pelo Main.

Arquivos principais:

```text
Data\Custom\Lua\ScriptMain.lua
Data\Custom\Lua\Definitions
Data\Custom\Lua\Systems
Data\Custom\Lua\Customs\Configs
```

`Server\Bridges.md` documenta eventos como `NpcTalk`, `MonsterDie`, `OnUserDamage` e `ClientPacket`.

`Server\Functions.md` documenta funcoes globais, banco de dados, inventario, itens, timers e pacotes.

`Server\User.md` fica separado porque o objeto `User` possui muitos metodos e e usado por praticamente todos os scripts.

`Server\Examples.md` lista exemplos prontos para copiar e testar.

Sistemas completos ficam em `Tutorials`, para separar guia de uso da referencia da API.

O sistema Jewel Bank do cliente usa janela Lua com posicao inicial configuravel e permite mover a janela pela barra superior. A posicao movida fica em memoria enquanto o cliente estiver aberto, respeita a escala interna da interface do jogo e volta ao padrao ao reiniciar o Main.

`Client\Bridges.md` documenta callbacks do Main, como `Render`, `RenderTop`, `Update`, `UpdateKey`, `Client.OnPacket`, `Client.OnHttpResponse` e `ClientHooks`.

`Client\Functions.md` documenta render, imagens, mouse/teclado, janelas, personagem local, packets, HTTP, `ClientAPI` e helpers.

## Padrao recomendado

```lua
Client.RenderText(...)
Client.HttpRequest(...)
User.new(playerIndex)
GameServerFunctions.NpcTalk(function(...)
end)
```

`ClientAPI` tambem esta disponivel como compatibilidade no client-side.

## Exemplos

Os exemplos ficam em:

```text
Data\Scripts\Examples
```

Essa pasta nao e carregada automaticamente. Para testar um exemplo, copie o arquivo desejado para `Data\Scripts\Custom\System` e use `/reloadscripts` ou reinicie o GameServer.

## Tutoriais

Guias passo a passo ficam em:

```text
Tutorials
```

Cada sistema possui sua propria pasta. Exemplo:

```text
Tutorials\GiftGuardian\README.md
Tutorials\ChaosMachine\README.md
Tutorials\CharFull\README.md
```
