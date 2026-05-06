# Client Side - Remote Content / HTML Leve

APIs para baixar conteudo remoto e transformar em UI nativa Lua.

Importante:

- Isto nao e um navegador embutido.
- Nao executa JavaScript.
- Nao interpreta CSS completo.
- O script Lua deve ler HTML simples ou JSON e desenhar a interface com `Client.RenderText`, `Client.RenderImage`, botoes Lua, etc.

## Client.HttpGet

```lua
Client.HttpGet(url, maxBytes)
```

Baixa texto remoto curto.

Parametros:

- `url`: endereco `http://` ou `https://`.
- `maxBytes`: limite de bytes para baixar.

Retorno:

```lua
{
	ok = true,
	url = "...",
	status = 200,
	size = 1234,
	data = "...",
	error = "",
	truncated = false,
}
```

Exemplo:

```lua
local result = Client.HttpGet("https://site.com/api/", 65536)
if result.ok then
	LogPrint(result.data)
end
```

## Client.HttpRequest

```lua
Client.HttpRequest(options)
```

Faz request HTTP/HTTPS com mais controle.

Opcoes:

- `method`: `"GET"` ou `"POST"`.
- `url`: endereco remoto.
- `body`: corpo do POST.
- `headers`: tabela de headers permitidos.
- `maxBytes`: limite de resposta.
- `timeoutMs`: timeout em milissegundos.
- `httpsOnly`: `true` por padrao.
- `allowedDomains`: lista de dominios permitidos.

Headers permitidos:

```text
Accept
Accept-Language
Authorization
Content-Type
User-Agent
X-Requested-With
X-Lua-Client
X-Api-Key
```

Exemplo GET:

```lua
local result = Client.HttpRequest({
	method = "GET",
	url = "https://site.com/api/",
	maxBytes = 65536,
	timeoutMs = 5000,
	httpsOnly = true,
	allowedDomains = {
		"site.com",
	},
	headers = {
		["Accept"] = "text/html",
		["X-Lua-Client"] = "Genesys",
	},
})

if result.ok then
	LogPrint("HTML recebido: " .. result.size .. " bytes")
end
```

Exemplo POST:

```lua
local result = Client.HttpRequest({
	method = "POST",
	url = "https://site.com/api/",
	body = "name=Admin&token=123",
	headers = {
		["Content-Type"] = "application/x-www-form-urlencoded",
	},
	allowedDomains = {
		"site.com",
	},
})
```

## Client.HttpRequestAsync

```lua
Client.HttpRequestAsync(requestId, options)
Client.OnHttpResponse(function(response)
end)
```

Executa request em segundo plano e entrega a resposta depois.
Use para evitar travar o cliente enquanto o site responde.

Exemplo:

```lua
Client.OnHttpResponse(function(response)
	if response.requestId ~= "news" then
		return
	end

	if response.ok then
		LogPrint("Noticia recebida: " .. response.size .. " bytes")
	else
		LogPrint("Erro HTTP: " .. response.error .. " status=" .. response.status)
	end
end)

Client.HttpRequestAsync("news", {
	method = "GET",
	url = "https://seusite.com/api/",
	maxBytes = 65536,
	timeoutMs = 5000,
	allowedDomains = {
		"seusite.com",
	},
})
```

## Client.DownloadFile

```lua
Client.DownloadFile(url, fileName)
```

Baixa arquivo remoto para:

```text
Data\Custom\Lua\Cache
```

Parametros:

- `url`: endereco remoto.
- `fileName`: nome simples do arquivo, sem pasta.

Retorno:

```lua
{
	ok = true,
	url = "...",
	fileName = "banner.jpg",
	path = ".\\Data\\Custom\\Lua\\Cache\\banner.jpg",
	hresult = 0,
	packed = true,
	packedPath = ".\\Data\\Custom\\Lua\\Cache\\banner.OZJ",
	error = "",
}
```

## Conversao automatica de imagem

Quando `Client.DownloadFile` baixa imagem, ele pode preparar o formato usado pelo loader do MU:

```text
.jpg  -> cria tambem .OZJ
.jpeg -> cria tambem .OZJ
.tga  -> cria tambem .OZT
```

Exemplo:

```lua
local result = Client.DownloadFile(
	"https://seusite.com/api/notice_banner.jpg",
	"notice_banner.jpg"
)

if result.ok then
	Client.LoadImage("Custom\\Lua\\Cache\\notice_banner.jpg", 92010)
end
```

Arquivos criados:

```text
Data\Custom\Lua\Cache\notice_banner.jpg
Data\Custom\Lua\Cache\notice_banner.OZJ
```

Mesmo chamando `Client.LoadImage` com `.jpg`, o cliente usa o `.OZJ` preparado por baixo.

## HTML leve recomendado

Use HTML simples:

```html
<h1>PROMO VIP GAME</h1>
<h2>Planos em promocao por tempo limitado</h2>
<img src="notice_banner.jpg">
<ul>
  <li>VIP Bronze: 15 dias com bonus de XP.</li>
  <li>VIP Silver: 30 dias com desconto especial.</li>
  <li>VIP Gold: 30 dias com melhor bonus de drop.</li>
</ul>
<footer>Oferta valida somente durante este teste.</footer>
```

O Lua pode converter essas tags para janela nativa.

Tags recomendadas:

```text
h1
h2
h3
p
ul/li
img
footer
button simples via Lua
```

Evite:

```text
script
iframe
form complexo
CSS pesado
HTML gigante
arquivos muito grandes
```
