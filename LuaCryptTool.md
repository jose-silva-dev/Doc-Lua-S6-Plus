# LuaCryptTool

Ferramenta para criptografar scripts Lua do Server Side e Client Side.

## Local

```text
MuServer\Tools\LuaCryptTool
```

## Estrutura

```text
LuaCryptTool
|-- ServerDecrypted
|   `-- Data\Scripts
|-- ServerEncrypted
|   `-- Data\Scripts
|-- ClientDecrypted
|   `-- Data\Custom\Lua
`-- ClientEncrypted
    `-- Data\Custom\Lua
```

## Server Side

Coloque scripts abertos em:

```text
ServerDecrypted\Data\Scripts
```

Depois de criptografar, copie:

```text
ServerEncrypted\Data\Scripts
```

para:

```text
MuServer\Data\Scripts
```

## Client Side

Coloque scripts abertos em:

```text
ClientDecrypted\Data\Custom\Lua
```

Depois de criptografar, copie:

```text
ClientEncrypted\Data\Custom\Lua
```

para:

```text
Cliente\Data\Custom\Lua
```

## Pastas carregadas automaticamente

Server:

```text
Data\Scripts\LuaSystem
Data\Scripts\Custom\Configs
Data\Scripts\Custom\Libs
Data\Scripts\Custom\Systems
Data\Scripts\Custom
```

Client:

```text
Data\Custom\Lua\Definitions
Data\Custom\Lua\Controller
Data\Custom\Lua\CharacterSystem
Data\Custom\Lua\Customs\Configs
Data\Custom\Lua\Customs\Libs
Data\Custom\Lua\Customs\Systems
Data\Custom\Lua\Customs
Data\Custom\Lua\Systems
```

## Observacao

Arquivos de configuracao podem ficar abertos quando o cliente precisar editar valores.
Scripts principais podem ser criptografados.
