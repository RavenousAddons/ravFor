local ADDON_NAME, ns = ...
local L = ns.L

local expansions = ns.data.expansions
local covenants = ns.data.covenants

local small = 6
local medium = 12
local large = 16
local gigantic = 24

local quest = ns:TextIcon(132049)
local skull = ns:TextIcon(137025)
local checkmark = ns:TextIcon(628564)

local _, class = UnitClass("player")
local faction, _ = UnitFactionGroup("player")
local factionCity = (faction == "Alliance" and "Stormwind" or "Orgrimmar")

---
-- Local stuff
---

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

local function contains(table, input)
    for index, value in ipairs(table) do
        if value == input then
            return index
        end
    end
    return false
end

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
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then
                return false
            end
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
-- Global Window Functions
---

local function CreateScroller(cfg)
    local Scroller = CreateFrame("ScrollFrame", ADDON_NAME .. "Scroller" .. string.gsub(cfg.label, "%s+", ""), cfg.parent, "UIPanelScrollFrameTemplate")
    Scroller:SetPoint("BOTTOMRIGHT", cfg.parent, "BOTTOMRIGHT", -28, 8)
    Scroller:SetWidth(cfg.width)
    Scroller:SetHeight(cfg.height)
    Scroller.title = cfg.label
    Scroller:Hide()

    local Content = CreateFrame("Frame", ADDON_NAME .. "Scroller" .. string.gsub(cfg.label, "%s+", "") .. "Content", Scroller)
    Content:SetWidth(cfg.width)
    Content:SetHeight(1)
    Content.offset = -large

    Scroller:SetScrollChild(Content)
    Scroller:SetScript("OnShow", function()
        Scroller:SetScrollChild(Content)
    end)

    Scroller.Content = Content
    return Scroller
end

local function CreateTab(cfg)
    local Tab = CreateFrame("Button", ADDON_NAME .. "Tab" .. string.gsub(cfg.label, "%s+", ""), cfg.parent)
    Tab:SetPoint("TOPLEFT", cfg.relativeTo, cfg.relativePoint, cfg.x, cfg.y)
    Tab:SetWidth(64)
    Tab:SetHeight(64)
    Tab:EnableMouse(true)
    Tab.title = cfg.label

    local TabBackground = Tab:CreateTexture(nil, "BACKGROUND")
    TabBackground:SetAllPoints()
    TabBackground:SetTexture(132074)
    TabBackground:SetDesaturated(1)

    local TabIcon = Tab:CreateTexture(nil, "ARTWORK")
    TabIcon:SetWidth(Tab:GetWidth() * 0.6)
    TabIcon:SetHeight(Tab:GetHeight() * 0.6)
    TabIcon:SetPoint("LEFT", Tab, "LEFT", 0, 6)
    TabIcon:SetTexture(cfg.icon)

    Tab:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_RIGHT", -large-small, -large*2)
        GameTooltip:SetText(cfg.label)
        GameTooltip:Show()
        TabBackground:SetDesaturated(nil)
    end)
    Tab:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
        TabBackground:SetDesaturated(1)
    end)

    return Tab
end

---
-- Core Stuff
---

function ns:RegisterCurrency(Currency)
    if not Currency then return end
    ns.Currencies = ns.Currencies or {}
    table.insert(ns.Currencies, Currency)
end

function ns:RefreshCurrencies()
    for _, Currency in ipairs(ns.Currencies) do
        local currency = C_CurrencyInfo.GetCurrencyInfo(Currency.currency)
        local quantity = currency.discovered and currency.quantity or 0
        local max = currency.useTotalEarnedForMaxQty and commaValue(currency.maxQuantity - currency.totalEarned + currency.quantity) or commaValue(currency.maxQuantity)
        Currency:SetText(ns:TextColor(commaValue(currency.quantity) .. (currency.maxQuantity > 0 and "/" .. max or ""), "ffffff") .. " " .. ns:TextColor(currency.name, Currency.color and Currency.color or "ffffff"))
    end
end

function ns:RegisterFaction(Faction)
    if not Faction then return end
    ns.Factions = ns.Factions or {}
    table.insert(ns.Factions, Faction)
end

