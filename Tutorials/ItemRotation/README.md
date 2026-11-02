# Rotação de itens em janelas Lua

A partir da 4.0.0, as funções de desenho de itens aceitam um ângulo adicional ou
giro automático. As chamadas existentes continuam funcionando sem alterações.
Consulte os [parâmetros de rotação](../../Client/Functions.md#rotação-de-itens-400).

## Instalação do exemplo

1. Atualize o `Main.exe` e `Data\Custom\Lua\Definitions\Client.lua` com os arquivos da 4.0.0 que incluem este recurso.
2. Copie `Data\Custom\Lua\Examples\ItemRotation.lua` para `Data\Custom\Lua\Systems\ItemRotation.lua` no cliente.
3. Feche e abra o Main e entre com um personagem.
4. Pressione `Ctrl+F8` para abrir ou fechar o exemplo. Ele inicia fechado.

O exemplo é entregue em texto aberto, na pasta `Examples`, que não é carregada
automaticamente. Não exige script de servidor, pacote de rede, SQL ou imagens extras.

## Controles e conferência

| Controle | Ação |
| --- | --- |
| `Ctrl+F8` | Abre ou fecha a comparação. |
| `Ctrl+F7` | Alterna entre espada, cajado, armadura, asa e joia. |
| `Ctrl+F6` | Alterna entre Marketplace, Item, Scaled e Centered. |
| `Esc` | Fecha a comparação. |

As quatro colunas mostram o mesmo item: comportamento original, ângulo fixo de
45 graus, giro de 30 graus por segundo e giro de -60 graus por segundo. O giro
positivo completa uma volta em 12 segundos; o negativo, em 6 segundos.

Passe o mouse sobre cada coluna: o ângulo fixo e os giros explícitos devem manter
seu comportamento. A coluna original conserva as regras de seleção do cliente.
Troque o item e o renderizador e confira a volta completa, inclusive armas e asas.
Os renderizadores tradicionais mantêm sua escala e âncora próprias; somente o
Marketplace aplica a calibração e o recorte compartilhados dos quadrados de itens.

Confira também em diferentes resoluções, limites de FPS e modos OpenGL disponíveis
na sua instalação. Os efeitos do item devem permanecer; no exemplo, todos estão
com nível e opções zero. Para conferir um item melhorado, altere os argumentos do
desenho respeitando o byte de nível descrito na documentação das funções.

O painel é uma comparação visual, sem botões ou bloqueio de movimento. Os atalhos
podem ser ajustados no próprio arquivo se conflitarem com scripts personalizados.
Para remover o exemplo, retire a cópia de `Systems` e reabra o Main.

## Uso em uma janela própria

Crie a tabela de opções uma vez e use-a no callback da sua janela:

```lua
local rotation = { autoRotate = true, rotationSpeed = 30 }

ClientHooks.RegisterRenderTop("MinhaColecao", function()
    if not minhaJanelaAberta then return end
    Client.RenderMarketplaceItem(300, 180, 96, 96,
        itemIndex, byte, excellent, ancient, rotation)
end)
```

Nesse trecho, `minhaJanelaAberta`, `itemIndex`, `byte`, `excellent` e `ancient`
representam os dados da sua janela. Não é necessário criar ou limpar um item
persistente. Ao mudar a coleção, basta passar os dados do novo item.
