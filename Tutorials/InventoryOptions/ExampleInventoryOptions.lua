-- Genesys 3.4.0: leitura dos atributos; nao cria, remove nem altera itens.
-- /luaitem [slot] [skill luck option esperados]
-- Exemplo: /luaitem 12 1 1 7
-- Somente GM. Slot 12 = primeira celula da mochila (use a origem do item).

local function integer(value, minimum, maximum)
    local n = tonumber(value)
    if not n or n ~= math.floor(n) or n < minimum or n > maximum then
        return nil
    end
    return n
end

command:add("/luaitem", function(playerIndex, args)
    local player = User.new(playerIndex)
    if not player:isGM() then
        SendMessage("Sem permissao para diagnostico de itens.", playerIndex, 1)
        return
    end

    local slot = integer(args[1] or "12", 0, 255)
    local compare = #args > 1
    local skill, luck, option
    if compare then
        skill = integer(args[2], 0, 1)
        luck = integer(args[3], 0, 1)
        option = integer(args[4], 0, 7)
    end
    if not slot or #args > 4 or (compare and (not skill or not luck or not option)) then
        SendMessage("Uso: /luaitem [slot] [skill luck option esperados]", playerIndex, 1)
        return
    end

    local item = player:getInventoryItem(slot)
    if not item then
        SendMessage("Slot vazio/invalido; use a primeira celula ocupada pelo item.", playerIndex, 1)
        return
    end
    if item.skill == nil or item.luck == nil or item.option == nil then
        SendMessage("API antiga: atualize o GS/GSCS para a build 3.4.0 com este recurso.", playerIndex, 1)
        LogPrint("[InventoryOptions] FALHA: campos ausentes; nao assumir valor zero.")
        return
    end

    local valid = integer(item.skill, 0, 1) ~= nil
        and integer(item.luck, 0, 1) ~= nil
        and integer(item.option, 0, 7) ~= nil
        and item.option1 == item.skill
    local matches = not compare or (item.skill == skill and item.luck == luck and item.option == option)
    local status = (valid and matches) and (compare and "PASS" or "LEITURA OK") or "FALHA"
    SendMessage(string.format("%s slot=%d item=%d,%d +%d", status, slot, item.section, item.index, item.level), playerIndex, 1)
    SendMessage(string.format("skill=%s luck=%s option=%s option1=%s", tostring(item.skill), tostring(item.luck), tostring(item.option), tostring(item.option1)), playerIndex, 1)
    LogPrint(string.format(
        "[InventoryOptions] %s player=%s slot=%d item=%d,%d level=%d serial=%s durability=%s skill=%s luck=%s option=%s option1=%s excellent=%s set=%s harmony=%s itemOptionEx=%s expected=%s,%s,%s",
        status, player:getName(), slot, item.section, item.index, item.level,
        tostring(item.serial), tostring(item.durability), tostring(item.skill), tostring(item.luck),
        tostring(item.option), tostring(item.option1), tostring(item.excellent), tostring(item.setOption),
        tostring(item.harmony), tostring(item.itemOptionEx), tostring(skill), tostring(luck), tostring(option)))
end)