function ns:RefreshFactions()
    for _, Faction in ipairs(ns.Factions) do
        local factionName, _, standingID, reputationMin, reputationMax, reputation, _, _, _, _, hasRep, _, _, _, hasBonusRepGain, _ = GetFactionInfoByID(Faction.faction)
        local quantity = commaValue(reputation - reputationMin)
        Faction:SetText(ns:TextColor(string.format(L.ReputationWith, standingID == 8 and ns:TextColor(_G.FACTION_STANDING_LABEL8, Faction.color and Faction.color or "ffffff") or reputation < reputationMax and ns:TextColor(quantity .. "/" .. commaValue(reputationMax)) or ns:TextColor(quantity), ns:TextColor(factionName, Faction.color and Faction.color or "ffffff")), "bbbbbb"))
    end
end

---
-- PVP
---

function ns:CreatePVP(Parent, Relative)
    local PVP = Parent:CreateFontString(ADDON_NAME .. "PVP", "ARTWORK", "GameFontNormalLarge")
    PVP:SetPoint("TOPLEFT", Relative, "TOPLEFT", 0, -gigantic-(Relative.offset or 0))
    PVP:SetJustifyH("LEFT")
    PVP:SetText(ns:TextIcon(236396) .. "  " .. ns:TextColor("PVP", "f5c87a"))
    Relative = PVP
    local LittleRelative = PVP

    local Honor = Parent:CreateFontString(ADDON_NAME .. "Honor", "ARTWORK", "GameFontNormal")
    Honor:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Honor:SetJustifyH("LEFT")
    Honor.currency = 1792
    Honor.color = "f5c87a"
    ns:RegisterCurrency(Honor)
    LittleRelative = Honor

    local Warmode = CreateFrame("Button", ADDON_NAME .. "Warmode", Parent)
    local WarmodeLabel = Warmode:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    WarmodeLabel:SetJustifyH("LEFT")
    WarmodeLabel:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Warmode:SetAllPoints(WarmodeLabel)
    ns:RegisterWarmode(WarmodeLabel)
    ns:RefreshWarmodes()
    Warmode:SetScript("OnClick", function()
        if C_PvP.CanToggleWarMode(not C_PvP.IsWarModeDesired()) then
            C_PvP.ToggleWarMode()
        elseif C_PvP.IsWarModeDesired() then
            RaidNotice_AddMessage(RaidBossEmoteFrame, L.alpha, ChatTypeInfo["RAID_WARNING"])
        else
            RaidNotice_AddMessage(RaidBossEmoteFrame, string.format(L.beta, factionCity), ChatTypeInfo["RAID_WARNING"])
        end
    end)

    local Conquest = Parent:CreateFontString(ADDON_NAME .. "Conquest", "ARTWORK", "GameFontNormal")
    Conquest:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    Conquest:SetJustifyH("LEFT")
    Conquest.currency = 1602
    Conquest.color = "f5c87a"
    ns:RegisterCurrency(Conquest)
    LittleRelative = Conquest

    ns:RefreshCurrencies()

    Relative.offset = large
    return Relative
end

function ns:RegisterWarmode(Warmode)
    if not Warmode then return end
    ns.Warmodes = ns.Warmodes or {}
    table.insert(ns.Warmodes, Warmode)
end

function ns:RefreshWarmodes()
    for _, label in ipairs(ns.Warmodes) do
        local warmode = C_PvP.IsWarModeDesired() and "|cff66ff66Enabled|r" or "|cffff6666Disabled|r"
        label:SetText(ns:TextColor("Warmode is " .. warmode .. ".", "ffffff"))
    end
end

---
-- Zone
---

