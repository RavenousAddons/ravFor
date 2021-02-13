local name, ns = ...
local L = ns.L

local expansion = ns.data.expansions[ns.expansion]
local notes = expansion.notes
local zones = expansion.zones
local covenants = ns.data.covenants


---
-- Local Bits and Bobs
---

local width = 420
local height = 360

local small = 6
local medium = 12
local large = 16
local gigantic = 24

local faction, _ = UnitFactionGroup("player")
local factionCity = (faction == "Alliance" and "Stormwind" or "Orgrimmar")

local function commaValue(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

local function TextColor(text, color)
    color = color and color or "bbbbbb"
    return "|cff" .. color .. text .. "|r"
end

local function TextIcon(icon, size)
    size = size and size or 16
    return "|T" .. icon .. ":" .. size .. "|t"
end

local skull = TextIcon(137025)
local checkmark = TextIcon(628564)

local function GetMaxRenown()
    -- if 0, then reset is today but has not yet happened
    local daysUntilWeeklyReset = math.floor(C_DateAndTime.GetSecondsUntilWeeklyReset() / 60 / 60 / 24)
    local now = C_DateAndTime.GetCurrentCalendarTime()
    local year, month, day = now.year, now.month, now.monthDay
    local lookup_year, lookup_month, lookup_day
    local maxRenown = 3
    for _, lookup in ipairs(ns.data.renownLevels) do
        lookup_year = lookup.year and lookup.year or lookup_year
        lookup_month = lookup.month and lookup.month or lookup_month
        lookup_day = lookup.day and lookup.day or lookup_day
        if year > lookup_year then
            maxRenown = lookup.level
        elseif year == lookup_year and month > lookup_month then
            maxRenown = lookup.level
        elseif year == lookup_year and month == lookup_month and day > lookup_day then
            maxRenown = lookup.level
        elseif year == lookup_year and month == lookup_month and day == lookup_day and daysUntilWeeklyReset > 0 then
            maxRenown = lookup.level
        end
    end
    return maxRenown
end

local function IsRareDead(rare)
    if type(rare.quest) == "table" then
        for _, quest in ipairs(rare.quest) do
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then break end
        end
        return true
    elseif rare.quest then
        return C_QuestLog.IsQuestFlaggedCompleted(rare.quest)
    end
    return false
end

local function IsItemOwned(item)
    if item.mount then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(item.mount)
        return isCollected
    elseif item.pet then
        local isCollected, _, _ = C_PetJournal.GetPetSummonInfo(item.pet)
        return isCollected
    -- elseif item.toy then
    --
    elseif item.quest then
        return C_QuestLog.IsQuestFlaggedCompleted(item.quest)
    elseif item.achievement then
        local _, _, _, isCompleted = GetAchievementInfo(item.achievement)
        return isCompleted
    end
    return false
end

---
-- General Functions
---

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. ns.name .. "|r |cff" .. ns.color .. ns.expansion .. "|r|cffffffff:|r " .. message)
end

local hasSeenNoSpaceMessage = false
function ns:EnsureMacro()
    if not UnitAffectingCombat("player") then
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

---
-- User Options
---

function ns:RegisterDefaultOption(key, value)
    if RAVFOR_data.options[key] == nil then
        RAVFOR_data.options[key] = value
    end
end

function ns:SetDefaultOptions()
    if RAVFOR_data == nil then
        RAVFOR_data = {}
    end
    if RAVFOR_data.options == nil then
        RAVFOR_data.options = {}
    end
    for k, v in pairs(ns.data.defaults) do
        ns:RegisterDefaultOption(k, v)
    end
end

function ns:CreateLabel(cfg)
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -16
    cfg.relativeTo = cfg.relativeTo or prevControl
    cfg.fontObject = cfg.fontObject or "GameFontNormal"
    cfg.justify = cfg.justify or "LEFT"

    local label = cfg.parent:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    label:SetJustifyH(cfg.justify)
    label:SetText(cfg.label)
    if cfg.width then
        label:SetWidth(cfg.width)
    end

    if not cfg.ignorePlacement then
        prevControl = label
    end
    return label
end

