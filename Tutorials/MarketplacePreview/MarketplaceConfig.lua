-- Marketplace / Auction House 4.0.0. Edite em MuServer/Data/Scripts/Custom/Configs/.
-- O DataServer valida e aplica as alteracoes automaticamente; reabra /marketplace para ver novos termos.
-- Os niveis sao 0=Free, 1=VIP1, 2=VIP2, 3=VIP3.
-- SalePercent=5 equivale a 5%; pode usar ate duas casas decimais (ex.: 2.5).
-- Publish/Renew: cada valor positivo e cobrado na sua moeda, independentemente da moeda do preco.
-- Ex.: WC.Publish=0 e Zen.Publish=10000 cobra apenas 10000 Zen; todos zero = gratis.
-- Se duas ou mais moedas tiverem valor positivo, todas serao cobradas na mesma transacao.
-- Uma moeda usada em Publish/Renew precisa estar ativada em Currencies.
-- SalePercent aplica-se somente a moeda escolhida para o preco da venda.
-- CanPublish=false impede anunciar e renovar; CanBuy=false impede comprar.
-- Consultar, cancelar e retirar itens continuam disponiveis para esse nivel.
-- Enabled=false suspende anuncios, compras e renovacoes para todos os niveis.
-- Cancelar, retirar itens, resgatar Zen e consultar historico continuam disponiveis.
-- ShowAdministration=false esconde o botao do GM e bloqueia o Historico geral no DataServer.
-- A verificacao de permissao do operador continua independente desta opcao.
return {
    SchemaVersion = 3,
    Enabled = true, -- Controle geral; alteracoes sao aplicadas pelo DataServer sem reinicio.
    ShowAdministration = true, -- false esconde o botao Administracao e bloqueia o Historico geral.
    Currencies = { WC = true, WP = true, GP = true, Zen = true },
    MaxCustodyItems = 20, -- Anuncios + Retiradas + vagas dos lances lideres, por conta (1 a 200).
    -- Leiloes: mesmas moedas, taxas, permissoes e custodia do Marketplace.
    -- DurationMask: 1=12h, 2=24h, 4=48h; somar para habilitar mais de uma.
    -- A prorrogacao e limitada por MaxExtensionSeconds desde o prazo original.
    Auction = {
        Enabled = false,
        DurationMask = 7,
        IncrementCoin = 25,
        IncrementZen = 250000,
        ExtendSeconds = 30,
        MaxExtensionSeconds = 300,
    },
    Accounts = {
        [0] = { -- Free
            CanPublish = false, CanBuy = false,
            MaxActiveListings = 20, ListingHours = 72,
            Fees = {
                WC = { Publish = 10, Renew = 0, SalePercent = 5 },
                WP = { Publish = 0, Renew = 0, SalePercent = 5 },
                GP = { Publish = 0, Renew = 0, SalePercent = 5 },
                Zen = { Publish = 0, Renew = 0, SalePercent = 5 },
            },
        },
        [1] = { -- VIP1
            CanPublish = true, CanBuy = true,
            MaxActiveListings = 20, ListingHours = 72,
            Fees = {
                WC = { Publish = 10, Renew = 0, SalePercent = 5 },
                WP = { Publish = 0, Renew = 0, SalePercent = 5 },
                GP = { Publish = 0, Renew = 0, SalePercent = 5 },
                Zen = { Publish = 0, Renew = 0, SalePercent = 5 },
            },
        },
        [2] = { -- VIP2
            CanPublish = true, CanBuy = true,
            MaxActiveListings = 20, ListingHours = 72,
            Fees = {
                WC = { Publish = 10, Renew = 0, SalePercent = 5 },
                WP = { Publish = 0, Renew = 0, SalePercent = 5 },
                GP = { Publish = 0, Renew = 0, SalePercent = 5 },
                Zen = { Publish = 0, Renew = 0, SalePercent = 5 },
            },
        },
        [3] = { -- VIP3
            CanPublish = true, CanBuy = true,
            MaxActiveListings = 20, ListingHours = 72,
            Fees = {
                WC = { Publish = 10, Renew = 0, SalePercent = 5 },
                WP = { Publish = 0, Renew = 0, SalePercent = 5 },
                GP = { Publish = 0, Renew = 0, SalePercent = 5 },
                Zen = { Publish = 0, Renew = 0, SalePercent = 5 },
            },
        },
    },
}