function ns:CreateZone(Parent, Relative, zone, worldQuests)
    local mapName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil

    local Zone = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id, "ARTWORK", "GameFontNormalLarge")
    Zone:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Zone:SetJustifyH("LEFT")
    Zone:SetText(ns:TextIcon(zoneIcon) .. "  " .. ns:TextColor(mapName:upper(), zoneColor))
    Relative = Zone
    Relative.offset = 0
    local LittleRelative = Zone

    if zone.covenant then
        local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
        local zoneCovenant = ns:TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor)
        local zonePhrase = ns:TextColor(string.format(covenants[zone.covenant].phrase, zoneCovenant))
        local Covenant = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Covenant", "ARTWORK", "GameFontNormal")
        Covenant:SetPoint("LEFT", LittleRelative, "RIGHT", large, 0)
        Covenant:SetJustifyH("LEFT")
        Covenant:SetText(zonePhrase)
        LittleRelative = Covenant
    end

    if zone.faction then
        local zoneFactions = type(zone.faction) == "table" and zone.faction or {zone.faction}
        for _, faction in ipairs(zoneFactions) do
            local Faction = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Faction", "ARTWORK", "GameFontNormal")
            if zone.covenant then
                Faction:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
                Relative.offset = Relative.offset + large
            else
                Faction:SetPoint("LEFT", LittleRelative, "RIGHT", large, 0)
            end
            Faction:SetJustifyH("LEFT")
            Faction.faction = faction
            Faction.color = zoneColor
            ns:RegisterFaction(Faction)
            ns:RefreshFactions()
            LittleRelative = Faction
        end
    end

    if zone.currency then
        local Currency = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Currency", "ARTWORK", "GameFontNormal")
        Currency:SetPoint("LEFT", LittleRelative, "RIGHT", large, 0)
        Currency:SetJustifyH("LEFT")
        Currency.currency = zone.currency
        Currency.color = zoneColor
        ns:RegisterCurrency(Currency)
        ns:RefreshCurrencies()
        LittleRelative = Currency
    end

    -- For each Rare in the Zone
    local i = 0
    for _, rare in ipairs(zone.rares) do
        local isWorldQuest, isAvailable = false, false
        if type(rare.quest) == "number" and (C_QuestLog.IsWorldQuest(rare.quest) or rare.worldquest or rare.weekly or rare.biweekly) then
            isWorldQuest = true
            if contains(worldQuests, rare.quest) then
                isAvailable = true
            elseif C_QuestLog.AddWorldQuestWatch(rare.quest) then
                isAvailable = true
                C_QuestLog.RemoveWorldQuestWatch(rare.quest)
            end
        elseif type(rare.quest) == "number" then
            isAvailable = C_QuestLog.IsQuestFlaggedCompleted(rare.quest) and false or true
        end
        if rare.hidden then
        elseif isWorldQuest and not isAvailable then
        else
            local items = {}
            if rare.items and #rare.items > 0 then
                -- For each Item dropped by the Rare in the Zone
                for _, item in ipairs(rare.items) do
                    if GetItemInfo(item.id) == nil then
                    elseif RAVFOR_data.options.showCannotUse == false and ((item.covenantOnly and covenant ~= zone.covenant) or (item.class and item.class:upper() ~= class)) then
                    elseif RAVFOR_data.options.showOwned == false and IsItemOwned(item) then
                    else
                        -- Insert Item into Items
                        table.insert(items, item)
                    end
                end
            end
            if #items == 0 and RAVFOR_data.options.showNoDrops == false and ((RAVFOR_data.options.showReputation and not rare.reptuation) or not RAVFOR_data.options.showReputation) then
            else
                -- Rare
                i = i + 1
                local Rare = ns:CreateRare(Parent, Relative, i, zone, rare, items, covenant)
                Relative = Rare
            end
        end
    end

    return Relative
end

---
-- Rare
---

