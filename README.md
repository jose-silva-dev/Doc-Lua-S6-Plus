# Genesys Lua API

Documentacao da API Lua Genesys Season 6 Plus.

## Estrutura

```text
Documentacao
|-- Server
|   |-- Bridges.md
|   |-- Functions.md
|   `-- User.md
|-- Client
|   |-- Bridges.md
|   `-- Functions.md
|-- Tutorials
|   |-- AutoPost
|   |   `-- README.md
|   |-- CharFull
|   |   `-- README.md
|   |-- ChaosMachine
|   |   `-- README.md
|   |-- DailyReward
|   |   `-- README.md
|   |-- GiftGuardian
|   |   `-- README.md
|   `-- TopRanking
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
Data\Scripts\Custom\System\AutoPost.lua
Data\Scripts\Custom\System\BuffSeller.lua
Data\Scripts\Custom\System\ChaosMachine.lua
Data\Scripts\Custom\System\CharFull.lua
Data\Scripts\Custom\System\DailyReward.lua
Data\Scripts\Custom\System\GiftGuardian.lua
Data\Scripts\Custom\System\JewelBank.lua
Data\Scripts\Custom\System\LuckyWheel.lua
Data\Scripts\Custom\System\NpcExchange.lua
Data\Scripts\Custom\System\ReloadScripts.lua
Data\Scripts\Custom\System\TopStatues.lua
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

`LuaAPI` e `LuaSecurity` ficam disponiveis no server-side para consulta de versao, compatibilidade e configuracoes de seguranca em modo compativel.

## Seguranca de callbacks

Callbacks registrados via `GameServerFunctions.*`, `command:add`, `Timer.Interval` e `DataBase.RunAfterLoad` ja executam sob `LuaCore`. Erros em `LOGS\LOG\LuaCore_YYYY-MM-DD.txt`. Uso direto de `LuaCore.SafeCall` reservado para sistemas avancados que chamem outros modulos fora das APIs publicas.

No server-side, os sistemas com tabelas proprias criam/validam automaticamente a estrutura apos a conexao com a DB:

- Jewel Bank: `CustomJewelBank`
- CharFull: `LuaCharFullUse`
- GiftGuardian: `GiftGuardianCodes`, `GiftGuardianRewards`, `GiftGuardianClaims`
- DailyReward: `LuaDailyReward`
- Lucky Wheel: `LuckyWheelVault`

Para suporte manual em instalacoes novas ou DB restaurada, rode somente o update do sistema que sera usado em `MuServer\SQL\Lua`. Atualmente:

- `Update1.6.2 - CustomJewelBank.sql`
- `Update1.6.3 - CharFull.sql`
- `Update1.6.3 - GiftGuardian.sql`
- `Update1.6.5 - DailyReward.sql`
- `Update2.2.0 - LuckyWheel.sql`

## Padrao para sistemas com economia

Em scripts que entregam premio, removem item, fazem deposito/saque ou gravam uso em tabela:

- valide DB/tabela antes de mexer no inventario;
- valide espaco antes de chamar `GiveItem`;
- confira retorno de `DataBase.Exec`, `GiveItem`, `TakeItem` e `TakeInventorySlot`;
- em saque/premio, reserve ou debite no DB antes de entregar item;
- em deposito/troca, se remover item e o DB falhar, tente devolver o item imediatamente.

`Client\Bridges.md` documenta callbacks do Main, como `Render`, `RenderTop`, `Update`, `UpdateKey`, `Client.OnPacket`, `Client.OnHttpResponse` e `ClientHooks`.

`Client\Functions.md` documenta render, imagens, sons personalizados, mouse/teclado, janelas, personagem local, packets, HTTP, `ClientAPI` e helpers.

## Convencao de chamadas

```lua
Client.RenderText(...)
Client.HttpRequest(...)
User.new(playerIndex)
GameServerFunctions.NpcTalk(function(...)
end)
```

`ClientAPI` disponivel como camada de compatibilidade no client-side.

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
Tutorials\AutoPost\README.md
Tutorials\TopRanking\README.md
Tutorials\DailyReward\README.md
```
