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
        return select(11, C_MountJournal.GetMountInfoByID(item.mount))
    elseif item.pet then
        return C_PetJournal.GetNumCollectedInfo(item.pet) > 0
    elseif item.toy then
        return PlayerHasToy(item.id)
    elseif item.quest then
        return C_QuestLog.IsQuestFlaggedCompleted(item.quest)
    elseif item.achievement then
        return select(4, GetAchievementInfo(item.achievement))
    else
        return C_TransmogCollection.PlayerHasTransmog(item.id)
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
    if not UnitAffectingCombat("player") and RAV_data.options.macro then
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
    checkbox:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -12)
    checkbox.var = cfg.var
    checkbox.label = cfg.label
    checkbox.Text:SetJustifyH("LEFT")
    checkbox.Text:SetText(cfg.label)
    checkbox.tooltipText = cfg.tooltip
    checkbox.restart = false
    if cfg.needsRestart then
        checkbox.tooltipText = checkbox.tooltipText .. "\n" .. RED_FONT_COLOR:WrapTextInColorCode(REQUIRES_RELOAD)
    end

    checkbox.GetValue = function()
        return checkbox:GetChecked()
    end
    checkbox.SetValue = function()
        checkbox:SetChecked(RAVFOR_data.options[cfg.var])
    end

    checkbox:SetScript("OnClick", function(self)
        checkbox.value = self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        if cfg.needsRestart then
            checkbox.restart = not checkbox.restart
        end
        RAVFOR_data.options[checkbox.var] = checkbox:GetChecked()
        ns:RefreshControls(ns.Options.controls)
    end)

    ns:RegisterControl(checkbox, ns.Options)
    prevControl = checkbox
    return checkbox
end

function ns:RegisterControl(control)
    if not control then return end
    ns.controls = ns.controls or {}
    table.insert(ns.controls, control)
end

function ns:RefreshControls()
    for _, control in pairs(ns.controls) do
        control:SetValue(control)
        control.oldValue = control:GetValue()
    end
end

function ns:RegisterCurrency(currency)
    if not currency then return end
    ns.currencies = ns.currencies or {}
    table.insert(ns.currencies, currency)
end

function ns:RefreshCurrencies()
    for _, label in ipairs(ns.currencies) do
        local currency = C_CurrencyInfo.GetCurrencyInfo(label.currency)
        local quantity = currency.discovered and currency.quantity or 0
        local max = currency.useTotalEarnedForMaxQty and commaValue(currency.maxQuantity - currency.totalEarned + currency.quantity) or commaValue(currency.maxQuantity)
        label:SetText(TextColor(commaValue(quantity) .. (currency.maxQuantity > 0 and "/" .. max or ""), "ffffff") .. " " .. TextColor(currency.name, label.color and label.color or "ffffff"))
    end
end

function ns:RegisterFaction(faction)
    if not faction then return end
    ns.factions = ns.factions or {}
    table.insert(ns.factions, faction)
end

function ns:RefreshFactions()
    for _, label in ipairs(ns.factions) do
        local factionName, _, standingID, reputationMin, reputationMax, reputation, _, _, _, _, hasRep, _, _, _, _, _ = GetFactionInfoByID(label.faction)
        local quantity = commaValue(reputation - reputationMin)
        label:SetText(TextColor(string.format(L.ReputationWith, reputation < reputationMax and quantity .. "/" .. commaValue(reputationMin) or quantity, TextColor(factionName, label.color and label.color or "ffffff")), "ffffff"))
    end
end

---
-- PVP
---