function ns:CreateCheckbox(cfg)
    local checkbox = CreateFrame("CheckButton", name .. "OptionsCheckbox" .. cfg.var, ns.Options, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -16)
    checkbox.var = cfg.var
    checkbox.label = cfg.label
    checkbox.Text:SetJustifyH("LEFT")
    checkbox.Text:SetText(cfg.label)
    checkbox.tooltipText = cfg.tooltip .. "\n" .. RED_FONT_COLOR:WrapTextInColorCode(REQUIRES_RELOAD)
    checkbox.restart = false

    checkbox.GetValue = function()
        return checkbox:GetChecked()
    end
    checkbox.SetValue = function()
        checkbox:SetChecked(RAVFOR_data.options[cfg.var])
    end

    checkbox:SetScript("OnClick", function(self)
        checkbox.value = self:GetChecked()
        checkbox.restart = not checkbox.restart
        RAVFOR_data.options[checkbox.var] = checkbox:GetChecked()
        ns:RefreshControls(ns.Options.controls)
    end)

    ns:RegisterControl(checkbox, ns.Options)
    prevControl = checkbox
    return checkbox
end

function ns:RegisterControl(control, parentFrame)
    if (not parentFrame) or (not control) then
        return
    end
    parentFrame.controls = parentFrame.controls or {}
    table.insert(parentFrame.controls, control)
end

function ns:RefreshControls(controls)
    for _, control in pairs(controls) do
        control:SetValue(control)
        control.oldValue = control:GetValue()
    end
end

function ns:RegisterCurrency(currency, parentFrame)
    if (not parentFrame) or (not currency) then
        return
    end
    parentFrame.currencies = parentFrame.currencies or {}
    table.insert(parentFrame.currencies, currency)
end

function ns:RefreshCurrencies(currencies)
    for _, label in ipairs(currencies) do
        local currency = C_CurrencyInfo.GetCurrencyInfo(label.currency)
        local quantity = commaValue(currency.quantity)
        local max = currency.useTotalEarnedForMaxQty and commaValue(currency.maxQuantity - currency.totalEarned + currency.quantity) or commaValue(currency.maxQuantity)
        label:SetText(TextColor(quantity .. (currency.maxQuantity > 0 and "/" .. max or ""), "ffffff") .. " " .. TextColor(string.gsub(currency.name, "Reservoir ", ""), (label.currencyColor and label.currencyColor or "ffffff")))
    end
end

---
-- PVP
---

function ns:CreatePVP()
    local heading = ns.Content:CreateFontString(name .. "PVP", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(236396) .. "  " .. TextColor("PVP", "f5c87a"))

    local honor = ns.Content:CreateFontString(name .. "Honor", "ARTWORK", "GameFontNormal")
    honor:SetPoint("LEFT", heading, "RIGHT", large, 0)
    honor:SetJustifyH("LEFT")
    honor.currency = 1792
    honor.currencyColor = "f5c87a"
    ns:RegisterCurrency(honor, ns.Content)

    local conquest = ns.Content:CreateFontString(name .. "Conquest", "ARTWORK", "GameFontNormal")
    conquest:SetPoint("LEFT", honor, "RIGHT", medium, 0)
    conquest:SetJustifyH("LEFT")
    conquest.currency = 1602
    conquest.currencyColor = "f5c87a"
    ns:RegisterCurrency(conquest, ns.Content)

    ns:RefreshCurrencies(ns.Content.currencies)

    local warmode = CreateFrame("Button", name .. "Warmode", ns.Content)
    warmode:SetWidth(width/2)
    warmode:SetHeight(large)
    warmode:SetPoint("TOPLEFT", honor, "BOTTOMLEFT", 0, -medium)

    local label = warmode:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(warmode:GetWidth())
    label:SetJustifyH("LEFT")

    ns:RegisterWarmode(label, ns.Content)
    ns:RefreshWarmode(ns.Content.warmode)
    warmode:EnableMouse(true)
    warmode:SetScript("OnClick", function()
        if C_PvP.CanToggleWarMode(not C_PvP.IsWarModeDesired()) then
            C_PvP.ToggleWarMode()
        elseif C_PvP.IsWarModeDesired() then
            RaidNotice_AddMessage(RaidBossEmoteFrame, "You must go to a rested area to disable War Mode.", ChatTypeInfo["RAID_WARNING"])
        else
            RaidNotice_AddMessage(RaidBossEmoteFrame, "You must go to " .. factionCity .. " to enable War Mode.", ChatTypeInfo["RAID_WARNING"])
        end
    end)

    prevControl = heading
    return heading
