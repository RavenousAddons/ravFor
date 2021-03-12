local ADDON_NAME, ns = ...
local L = ns.L

local notes = ns.data.notes
local expansions = ns.data.expansions
local currencies = ns.data.currencies
local reputationColors = ns.data.reputationColors
local covenants = ns.data.covenants
local renownLevels = ns.data.renownLevels
local animaValuesBySpellID = ns.data.animaValuesBySpellID

local small = 6
local medium = 12
local large = 16
local gigantic = 24

local _, class = UnitClass("player")
local faction, _ = UnitFactionGroup("player")
local factionCity = (faction == "Alliance" and "Stormwind" or "Orgrimmar")

local CQL = C_QuestLog

---
-- Local Functions
---

local function commaValue(amount)
    local formatted, i = amount
    while true do
        formatted, i = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if i == 0 then
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

local function HideTooltip()
    GameTooltip:Hide()
end

local function TextColor(text, color)
    color = color and color or "eeeeee"
    return "|cff" .. color .. text .. "|r"
end

local function TextIcon(icon, size)
    size = size and size or 16
    return "|T" .. icon .. ":" .. size .. "|t"
end

local icons = {
    Quest = TextIcon(132049),
    Checkmark = TextIcon(628564),
    SkullBlue = TextIcon(311235),
    SkullBlueGlow = TextIcon(311228),
    SkullGreen = TextIcon(311236),
    SkullGreenGlow = TextIcon(311229),
    SkullGrey = TextIcon(308480),
    SkullGreyGlow = TextIcon(311230),
    SkullPurple = TextIcon(311237),
    SkullPurpleGlow = TextIcon(311231),
    SkullRed = TextIcon(311238),
    SkullRedGlow = TextIcon(311232),
}

local function IsRareDead(rare)
    if type(rare.quest) == "table" then
        for _, quest in ipairs(rare.quest) do
            if not CQL.IsQuestFlaggedCompleted(quest) then
                return false
            end
        end
        return true
    elseif rare.quest then
        return CQL.IsQuestFlaggedCompleted(rare.quest)
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
        return CQL.IsQuestFlaggedCompleted(item.quest)
    elseif item.achievement then
        return select(4, GetAchievementInfo(item.achievement))
    else
        return C_TransmogCollection.PlayerHasTransmog(item.id)
    end
    return false
end

local function RunsUntil95(chance, bound)
    bound = bound and bound or 300
    for i = 1, bound do
        local percentage = 1 - ((1 - chance / 100) ^ i)
        if percentage > 0.95 then
            return i
        end
    end
    return bound
end

local function GetAnimaItems()
    local items = {}
    for bagID = 0, 4 do
        for slot = 0, GetContainerNumSlots(bagID) do
            if GetContainerItemInfo(bagID, slot) then
                local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(bagID, slot)
                local isAnimaItem = C_Item.IsAnimaItemByID(itemLink)
                if isAnimaItem then
                    table.insert(items, {
                        id = itemID,
                        count = itemCount,
                    })
                end
            end
        end
    end
    return items
end

local function GetAnimaItemsTotal()
    local total = 0
    for _, item in ipairs(GetAnimaItems()) do
        local spellName, spellID = GetItemSpell(item.id)
        total = total + (animaValuesBySpellID[spellID] * item.count)
    end
    return total
end

local function GetMaxRenown()
    -- if 0, then reset is today but has not yet happened
    local daysUntilWeeklyReset = math.floor(C_DateAndTime.GetSecondsUntilWeeklyReset() / 60 / 60 / 24)
    local now = C_DateAndTime.GetCurrentCalendarTime()
    local year, month, day = now.year, now.month, now.monthDay
    local lookup_year, lookup_month, lookup_day
    local maxRenown = 3
    for _, lookup in ipairs(renownLevels) do
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

local function GetCurrencyData(id)
    for _, currency in ipairs(currencies) do
        if id == currency.id then return currency end
    end
end

---
-- Global Functions
---

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
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
-- Data Management
---

local function Register(Key, Value)
    if not Key or not Value then return end
    ns[Key] = ns[Key] or {}
    table.insert(ns[Key], Value)
end

local function RegisterCovenant(Covenant, Renown)
    if (not Covenant) or (not Renown) then return end
    ns.Covenant = Covenant
    ns.Renown = Renown
end

function ns:RefreshCurrencies()
    for _, Currency in ipairs(ns.Currencies) do
        local currency = C_CurrencyInfo.GetCurrencyInfo(Currency.currency.id)
        local quantity = currency.discovered and currency.quantity or 0
        local max = currency.useTotalEarnedForMaxQty and commaValue(currency.maxQuantity - currency.totalEarned + quantity) or commaValue(currency.maxQuantity)
        local add = Currency.add and Currency.add() or 0
        Currency:SetText(TextColor(commaValue(quantity + add) .. (currency.maxQuantity >= currency.quantity and "/" .. max or ""), "ffffff") .. " " .. TextColor(currency.name, Currency.currency.color or "ffffff") .. " " .. TextIcon(currency.iconFileID))
    end
end

