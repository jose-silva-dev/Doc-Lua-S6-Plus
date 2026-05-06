# Genesys Lua API

Documentacao da API Lua Genesys Season 6 Plus.

Use estes arquivos para consultar funcoes, bridges, parametros, retornos e exemplos.

## Estrutura

```text
Documentacao
|-- Server
|   |-- Bridges.md
|   `-- Functions.md
|-- Client
|   |-- Bridges.md
|   |-- Functions.md
|   `-- RemoteContent.md
`-- LuaCryptTool.md
```

## Server Side

Scripts executados pelo GameServer.

Arquivos principais:

```text
Data\Scripts\GameServer.lua
Data\Scripts\LuaSystem
Data\Scripts\Custom
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

## Padrao recomendado

```lua
Client.RenderText(...)
Client.HttpRequest(...)
User.new(playerIndex)
GameServerFunctions.NpcTalk(function(...)
end)
```

`ClientAPI` tambem esta disponivel como compatibilidade no client-side.
