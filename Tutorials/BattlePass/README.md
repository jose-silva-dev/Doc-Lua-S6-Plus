# Battle Pass

## Instalacao

Execute uma vez no banco `MuOnline`:

```text
MuServer\SQL\Lua\Update2.4.0 - BattlePass.sql
```

Na 4.0.0, abra o menu pelo botão **Atalho** ou por **Ctrl+F10** e selecione
**Battle Pass**. Os antigos botões laterais foram substituídos pelo **Atalho Rápido**. A compra, o progresso e os resgates sao salvos por conta e
compartilhados entre todos os personagens da conta.

## Interface

Na 4.0.0, a interface ETERNAL LEGENDS usa abas para Silver e Golden, um prêmio
em destaque, o requisito com progresso e cinco níveis por página. Selecione um
card para consultar a missão e use as setas para navegar pelos níveis. A barra
entre os marcadores termina no nível selecionado; não representa a conclusão
das missões. Os resgates continuam sujeitos às regras e à validação do servidor.

Em `MuServer\Tools\MainInfo\UI\ui.ini`, escolha a apresentação:

```ini
[BattlePass]
panels = 1
```

`1` usa a nova interface; `0` mantém a janela Lua original, com as duas trilhas
e navegação por arraste. Após mudar a configuração, execute o Encoder e atualize
o `config.bin` gerado no cliente. Use o Main, UI.bin, imagens e scripts BattlePass
da mesma atualização. Os scripts do servidor enviam os dados visuais adicionais;
se o GS já estiver aberto, recarregue os scripts após substituí-los.

Cada nível informa seu estado: bloqueado, em curso, concluído, pronto para
resgatar ou resgatado. A compra apresenta uma confirmação com preço e saldo.
O calendário e o progresso vêm do servidor. A nova tela fecha pelo botão
Fechar, pelo X, pela tecla Esc ou ao clicar fora.

Os dados 3D são carregados por página e ficam em cache enquanto o catálogo
permanece aberto, evitando enviar todos os modelos em uma única resposta.
Ao trocar de página, o modelo pode aparecer após a resposta do servidor.

O modelo 3D mostra o primeiro item da recompensa, com suas opções. Pacotes com
várias entradas indicam essa quantidade; o servidor continua entregando todos
os itens e moedas configurados. Passe o mouse no item para consultar o tooltip.
Os nomes e as missões personalizados vêm do BattlePassConfig.lua; os textos da
interface estão nos quatro arquivos de idioma em `UI\Text`.

## Configuracao

```text
MuServer\Data\Scripts\Custom\Configs\BattlePassConfig.lua
```

As trilhas `quests.silver` e `quests.golden` possuem missoes independentes.
Cada nivel usa `type`, `amount` e `label`:

```lua
quests = {
    silver = {
        [1] = { type = "bc", amount = 1, label = "Complete 1 Blood Castle" },
        [2] = { type = "level_reach", amount = 350, label = "Alcance o level 350" },
        [3] = { type = "ds", amount = 1, label = "Complete 1 Devil Square" },
        [4] = { type = "pk", amount = 5, label = "Faca 5 kills PvP" },
    },

    golden = {
        [1] = { type = "bc", amount = 2, label = "Complete 2 Blood Castle" },
        [2] = { type = "level_reach", amount = 400, label = "Alcance o level 400" },
        [3] = { type = "ds", amount = 2, label = "Complete 2 Devil Square" },
        [4] = { type = "pk", amount = 10, label = "Faca 10 kills PvP" },
    },
}
```

Por padrao, `questMode = "open"`. Nesse modo:

- no dia 1 fica disponivel a missao do nivel 1;
- no dia 26 ficam disponiveis todas as missoes dos niveis 1 ate 26;
- os niveis 27 e 28 continuam bloqueados ate os respectivos dias;
- todas as missoes disponiveis progridem ao mesmo tempo;
- um evento conta em todas as missoes abertas do tipo correspondente;
- concluir uma missao libera somente a recompensa daquele nivel.

Exemplo: se os niveis 1, 7 e 12 possuem missoes `kill`, uma morte soma `1` nas
tres missoes. O progresso Silver e Golden e salvo separadamente por conta,
temporada, trilha e nivel.

Mortes e coletas sao gravadas no SQL a cada 20 eventos por missao ou ao concluir
o requisito; ao sair do personagem, o saldo pendente tambem e gravado. A janela
mostra o contador atual ao ser reaberta. Para conferir a persistencia de um
nivel, consulte `dbo.LuaBattlePassProgress` filtrando `AccountID`, `YearMonth`,
`Track` (`1` = Silver, `2` = Golden) e `Level`.

Outros modos opcionais:

- `questMode = "catchup"`: progride somente a missao pendente mais antiga.
- `questMode = "strict"`: progride somente a missao do dia atual.

Tipos disponiveis:

- `kill`: matar monstros.
- `pick`: coletar itens do chao; Zen nao conta.
- `level`: ganhar niveis.
- `level_reach`: alcancar o level definido em `amount`.
- `pk`: eliminar outros jogadores.
- `bc`: permanecer no Blood Castle ate o encerramento.
- `bc_win`: vencer o Blood Castle ou participar da party vencedora.
- `ds`: permanecer no Devil Square ate o encerramento.

O Golden pode ter requisitos maiores e premios melhores sem interferir no
progresso Silver. Um nivel sem configuracao usa `defaultQuest` da propria
trilha.

Itens simples com stack ativo em `MuServer\Data\Item\ItemStack.txt` sao
entregues acumulados ate o limite configurado. Por exemplo, uma recompensa
`{ section = 14, index = 16, count = 10 }` entrega 10 Jewel of Life em uma
stack; acima do limite, o premio e dividido em varias stacks. A entrega
aproveita stacks existentes no inventario. Itens sem stack ou com
durabilidade, tempo ou opcoes proprias continuam separados. O resgate confere
antes se ha espaco para a recompensa inteira.

Todos os IDs de premio precisam existir em `MuServer\Data\Item\Item.txt`.
Quando um item configurado nao estiver cadastrado, o resgate e recusado como
premio indisponivel e o GameServer registra secao e indice no log. Isso nao
significa que o inventario esteja cheio.

A compra do passe libera o direito de resgatar os premios da respectiva trilha,
mas nao conclui missoes. O botao `RESGATAR` aparece somente depois que a missao
do nivel estiver concluida. Com `retroactive = true`, quem compra depois pode
resgatar os niveis que ja havia concluido.

## Temporada mensal

Cada temporada usa o mes atual no formato `AAAA-MM`. No primeiro dia de um novo
mes o jogador comeca uma temporada limpa; o progresso do mes anterior nao e
reaproveitado. Os registros antigos permanecem no SQL como historico e nao
interferem na temporada nova. Premios nao resgatados ate o fim do mes expiram.

## Comandos administrativos

- `/bpreset`: limpa o Battle Pass da conta do GM no mes atual.
- `/bpunlock`: libera niveis para teste; existe apenas com `debug = true`.

Os dois comandos exigem permissao de GM. Mantenha `debug = false` em producao.

Depois de editar, use `/reload scripts` ou reinicie o GameServer. Alteracoes no
cliente exigem que `BattlePass.lua` continue descriptografado.