function ns:RefreshFactions()
    for _, Faction in ipairs(ns.Factions) do
        local factionName, _, standingID, reputationMin, reputationMax, reputation, _, _, _, _, hasRep, _, _, _, hasBonusRepGain, _ = GetFactionInfoByID(Faction.faction)
        Faction:SetText(TextColor(string.format(L.Faction, TextColor(_G["FACTION_STANDING_LABEL"..standingID], reputationColors[standingID]), TextColor(factionName, Faction.color and Faction.color or "ffffff")), "bbbbbb"))
        Faction.anchor:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
            GameTooltip:SetText(TextColor("Reputation with ") .. TextColor(factionName, Faction.color and Faction.color or "ffffff"))
            GameTooltip:AddLine(TextColor(_G["FACTION_STANDING_LABEL"..standingID], reputationColors[standingID]))
            if standingID < 8 then
                GameTooltip:AddLine(commaValue(reputation - reputationMin) .. "/" .. commaValue(reputationMax - reputationMin))
            end
            GameTooltip:Show()
        end)
        Faction.anchor:SetScript("OnLeave", HideTooltip)
    end
end

function ns:RefreshWarmodes()
    for _, WarmodeLabel in ipairs(ns.Warmodes) do
        WarmodeLabel:SetText(TextColor(L.WarmodeLabel .. (C_PvP.IsWarModeDesired() and "|cff66ff66" .. _G.VIDEO_OPTIONS_ENABLED .. "|r" or "|cffff6666" .. _G.VIDEO_OPTIONS_DISABLED .. "|r") .. ".", "ffffff"))
        WarmodeLabel.anchor:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
            GameTooltip:SetText(TextColor((C_PvP.IsWarModeDesired() and "|cffff6666Disable|r" or "|cff66ff66Enable|r") .. " War Mode"))
            GameTooltip:Show()
        end)
    end
end

function ns:RefreshRares()
    for _, Rare in ipairs(ns.Rares) do
        local without = Rare:GetText()
        for _, icon in ipairs(icons) do
            without = string.gsub(without, icon, "")
        end
        Rare.rare.quest = Rare.rare.quest or (faction == "Alliance" and (Rare.rare.questAlliance or nil) or (Rare.rare.questHorde or nil))
        Rare:SetText((IsRareDead(Rare.rare) and icons.SkullGrey or ((type(Rare.rare.quest) == "number" and CQL.IsWorldQuest(Rare.rare.quest))) and icons.Quest or (Rare.rare.biweekly or Rare.rare.weekly) and icons.SkullBlueGlow or Rare.rare.quest and icons.SkullRedGlow or icons.SkullPurple) .. without)
    end
end

function ns:RefreshItems()
    for _, Item in ipairs(ns.Items) do
        local without = Item:GetText()
        for _, icon in ipairs(icons) do
            without = string.gsub(without, icon, "")
        end
        Item:SetText(without .. (IsItemOwned(Item.item) and icons.Checkmark or ""))
    end
end

function ns:RefreshCovenant()
    local covenant = C_Covenants.GetActiveCovenantID()
    local renown = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = GetMaxRenown()

    ns.Covenant:SetText(TextIcon(3726261) .. "  " .. TextColor(C_Covenants.GetCovenantData(covenant).name, covenants[covenant].color))
    ns.Renown:SetText((renown < maxRenown and TextColor(renown .. "/" .. maxRenown, "ff6666") or TextColor(renown, "ffffff")) .. TextColor(" Renown", covenants[covenant].color))
end

---
-- Item Cache Preloader
---

local function CacheItem(i, itemIDs, callback)
    local Item = Item:CreateFromItemID(itemIDs[i])
    Item:ContinueOnItemLoad(function()
        if i < #itemIDs then
            -- Sadly this *must* be rate-limited
            -- 0 = per frame, as fast as we can go
            C_Timer.After(0, function()
                CacheItem(i + 1, itemIDs, callback)
            end)
        else
            callback()
        end
    end)
end

function ns:CacheAndBuild(callback)
    local covenant = C_Covenants.GetActiveCovenantID()
    local worldQuests = {}
    if CQL.GetNumWorldQuestWatches() then
        for i = 1, CQL.GetNumWorldQuestWatches() do
            tinsert(worldQuests, CQL.GetQuestIDForWorldQuestWatchIndex(i))
        end
    end
    local itemIDs = {}
    for title, expansion in pairs(expansions) do
        for _, zone in ipairs(expansion.zones) do
            for _, rare in ipairs(zone.rares) do
                local isWorldQuest, isAvailable = false, false
                rare.quest = rare.quest or (faction == "Alliance" and (rare.questAlliance or nil) or (rare.questHorde or nil))
                if type(rare.quest) == "number" then
                    if CQL.IsWorldQuest(rare.quest) or rare.worldquest then
                        isWorldQuest = true
                        if contains(worldQuests, rare.quest) or CQL.IsQuestFlaggedCompleted(rare.quest) then
                            isAvailable = true
                        elseif CQL.AddWorldQuestWatch(rare.quest) then
                            isAvailable = true
                            CQL.RemoveWorldQuestWatch(rare.quest)
                        end
                    else
                        isAvailable = CQL.IsQuestFlaggedCompleted(rare.quest) and false or true
                    end
                end
                if rare.hidden or rare.items == nil then
                elseif isWorldQuest and not isAvailable then
                else
                    for _, item in ipairs(rare.items) do
                        if RAVFOR_data.options.showOwned == false and IsItemOwned(item) then
                        elseif RAVFOR_data.options.showCannotUse == false and item.faction and item.faction:upper() ~= faction:upper() then
                        elseif RAVFOR_data.options.showCannotUse == false and item.class and item.class:upper() ~= class:upper() then
                        elseif RAVFOR_data.options.showCannotUse == false and item.covenantOnly and covenant ~= zone.covenant then
                        else
                            table.insert(itemIDs, item.id)
                        end
                    end
                end
            end
        end
    end
    CacheItem(1, itemIDs, callback)
