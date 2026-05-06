# Client Side - ClientAPI

`ClientAPI` e uma camada de compatibilidade para scripts que preferem chamadas nesse namespace.

Para scripts novos, prefira `Client.X`. Quando existir equivalente, `ClientAPI.X` chama a mesma funcao ou aplica uma protecao simples de retorno.

## Conexao e packet

```lua
ClientAPI.IsConnected()
ClientAPI.IsReady()
ClientAPI.Send(packetName, data)
ClientAPI.OnPacket(callback)
```

## Personagem local

```lua
ClientAPI.GetName()
ClientAPI.GetLevel()
ClientAPI.GetClass()
ClientAPI.GetMap()
ClientAPI.GetX()
ClientAPI.GetY()
ClientAPI.GetLife()
ClientAPI.GetMaxLife()
ClientAPI.GetMana()
ClientAPI.GetMaxMana()
ClientAPI.GetBP()
ClientAPI.GetMaxBP()
ClientAPI.GetShield()
ClientAPI.GetMaxShield()
ClientAPI.GetStatsPoint()
ClientAPI.GetStrength()
ClientAPI.GetDexterity()
ClientAPI.GetVitality()
ClientAPI.GetEnergy()
ClientAPI.GetLeadership()
ClientAPI.GetExperience()
ClientAPI.GetNextExperience()
ClientAPI.GetBaseExperience()
ClientAPI.GetMasterLevel()
ClientAPI.GetMasterPoint()
ClientAPI.GetMasterExperience()
ClientAPI.GetMasterNextExperience()
```

## Mouse e teclado

```lua
ClientAPI.GetMouseX()
ClientAPI.GetMouseY()
ClientAPI.GetMouseWheel()
ClientAPI.PeekMouseWheel()
ClientAPI.IsMouseLeftButton()
ClientAPI.IsMouseRightButton()
ClientAPI.IsMouseLeftButtonPush()
ClientAPI.IsMouseRightButtonPush()
ClientAPI.IsMouseLeftButtonPop()
ClientAPI.IsMouseRightButtonPop()
ClientAPI.IsKeyDown(key)
ClientAPI.ConsumeKey(key)
ClientAPI.IsWindowActive()
ClientAPI.IsMouseInRect(x, y, width, height)
ClientAPI.IsMouseClickInRect(x, y, width, height)
```

Use `ClientAPI.ConsumeKey(key)` quando uma janela Lua tratar uma tecla com acao nativa. Exemplo comum: fechar a janela com `ESC` e impedir que o mesmo comando abra o menu de opcoes ou feche outras janelas nativas ate a tecla ser solta.

## Inventario e tooltip

```lua
ClientAPI.GetInventoryMouseSlot()
ClientAPI.GetInventoryMouseItemSlot()
ClientAPI.GetInventoryMouseItemIndex()
ClientAPI.GetInventoryMouseItemLevel()
ClientAPI.GetInventoryMouseItemOption()
ClientAPI.GetInventoryMouseItemExcellent()
ClientAPI.GetInventoryMouseItemDurability()
ClientAPI.GetInventoryMouseItemInfo()
ClientAPI.GetItemName(itemIndex, level)
ClientAPI.GetItemWidth(itemIndex)
ClientAPI.GetItemHeight(itemIndex)
ClientAPI.GetItemSlot(itemIndex)
ClientAPI.ShowInventoryMouseItemTooltip(x, y)
ClientAPI.ShowItemTooltip(x, y, itemIndex, level, option1, excellent)
ClientAPI.ShowItemTooltipFull(x, y, itemIndex, level, skill, luck, option, excellent, setOption, harmony, itemOptionEx)
```

`ShowItemTooltipFull` e indicado para previews de brindes ou lojas que precisam exibir skill, luck, option, excellent, set/ancient, harmony e opcoes extras antes da entrega real do item.

## Cliente e visual

