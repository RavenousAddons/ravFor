local ADDON_NAME, ns = ...
local L = ns.L

---
-- Local Functions
---

local function contains(table, input)
    for index, value in ipairs(table) do
        if value == input then
            return index
        end
    end
    return false
end

---
-- Global Functions
---

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
end

function ns:TextColor(text, color)
    color = color and color or "eeeeee"
    return "|cff" .. color .. text .. "|r"
end

function ns:TextIcon(icon, size)
    size = size and size or 16
    return "|T" .. icon .. ":" .. size .. "|t"
end

local hasSeenNoSpaceMessage = false
function ns:EnsureMacro()
    if not UnitAffectingCombat("player") and RAVFOR_data.options.macro then
        local body = "/" .. ns.command
        local numberOfMacros, _ = GetNumMacros()
        if GetMacroIndexByName(ns.name) > 0 then
            EditMacro(GetMacroIndexByName(ns.name), ns.name, ns.icon, body)
        elseif numberOfMacros < 120 then
            CreateMacro(ns.name, ns.icon, body)
        elseif not hasSeenNoSpaceMessage then
            hasSeenNoSpaceMessage = true
            ns:PrettyPrint(L.NoMacroSpace)
        end
    end
end

function ns:GetDropChanceData(dropChance, upperBound)
    dropChance = dropChance / 100
    upperBound = upperBound and upperBound or 100
    for i = 1, upperBound do
        local percentage = 1 - ((1 - dropChance) ^ i)
        if percentage > 0.99 then
            return i .. " " .. percentage * 100
        end
    end
    return string.format("%.2f", (1 - ((1 - dropChance) ^ upperBound)) * 100 .. "")
end
