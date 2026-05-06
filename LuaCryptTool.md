# LuaCryptTool

Ferramenta para criptografar scripts Lua do Server Side e Client Side.

## Local

```text
Tools\LuaCryptTool
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

A ferramenta le somente o conteudo colocado manualmente nas pastas `ClientDecrypted` e `ServerDecrypted`.
Ela gera apenas nas pastas `ClientEncrypted` e `ServerEncrypted`.

Antes de gerar, a pasta encrypted de destino e limpa para evitar arquivo antigo sobrando no pacote.

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
Data\Scripts\Custom\System
```

Client:

```text
Data\Custom\Lua\Definitions
Data\Custom\Lua\Customs\Configs
Data\Custom\Lua\Systems
```

## Observacao

Arquivos de configuracao podem ficar abertos quando o cliente precisar editar valores.
Scripts principais podem ser criptografados.

Use `--keep-configs` para manter arquivos dentro de pastas `Configs` sem criptografar.