end

---
-- Targets
---

function ns:NewTarget(zone, rare, sender)
    local zoneName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local c = {}
    local waypoint = type(rare.waypoint) == "table" and rare.waypoint[1] or rare.waypoint
    for d in tostring(waypoint):gmatch("[0-9][0-9]") do
        tinsert(c, d)
    end
    -- Print message to chat if sent by self
    if sender == string.format("%1$s-%2$s", UnitName("player"), GetNormalizedRealmName()) then
        ns:PrettyPrint(rare.name .. "\n|cffffd100|Hworldmap:" .. zone.id .. ":" .. c[1] .. c[2] .. ":" .. c[3] .. c[4] .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cff" .. zoneColor .. zoneName .. "|r |cffeeeeee" .. c[1] .. "." .. c[2] .. ", " .. c[3] .. "." .. c[4] .. "|r]|h|r")
    end
    -- Add the waypoint to the map and track it
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(zone.id, "0." .. c[1] .. c[2], "0." .. c[3] .. c[4]))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

function ns:SendTarget(zone, rare)
    if ns.sendOnCooldown == true then return end
    ns.sendOnCooldown = true
    C_Timer.After(10, function()
        ns.sendOnCooldown = false
    end)

    local target = string.format("target={%1$s,%2$s}", zone.id, rare.id)
    local inInstance, _ = IsInInstance()
    if inInstance then
        ns:PrettyPrint("Sending " .. rare.name .. " to instance group...")
        C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "INSTANCE_CHAT")
    elseif IsInGroup() then
        if GetNumGroupMembers() > 5 then
            ns:PrettyPrint("Sending " .. rare.name .. " to raid...")
            C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "RAID")
        else
            ns:PrettyPrint("Sending " .. rare.name .. " to party...")
            C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "PARTY")
        end
    -- else -- Uncomment for testing
    --     ns:PrettyPrint("Sending " .. rare.name .. " to self...")
    --     C_ChatInfo.SendAddonMessage(ADDON_NAME, target, "WHISPER", UnitName("player"))
    end
end

---
-- UI
---

local function CreateSpacer(Parent, Relative, size)
    size = size and size or 24

    local Spacer = CreateFrame("Frame", nil, Parent)
    Spacer:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT")
    Spacer:SetWidth(Parent:GetWidth())
    Spacer:SetHeight(size)

    return Spacer
end

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
    Scroller.Content = Content

    Scroller:SetScrollChild(Content)
    Scroller:SetScript("OnShow", function()
        Scroller:SetScrollChild(Content)
    end)

    return Scroller
end

local function CreateTab(cfg)
    local Tab = CreateFrame("Button", ADDON_NAME .. "Tab" .. string.gsub(cfg.label, "%s+", ""), cfg.parent)
    Tab:SetPoint("TOPLEFT", cfg.relativeTo, cfg.relativePoint, cfg.x, cfg.y)
    Tab:SetWidth(48)
    Tab:SetHeight(48)
    Tab:EnableMouse(true)
    Tab.title = cfg.label

    local TabBackground = Tab:CreateTexture(nil, "BACKGROUND")
    TabBackground:SetAllPoints()
    TabBackground:SetTexture(132074)
    TabBackground:SetDesaturated(1)

    local TabIcon = Tab:CreateTexture(nil, "ARTWORK")
    TabIcon:SetWidth(Tab:GetWidth() * 0.6)
    TabIcon:SetHeight(Tab:GetHeight() * 0.6)
    TabIcon:SetPoint("LEFT", Tab, "LEFT", 0, 5)
    TabIcon:SetTexture(cfg.icon)

    Tab:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetText(TextColor(cfg.label))
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
-- Notes
---

function ns:CreateNotes(Parent, Relative, notes, indent)
    indent = indent and indent or ""
    for i, note in ipairs(notes) do
        local Note = Parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        Note:SetJustifyH("LEFT")
        Note:SetText(indent .. TextColor(note, "eeeeee"))
        Note:SetWidth(Parent:GetWidth())
        Note:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -medium-(Relative.offset or 0))
        Relative = Note
    end

    return Relative
end

---
-- PVP
---

