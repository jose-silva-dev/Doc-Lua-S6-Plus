# Tutorial: Configurar Cupons do Gift Guardian

Este tutorial mostra como configurar o Gift Guardian para entregar brindes por codigo no servidor.

O sistema funciona com duas partes:

- Configuracao Lua: comando, NPC, mensagens e comportamento geral.
- Banco de dados: codigos de cupom e itens que cada codigo entrega.

## Arquivos

Servidor:

```text
Data\Scripts\Custom\System\GiftGuardian.lua
Data\Scripts\Custom\Configs\GiftGuardianConfig.lua
```

Cliente:

```text
Data\Custom\Lua\Systems\GiftGuardian.lua
Data\Custom\Lua\Customs\Configs\GiftGuardianConfig.lua
```

## Ativar ou Desativar

No servidor, abra:

```text
Data\Scripts\Custom\Configs\GiftGuardianConfig.lua
```

Para deixar ativo:

```lua
enabled = true
```

Para desativar:

```lua
enabled = false
```

## Configurar Comando

O comando padrao e:

```lua
commands = { "/gift" }
```

Para trocar o comando:

```lua
commands = { "/brinde" }
```

Para permitir mais de um comando:

```lua
commands = { "/gift", "/brinde", "/cupom" }
```

Depois de alterar o arquivo, reinicie o GameServer ou use o reload de scripts do servidor.

## Abrir por NPC

Por padrao, o NPC fica desativado:

```lua
npc = {
	enabled = false,
}
```

Para ativar:

```lua
npc = {
	enabled = true,
	class = 381,
	map = 0,
	x = 130,
	y = 134,
	dir = 3,
	checkPosition = true,
}
```

Campos:

- `class`: classe do NPC.
- `map`: mapa onde o NPC vai nascer.
- `x` e `y`: coordenadas.
- `dir`: direcao.
- `checkPosition`: evita abrir a janela para interacoes fora da posicao esperada.

Depois de alterar o NPC, reinicie o GameServer.

## Tabelas do Banco

Com esta opcao ativa, o sistema cria as tabelas automaticamente no startup:

```lua
autoCreateTables = true
```

Tabelas usadas:

```text
GiftGuardianCodes
GiftGuardianRewards
GiftGuardianClaims
```

`GiftGuardianCodes` guarda os codigos.

`GiftGuardianRewards` guarda os itens de cada codigo.

`GiftGuardianClaims` guarda o historico de retirada por conta. Em um cupom publico, cada conta pode retirar os itens uma vez.

## Cupom Padrao

O pacote acompanha o cupom:

```text
GENESYS
```

Ele entrega um set Leather +15 full excellent, uma vez por conta.

## Criar um Cupom

Exemplo de cupom que qualquer conta pode usar:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('VIP2026', 'Cupom VIP 2026', NULL, 1);
```

Campos:

- `Code`: codigo digitado pelo jogador.
- `Title`: descricao interna do cupom.
- `AccountID`: conta autorizada. Use `NULL` para qualquer conta. Cada conta pode retirar uma vez.
- `Active`: `1` ativo, `0` desativado.

Exemplo de cupom limitado a uma conta:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('JOSEVIP', 'Cupom da conta jose', 'jose', 1);
```

## Adicionar um Item ao Cupom

Exemplo entregando uma Jewel of Bless:

```sql
INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('VIP2026', 'Jewel of Bless', 14, 13, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
```

Campos principais:

- `Code`: codigo do cupom.
- `Name`: nome exibido na janela do Gift Guardian.
- `Section`: secao do item.
- `ItemIndex`: indice do item dentro da secao.
- `Level`: level do item, de `0` a `15`.
- `Skill`: `1` com skill, `0` sem skill.
- `Luck`: `1` com luck, `0` sem luck.
- `OptionValue`: option do item. Exemplo: `4` para +16, `7` para +28.
- `Excellent`: soma das opcoes excellent. Use `0` para item normal e `63` para full excellent.
- `Count`: quantidade. Recomendado usar `1` e criar uma linha por item.
- `Duration`: `0` para permanente.
- `SetOption`: opcao ancient/set.
- `Harmony`: opcao Jewel of Harmony.
- `ItemOptionEx`: opcao extra.

