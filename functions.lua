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

function ns:ToggleWindow(frame, force)
    if frame == nil then
        ns:PrettyPrint(L.NotLoaded)
        ns.waitingForWindow = true
        return
    end
    if (frame:IsVisible() and force ~= "Show") or force == "Hide" then
        UIFrameFadeOut(frame, 0.1, 1, 0)
        C_Timer.After(0.1, function()
            frame:Hide()
        end)
    else
        UIFrameFadeIn(frame, 0.1, 0, 1)
        C_Timer.After(0.1, function()
            frame:Show()
        end)
    end
end

---
-- Minimap Button (thanks Leatrix!)
---

function ns:CreateMinimapButton()
    if RAVFOR_data.options.minimapButton ~= true then
        if ns.MinimapButton then ns.MinimapButton:Hide() end
        return
    end

    local Button = CreateFrame("Button", nil, Minimap)
    Button:SetFrameLevel(8)
    Button:SetSize(32, 32)
    Button:EnableMouse(true)
    Button:SetMovable(true)
    Button:ClearAllPoints()
    Button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(RAVFOR_data.options.minimapPosition)),(80 * sin(RAVFOR_data.options.minimapPosition)) - 52)

    Button:SetNormalTexture("Interface/AddOns/ravFor/ravFor.tga")
    Button:SetPushedTexture("Interface/AddOns/ravFor/ravFor.tga")
    Button:SetHighlightTexture("Interface/AddOns/ravFor/ravFor.tga")

    local function UpdateMinimapButton()
        local Xpoa, Ypoa = GetCursorPosition()
        local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
        Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
        Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
        RAVFOR_data.options.minimapPosition = math.deg(math.atan2(Ypoa, Xpoa))
        Button:ClearAllPoints()
        Button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(RAVFOR_data.options.minimapPosition)), (80 * sin(RAVFOR_data.options.minimapPosition)) - 52)
    end

    Button:RegisterForDrag("LeftButton")
    Button:SetScript("OnDragStart", function()
        Button:StartMoving()
        Button:SetScript("OnUpdate", UpdateMinimapButton)
    end)

    Button:SetScript("OnDragStop", function()
        Button:StopMovingOrSizing()
        Button:SetScript("OnUpdate", nil)
        UpdateMinimapButton()
    end)

    Button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_TOP", 0, small)
        GameTooltip:SetText("Left-click to open Window.\nRight-click to open Interface Options.")
        GameTooltip:Show()
    end)
    Button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    Button:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            ns.waitingForOptions = true
            ns:PrettyPrint(L.NotLoaded)
        else
            ns:ToggleWindow(ns.Window, "Show")
        end
    end)

    ns.MinimapButton = Button
end

---
-- Calculate # of kills until 95%+ chance item has dropped
---

function ns:RunsUntil95(chance, bound)
    bound = bound and bound or 300
    for i = 1, bound do
        local percentage = 1 - ((1 - chance / 100) ^ i)
        if percentage > 0.95 then
            -- return percentage * 100
            return i
        end
    end
    -- return string.format("%.2f", (1 - ((1 - chance) ^ bound)) * 100 .. "")
    return bound
end

---
-- Item Cache Preloader
---

local function CacheItem(i, itemIDs)
    local Item = Item:CreateFromItemID(itemIDs[i])
    Item:ContinueOnItemLoad(function()
        if i < #itemIDs then
            C_Timer.After(1 / GetFramerate(), function()
                CacheItem(i + 1, itemIDs)
            end)
        else
            ns:BuildOptions()
            InterfaceOptions_AddCategory(ns.Options)
            ns:BuildWindow()
            -- Control clicks
            if ns.MinimapButton then
                ns.MinimapButton:SetScript("OnMouseDown", function(self, button)
                    if button == "RightButton" then
                        InterfaceOptionsFrame_OpenToCategory(ns.Options)
                        InterfaceOptionsFrame_OpenToCategory(ns.Options)
                    else
                        ns:ToggleWindow(ns.Window, "Show")
                    end
                end)
            end
            ns:PrettyPrint(L.Loaded)
            if ns.waitingForWindow then
                ns:ToggleWindow(ns.Window, "Show")
            end
            if ns.waitingForOptions then
                InterfaceOptionsFrame_OpenToCategory(ns.Options)
                InterfaceOptionsFrame_OpenToCategory(ns.Options)
            end
        end
    end)
end

function ns:CacheAndBuild()
    local itemIDs = {}
    for title, expansion in pairs(ns.data.expansions) do
        for _, zone in ipairs(expansion.zones) do
            for _, rare in ipairs(zone.rares) do
                if rare.items and #rare.items then
                    for _, item in ipairs(rare.items) do
                        table.insert(itemIDs, item.id)
                    end
                end
            end
        end
    end
    CacheItem(1, itemIDs)
end
