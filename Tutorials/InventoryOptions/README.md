# Teste de skill, Luck e adicional — 3.4.0

Requer GS/GSCS compilados com a extensão de `User:getInventoryItem` da 3.4.0.
Atualizar somente os scripts ou o Main não adiciona esses campos à API.

Copie [ExampleInventoryOptions.lua](ExampleInventoryOptions.lua) para
`MuServer\Data\Scripts\Custom\System` e use `/reload scripts` ou reinicie o GS.
O exemplo exige personagem GM e apenas consulta o próprio inventário.
Não cria, remove, duplica ou altera itens.

1. Coloque um item na primeira célula da mochila, slot 12. Para itens maiores,
   consulte sempre a célula superior esquerda. Slots 0–11 são equipamentos.
2. Use `/luaitem 12` para ler os atributos; os demais campos também vão ao log do GS.
3. Para comparar, informe os três valores conhecidos: `/luaitem 12 1 1 7`.
   O comando mostra `PASS` somente se os atributos coincidirem, estiverem nas
   faixas válidas e `option1` continuar igual a `skill`.
4. Repita com itens cujos atributos sejam conhecidos, conforme a tabela.
5. Saia e entre novamente no personagem e repita a consulta para conferir a persistência.
   Repita no GSCS quando o personagem estiver nesse servidor.

| Item de teste | Comando (item no slot 12) |
| --- | --- |
| Sem skill, sem Luck e sem adicional | `/luaitem 12 0 0 0` |
| Apenas skill | `/luaitem 12 1 0 0` |
| Apenas Luck | `/luaitem 12 0 1 0` |
| Adicional nível 1, sem skill/Luck | `/luaitem 12 0 0 1` |
| Adicional nível 4, sem skill/Luck | `/luaitem 12 0 0 4` |
| Skill, Luck e adicional nível 7 | `/luaitem 12 1 1 7` |

`option` é o nível de 0 a 7 aceito pelo `GiveItem`, não o bônus numérico do tooltip.
Use itens compatíveis com os atributos testados. Também confira um slot vazio,
uma expectativa propositalmente errada e o bloqueio do comando para quem não é GM.
`LEITURA OK` verifica apenas o formato e o alias; não confirma os atributos esperados.
`PASS` compara os valores informados pelo operador, mas não testa entrega via `GiveItem`.

Para encerrar o teste, remova o exemplo de `Custom\System` e recarregue os scripts.

## Limite para Marketplace

Este teste valida leitura. Não implementa anúncio, retirada, pagamento ou entrega.
`GiveItem` cria outro item e não preserva o serial nem os sockets do original.
O getter não retorna sockets, bônus de socket ou vencimento. Não use os campos
básicos como se fossem uma cópia completa do item; uma transferência de Marketplace
precisa de tratamento próprio de persistência e recuperação de falhas.