function ns:CreatePVP(Parent, Relative)
    local PVP = Parent:CreateFontString(ADDON_NAME .. "PVP", "ARTWORK", "GameFontNormalLarge")
    PVP:SetPoint("TOPLEFT", Relative, "TOPLEFT", 0, -gigantic-(Relative.offset or 0))
    PVP:SetJustifyH("LEFT")
    PVP:SetText(TextIcon(236396) .. "  " .. TextColor("PVP", "f5c87a"))
    Relative = PVP
    local LittleRelative = PVP

    local Honor = Parent:CreateFontString(ADDON_NAME .. "Honor", "ARTWORK", "GameFontNormal")
    Honor:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Honor:SetJustifyH("LEFT")
    Honor.currency = GetCurrencyData(1792)
    Register("Currencies", Honor)
    LittleRelative = Honor

    local Warmode = CreateFrame("Button", ADDON_NAME .. "Warmode", Parent)
    local WarmodeLabel = Warmode:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    WarmodeLabel:SetJustifyH("LEFT")
    WarmodeLabel:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Register("Warmodes", WarmodeLabel)
    Warmode:SetAllPoints(WarmodeLabel)
    Warmode:SetScript("OnClick", function()
        if C_PvP.CanToggleWarMode(not C_PvP.IsWarModeDesired()) then
            C_PvP.ToggleWarMode()
        elseif C_PvP.IsWarModeDesired() then
            RaidNotice_AddMessage(RaidBossEmoteFrame, L.alpha, ChatTypeInfo["RAID_WARNING"])
        else
            RaidNotice_AddMessage(RaidBossEmoteFrame, string.format(L.beta, factionCity), ChatTypeInfo["RAID_WARNING"])
        end
    end)
    Warmode:SetScript("OnLeave", HideTooltip)
    WarmodeLabel.anchor = Warmode
    ns:RefreshWarmodes()

    local Conquest = Parent:CreateFontString(ADDON_NAME .. "Conquest", "ARTWORK", "GameFontNormal")
    Conquest:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    Conquest:SetJustifyH("LEFT")
    Conquest.currency = GetCurrencyData(1602)
    Register("Currencies", Conquest)
    LittleRelative = Conquest

    ns:RefreshCurrencies()

    Relative.offset = large
    return Relative
end

---
-- Zone
---

