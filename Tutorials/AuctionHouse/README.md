# Auction House — leilões no Marketplace

Disponível na 4.0.0, com os testes locais concluídos. Abra `/marketplace` e clique
em **Auction House**. Se apenas os leilões estiverem habilitados, o comando abre
diretamente essa janela. A interface usa o tema, os nomes das moedas e o
posicionamento de itens já definidos no Marketplace. O botão Marketplace aparece
quando o mercado de preço fixo também está habilitado.

## Configuração

Adicione a seção abaixo ao `MuServer/Data/Scripts/Custom/Configs/MarketplaceConfig.lua`,
no mesmo nível de `Currencies` e `Accounts`. O DataServer valida e aplica a alteração
automaticamente; reabra a janela para receber os termos atuais. Use
`SchemaVersion = 3` na configuração e preserve suas permissões e taxas.

```lua
Auction = {
    Enabled = false,
    DurationMask = 7,
    IncrementCoin = 25,
    IncrementZen = 250000,
    ExtendSeconds = 30,
    MaxExtensionSeconds = 300,
},
```

- `Enabled`: habilita novos anúncios, lances e compras. Desligar não abandona
  leilões aceitos: eles ainda encerram, devolvem valores e entregam os itens.
- `DurationMask`: some 1 para 12 horas, 2 para 24 horas e 4 para 48 horas.
  O padrão 7 libera todas; esta seleção vale para todos os níveis de conta.
- `IncrementCoin` e `IncrementZen`: aumento mínimo depois do primeiro lance.
  O primeiro lance aceita o preço inicial informado pelo vendedor.
- `ExtendSeconds`: quando faltar menos que esse tempo, o novo lance estende o
  prazo até esse intervalo. Zero desliga a extensão.
- `MaxExtensionSeconds`: limite acumulado além do prazo original; deve ser maior
  ou igual a ExtendSeconds. O padrão limita a prorrogação a cinco minutos.

Moedas habilitadas, taxas e permissões são herdadas de `Currencies` e `Accounts`.
`MaxActiveListings` limita os anúncios ativos das duas modalidades juntos.
`MaxCustodyItems` inclui anúncios, itens em Retiradas e vagas reservadas pelos
lances que a conta está vencendo. Não é necessário outro arquivo de posições.
O modelo completo fica em [MarketplaceConfig.lua](../MarketplacePreview/MarketplaceConfig.lua).

Não há funções Lua públicas para debitar, entregar ou fechar leilões. Todas as
movimentações são validadas e confirmadas pelas procedures SQL do servidor.

## Acesso independente e reload no GS/GSCS

Em `Data/Marketplace.ini` de cada GameServer, configure as duas seções:

```ini
[Marketplace]
Enabled = 1
TradingEnabled = 1

[AuctionHouse]
Enabled = 1
TradingEnabled = 1
```

`Enabled = 0` desativa o acesso e as operações somente daquela modalidade.
`TradingEnabled = 0` bloqueia compras no Marketplace ou lances/compras nos leilões,
mantendo as demais operações quando o acesso está habilitado. Essas opções não
apagam itens, reservas ou saldos, nem substituem as permissões do Lua. Para novos
negócios nos leilões, o Lua também precisa de `Enabled = true` no nível principal
e de `Auction.Enabled = true`, além das permissões Free/VIP correspondentes.

Após editar, use **Reload > Reload Marketplace.ini** no GS ou GSCS que atende o
mapa do personagem. Cada processo aplica seu próprio arquivo. Reabra a janela
no jogo para atualizar os botões. O reload não exige reinício; arquivo ausente,
em gravação ou com opção inválida conserva a configuração anterior e registra
erro no log. Operações já aceitas continuam aguardando a confirmação do DataServer.

## Como funciona

Em **Anunciar item**, escolha o item da mochila principal, moeda, lance inicial
e duração. Comprar agora é opcional: use zero para desativar; quando definido,
deve ser pelo menos o preço inicial mais o incremento. Confira as taxas antes
de confirmar. Valem as restrições de itens e de área segura do Marketplace.

O maior lance sai do saldo disponível e fica reservado. Se outro jogador superar
o lance, a devolução é registrada. WC/WP/GP voltam à carteira quando houver espaço;
o excedente e as devoluções em Zen ficam em **Retiradas > Resgatar saldo**.
O valor que não couber na carteira continua pendente. Não há conversão de moedas.

Quem já lidera pode comprar imediatamente pagando apenas a diferença. Não pode
aumentar o próprio lance nem negociar com a própria conta por outro personagem.
O vendedor só pode cancelar antes do primeiro lance; a taxa de publicação não é
devolvida. Sem lances, o item volta ao vendedor no encerramento. Com vencedor,
o item vai para as Retiradas dele, preservando seus atributos e durabilidade.

O fechamento usa o horário do SQL e funciona com os jogadores offline enquanto
o DataServer estiver ativo. Após uma parada, leilões vencidos são processados ao
retomar o serviço. Alterar a configuração não reescreve os termos já aceitos.
As abas Meus lances, Meus leilões e Histórico mostram a situação da própria conta.

## Instalação e cuidados com atualização

É necessário atualizar Main, DataServer, GameServer e GameServerCS juntos, além
do UI.bin e dos textos de UI nos quatro idiomas. Com os processos parados e um
backup verificado, execute integralmente `MuServer/SQL/Update4.0.0 - AuctionHouse.sql`
no banco MuOnline já atualizado para Marketplace 3.5.0. A migração é transacional
e pode ser reaplicada sem apagar anúncios, moedas ou recibos.

O exemplo vem com Auction desligada. Ative após conferir as permissões e taxas
do seu servidor. Para interromper novos negócios depois do uso, desligue a opção
e mantenha a versão compatível funcionando até resolver as retiradas; não volte
a executáveis antigos enquanto houver leilões/reservas pendentes.