function ns:CreatePVP(Content)
    local heading = Content:CreateFontString(name .. "PVP", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", Content, "TOPLEFT", 0, -small)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(236396) .. "  " .. TextColor("PVP", "f5c87a"))

    local honor = Content:CreateFontString(name .. "Honor", "ARTWORK", "GameFontNormal")
    honor:SetPoint("LEFT", heading, "RIGHT", large, 0)
    honor:SetJustifyH("LEFT")
    honor.currency = 1792
    honor.color = "f5c87a"
    ns:RegisterCurrency(honor)

    local conquest = Content:CreateFontString(name .. "Conquest", "ARTWORK", "GameFontNormal")
    conquest:SetPoint("LEFT", honor, "RIGHT", medium, 0)
    conquest:SetJustifyH("LEFT")
    conquest.currency = 1602
    conquest.color = "f5c87a"
    ns:RegisterCurrency(conquest)

    ns:RefreshCurrencies()

    local warmode = CreateFrame("Button", name .. "Warmode", Content)
    warmode:SetWidth(width/2)
    warmode:SetHeight(large)
    warmode:SetPoint("TOPLEFT", honor, "BOTTOMLEFT", 0, -medium)

    local label = warmode:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(warmode:GetWidth())
    label:SetJustifyH("LEFT")

    ns:RegisterWarmode(label)
    ns:RefreshWarmode()
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

function ns:RegisterWarmode(warmode)
    if not warmode then return end
    ns.warmode = warmode
end

function ns:RefreshWarmode()
    local warmode = C_PvP.IsWarModeDesired() and "|cff66ff66Enabled|r" or "|cffff6666Disabled|r"
    ns.warmode:SetText(TextColor("Warmode is " .. warmode .. ".", "ffffff"))
end

---
-- Zone
---

function ns:CreateZone(Content, offset, zone)
    offset = offset and offset or 0
    local mapName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil

    local heading = Content:CreateFontString(name .. "Zone" .. zone.id, "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-offset)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(zoneIcon) .. "  " .. TextColor(mapName, zoneColor))
    prevControl = heading

    if zone.covenant then
        local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
        local zoneCovenant = TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor)
        local zonePhrase = TextColor(string.format(covenants[zone.covenant].phrase, zoneCovenant))
        local label = Content:CreateFontString(name .. "Zone" .. zone.id .. "Covenant", "ARTWORK", "GameFontNormal")
        label:SetPoint("LEFT", heading, "RIGHT", large, 0)
        label:SetJustifyH("LEFT")
        label:SetText(zonePhrase)
    end

    local faction
    if zone.faction then
        faction = Content:CreateFontString(name .. "Zone" .. zone.id .. "Faction", "ARTWORK", "GameFontNormal")
        faction:SetPoint("LEFT", heading, "RIGHT", large, 0)
        faction:SetJustifyH("LEFT")
        faction.faction = zone.faction
        faction.color = zoneColor
        ns:RegisterFaction(faction)
        ns:RefreshFactions()
    end

    local currency
    if zone.currency then
        currency = Content:CreateFontString(name .. "Zone" .. zone.id .. "Currency", "ARTWORK", "GameFontNormal")
        currency:SetPoint("LEFT", (zone.faction and faction or heading), "RIGHT", large, 0)
        currency:SetJustifyH("LEFT")
        currency.currency = zone.currency
        currency.color = zoneColor
        ns:RegisterCurrency(currency)
        ns:RefreshCurrencies()
    end

    -- For each Rare in the Zone
    local j = 0
    for _, rare in ipairs(zone.rares) do
        if rare.hidden ~= true then
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
                    elseif RAVFOR_data.options.showCannotUse == false and item.covenantOnly and (covenant ~= zone.covenant) then
                    elseif RAVFOR_data.options.showOwned == false and IsItemOwned(item) then
                    else
                        -- Insert Item into Items
                        table.insert(items, item)
                    end
                end
            end
            if RAVFOR_data.options.showNoDrops == false and #items == 0 and ((RAVFOR_data.options.showReputation and not rare.reptuation) or not RAVFOR_data.options.showReputation) then
            else
                -- Rare
                j = j + 1
                ns:CreateRare(Content, j, zone, rare, items, covenant)
            end
        end
    end

    return heading
end

---
-- Rare
---

function ns:CreateRare(Content, i, zone, rare, items, covenant)
    local button = CreateFrame("Button", name .. "Rare" .. rare.id, Content)
    button:SetWidth(ns.Window:GetWidth() - 42)
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
    local covenantRequired = rare.covenantRequired and TextColor(L.SummonedBy) .. zoneCovenant .. (#items > 0 and TextColor(",") or "") or ""
    local drops = #items > 0 and  " " .. TextColor(L.Drops) or ""

    local label = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(button:GetWidth())
    label:SetJustifyH("LEFT")
    label:SetText(dead .. " " .. TextColor(i .. ". ") .. rare.name .. covenantRequired .. drops)

    label.rare = rare
    ns:RegisterRare(label)

    if RAVFOR_data.options.showReputation == true and rare.reputation then
        ns:CreateLabel({
            name = name .. "Rare" .. rare.id .. "Reputation",
            parent = Content,
            label = "    " .. TextColor("+ " .. rare.reputation .. " " .. L.Reputation, "8080ff"),
            offsetY = -small,
        })
    end

    if #items > 0 then
        for _, item in ipairs(items) do
            ns:CreateItem(Content, zone, rare, item, covenant)
        end
    end

    return button
end

function ns:RegisterRare(rare)
    if not rare then return end
    ns.rares = ns.rares or {}
    table.insert(ns.rares, rare)
end

function ns:RefreshRares()
    for _, label in ipairs(ns.rares) do
        local withoutDead = string.gsub(string.gsub(label:GetText(), skull, ""), checkmark, "")
        label:SetText((IsRareDead(label.rare) and checkmark or skull) .. withoutDead)
    end
end

function ns:CreateItem(Content, zone, rare, item, covenant)
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
    local itemMeta = (itemType == "Armor" or itemType == "Weapon") and TextColor(" (" .. itemSubType .. ")") or ""
    -- itemLink = string.gsub(itemLink, "]", itemMeta .. "]")
    local guaranteed = item.guaranteed and TextColor(" 100% drop!") or ""
    local achievement = item.achievement and TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
    local covenantOnly = item.covenantOnly and TextColor(L.OnlyFor) .. zoneCovenant or ""
    local owned = IsItemOwned(item) and " " .. checkmark or ""

    local button = CreateFrame("Button", name .. "Item" .. item.id, Content)
    button:SetWidth(ns.Window:GetWidth() - 42)
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
    ns:RegisterItem(label, Content)

    prevControl = button
    return button
end

function ns:RegisterItem(item)
    if not item then return end
    ns.items = ns.items or {}
    table.insert(ns.items, item)
end

function ns:RefreshItems()
    for _, label in ipairs(ns.items) do
        local withoutOwned = string.gsub(label:GetText(), checkmark, "")
        label:SetText(withoutOwned .. (IsItemOwned(label.item) and checkmark or ""))
    end
end

---
-- Notes
---

function ns:CreateNotes(Content, offset, notes)
    if not #notes then
        return
    end

    offset = offset and offset or 0
    local heading = Content:CreateFontString(name .. "Notes", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-offset)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(1506451) .. "  " .. TextColor("Notes", "ffffff"))
    prevControl = heading

    for i, note in ipairs(notes) do
        ns:CreateLabel({
            name = name .. "Note" .. i,
            parent = Content,
            label = TextColor(note, "ffffff"),
            width = ns.Window:GetWidth() - 42,
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

function ns:CreateGreatVault(Content, offset)
    if not C_WeeklyRewards.CanClaimRewards() then
        return
    end

    offset = offset and offset or 0
    local heading = Content:CreateFontString(name .. "GreatVault", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-offset)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(3847780) .. "  " .. TextColor("Great Vault", "8899c6"))

    local Notice = Content:CreateFontString(name .. "GreatVaultNotice", "ARTWORK", "GameFontNormal")
    Notice:SetPoint("LEFT", heading, "RIGHT", large, 0)
    Notice:SetJustifyH("LEFT")
    Notice:SetText(TextColor("Go to Oribos to claim your rewards!", "ff6666"))

    prevControl = heading
    return heading
end

---
-- Covenant and Renown (Shadowlands)
---

function ns:CreateCovenant(Content, offset)
    offset = offset and offset or 0
    local heading = Content:CreateFontString(name .. "Covenant", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-offset)
    heading:SetJustifyH("LEFT")

    local label = Content:CreateFontString(name .. "Renown", "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", heading, "RIGHT", large, 0)
    label:SetJustifyH("LEFT")

    ns:RegisterCovenant(heading, label)
    ns:RefreshCovenant()

    local anima = Content:CreateFontString(name .. "Anima", "ARTWORK", "GameFontNormal")
    anima:SetPoint("LEFT", label, "RIGHT", medium, 0)
    anima:SetJustifyH("LEFT")
    anima.currency = 1813
    anima.color = "95c3e1"
    ns:RegisterCurrency(anima)
    ns:RefreshCurrencies()

    prevControl = heading
    return heading
end

function ns:RegisterCovenant(heading, label)
    if (not heading) or (not label) then return end
    ns.covenant = heading
    ns.renown = label
end

function ns:RefreshCovenant()
    local covenant = C_Covenants.GetActiveCovenantID()
    if not covenant then
        return
    end
    local renown = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = GetMaxRenown()

    ns.covenant:SetText(TextIcon(3726261) .. "  " .. TextColor(C_Covenants.GetCovenantData(covenant).name, ns.data.covenants[covenant].color))
    ns.renown:SetText((renown < maxRenown and TextColor(renown .. "/" .. maxRenown, "ff6666") or TextColor(renown, "ffffff")) .. TextColor(" Renown", ns.data.covenants[covenant].color))
end

---
-- Torghast (Shadowlands)
---

function ns:CreateTorghast(Content, offset)
    offset = offset and offset or 0
    local heading = Content:CreateFontString(name .. "Torghast", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic-offset)
    heading:SetJustifyH("LEFT")
    heading:SetText(TextIcon(3642306) .. "  " .. TextColor("Torghast", "b0ccd8"))

    local soulAsh = Content:CreateFontString(name .. "SoulAsh", "ARTWORK", "GameFontNormal")
    soulAsh:SetPoint("LEFT", heading, "RIGHT", large, 0)
    soulAsh:SetJustifyH("LEFT")

    soulAsh.currency = 1828
    soulAsh.color = "b0ccd8"
    ns:RegisterCurrency(soulAsh)
    ns:RefreshCurrencies()

    prevControl = heading
    return heading
end