function ns:CreateZone(Parent, Relative, zone, worldQuests, covenant, relativePoint)
    local mapName = C_Map.GetMapInfo(zone.id).name
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local Rares = {}

    local ZoneFrame = CreateFrame("Frame", ADDON_NAME .. "ZoneFrame" .. zone.id, Parent)
    ZoneFrame:SetPoint("TOPLEFT", Relative, (relativePoint or "BOTTOMLEFT"), 0, -gigantic-(Relative.offset or 0))
    ZoneFrame:SetWidth(Parent:GetWidth())
    ZoneFrame:SetHeight(1)
    Parent = ZoneFrame
    Relative = ZoneFrame

    local Zone = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id, "ARTWORK", "GameFontNormalLarge")
    local ZoneAnchor = CreateFrame("Button", nil, Parent)
    Zone:SetPoint("TOPLEFT", Relative, "TOPLEFT")
    Zone:SetJustifyH("LEFT")
    Zone:SetText(TextIcon(zoneIcon) .. "  " .. TextColor(mapName:upper(), zoneColor))
    ZoneAnchor:SetAllPoints(Zone)
    ZoneAnchor:SetScript("OnClick", function()
        -- TODO How to reliably expand/collapse
        -- fontstring height is not reliable until frame after update
    end)
    Relative = Zone
    Relative.offset = 0
    local LittleRelative = Zone

    if zone.covenant then
        local zoneCovenant = string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords")
        local zonePhrase = TextColor("\"" .. string.format(covenants[zone.covenant].phrase, zoneCovenant) .. "\"", "bbbbbb")
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
            local FactionAnchor = CreateFrame("Frame", nil, Parent)
            FactionAnchor:SetAllPoints(Faction)
            Faction.anchor = FactionAnchor
            Faction.faction = faction
            Faction.color = zoneColor
            Register("Factions", Faction)
            ns:RefreshFactions()
            LittleRelative = Faction
        end
    end

    if zone.currency then
        local Currency = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Currency", "ARTWORK", "GameFontNormal")
        if zone.covenant or zone.faction then
            Currency:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
            Relative.offset = Relative.offset + ((zone.covenant and zone.faction) and gigantic or large)
        else
            Currency:SetPoint("LEFT", LittleRelative, "RIGHT", large, 0)
        end
        Currency:SetJustifyH("LEFT")
        Currency.currency = GetCurrencyData(zone.currency)
        Register("Currencies", Currency)
        ns:RefreshCurrencies()
        LittleRelative = Currency
    end

    -- For each Rare in the Zone
    local i = 0
    for _, rare in ipairs(zone.rares) do
        local isWorldQuest, isAvailable = false, false
        rare.quest = rare.quest or (faction == "Alliance" and (rare.questAlliance or nil) or (rare.questHorde or nil))
        if type(rare.quest) == "number" then
            if CQL.IsWorldQuest(rare.quest) or rare.worldquest then
                isWorldQuest = true
                if contains(worldQuests, rare.quest) or CQL.IsQuestFlaggedCompleted(rare.quest) then
                    isAvailable = true
                elseif CQL.AddWorldQuestWatch(rare.quest) then
                    isAvailable = true
                    CQL.RemoveWorldQuestWatch(rare.quest)
                end
            else
                isAvailable = CQL.IsQuestFlaggedCompleted(rare.quest) and false or true
            end
        end
        if rare.hidden then
        elseif isWorldQuest and not isAvailable then
        else
            local items = {}
            if rare.items and #rare.items > 0 then
                -- For each Item dropped by the Rare in the Zone
                for _, item in ipairs(rare.items) do
                    if GetItemInfo(item.id) == nil then
                    elseif RAVFOR_data.options.showOwned == false and IsItemOwned(item) then
                    elseif RAVFOR_data.options.showCannotUse == false and item.faction and item.faction:upper() ~= faction:upper() then
                    elseif RAVFOR_data.options.showCannotUse == false and item.class and item.class:upper() ~= class:upper() then
                    elseif RAVFOR_data.options.showCannotUse == false and item.covenantOnly and covenant ~= zone.covenant then
                    else
                        -- Insert Item into Items
                        table.insert(items, item)
                    end
                end
            end
            if #items == 0 and RAVFOR_data.options.showNoDrops == false and ((RAVFOR_data.options.showReputation and not rare.reptuation) or not RAVFOR_data.options.showReputation) then
            elseif RAVFOR_data.options.showCannotUse == false and rare.faction and rare.faction:upper() ~= faction:upper() then
            else
                -- Rare
                i = i + 1
                local Rare = ns:CreateRare(Parent, Relative, i, zone, rare, items, covenant)
                table.insert(Rares, Rare)
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
    local zoneCovenant = zone.covenant and TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil
    local zoneName = C_Map.GetMapInfo(zone.id).name
    local c = {}
    local waypoint = type(rare.waypoint) == "table" and rare.waypoint[1] or rare.waypoint
    for d in tostring(waypoint):gmatch("[0-9][0-9]") do
        tinsert(c, d)
    end

    local dead = IsRareDead(rare) and icons.SkullGrey or ((type(rare.quest) == "number" and CQL.IsWorldQuest(rare.quest))) and icons.Quest or (rare.biweekly or rare.weekly) and icons.SkullBlueGlow or rare.quest and icons.SkullRedGlow or icons.SkullPurple
    local rareFaction = rare.faction and "|cff" .. (rare.faction == "Alliance" and "0078ff" or "b30000") .. rare.faction .. "|r" or nil
    local factionOnly = rareFaction and TextColor(L.OnlyFor) .. rareFaction or ""
    local rareControl = rare.control and "|cff" .. (rare.control == "Alliance" and "0078ff" or "b30000") .. rare.control .. "|r" or nil
    local controlRequired = rareControl and TextColor(string.format(L.ZoneControl, rareControl)) or ""
    local covenantRequired = rare.covenantRequired and TextColor(L.SummonedBy) .. zoneCovenant .. (#items > 0 and TextColor(",") or "") or ""
    local drops = #items > 0 and  " " .. TextColor(L.Drops, "bbbbbb") or ""

    local Rare = CreateFrame("Button", ADDON_NAME .. "Rare" .. rare.id, Parent)
    local RareLabel = Rare:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    RareLabel:SetJustifyH("LEFT")
    RareLabel:SetText(dead .. " " .. TextColor(i .. ". ") .. rare.name .. controlRequired .. factionOnly .. covenantRequired .. drops)
    RareLabel:SetHeight(16)
    RareLabel:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Rare:SetAllPoints(RareLabel)
    Rare:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
        local isLead = false
        for i = 1, MAX_RAID_MEMBERS do
            local lookup, rank = GetRaidRosterInfo(i)
            if lookup == playerName then
                if rank > 1 then isLead = true end
                break
            end
        end
        local prefix = isLead and L.CreateSendMapPin or L.CreateMapPin
        GameTooltip:SetText(TextColor(prefix .. ":"))
        GameTooltip:AddLine(rare.name .. ((rare.quest and IsRareDead(rare)) and TextColor(" (" .. _G.DEAD .. ")", "bbbbbb") or ""))
        GameTooltip:AddLine(TextColor(zoneName, zoneColor) .. " " .. c[1] .. "." .. c[2] .. ", " .. c[3] .. "." .. c[4])
        if isLead then
            GameTooltip:AddLine(TextColor(L.ModifierToShare, "bbbbbb"))
        end
        if type(rare.quest) == "number" and CQL.IsWorldQuest(rare.quest) then
            GameTooltip:AddLine(icons.Quest .. " World Quest")
        elseif rare.biweekly or rare.weekly then
            GameTooltip:AddLine("Weekly")
        elseif rare.achievement then
            GameTooltip:AddLine("Achievement-based")
        end
        GameTooltip:Show()
    end)
    Rare:SetScript("OnLeave", HideTooltip)
    Rare:SetScript("OnClick", function()
        local isLead = false
        for i = 1, MAX_RAID_MEMBERS do
            local lookup, rank = GetRaidRosterInfo(i)
            if lookup == playerName then
                if rank > 1 then isLead = true end
                break
            end
        end
        if isLead and (IsAltKeyDown() or IsControlKeyDown() or IsShiftKeyDown()) then
            -- Send the Rare to Group Members if Group Lead
            ns:SendTarget(zone, rare)
        else
            -- Mark the Rare
            ns:NewTarget(zone, rare, string.format("%1$s-%2$s", UnitName("player"), GetNormalizedRealmName()))
        end
    end)
    RareLabel.rare = rare
    Register("Rares", RareLabel)
    Relative = Rare

    if RAVFOR_data.options.showReputation == true and rare.reputation then
        if type(zone.faction) == "table" then
            zone.faction = zone.faction[1]
        end
        local factionName = select(1, GetFactionInfoByID(zone.faction))
        local Reputation = Parent:CreateFontString(ADDON_NAME .. "Zone" .. zone.id .. "Reputation", "ARTWORK", "GameFontNormal")
        Reputation:SetJustifyH("LEFT")
        Reputation:SetText("    " .. TextColor(string.format(L.Reputation, rare.reputation, TextColor(factionName, zoneColor)), "8080ff"))
        Reputation:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -small)
        Relative = Reputation
    end

    if #items > 0 then
        for _, item in ipairs(items) do
            local Item = ns:CreateItem(Parent, Relative, zone, rare, item, covenant)
            Relative = Item
        end
    end

    if rare.notes then
        Relative.offset = -small
        local Notes = ns:CreateNotes(Parent, Relative, rare.notes, "    ")
        Relative = Notes
    end

    return Relative
