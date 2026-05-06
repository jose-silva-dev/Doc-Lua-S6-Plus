# Gift Guardian

O Gift Guardian e uma janela Lua para resgatar brindes por codigo.

## Arquivos

```text
Data\Custom\Lua\Systems\GiftGuardian.lua
Data\Custom\Lua\Customs\Configs\GiftGuardianConfig.lua
```

## Configuracao Visual

```lua
GiftGuardianConfig = {
	enabled = true,
	window = {
		width = 300,
		height = 270,
		x = 170,
		y = 96,
		center = true,
		maxItems = 6,
		itemIconSize = 15,
		itemIconScale = 0.30,
		itemIconOffsetX = 0,
		itemIconOffsetY = -2,
	},
	text = {
		loading = "Buscando brindes...",
	},
}
```

A janela usa `RenderTop`, entao fica acima do HUD e dos textos nativos. Ela tambem pode ser movida pela barra superior; a posicao fica em memoria ate fechar o cliente.

## Uso

O jogador digita o codigo, pressiona Enter ou clica em Buscar, marca um ou mais brindes e clica em Retirar.

Cada clique em um item alterna entre marcado e desmarcado. Quando mais de um item estiver marcado, o botao mostra a quantidade selecionada.

O cliente nao entrega itens diretamente. Toda validacao e feita pelo servidor.

A listagem pode chegar em varios pacotes internos quando o codigo possui muitos brindes.

Ao retirar varios brindes marcados, o servidor valida espaco para todos os itens antes da entrega. Se o inventario nao tiver espaco suficiente para o lote inteiro, nenhum item selecionado e entregue.

Quando a retirada e recusada pelo servidor, a janela preserva a mensagem de erro recebida, como inventario sem espaco, mesmo que a lista de brindes seja reenviada em seguida. As mensagens de carregamento da lista nao substituem mensagens de erro ou sucesso de retirada.

A renderizacao do icone do item usa escala reduzida para caber na linha da lista. Ao passar o mouse sobre a linha, o cliente exibe o tooltip nativo com o preview do item.

Quando o cliente possui `ClientAPI.ShowItemTooltipFull`, o tooltip do brinde tambem recebe `Skill`, `Luck`, `Option`, `Excellent`, `SetOption`, `Harmony` e `ItemOptionEx` enviados pelo servidor. Isso permite conferir previews de itens simples e full antes da retirada usando a mesma composicao de bytes do item nativo. Para itens ancient, o `SetOption` deve ser o byte completo aceito pelo servidor, preservando tambem a opcao individual exibida no tooltip.

O preview deve representar exatamente os mesmos atributos que o servidor usa na entrega. Se um brinde for cadastrado com skill, luck, option, excellent, ancient ou harmony, o tooltip da lista deve exibir esses atributos antes da retirada. Itens com skill e sem excellent devem aparecer como itens normais com skill.

A renderizacao do icone do item e protegida para que um item visual indisponivel nao impeça a exibicao do nome do brinde.