end

function ns:RegisterWarmode(warmode, parentFrame)
    if (not parentFrame) or (not warmode) then
        return
    end
    parentFrame.warmode = warmode
end

function ns:RefreshWarmode(label)
    local warmode = C_PvP.IsWarModeDesired() and "|cff66ff66Enabled|r" or "|cffff6666Disabled|r"
    label:SetText(TextColor("Warmode is " .. warmode .. ".", "ffffff"))
end

---
-- Zone
---

function ns:CreateZone(zone)
    local mapName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil

    local heading = ns.Content:CreateFontString(name .. "Zone" .. zone.id, "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(zoneIcon) .. "  " .. TextColor(mapName, zoneColor))
    prevControl = heading

    if zone.covenant then
        local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
        local zoneCovenant = TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor)
        local label = ns.Content:CreateFontString(name .. "Zone" .. zone.id .. "Covenant", "ARTWORK", "GameFontNormal")
        label:SetPoint("LEFT", heading, "RIGHT", large, 0)
        label:SetJustifyH("LEFT")
        label:SetText(TextColor("Home of the ", "ffffff") .. zoneCovenant)
    end

    if zone.currency then
        local label = ns.Content:CreateFontString(name .. "Zone" .. zone.id .. "Currency", "ARTWORK", "GameFontNormal")
        label:SetPoint("LEFT", heading, "RIGHT", large, 0)
        label:SetJustifyH("LEFT")
        label.currency = zone.currency
        label.currencyColor = zoneColor
        ns:RegisterCurrency(label, ns.Content)
        ns:RefreshCurrencies(ns.Content.currencies)
    end

    -- For each Rare in the Zone
    local j = 0
    for _, rare in ipairs(zone.rares) do
        if rare.hidden then
        elseif rare.waypoint[1] > 99 and rare.waypoint[2] > 99 then
        else
            local items = {}
            if rare.items then
                -- For each Item dropped by the Rare in the Zone
                for _, item in ipairs(rare.items) do
                    if not GetItemInfo(item.id) then
                    elseif RAVFOR_data.options.showTransmog == false and item.transmog then
                    elseif RAVFOR_data.options.showMounts == false and item.mount then
                    elseif RAVFOR_data.options.showPets == false and item.pet then
                    elseif RAVFOR_data.options.showToys == false and item.toy then
                    elseif RAVFOR_data.options.showGear == false and not item.transmog and not item.mount and not item.pet and not item.toy then
                    elseif RAVFOR_data.options.showOtherCovenantItems == false and item.covenantOnly and (covenant ~= zone.covenant) then
                    elseif RAVFOR_data.options.showOwned == false and IsItemOwned(item) then
                    else
                        -- Insert Item into Items
                        table.insert(items, item)
                    end
                end
            end
            if RAVFOR_data.options.showNoDrops == false and #items == 0 and not rare.reptuation then
            else
                -- Rare
                j = j + 1
                ns:CreateRare(j, zone, rare, items, covenant)
            end
        end
    end

    return heading
end

---
-- Rare
---

