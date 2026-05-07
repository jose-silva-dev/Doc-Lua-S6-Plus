# Tutorial - Char Full

O Char Full libera um comando para completar o personagem com level e atributos configurados.

## Arquivos

```text
Data\Scripts\Custom\System\CharFull.lua
Data\Scripts\Custom\Configs\CharFullConfig.lua
```

## Comando

Por padrao:

```text
/full
```

O comando pode ser alterado em:

```lua
command = "/full"
commands = { "/full" }
```

## Configuracao principal

```lua
enabled = true
commands = { "/full" }
requireGM = false
maxUsePerAccount = 1
closeCharacterAfterUse = true
debug = false
```

`enabled = false` desliga o comando sem remover os arquivos.

`requireGM = true` limita o uso a contas GM.

`maxUsePerAccount = 1` permite usar uma vez por conta. Use `0` para liberar sem limite em ambiente de teste.

`closeCharacterAfterUse = true` fecha o personagem apos aplicar os atributos, para atualizar os dados no cliente com seguranca.

## Valores aplicados

```lua
values = {
	level = 400,
	strength = 65000,
	dexterity = 65000,
	vitality = 65000,
	energy = 65000,
	leadership = 65000,
	levelUpPoint = 0,
	reset = { enabled = false, value = 0 },
	masterReset = { enabled = false, value = 0 },
}
```

O limite maximo aceito para atributos e validado pelo GameServer conforme a configuracao de `MaxStatPoint` por tipo de conta.

## Controle de uso

O sistema registra o uso por conta na tabela:

```text
LuaCharFullUse
```

Ela armazena `AccountID`, `UseCount` e `LastUse`.

## Fluxo

1. O jogador usa `/full`.
2. O servidor valida se o sistema esta ativo.
3. O servidor valida permissao GM, quando configurado.
4. O servidor consulta o limite de uso da conta.
5. O servidor aplica level, atributos e pontos.
6. O servidor registra o uso no banco.
7. O personagem e fechado para atualizar os dados ao entrar novamente.