end

---
-- Item
---

function ns:CreateItem(Parent, Relative, zone, rare, item, covenant)
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
    local zoneCovenant = zone.covenant and TextColor(string.gsub(C_Covenants.GetCovenantData(zone.covenant).name, "lord", "lords"), zoneColor) or nil

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
    local itemFaction = item.faction and "|cff" .. (item.faction == "Alliance" and "0078ff" or "b30000") .. item.faction .. "|r" or nil
    local itemClass = item.class and "|c" .. select(4, GetClassColor(string.gsub(item.class, "%s+", ""):upper())) .. item.class .. "s|r" or nil
    local guaranteed = item.guaranteed and TextColor(L.HundredDrop) or ""
    local achievement = item.achievement and TextColor(L.From) .. GetAchievementLink(item.achievement) or ""
    local factionOnly = itemFaction and TextColor(L.OnlyFor) .. itemFaction or ""
    local classOnly = item.class and TextColor(L.OnlyFor) .. itemClass or ""
    local covenantOnly = item.covenantOnly and TextColor(L.OnlyFor) .. zoneCovenant or ""
    local owned = IsItemOwned(item) and " " .. icons.Checkmark or ""

    local Item = CreateFrame("Button", ADDON_NAME .. "Item" .. item.id, Parent)
    local ItemLabel = Item:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ItemLabel:SetJustifyH("LEFT")
    ItemLabel:SetText("    " .. TextIcon(itemTexture) .. "  " .. itemLink .. guaranteed .. achievement .. factionOnly .. classOnly .. covenantOnly .. owned)
    ItemLabel:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -small)
    ItemLabel:SetWidth(Parent:GetWidth())
    Item:SetAllPoints(ItemLabel)
    Item:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end)
    Item:SetScript("OnLeave", HideTooltip)
    Item:SetScript("OnClick", function()
        ns:PrettyPrint(itemLink)
    end)
    ItemLabel.item = item
    Register("Items", ItemLabel)

    Relative = ItemLabel
    return Relative
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
    GreatVault:SetText(TextIcon(3847780) .. "  " .. TextColor("The Great Vault", "8899c6"))
    GreatVault:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = GreatVault

    local GreatVaultNotice = Parent:CreateFontString(ADDON_NAME .. "GreatVaultNotice", "ARTWORK", "GameFontNormal")
    GreatVaultNotice:SetJustifyH("LEFT")
    GreatVaultNotice:SetText(TextColor("Go to Oribos to claim your rewards!", "ff6666"))
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

    RegisterCovenant(Covenant, Renown)
    ns:RefreshCovenant()

    local Anima = Parent:CreateFontString(ADDON_NAME .. "Anima", "ARTWORK", "GameFontNormal")
    Anima:SetPoint("LEFT", LittleRelative, "RIGHT", gigantic, 0)
    Anima:SetJustifyH("LEFT")
    Anima.currency = GetCurrencyData(1813)
    Anima.add = GetAnimaItemsTotal
    Register("Currencies", Anima)
    LittleRelative = Anima

    local AnimaAnchor = CreateFrame("Frame", nil, Parent)
    AnimaAnchor:SetAllPoints(Anima)
    AnimaAnchor:SetScript("OnEnter", function(self)
        local currency = C_CurrencyInfo.GetCurrencyInfo(Anima.currency.id)
        local quantity = currency.discovered and currency.quantity or 0
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
        GameTooltip:SetText(TextColor(currency.name, Anima.currency.color))
        GameTooltip:AddLine(TextColor(L.InReservoir) .. commaValue(quantity))
        GameTooltip:AddLine(TextColor(L.InBags) .. commaValue(GetAnimaItemsTotal()))
        GameTooltip:Show()
    end)
    AnimaAnchor:SetScript("OnLeave", HideTooltip)

    local RedeemedSouls = Parent:CreateFontString(ADDON_NAME .. "RedeemedSouls", "ARTWORK", "GameFontNormal")
    RedeemedSouls:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    RedeemedSouls:SetJustifyH("LEFT")
    RedeemedSouls.currency = GetCurrencyData(1810)
    Register("Currencies", RedeemedSouls)
    LittleRelative = RedeemedSouls

    local GratefulOfferings = Parent:CreateFontString(ADDON_NAME .. "GratefulOfferings", "ARTWORK", "GameFontNormal")
    GratefulOfferings:SetPoint("TOPLEFT", LittleRelative, "BOTTOMLEFT", 0, -medium)
    GratefulOfferings:SetJustifyH("LEFT")
    GratefulOfferings.currency = GetCurrencyData(1885)
    Register("Currencies", GratefulOfferings)

    ns:RefreshCurrencies()

    Relative.offset = large + large + medium
    return Relative
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
    Torghast:SetText(TextIcon(3642306) .. "  " .. TextColor(("Torghast"):upper(), "b0ccd8"))
    Torghast:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = Torghast

    local SoulAsh = Parent:CreateFontString(ADDON_NAME .. "SoulAsh", "ARTWORK", "GameFontNormal")
    SoulAsh:SetJustifyH("LEFT")
    SoulAsh:SetPoint("LEFT", Relative, "RIGHT", large, 0)

    SoulAsh.currency = GetCurrencyData(1828)
    Register("Currencies", SoulAsh)
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
    Heading:SetText(TextColor(ns.name .. " ") .. TextColor(ns.expansion, ns.color) .. TextColor(" v" .. ns.version))

    local LockButton = CreateFrame("Button", ADDON_NAME .. "LockButton", Window, "UIPanelButtonTemplate")
    LockButton:SetPoint("TOPLEFT", Window, "TOPLEFT", 9, -small)
    LockButton:SetWidth(18)
    LockButton:SetHeight(18)
    LockButton:RegisterForClicks("LeftButton")
    LockButton:SetScript("OnMouseDown", function(self, button)
        RAVFOR_data.options.locked = not RAVFOR_data.options.locked
        GameTooltip:SetText(TextColor(RAVFOR_data.options.locked and "Unlock Window" or "Lock Window"))
    end)
    LockButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
        GameTooltip:SetText(TextColor(RAVFOR_data.options.locked and "Unlock Window" or "Lock Window"))
        GameTooltip:Show()
    end)
    LockButton:SetScript("OnLeave", HideTooltip)
    local LockButtonIcon = LockButton:CreateTexture()
    LockButtonIcon:SetAllPoints(LockButton)
    LockButtonIcon:SetTexture(130944)

    local OptionsButton = CreateFrame("Button", ADDON_NAME .. "OptionsButton", Window, "UIPanelButtonTemplate")
    OptionsButton:SetPoint("TOPLEFT", LockButton, "TOPRIGHT", 2, 0)
    OptionsButton:SetWidth(18)
    OptionsButton:SetHeight(18)
    OptionsButton:RegisterForClicks("LeftButton")
    OptionsButton:SetScript("OnMouseDown", function(self, button)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
    end)
    OptionsButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_BOTTOM", 0, -small)
        GameTooltip:SetText(TextColor("Open Interface Options"))
        GameTooltip:Show()
    end)
    OptionsButton:SetScript("OnLeave", HideTooltip)
    local OptionsButtonIcon = OptionsButton:CreateTexture()
    OptionsButtonIcon:SetAllPoints(OptionsButton)
    OptionsButtonIcon:SetTexture(134063)

    -- TODO Get the resizer attached to Window + Events
    -- local Resizer = CreateFrame("Button", ADDON_NAME .. "Resizer", Window)
    -- Icon/Texture to use: 386862

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

    local function WindowInteractionStart(self, button)
        if button == "LeftButton" and not RAVFOR_data.options.locked then
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

    local covenant = C_Covenants.GetActiveCovenantID()

    -- Get "Watched" World Quests
    -- What is useful is that the weekly WQ Rare is auto-tracked on login, so we
    -- can use this + quest completion to determine the Weekly WQ Rare
    local worldQuests = {}
    if CQL.GetNumWorldQuestWatches() then
        for i = 1, CQL.GetNumWorldQuestWatches() do
            tinsert(worldQuests, CQL.GetQuestIDForWorldQuestWatchIndex(i))
        end
    end

    -- Set up where to put content of each Scroller
    local Parent = Scrollers["General"].Content
    local Relative = Parent

    -- PVP
    local PVP = ns:CreatePVP(Parent, Relative)
    Relative = PVP
    -- Notes
    local NoteHeading = Parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    NoteHeading:SetJustifyH("LEFT")
    NoteHeading:SetText(TextIcon(1506451) .. "  " .. TextColor("Notes", "eeeeee"))
    NoteHeading:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
    Relative = NoteHeading
    local Notes = ns:CreateNotes(Parent, Relative, notes)
    Relative = Notes
    local Spacer = CreateSpacer(Parent, Relative)

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
            local Zone = ns:CreateZone(Parent, Relative, zone, worldQuests, covenant)
            Relative = Zone
        end
        -- Notes
        if expansion.notes and #expansion.notes > 0 then
            local NoteHeading = Parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
            NoteHeading:SetJustifyH("LEFT")
            NoteHeading:SetText(TextIcon(1506451) .. "  " .. TextColor("Notes", "eeeeee"))
            NoteHeading:SetPoint("TOPLEFT", Relative, "BOTTOMLEFT", 0, -gigantic-(Relative.offset or 0))
            Relative = NoteHeading
            local Notes = ns:CreateNotes(Parent, Relative, expansion.notes)
            Relative = Notes
        end
        local Spacer = CreateSpacer(Parent, Relative)
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