function ns:CreateRare(i, zone, rare, items, covenant)
    local button = CreateFrame("Button", name .. "Rare" .. rare.id, ns.Content)
    button:SetWidth(ns.Window:GetWidth() - (medium * 2) - 18)
    button:SetHeight(large)
    button:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -large)
    button:EnableMouse(true)
    button:SetScript("OnClick", function()
        -- Mark the Rare
        ns:NewTarget(zone, rare)
        -- Send the Rare to Party/Raid Members
        ns:SendTarget(zone, rare)
    end)
    prevControl = button

    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local dead = IsRareDead(rare) and checkmark or skull
    local covenantRequired = rare.covenantRequired and TextColor(", summoned by ") .. zoneCovenant .. (#items > 0 and TextColor(",") or "") or ""
    local drops = #items > 0 and  " " .. TextColor("drops:") or ""

    local label = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(button:GetWidth())
    label:SetJustifyH("LEFT")
    label:SetText(dead .. " " .. TextColor(i .. ". ") .. rare.name .. covenantRequired .. drops)

    label.rare = rare
    ns:RegisterRare(label, ns.Content)

    if RAVFOR_data.options.showReputation == true and rare.reputation then
        ns:CreateLabel({
            name = name .. "Rare" .. rare.id .. "Reputation",
            parent = ns.Content,
            label = "    " .. TextColor("+ " .. rare.reputation .. " reputation with Ve'nari", "8080ff"),
            offsetY = -small,
        })
    end

    if #items > 0 then
        for _, item in ipairs(items) do
            ns:CreateItem(zone, rare, item, covenant)
        end
    end

    return button
end

function ns:RegisterRare(rare, parentFrame)
    if (not parentFrame) or (not rare) then
        return
    end
    parentFrame.rares = parentFrame.rares or {}
    table.insert(parentFrame.rares, rare)
end

function ns:RefreshRares(rares, id)
    for _, label in ipairs(rares) do
        local withoutDead = string.gsub(string.gsub(label:GetText(), skull, ""), checkmark, "")
        label:SetText((IsRareDead(label.rare) and checkmark or skull) .. withoutDead)
    end
end

function ns:CreateItem(zone, rare, item, covenant)
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
    local itemMeta = (itemType == "Armor" or itemType == "Weapon") and TextColor(" (" .. itemSubType .. ")") or ""
    -- itemLink = string.gsub(itemLink, "]", itemMeta .. "]")
    local guaranteed = item.guaranteed and TextColor(" 100% drop!") or ""
    local achievement = item.achievement and TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
    local covenantOnly = item.covenantOnly and TextColor(" only for ") .. zoneCovenant or ""
    local owned = IsItemOwned(item) and " " .. checkmark or ""

    local button = CreateFrame("Button", name .. "Item" .. item.id, ns.Content)
    button:SetWidth(ns.Window:GetWidth() - (medium * 2) - 18)
    button:SetHeight(large)
    button:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -small)
    button:EnableMouse(true)
    button:SetScript("OnClick", function()
        -- TODO Should open Item Tooltip/Mount Journal/Pet Journal/etc.
    end)

    local label = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(button:GetWidth())
    label:SetJustifyH("LEFT")
    label:SetText("    " .. TextIcon(itemTexture) .. "  " .. itemLink .. guaranteed .. achievement .. covenantOnly .. owned)

    label.item = item
    ns:RegisterItem(label, ns.Content)

    prevControl = button
    return button
end

function ns:RegisterItem(item, parentFrame)
    if (not parentFrame) or (not item) then
        return
    end
    parentFrame.items = parentFrame.items or {}
    table.insert(parentFrame.items, item)
end

function ns:RefreshItems(items)
    for _, label in ipairs(items) do
        local withoutOwned = string.gsub(label:GetText(), checkmark, "")
        label:SetText(withoutOwned .. (IsItemOwned(label.item) and checkmark or ""))
    end
end

---
-- Notes
---

function ns:CreateNotes(notes)
    if not #notes then
        return
    end

    local heading = ns.Content:CreateFontString(name .. "Notes", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(1506451) .. "  " .. TextColor("Notes", "ffffff"))
    prevControl = heading

    for i, note in ipairs(notes) do
        ns:CreateLabel({
            name = name .. "Note" .. i,
            parent = ns.Content,
            label = TextColor(note, "ffffff"),
            width = ns.Window:GetWidth() - (medium * 2) - 18,
            offsetY = -medium,
        })
    end

    return heading
end

---
-- Targets
---

function ns:NewTarget(zone, rare)
    local zoneName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local x = rare.waypoint[1]
    local y = rare.waypoint[2]
    -- Print message to chat
    ns:PrettyPrint("\n" .. rare.name .. "  |cffffd100|Hworldmap:" .. zone.id .. ":" .. x * 100 .. ":" .. y * 100 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cff" .. zoneColor .. zoneName .. "|r |cffffffff" .. string.format("%.1f", x) .. ", " .. string.format("%.1f", y) .. "|r]|h|r")
    -- Add the waypoint to the map and track it
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(zone.id, x / 100, y / 100))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