function ns:CreateRare(Parent, Relative, i, zone, rare, items, covenant)
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and ns:TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local dead = IsRareDead(rare) and checkmark or ((type(rare.quest) == "number" and C_QuestLog.IsWorldQuest(rare.quest)) or rare.biweekly or rare.weekly) and quest or skull
    local covenantRequired = rare.covenantRequired and ns:TextColor(L.SummonedBy) .. zoneCovenant .. (#items > 0 and ns:TextColor(",") or "") or ""
    local drops = #items > 0 and  " " .. ns:TextColor(L.Drops, "bbbbbb") or ""

    local Rare = CreateFrame("Button", ADDON_NAME .. "Rare" .. rare.id, Parent)
    local RareLabel = Rare:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    RareLabel:SetJustifyH("LEFT")
    RareLabel:SetText(dead .. " " .. ns:TextColor(i .. ". ") .. rare.name .. covenantRequired .. drops)
    RareLabel:SetHeight(16)
    RareLabel:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Rare:SetAllPoints(RareLabel)
    Rare:SetScript("OnClick", function()
        -- Mark the Rare
        ns:NewTarget(zone, rare)
        -- Send the Rare to Group Members
        ns:SendTarget(zone, rare)
    end)
    RareLabel.rare = rare
    ns:RegisterRare(RareLabel)
    Relative = Rare

    if RAVFOR_data.options.showReputation == true and rare.reputation then
        local Reputation = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Reputation", "ARTWORK", "GameFontNormal")
        Reputation:SetJustifyH("LEFT")
        Reputation:SetText("    " .. ns:TextColor("+ " .. rare.reputation .. " " .. L.Reputation, "8080ff"))
        Reputation:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -small)
        Relative = Reputation
    end

    if #items > 0 then
        for _, item in ipairs(items) do
            local Item = ns:CreateItem(Parent, Relative, zone, rare, item, covenant)
            Relative = Item
        end
    end

    return Relative
end

function ns:RegisterRare(Rare)
    if not Rare then return end
    ns.Rares = ns.Rares or {}
    table.insert(ns.Rares, Rare)
end

function ns:RefreshRares()
    for _, Rare in ipairs(ns.Rares) do
        local withoutDead = string.gsub(string.gsub(string.gsub(Rare:GetText(), quest, ""), skull, ""), checkmark, "")
        Rare:SetText((IsRareDead(Rare.rare) and checkmark or ((type(Rare.rare.quest) == "number" and C_QuestLog.IsWorldQuest(Rare.rare.quest)) or Rare.rare.biweekly or Rare.rare.weekly) and quest or skull) .. withoutDead)
    end
end

function ns:CreateItem(Parent, Relative, zone, rare, item, covenant)
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and ns:TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
    local itemClass = item.class and "|c" .. select(4, GetClassColor(string.gsub(item.class, "%s+", ""):upper())) .. item.class .. "s|r" or nil
    local guaranteed = item.guaranteed and ns:TextColor(" 100% drop!") or ""
    local achievement = item.achievement and ns:TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
    local covenantOnly = item.covenantOnly and ns:TextColor(L.OnlyFor, "bbbbbb") .. zoneCovenant or ""
    local classOnly = item.class and ns:TextColor(L.OnlyFor, "bbbbbb") .. itemClass or ""
    local owned = IsItemOwned(item) and " " .. checkmark or ""

    local Item = CreateFrame("Button", ADDON_NAME .. "Item" .. item.id, Parent)
    local ItemLabel = Item:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ItemLabel:SetJustifyH("LEFT")
    ItemLabel:SetText("    " .. ns:TextIcon(itemTexture) .. "  " .. itemLink .. guaranteed .. achievement .. covenantOnly .. classOnly .. owned)
    ItemLabel:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -small)
    ItemLabel:SetWidth(Parent:GetWidth())
    Item:SetAllPoints(ItemLabel)
    Item:SetScript("OnClick", function()
        -- TODO Should open Item Tooltip/Mount Journal/Pet Journal/etc.
    end)
    Relative = Item

    ItemLabel.item = item
    ns:RegisterItem(ItemLabel)

    return Relative
end

function ns:RegisterItem(Item)
    if not Item then return end
    ns.Items = ns.Items or {}
    table.insert(ns.Items, Item)
end

function ns:RefreshItems()
    for _, Item in ipairs(ns.Items) do
        local withoutOwned = string.gsub(Item:GetText(), checkmark, "")
        Item:SetText(withoutOwned .. (IsItemOwned(Item.item) and checkmark or ""))
    end
end

---
-- Notes
---

function ns:CreateNotes(Parent, Relative, notes)
    local Notes = Parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    Notes:SetJustifyH("LEFT")
    Notes:SetText(ns:TextIcon(1506451) .. "  " .. ns:TextColor("Notes", "eeeeee"))
    Notes:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = Notes

    for i, note in ipairs(notes) do
        local Note = Parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        Note:SetJustifyH("LEFT")
        Note:SetText(ns:TextColor(note, "eeeeee"))
        Note:SetWidth(Parent:GetWidth())
        Note:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -medium)
        Relative = Note
    end

    return Relative
