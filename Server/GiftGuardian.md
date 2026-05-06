# Gift Guardian

O Gift Guardian entrega brindes por codigo. A janela abre no cliente e a entrega dos itens sempre e validada pelo servidor.

## Arquivos

```text
Data\Scripts\Custom\System\GiftGuardian.lua
Data\Scripts\Custom\Configs\GiftGuardianConfig.lua
```

No cliente:

```text
Data\Custom\Lua\Systems\GiftGuardian.lua
Data\Custom\Lua\Customs\Configs\GiftGuardianConfig.lua
```

## Configuracao

O servidor usa `GiftGuardianConfig`.

Campos principais:

```lua
enabled = true
autoCreateTables = true
commands = { "/gift" }
reusableCodes = {}
```

`autoCreateTables = true` cria as tabelas abaixo automaticamente quando o banco conectar:

```text
GiftGuardianCodes
GiftGuardianRewards
GiftGuardianClaims
```

`GiftGuardianClaims` registra os brindes retirados por conta. Em codigos publicos, cada conta pode retirar uma vez os itens disponiveis.

`reusableCodes` marca codigos de teste que podem ser retirados sem registrar uso por conta. Use somente em ambiente de teste.

Para abrir por NPC, ative:

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

## Inserir Codigo

Exemplo de codigo:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('VIP2026', 'VIP 2026', NULL, 1);
```

`AccountID = NULL` permite que qualquer conta com o codigo visualize os brindes disponiveis. Cada conta pode retirar uma vez. Para limitar a uma conta especifica, informe o login da conta.

## Inserir Brinde

Exemplo:

```sql
INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('VIP2026', 'Jewel of Bless', 14, 13, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
```

`Duration = 0` entrega item permanente. Valores maiores usam a duracao suportada pela funcao de entrega de item do servidor.

Use `[Count] = 1` e crie uma linha para cada item do brinde. Esse formato mantem a validacao de espaco do inventario precisa antes da entrega.

Ao retirar varios brindes de uma vez, o servidor valida o lote inteiro antes de entregar o primeiro item. Se nao houver espaco para todos os itens selecionados, nenhum item do lote e entregue.

A listagem usa leitura linha a linha pelo banco e envia um pacote por item. Esse formato permite codigos com varios brindes e mantem a entrega validada pelo servidor. As colunas numericas sao lidas antes do nome do item para manter compatibilidade com o cursor ODBC. Itens ja retirados pela conta atual sao filtrados pela tabela `GiftGuardianClaims`.

## Cupom Padrao

O pacote acompanha o cupom padrao:

```text
GENESYS
```

Esse cupom entrega um set Leather +15 full excellent, uma vez por conta.

Exemplo com set completo:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('SET2026', 'Set Completo Teste', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('SET2026', 'Set Teste Helm', 7, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0),
('SET2026', 'Set Teste Armor', 8, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0),
('SET2026', 'Set Teste Pants', 9, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0),
('SET2026', 'Set Teste Gloves', 10, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0),
('SET2026', 'Set Teste Boots', 11, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0);
```

Campos opcionais:

- `SetOption`: opcao de set/ancient.
- `Harmony`: opcao Jewel of Harmony.
- `ItemOptionEx`: opcao extra.

Exemplo variado para validar preview e entrega:

```sql
INSERT INTO GiftGuardianCodes (Code, Title, AccountID, Active)
VALUES ('SETFULL', 'Set Leather Variado', NULL, 1);

INSERT INTO GiftGuardianRewards
(Code, Name, [Section], ItemIndex, [Level], Skill, Luck, OptionValue, Excellent, [Count], Duration, SetOption, Harmony, ItemOptionEx)
VALUES
('SETFULL', 'Leather Helm Ancient +0', 7, 5, 0, 0, 0, 0, 0, 1, 0, 9, 0, 0),
('SETFULL', 'Leather Armor Ancient +9 Luck +16', 8, 5, 9, 0, 1, 4, 0, 1, 0, 9, 0, 0),
('SETFULL', 'Leather Pants Ancient +13 Exc Parcial', 9, 5, 13, 0, 0, 0, 3, 1, 0, 9, 0, 0),
('SETFULL', 'Leather Gloves Ancient +15 Full', 10, 5, 15, 0, 1, 7, 63, 1, 0, 9, 0, 0),
('SETFULL', 'Leather Boots Ancient +15 Full Harmony', 11, 5, 15, 0, 1, 7, 63, 1, 0, 9, 80, 0);
```

O exemplo usa Leather/Warrior porque as cinco partes possuem o mesmo indice ancient no arquivo de tipo de set. Alguns sets nativos, como Dragon/Hyon, nao possuem todas as partes no mesmo set effect.

`SetOption` usa o byte final aceito pelo GameServer. Para a primeira opcao ancient, o valor comum e `9`; para a segunda opcao ancient, o valor comum e `6`, quando o item possui essa segunda opcao.

## Fluxo

1. O jogador abre a janela pelo comando ou NPC.
2. O cliente envia somente o codigo digitado.
3. O servidor lista os brindes ainda nao retirados.
4. O jogador marca um ou mais brindes.
5. O cliente envia os `ids` marcados.
6. O servidor valida codigo, conta, itens selecionados e espaco total no inventario antes de entregar.
7. Ao entregar pelo menos um item com sucesso, o servidor dispara o efeito de fogos no personagem.