```lua
ClientAPI.GetWindowWidth()
ClientAPI.GetWindowHeight()
ClientAPI.GetInterfaceWidth()
ClientAPI.GetInterfaceHeight()
ClientAPI.GetOpenGLWindowWidth()
ClientAPI.GetOpenGLWindowHeight()
ClientAPI.GetFPS()
ClientAPI.GetLanguage()
ClientAPI.GetCodePage()
ClientAPI.GetResolution()
ClientAPI.GetResolutionInfo()
ClientAPI.GetVolume()
ClientAPI.SetVolume(level)
ClientAPI.GetGlobalText(textId)
ClientAPI.GetMapName(mapId)
ClientAPI.GetMonsterName(monsterId)
ClientAPI.GetPartyCount()
ClientAPI.GetPing()
ClientAPI.GetCamera3D()
ClientAPI.SetGlowVisible(enabled)
ClientAPI.IsGlowVisible()
ClientAPI.SetEquipmentVisible(enabled)
ClientAPI.IsEquipmentVisible()
```

Use `ClientAPI.GetInterfaceWidth()` e `ClientAPI.GetInterfaceHeight()` para limites de janelas Lua, principalmente em resolucoes widescreen. Esses valores seguem a area logica usada pela interface nativa.

## Render

```lua
ClientAPI.RenderText(x, y, text, width, height, sort, red, green, blue, alpha)
ClientAPI.SetTextColor(red, green, blue, alpha)
ClientAPI.SetTextBg(red, green, blue, alpha)
ClientAPI.SetFontType(fontType)
ClientAPI.RenderBox(x, y, width, height, alpha, flag)
ClientAPI.RenderColorBox(x, y, width, height, red, green, blue, alpha)
ClientAPI.LoadImage(filePath, imageId)
ClientAPI.UnloadImage(imageId)
ClientAPI.RenderImage(imageId, x, y, width, height)
ClientAPI.RenderImageUV(imageId, x, y, width, height, su, sv, uw, vh)
ClientAPI.GetImageWidth(imageId)
ClientAPI.GetImageHeight(imageId)
ClientAPI.PlaySound(soundId)
ClientAPI.StopSound(soundId)
ClientAPI.RenderItem(x, y, width, height, itemIndex, level, option1, extOption)
ClientAPI.RenderCharacter(id, x, y, width, height, angle, zoom, animation)
ClientAPI.RenderCharacterPacket(id, x, y, width, height, classType, change, equipment, angle, zoom, animation)
ClientAPI.RenderMonster(id, x, y, width, height, monsterIndex, angle, zoom, heightOffset, action)
ClientAPI.RenderModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
ClientAPI.RenderMonsterModel(id, x, y, width, height, modelType, kind, scale, angle, zoom, heightOffset, action)
ClientAPI.GetMonsterModelInfo(monsterIndex)
ClientAPI.GetModelPlayer()
ClientAPI.GetModelMonsterBase()
ClientAPI.GetModelMonsterEnd()
ClientAPI.GetKindPlayer()
ClientAPI.GetKindMonster()
```

## Janelas

```lua
ClientAPI.IsWindowOpen(windowId)
ClientAPI.OpenWindow(windowId)
ClientAPI.CloseWindow(windowId)
ClientAPI.ToggleWindow(windowId)
ClientAPI.HideAllInterfaces()
ClientAPI.LockInterface()
ClientAPI.UnlockInterface()
ClientAPI.LockPlayerWalk()
ClientAPI.UnlockPlayerWalk()
ClientAPI.IsInterfaceLocked()
ClientAPI.IsPlayerWalkLocked()
ClientAPI.BlockMouse()
ClientAPI.ConsumeKey(key)
```

## HTTP

```lua
ClientAPI.HttpGet(url, maxBytes)
ClientAPI.HttpRequest(options)
ClientAPI.HttpPost(url, body, headers, maxBytes)
ClientAPI.HttpRequestAsync(requestId, options)
ClientAPI.OnHttpResponse(callback)
ClientAPI.DownloadFile(url, fileName)
```