end

---
-- Targets
---

function ns:NewTarget(zone, rare)
    local zoneName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local c = {}
    local waypoint = type(rare.waypoint) == "table" and rare.waypoint[1] or rare.waypoint
    for d in tostring(rare.waypoint):gmatch("[0-9][0-9]") do
        tinsert(c, d)
    end
    -- Print message to chat
    ns:PrettyPrint("\n" .. rare.name .. "  |cffffd100|Hworldmap:" .. zone.id .. ":" .. c[1] .. c[2] .. ":" .. c[3] .. c[4] .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cff" .. zoneColor .. zoneName .. "|r |cffeeeeee" .. c[1] .. "." .. c[2] .. ", " .. c[3] .. "." .. c[4] .. "|r]|h|r")
    -- Add the waypoint to the map and track it
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(zone.id, "0." .. c[1] .. c[2], "0." .. c[3] .. c[4]))
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
            print("Sending target to Instance members…")
            C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "INSTANCE_CHAT")
        elseif IsInGroup() then
            if GetNumGroupMembers() > 5 then
                print("Sending target to Raid members…")
                C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "RAID")
            else
                print("Sending target to Party members…")
                C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "PARTY")
            end
        end
    -- else -- Enable for testing
    --     print("Sending target to… self!")
    --     C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "WHISPER", UnitName("player"))
    end
end

---
-- Great Vault (Shadowlands)
---

function ns:CreateGreatVault(Parent, Relative)
    if not C_WeeklyRewards.CanClaimRewards() then
        return Relative
    end

    local GreatVault = Parent:CreateFontString(ADDON_NAME .. "GreatVault", "ARTWORK", "GameFontNormalLarge")
    GreatVault:SetJustifyH("LEFT")
    GreatVault:SetText(ns:TextIcon(3847780) .. "  " .. ns:TextColor("The Great Vault", "8899c6"))
    GreatVault:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = GreatVault

    local GreatVaultNotice = Parent:CreateFontString(ADDON_NAME .. "GreatVaultNotice", "ARTWORK", "GameFontNormal")
    GreatVaultNotice:SetJustifyH("LEFT")
    GreatVaultNotice:SetText(ns:TextColor("Go to Oribos to claim your rewards!", "ff6666"))
    GreatVaultNotice:SetPoint("LEFT", Relative, "RIGHT", large, 0)

    return Relative
end

---
-- Covenant: Renown, Reservoir Anima, Redeemed Souls (Shadowlands)
---

function ns:CreateCovenant(Parent, Relative)
    if C_Covenants.GetActiveCovenantID() == 0 then
        return Relative
    end

    local Covenant = Parent:CreateFontString(ADDON_NAME .. "Covenant", "ARTWORK", "GameFontNormalLarge")
    Covenant:SetJustifyH("LEFT")
    Covenant:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = Covenant
    local LittleRelative = Covenant

    local Renown = Parent:CreateFontString(ADDON_NAME .. "Renown", "ARTWORK", "GameFontNormal")
    Renown:SetJustifyH("LEFT")
    Renown:SetPoint("TOP", Relative, "BOTTOM", 0, -medium-small)

    ns:RegisterCovenant(Covenant, Renown)
    ns:RefreshCovenant()

    local Anima = Parent:CreateFontString(ADDON_NAME .. "Anima", "ARTWORK", "GameFontNormal")
    Anima:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Anima:SetJustifyH("LEFT")
    Anima.currency = 1813
    Anima.color = "95c3e1"
    ns:RegisterCurrency(Anima)
    LittleRelative = Anima

    local RedeemedSouls = Parent:CreateFontString(ADDON_NAME .. "RedeemedSouls", "ARTWORK", "GameFontNormal")
    RedeemedSouls:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    RedeemedSouls:SetJustifyH("LEFT")
    RedeemedSouls.currency = 1810
    RedeemedSouls.color = "f5dcd0"
    ns:RegisterCurrency(RedeemedSouls)
    LittleRelative = RedeemedSouls

    local GratefulOfferings = Parent:CreateFontString(ADDON_NAME .. "GratefulOfferings", "ARTWORK", "GameFontNormal")
    GratefulOfferings:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    GratefulOfferings:SetJustifyH("LEFT")
    GratefulOfferings.currency = 1885
    GratefulOfferings.color = "96dc93"
    ns:RegisterCurrency(GratefulOfferings)

    ns:RefreshCurrencies()

    Relative.offset = large + large + medium
    return Relative