function ns:SendTarget(zone, rare)
    local target = string.format("target={%1$s,%2$s}", zone.id, rare.id)
    local playerName = UnitName("player")
    local isLead = false
    for i = 1, MAX_RAID_MEMBERS do
        local lookup, rank = GetRaidRosterInfo(i)
        if lookup == playerName then
            if rank > 1 then isLead = true end
            break
        end
    end
    if isLead then
        local inInstance, _ = IsInInstance()
        if inInstance then
            C_ChatInfo.SendAddonMessage(name, target, "INSTANCE_CHAT")
            print("Sending target to Instance members…")
        elseif IsInGroup() then
            if GetNumGroupMembers() > 5 then
                C_ChatInfo.SendAddonMessage(name, target, "RAID")
                print("Sending target to Raid members…")
            else
                C_ChatInfo.SendAddonMessage(name, target, "PARTY")
                print("Sending target to Party members…")
            end
        end
    -- Enable for testing
    -- else
    --     C_ChatInfo.SendAddonMessage(name, target, "WHISPER", UnitName("player"))
    end
end

---
-- Great Vault (Shadowlands)
---

function ns:CreateGreatVault()
    if not C_WeeklyRewards.CanClaimRewards() then
        return
    end

    local heading = ns.Content:CreateFontString(name .. "GreatVault", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(3847780) .. "  " .. TextColor("Great Vault", "8899c6"))

    local Notice = ns.Content:CreateFontString(name .. "GreatVaultNotice", "ARTWORK", "GameFontNormal")
    Notice:SetPoint("LEFT", heading, "RIGHT", large, 0)
    Notice:SetJustifyH("LEFT")
    Notice:SetText(TextColor("Go to Oribos to claim your rewards!", "ff6666"))

    prevControl = heading
    return heading
end

---
-- Covenant and Renown (Shadowlands)
---

function ns:CreateCovenant()
    local heading = ns.Content:CreateFontString(name .. "Covenant", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-medium)
    heading:SetJustifyH("LEFT")

    local label = ns.Content:CreateFontString(name .. "Renown", "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", heading, "RIGHT", large, 0)
    label:SetJustifyH("LEFT")

    ns:RegisterCovenant(heading, label, ns.Content)
    ns:RefreshCovenant(heading, label)

    local anima = ns.Content:CreateFontString(name .. "Anima", "ARTWORK", "GameFontNormal")
    anima:SetPoint("LEFT", label, "RIGHT", medium, 0)
    anima:SetJustifyH("LEFT")
    anima.currency = 1813
    anima.currencyColor = "95c3e1"
    ns:RegisterCurrency(anima, ns.Content)
    ns:RefreshCurrencies(ns.Content.currencies)

    prevControl = heading
    return heading
end

function ns:RegisterCovenant(heading, label, parentFrame)
    if (not parentFrame) or (not heading) or (not label) then
        return
    end
    parentFrame.covenant = heading
    parentFrame.renown = label
end

function ns:RefreshCovenant(heading, label)
    local covenant = C_Covenants.GetActiveCovenantID()
    if not covenant then
        return
    end
    local renown = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = GetMaxRenown()

    heading:SetText(TextIcon(3726261) .. "  " .. TextColor(C_Covenants.GetCovenantData(covenant).name, ns.data.covenants[covenant].color))
    label:SetText((renown < maxRenown and TextColor(renown .. "/" .. maxRenown, "ff6666") or TextColor(renown, "ffffff")) .. TextColor(" Renown", ns.data.covenants[covenant].color))
end

---
-- Torghast (Shadowlands)
---

function ns:CreateTorghast()
    local heading = ns.Content:CreateFontString(name .. "Torghast", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(3642306) .. "  " .. TextColor("Torghast", "b0ccd8"))

    local soulAsh = ns.Content:CreateFontString(name .. "SoulAsh", "ARTWORK", "GameFontNormal")
    soulAsh:SetPoint("LEFT", heading, "RIGHT", large, 0)
    soulAsh:SetJustifyH("LEFT")

    soulAsh.currency = 1828
    soulAsh.currencyColor = "b0ccd8"
    ns:RegisterCurrency(soulAsh, ns.Content)
    ns:RefreshCurrencies(ns.Content.currencies)

    prevControl = heading
    return heading
end