## Exemplo: Arma +9 com Skill

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('ARMA9', 'Arma +9', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('ARMA9', 'Blade +9 Skill', 0, 5, 9, 1, 0, 0, 0, 1, 0, 0, 0, 0);
```

## Exemplo: Item Excellent Full

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('FULLITEM', 'Item Full', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('FULLITEM', 'Blade +15 Full', 0, 5, 15, 1, 1, 7, 63, 1, 0, 0, 0, 0);
```

## Exemplo: Set Completo

Para entregar um set completo, crie uma linha para cada parte.

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('SET2026', 'Set completo', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('SET2026', 'Helm +15 Full', 7, 0, 15, 0, 1, 7, 63, 1, 0, 0, 0, 0),
('SET2026', 'Armor +15 Full', 8, 0, 15, 0, 1, 7, 63, 1, 0, 0, 0, 0),
('SET2026', 'Pants +15 Full', 9, 0, 15, 0, 1, 7, 63, 1, 0, 0, 0, 0),
('SET2026', 'Gloves +15 Full', 10, 0, 15, 0, 1, 7, 63, 1, 0, 0, 0, 0),
('SET2026', 'Boots +15 Full', 11, 0, 15, 0, 1, 7, 63, 1, 0, 0, 0, 0);
```

O jogador pode marcar todos os itens e retirar em uma unica acao. O servidor valida o espaco total do inventario antes de entregar. Se nao houver espaco para todos, nenhum item e entregue.

## Exemplo: Ancient

Para item ancient, use o `SetOption` final aceito pelo servidor.

Valor comum para primeira opcao ancient:

```text
9
```

Valor comum para segunda opcao ancient, quando o item possui segunda opcao:

```text
6
```

Exemplo:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('ANCIENT', 'Item ancient', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('ANCIENT', 'Leather Helm Ancient +9', 7, 5, 9, 0, 1, 4, 0, 1, 0, 9, 0, 0);
```

## Cupom de Teste Reutilizavel

No arquivo:

```text
Data\Scripts\Custom\Configs\GiftGuardianConfig.lua
```

Existe a lista:

```lua
reusableCodes = {
}
```

Codigos nessa lista podem ser retirados varias vezes e nao registram uso em `GiftGuardianClaims`.

Use apenas para testes. Em producao, remova o codigo dessa lista ou deixe:

```lua
reusableCodes = {}
```

## Desativar um Cupom

```sql
UPDATE GiftGuardianCodes
SET Active = 0
WHERE Code = 'VIP2026';
```

## Reativar um Cupom

```sql
UPDATE GiftGuardianCodes
SET Active = 1
WHERE Code = 'VIP2026';
```

## Liberar um Brinde Ja Retirado por uma Conta

Para permitir que uma conta retire novamente os brindes de um codigo:

```sql
DELETE FROM GiftGuardianClaims
WHERE Code = 'VIP2026'
  AND AccountID = 'login_da_conta';
```

Para limpar o historico desse codigo para todas as contas:

```sql
DELETE FROM GiftGuardianClaims
WHERE Code = 'VIP2026';
```

## Fluxo de Teste

1. Crie o codigo em `GiftGuardianCodes`.
2. Crie os itens em `GiftGuardianRewards`.
3. Entre no jogo.
4. Use o comando configurado, por exemplo `/gift`.
5. Digite o codigo.
6. Clique em `Buscar`.
7. Passe o mouse sobre os itens para conferir o tooltip.
8. Marque um ou mais itens.
9. Clique em `Retirar`.

Se o inventario estiver sem espaco, nenhum item do lote e entregue.

## Observacoes Importantes

- O cliente apenas mostra a janela e envia o codigo/ids selecionados.
- A entrega e sempre validada pelo servidor.
- Para set completo, prefira uma linha por parte.
- Para varios itens diferentes, prefira uma linha por item.
- O campo `Name` e o texto exibido na janela. O tooltip usa os atributos reais do item configurado.
- O codigo pode ser publico (`AccountID = NULL`) ou restrito a uma conta.