end

function ns:RegisterCovenant(Covenant, Renown)
    if (not Covenant) or (not Renown) then return end
    ns.Covenant = Covenant
    ns.Renown = Renown
end

function ns:RefreshCovenant()
    local covenant = C_Covenants.GetActiveCovenantID()
    local renown = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = GetMaxRenown()

    ns.Covenant:SetText(ns:TextIcon(3726261) .. "  " .. ns:TextColor(C_Covenants.GetCovenantData(covenant).name, ns.data.covenants[covenant].color))
    ns.Renown:SetText((renown < maxRenown and ns:TextColor(renown .. "/" .. maxRenown, "ff6666") or ns:TextColor(renown, "ffffff")) .. ns:TextColor(" Renown", ns.data.covenants[covenant].color))
end

---
-- Torghast: Soul Ash (Shadowlands)
---

function ns:CreateTorghast(Parent, Relative)
    if UnitLevel("player") < 50 then
        return Relative
    end

    local Torghast = Parent:CreateFontString(ADDON_NAME .. "Torghast", "ARTWORK", "GameFontNormalLarge")
    Torghast:SetJustifyH("LEFT")
    Torghast:SetText(ns:TextIcon(3642306) .. "  " .. ns:TextColor(("Torghast"):upper(), "b0ccd8"))
    Torghast:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = Torghast

    local SoulAsh = Parent:CreateFontString(ADDON_NAME .. "SoulAsh", "ARTWORK", "GameFontNormal")
    SoulAsh:SetJustifyH("LEFT")
    SoulAsh:SetPoint("LEFT", Relative, "RIGHT", large, 0)

    SoulAsh.currency = 1828
    SoulAsh.color = "b0ccd8"
    ns:RegisterCurrency(SoulAsh)
    ns:RefreshCurrencies()

    return Relative
end

---
-- Window
---

