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

A pasta encrypted de destino e limpa antes de cada geracao.

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

## Configs abertas

Arquivos em `Configs` podem ficar abertos; scripts principais devem ser criptografados.

Use `--keep-configs` para preservar pastas `Configs`.
