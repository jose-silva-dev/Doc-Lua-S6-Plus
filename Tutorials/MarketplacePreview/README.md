# Marketplace — configuração e uso

Na 4.0.0, o botão **Auction House** abre a modalidade de leilões. Consulte
[configuração e regras da Auction House](../AuctionHouse/README.md). Ela herda
as moedas, taxas, permissões e posições de modelos descritas neste tutorial.

O Marketplace nativo permite anunciar itens da mochila principal, comprar com WC, WP, GP ou Zen, cancelar, renovar anúncios expirados e retirar itens ou Zen. Consulte anúncios em qualquer mapa; anunciar, comprar, cancelar, renovar e retirar exigem zona segura. As operações são confirmadas pelo servidor e registradas no histórico pessoal. Operadores autorizados também podem abrir o Histórico geral.

Na 4.0.0, o acesso pode ser ativado separadamente em `Data/Marketplace.ini`
do GS e do GSCS, com aplicação por **Reload > Reload Marketplace.ini** no servidor
alterado. Consulte [acesso independente e reload](../AuctionHouse/README.md#acesso-independente-e-reload-no-gsgscs).

## Configuração do administrador

Edite `MuServer/Data/Scripts/Custom/Configs/MarketplaceConfig.lua`. A cópia [MarketplaceConfig.lua](MarketplaceConfig.lua) nesta documentação é apenas o modelo inicial. O DataServer valida e aplica alterações em até 5 segundos; reabra `/marketplace` para atualizar os termos. A instalação 3.4.0 requer Main, DataServer, GameServer e GameServerCS compatíveis, migrações SQL 001–018 na ordem indicada no Guia e os INIs de ativação.

O comando padrão `/marketplace` é a linha de índice `90` em `MuServer/Data/Command.txt`. O administrador pode mudar seu nome e recarregar `Command.txt` nos GameServers; não há mais um atalho `/mkp` fixo no Main. Para retirar o acesso à janela, desative essa linha após resolver eventuais retiradas pendentes.

- `Currencies`: ative individualmente WC, WP, GP e Zen. Desativar uma moeda impede novos anúncios, compras e renovações nela; cancelamento, retirada e histórico continuam disponíveis.
- `Enabled=false`: suspende anúncios, compras e renovações para todos; mantém a consulta, o cancelamento, as retiradas e o resgate de Zen. `true` reativa as regras anteriores sem reiniciar os serviços.
- `MaxCustodyItems`: limite total por conta de anúncios, itens em Retiradas e, na 4.0.0, vagas reservadas pelos lances líderes. `MaxActiveListings`: limite de anúncios ativos por nível Free/VIP. Cancelar libera uma vaga ativa; só retirar libera a vaga total.
- `ListingHours`: duração dos anúncios. Anúncios expirados deixam de aceitar compras; o item passa a Retiradas. A renovação é manual.
- `Fees`: cada `Publish` ou `Renew` positivo cobra sua moeda, mesmo que o preço use outra. Duas ou mais taxas são cobradas juntas. Zero em todas significa operação gratuita. `SalePercent` é cobrado somente na moeda da venda; a comissão acordada de anúncios existentes não muda ao editar a configuração.
- `CanPublish` e `CanBuy`: permissões independentes por nível de conta. O modelo bloqueia ambas para Free e libera VIP1–VIP3. Free ainda pode consultar, cancelar anúncios antigos, retirar e resgatar Zen.
- `ShowAdministration=false`: oculta o botão Administração e bloqueia o Histórico geral. `true` ainda exige autoridade de operador; a opção não concede acesso GM.

O servidor confere novamente saldo, item, espaço, nível e regras comerciais dentro da transação. Uma recusa não debita nem move o item. WC, WP e GP pertencem à conta. O Zen líquido de uma venda fica em **Retiradas > Retirar Zen** e pode ser transferido ao personagem em zona segura, respeitando o teto de saldo.

Os nomes das moedas vêm de `Cliente/Data/Local/<idioma>/GlobalText.bmd` (WC/WP/GP, entradas 58–60) e `Text.bmd` (Zen, entrada 224). Reabra o Main após alterar os BMD.

## Interface e histórico

O rodapé global mostra anúncios ativos, itens guardados e os quatro saldos, sem repetir os limites em cada aba. O catálogo tem filtros, busca e paginação. A janela de anúncio mostra item, preço, duração, cada taxa de publicação, comissão e líquido da venda antes da confirmação. O Histórico registra criação, compra, cancelamento, expiração, renovação e retirada, com taxas e saldos quando aplicáveis.

A lista aberta se atualiza ao vencer o próximo anúncio, após a confirmação do servidor. Uma confirmação em andamento não dispara consultas duplicadas. Se outro jogador já comprou um anúncio que ainda aparece numa janela antiga, a tentativa de cancelamento recebe aviso e atualiza a lista; não deve reconectar o personagem.

**Experimentar em 3D** aparece apenas para itens visualizáveis: armas, escudos, armaduras, asas e pets/montarias. Joias, consumíveis, munições, anéis, colares, tickets e skills não apresentam o botão. A comparação usa o tooltip nativo quando o item pode ser equipado.

## Posicionamento dos itens

Em `/marketplace` com personagem GM/ADM, abra **Administração > Posicionamento dos itens**. Busque por nome, ID ou grupo/índice, ajuste escala, posição e rotação, e clique em **Salvar**. Isso exporta `MarketplaceItemPosition.txt` na raiz do cliente e mantém uma cópia `.bak` da exportação anterior. Copie o TXT para `MuServer/Tools/MainInfo/Local/MarketplaceItemPosition.txt`, execute o Encoder atualizado e distribua o `Data/av-code45.pak` gerado para o seu servidor. O arquivo inicial da 3.4.0 já traz 108 ajustes aprovados.

O formato usa ponto decimal e termina em `end`:

```text
// Group Index Scale OffsetX OffsetY RotateX RotateY RotateZ
12 250 0.8 0 -2 0 0 0
end
```

A escala vai de 0.02 a 10, os deslocamentos de -116 a 116 e as rotações de -360 a 360 graus. Entradas inválidas ou repetidas são rejeitadas. O TXT exportado não deve ser entregue ao jogador comum; ele lê os dados do PAK.

## API Lua

`User:isMarketplaceBusy()` informa se o personagem aguarda confirmação de uma transação. Os comandos para criar anúncios, comprar e retirar continuam nativos e ainda não têm API Lua pública. `User:getInventoryItem(slot)` é uma consulta de atributos, não uma serialização completa para venda; veja [InventoryOptions](../InventoryOptions/README.md).