---
-- Minimap Button
-- Thanks to Leatrix for the gist of this code!
---

function ns:CreateMinimapButton()
    if RAVFOR_data.options.minimapButton ~= true then
        if ns.MinimapButton then ns.MinimapButton:Hide() end
        return
    end

    local Button = CreateFrame("Button", nil, Minimap)
    Button:SetFrameStrata("MEDIUM")
    Button:SetFrameLevel(8)
    Button:SetSize(31, 31)
    Button:EnableMouse(true)
    Button:SetMovable(true)
    Button:ClearAllPoints()

    Button:SetHighlightTexture(136477) --"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
    local overlay = Button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture(136430) --"Interface\\Minimap\\MiniMap-TrackingBorder"
    overlay:SetPoint("TOPLEFT")
    local background = Button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture(136467) --"Interface\\Minimap\\UI-Minimap-Background"
    background:SetPoint("TOPLEFT", 7, -5)
    local icon = Button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(23, 23)
    icon:SetTexture("Interface/AddOns/ravFor/ravFor.tga")
    icon:SetPoint("TOPLEFT", 6, -6)

    local minimapShapes = {
        ["ROUND"] = {true, true, true, true},
        ["SQUARE"] = {false, false, false, false},
        ["CORNER-TOPLEFT"] = {false, false, false, true},
        ["CORNER-TOPRIGHT"] = {false, false, true, false},
        ["CORNER-BOTTOMLEFT"] = {false, true, false, false},
        ["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
        ["SIDE-LEFT"] = {false, true, false, true},
        ["SIDE-RIGHT"] = {true, false, true, false},
        ["SIDE-TOP"] = {false, false, true, true},
        ["SIDE-BOTTOM"] = {true, true, false, false},
        ["TRICORNER-TOPLEFT"] = {false, true, true, true},
        ["TRICORNER-TOPRIGHT"] = {true, false, true, true},
        ["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
        ["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
    }

    local rad, cos, sin, sqrt, max, min = math.rad, math.cos, math.sin, math.sqrt, math.max, math.min
    function updatePosition(button, position)
        local angle = rad(position or 225)
        local x, y, q = cos(angle), sin(angle), 1
        if x < 0 then q = q + 1 end
        if y > 0 then q = q + 2 end
        local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
        local quadTable = minimapShapes[minimapShape]
        local w = (Minimap:GetWidth() / 2) + 5
        local h = (Minimap:GetHeight() / 2) + 5
        if quadTable[q] then
            x, y = x*w, y*h
        else
            local diagRadiusW = sqrt(2*(w)^2)-10
            local diagRadiusH = sqrt(2*(h)^2)-10
            x = max(-w, min(x*diagRadiusW, w))
            y = max(-h, min(y*diagRadiusH, h))
        end
        button:ClearAllPoints()
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end
    updatePosition(Button, RAVFOR_data.options.minimapPosition)

    local deg, atan2 = math.deg, math.atan2
    local function onUpdate(self)
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        local pos = 225
        if self.db then
            pos = deg(atan2(py - my, px - mx)) % 360
            self.db.minimapPos = pos
        else
            pos = deg(atan2(py - my, px - mx)) % 360
            self.minimapPos = pos
        end
        updatePosition(self, pos)
        RAVFOR_data.options.minimapPosition = pos
    end

    Button:RegisterForDrag("LeftButton")
    Button:SetScript("OnDragStart", function()
        Button:StartMoving()
        Button.isMoving = true
        Button:SetScript("OnUpdate", onUpdate)
    end)

    Button:SetScript("OnDragStop", function()
        Button:StopMovingOrSizing()
        Button.isMoving = false
        Button:SetScript("OnUpdate", nil)
    end)

    Button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self or UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetText(TextColor(ns.name))
        GameTooltip:AddLine(L.MinimapLClick)
        GameTooltip:AddLine(L.MinimapRClick)
        GameTooltip:Show()
    end)
    Button:SetScript("OnLeave", HideTooltip)

    Button:SetScript("OnMouseUp", function(self, button)
        if not self.isMoving then
            if button == "RightButton" then
                ns.waitingForOptions = true
                ns:PrettyPrint(L.NotLoaded)
            else
                ns:ToggleWindow(ns.Window)
            end
        end
    end)

    ns.MinimapButton = Button
end