function ns:BuildWindow()
    local Scrollers = {}
    local Tabs = {}

    local Window = CreateFrame("Frame", ADDON_NAME .. "Window", UIParent, "UIPanelDialogTemplate")
    Window:SetFrameStrata("MEDIUM")
    Window:SetWidth(RAVFOR_data.options.windowWidth)
    Window:SetHeight(RAVFOR_data.options.windowHeight)
    Window:SetScale(RAVFOR_data.options.scale)
    Window:SetPoint(RAVFOR_data.options.windowPosition, RAVFOR_data.options.windowX, RAVFOR_data.options.windowY)
    Window:EnableMouse(true)
    Window:SetMovable(true)
    Window:SetClampedToScreen(true)
    Window:RegisterForDrag("LeftButton")
    Window:Hide()
    Window:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end)
    Window:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
    end)
    tinsert(UISpecialFrames, Window:GetName())
    ns.Window = Window

    local Heading = Window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Heading:SetPoint("TOP", Window, "TOP")
    Heading:SetPoint("BOTTOM", Window, "TOP", 0, -30)
    Heading:SetText(ns:TextColor(ns.name .. " ") .. ns:TextColor(ns.expansion, ns.color) .. ns:TextColor(" v" .. ns.version))
    local HeadingFrame = CreateFrame("Frame", ADDON_NAME .. "Heading", Window)
    HeadingFrame:SetAllPoints(Heading)
    HeadingFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_TOP", 0, small)
        -- GameTooltip:SetText("Left-click to move.\nRight-click to resize.") -- TODO get resizing working
        GameTooltip:SetText("Left-click to move.")
        GameTooltip:Show()
    end)
    HeadingFrame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local OptionsButton = CreateFrame("Button", ADDON_NAME .. "OptionsButton", Window, "UIPanelButtonTemplate")
    OptionsButton:SetPoint("TOPLEFT", Window, "TOPLEFT", 9, -small)
    OptionsButton:SetWidth(18)
    OptionsButton:SetHeight(18)
    OptionsButton:RegisterForClicks("LeftButton")
    OptionsButton:SetScript("OnMouseDown", function(self, button)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
    end)
    local OptionsButtonIcon = OptionsButton:CreateTexture()
    OptionsButtonIcon:SetAllPoints(OptionsButton)
    OptionsButtonIcon:SetTexture(134063)

    local Scroller = CreateScroller({
        label = "General",
        parent = Window,
        width = Window:GetWidth() - 42,
        height = Window:GetHeight() - Heading:GetHeight() - 6,
        current = true,
    })
    Scroller:Show()
    Scrollers["General"] = Scroller
    for title, expansion in pairs(expansions) do
        local Scroller = CreateScroller({
            label = title,
            parent = Window,
            width = Window:GetWidth() - 42,
            height = Window:GetHeight() - Heading:GetHeight() - 6,
        })
        Scrollers[title] = Scroller
    end

    local Tab = CreateTab({
        label = "General",
        icon = 1542860,
        parent = Window,
        relativeTo = Window,
        relativePoint = "TOPRIGHT",
        x = -3,
        y = -Heading:GetHeight(),
        current = true,
    })
    Tabs["General"] = Tab
    local previousTab = Tab
    for title, expansion in pairs(expansions) do
        local Tab = CreateTab({
            label = title,
            icon = expansion.icon,
            parent = Window,
            relativeTo = previousTab,
            relativePoint = "BOTTOMLEFT",
            x = 0,
            y = 0,
        })
        Tabs[title] = Tab
        previousTab = Tab
    end

    -- Window Interactions
    local function WindowInteractionStart(self, button)
        if button == "LeftButton" then
            Window:StartMoving()
            Window.isMoving = true
            Window.hasMoved = false
        end
    end
    local function WindowInteractionEnd(self)
        if Window.isMoving then
            Window:StopMovingOrSizing()
            Window.isMoving = false
            Window.hasMoved = true
            local point, _, _, x, y = Window:GetPoint()
            RAVFOR_data.options.windowPosition = point
            RAVFOR_data.options.windowX = x
            RAVFOR_data.options.windowY = y
        end
    end
    Window:SetScript("OnMouseDown", WindowInteractionStart)
    Window:SetScript("OnMouseUp", WindowInteractionEnd)

    -- Get "Watched" World Quests
    -- What is useful is that the weekly WQ Rare is auto-tracked on login, so we
    -- can use this + quest completion to determine the weekly WQ Rare
    local worldQuests = {}
    if C_QuestLog.GetNumWorldQuestWatches() then
        for i = 1, C_QuestLog.GetNumWorldQuestWatches() do
            tinsert(worldQuests, C_QuestLog.GetQuestIDForWorldQuestWatchIndex(i))
        end
    end

    -- Set up where to put content of each Scroller
    local Parent = Scrollers["General"].Content
    local Relative = Parent

    -- PVP
    local PVP = ns:CreatePVP(Parent, Relative)
    Relative = PVP
    -- Notes
    local Notes = ns:CreateNotes(Parent, Relative, ns.data.notes)

    for title, expansion in pairs(expansions) do
        Parent = Scrollers[title].Content
        Relative = Parent
        if title == "Shadowlands" then
            -- Covenant
            local Covenant = ns:CreateCovenant(Parent, Relative)
            Relative = Covenant
            -- Torghast
            local Torghast = ns:CreateTorghast(Parent, Relative)
            Relative = Torghast
            -- Great Vault
            local GreatVault = ns:CreateGreatVault(Parent, Relative)
            Relative = GreatVault
        end
        for i, zone in ipairs(expansion.zones) do
            if i > 1 then
                Relative.offset = medium
            end
            -- Zone
            local Zone = ns:CreateZone(Parent, Relative, zone, worldQuests)
            Relative = Zone
        end
        -- Notes
        if expansion.notes and #expansion.notes > 0 then
            local Notes = ns:CreateNotes(Parent, Relative, expansion.notes)
            Relative = Notes
        end
    end

    for title, Tab in pairs(Tabs) do
        Tab:SetScript("OnClick", function(self)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            for lookup, Scroller in pairs(Scrollers) do
                if title == lookup then
                    Scroller:Show()
                else
                    Scroller:Hide()
                end
            end
        end)
    end
end
