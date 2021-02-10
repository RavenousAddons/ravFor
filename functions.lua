local name, ns = ...
local L = ns.L

local expansion = ns.data.expansions[ns.expansion]
local notes = expansion.notes
local zones = expansion.zones

local covenants = ns.data.covenants

local width = 420
local height = 360

local small = 6
local medium = 12
local large = 16
local gigantic = 24

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

    local label = cfg.parent:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    label:SetJustifyH("LEFT")
    label:SetText(cfg.label)
    if cfg.width then
        label:SetWidth(cfg.width)
    else
        label:SetWidth(ns.Window:GetWidth() - (medium * 2) - 18)
    end

    if not cfg.ignorePlacement then
        prevControl = label
    end
    return label
end

function ns:CreateRenown()
    local heading = ns.Content:CreateFontString(name .. "Renown", "ARTWORK", "GameFontNormalLarge")
    heading:SetPoint("TOPLEFT", prevControl, "BOTTOMLEFT", 0, -gigantic)
    heading:SetJustifyH("LEFT")

    local label = ns.Content:CreateFontString(name .. "RenownLevel", "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", heading, "RIGHT", large, 0)
    label:SetJustifyH("LEFT")

    ns:PushRenown(heading, label)

    ns:RegisterRenown({
        heading = heading,
        label = label,
    }, ns.Content)

    prevControl = heading
    return heading
end

function ns:PushRenown(heading, label)
    local covenant = C_Covenants.GetActiveCovenantID()
    if not covenant then
        return
    end
    local renown = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = ns:GetMaxRenown()

    heading:SetText(TextIcon(3726261) .. "  " .. TextColor(C_Covenants.GetCovenantData(covenant).name, ns.data.covenants[covenant].color) .. TextColor(" Renown", "ffffff"))
    label:SetText(TextColor("Level ", "ffffff") .. (renown < maxRenown and TextColor(renown .. "/" .. maxRenown, "ff3333") or TextColor(renown, "ffffff")))
end

function ns:RegisterRenown(data, parentFrame)
    if (not parentFrame) or (not data) then
        return
    end
    parentFrame.renown = data
end

function ns:RefreshRenown(data)
    ns:PushRenown(data.heading, data.label)
end

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

    local zoneCovenant = zone.covenant and C_Covenants.GetCovenantData(zone.covenant).name or nil
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil

    local dead = ns:IsRareDead(rare) and checkmark or skull
    local covenantRequired = rare.covenantRequired and TextColor(", summoned by ") .. TextIcon(zoneIcon) .. " " .. TextColor(zoneCovenant, zoneColor) .. (#items > 0 and TextColor(",") or "") or ""
    local drops = #items > 0 and  " " .. TextColor("drops:") or ""

    local label = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetWidth(button:GetWidth())
    label:SetJustifyH("LEFT")
    label:SetText(dead .. " " .. TextColor(i .. ". ") .. rare.name .. covenantRequired .. drops)

    label.rare = rare
    ns:RegisterRare(label, ns.Content)

    prevControl = button
    return button
end

function ns:RegisterRare(rare, parentFrame)
    if (not parentFrame) or (not rare) then
        return
    end
    parentFrame.rares = parentFrame.rares or {}
    table.insert(parentFrame.rares, rare)
end

function ns:RefreshRares(rares)
    for _, label in ipairs(rares) do
        local withoutDead = string.gsub(string.gsub(label:GetText(), skull, ""), checkmark, "")
        label:SetText((ns:IsRareDead(label.rare) and checkmark or skull) .. withoutDead)
        label.oldValue = label:GetText()
    end
end

function ns:CreateItem(zone, rare, item, covenant)
    local zoneCovenant = zone.covenant and C_Covenants.GetCovenantData(zone.covenant).name or nil
    local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
    local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
    local itemMeta = (itemType == "Armor" or itemType == "Weapon") and TextColor(" (" .. itemSubType .. ")") or ""
    itemLink = string.gsub(itemLink, "]", itemMeta .. "]")
    local guaranteed = item.guaranteed and TextColor(" 100% drop!") or ""
    local achievement = item.achievement and TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
    local covenantOnly = item.covenantOnly and TextColor(" only for ") .. TextIcon(zoneIcon) .. "  " .. TextColor(zoneCovenant, zoneColor) or ""
    local owned = ns:IsItemOwned(item) and " " .. checkmark or ""

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
        label:SetText(withoutOwned .. (ns:IsItemOwned(label.item) and checkmark or ""))
        label.oldValue = label:GetText()
    end
end

function ns:GetMaxRenown()
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

function ns:IsRareDead(rare)
    if type(rare.quest) == "table" then
        for _, quest in ipairs(rare.quest) do
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then break end
            return true
        end
    elseif rare.quest then
        return C_QuestLog.IsQuestFlaggedCompleted(rare.quest)
    end
    return false
end

function ns:IsItemOwned(item)
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
