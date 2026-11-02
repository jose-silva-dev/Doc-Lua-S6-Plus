# Pagamento da lojinha pelo Banco de Joias

`JewelBankPayment` e uma chave do GameServer e GameServerCS em `Data/GameServerInfo - Common.dat`, na secao da Personal Shop. O valor padrao e `0`.

| Valor | Compra por Bless, Soul e Chaos na Personal Shop |
| --- | --- |
| `0` | Comportamento anterior: retira as joias do inventario do comprador e entrega ao inventario do vendedor. |
| `1` | Retira o preco do Banco de Joias do comprador e credita o mesmo valor no Banco de Joias do vendedor. O item vai ao inventario do comprador. |

O pagamento bancario abrange as tres joias da Personal Shop nativa e da Custom Store. Precos em Zen ou moedas continuam nas rotas existentes. Um anuncio que misture Zen e joias e recusado enquanto o modo bancario estiver ligado; cadastre somente joias nesse anuncio.

## Requisitos

- Atualizar em conjunto GameServer, GameServerCS e DataServer. Todos precisam usar a mesma versao do protocolo interno.
- Ativar `InventorySaveGuard = 1` no DataServer. Instalar primeiro `MuServer/SQL/Marketplace/001-InventorySaveGuard.sql` do update 3.4.0 na base de personagens e depois `MuServer/SQL/Update3.5.0 - JewelBankPayment.sql` do update 3.5.0 na mesma base. A segunda migracao cria `JBP_Transfer` para uso futuro e `JBP_PersonalShopBuy` para a lojinha.
- O Banco de Joias deve usar a tabela padrao `dbo.CustomJewelBank`, com `AccountID`, `Bless`, `Soul` e `Chaos`, conforme `Data/Scripts/Custom/Configs/JewelBankConfig.lua`. Se o cliente personalizou o nome da tabela ou dessas colunas, adaptar a migracao antes de ligar a chave.
- Substituir `Data/Scripts/Custom/System/JewelBank.lua` pela versao aberta entregue com o recurso. Ela atualiza os saldos na janela apos a compra e valida o debito do saque concorrente.
- Acrescentar os IDs 934–942 dos arquivos `Data/Lang/* (Example).txt` aos idiomas do servidor. O aviso exibido segue o `LanguageCode` configurado no GS.

A compra e concluida numa transacao SQL unica: saldo do comprador, saldo do vendedor e os dois inventarios sao confirmados juntos. A tabela `dbo.JBP_Operation` registra um recibo por pedido para impedir cobranca duplicada. Se a resposta do DataServer for incerta, os jogadores envolvidos sao desconectados para recarregar os inventarios persistidos.

## Conferencia antes de habilitar para jogadores

1. Com a chave em `0`, vender por Bless, Soul e Chaos; confirmar que os saldos do banco nao mudam e que as joias fisicas passam entre os inventarios.
2. Com a chave em `1`, repetir com inventarios de joias vazios e saldo bancario suficiente; confirmar item, debito e credito exatos, inclusive apos relog dos dois personagens.
3. Tentar com saldo insuficiente, inventario do comprador cheio, dois compradores disputando o mesmo item e vendedor sem linha no banco. Nenhum caso recusado pode criar ou cobrar um item.
4. Conferir os recibos em `dbo.JBP_Operation` e os saldos em `dbo.CustomJewelBank`. Testar tambem um saque simultaneo do banco e a Custom Store.

Estas instrucoes descrevem a implementacao para validacao. A entrada em producao depende dos testes em jogo.
