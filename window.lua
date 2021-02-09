local name, ns = ...
local L = ns.L

local expansion = ns.data.expansions[ns.expansion]
local notes = expansion.notes
local zones = expansion.zones

local covenants = ns.data.covenants
local renownLevels = ns.data.renownLevels

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

local Window = CreateFrame("Frame", name .. "Window", UIParent)
Window.name = name .. "Window"
Window:SetFrameStrata("MEDIUM")
Window:SetWidth(width)
Window:SetHeight(height)
Window:SetPoint("CENTER", 0, 0)
Window:EnableMouse(true)
Window:SetMovable(true)
Window:SetClampedToScreen(true)
Window:SetResizable(true)
Window:SetMinResize(width, height)
Window:SetMinResize(width, height)
Window:RegisterForDrag("LeftButton")
Window:SetScript("OnMouseDown", function(self, button)
    self:StartMoving()
end)
Window:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
end)

local WindowBackground = Window:CreateTexture(nil, "BACKGROUND")
WindowBackground:SetColorTexture(0, 0, 0, 0.85)
WindowBackground:SetAllPoints(Window)
Window.texture = WindowBackground

local Parent = CreateFrame("ScrollFrame", "Parent", Window, "UIPanelScrollFrameTemplate")
Parent:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
Parent:SetHeight(Window:GetHeight() - small - (medium * 2) - (large * 2))
Parent:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, large)

local Content = CreateFrame("Frame", "Content", ScrollFrame)
Content:SetWidth(1)
Content:SetHeight(1)
Parent:SetScrollChild(Content)

local Close = CreateFrame("Button", "Close", Window, "UIPanelCloseButton")
Close:SetPoint("TOPRIGHT", Window, "TOPRIGHT")
Close:RegisterForClicks("AnyUp")
Close:SetScript("OnMouseUp", function(self)
    Window:StopMovingOrSizing()
    Window:Hide()
    Window:SetWidth(width)
    Window:SetHeight(height)
end)

local Resize = CreateFrame("Button", "Resize", Window)
Resize:SetWidth(10)
Resize:SetHeight(10)
Resize:SetPoint("BOTTOMRIGHT", Window, "BOTTOMRIGHT")
Resize:RegisterForClicks("AnyUp")
Resize:SetScript("OnMouseDown", function(self, button)
    Window:StartSizing()
    self.isMoving = true
    self.hasMoved = false
end)
Resize:SetScript("OnMouseUp", function(self)
    if self.isMoving then
        Window:StopMovingOrSizing()
        -- Parent:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
        -- Parent:SetHeight(Window:GetHeight() - small - (medium * 2) - (large * 2))
        self.isMoving = false
        self.hasMoved = true
    end
end)

Window:Hide()
Window:SetScript("OnShow", function()
    -- Window Title
    ns:CreateLabel({
        name = "Heading",
        parent = Window,
        label = TextColor(ns.name, "ffffff") .. " " .. TextColor(ns.expansion, ns.color),
        relativeTo = Window,
        relativePoint = "TOPLEFT",
        fontObject = "GameFontNormalLarge",
        offsetX = medium,
        offsetY = -12,
    })
    -- Version
    ns:CreateLabel({
        name = "Version",
        parent = Window,
        label = TextColor("v" .. ns.version),
        relativeTo = Window,
        relativePoint = "TOPRIGHT",
        offsetX = -large*4,
        offsetY = -12,
    })
    -- Introduction
    ns:CreateLabel({
        name = "introduction",
        parent = Content,
        label = TextColor(ns.notes, "ffffff"),
        relativeTo = Content,
        relativePoint = "TOPLEFT",
        offsetY = 0,
    })
    -- Renown
    local covenant = C_Covenants.GetActiveCovenantID()
    if covenant ~= 0 then
        local renown = C_CovenantSanctumUI.GetRenownLevel()
        -- Max can't be lower than our current
        local maxRenown = renown
        -- if 0, then reset is today but has not yet happened
        local daysUntilWeeklyReset = math.floor(C_DateAndTime.GetSecondsUntilWeeklyReset() / 60 / 60 / 24)
        local now = C_DateAndTime.GetCurrentCalendarTime()
        local year, month, day = now.year, now.month, now.monthDay
        local lookup_year, lookup_month, lookup_day
        for _, lookup in ipairs(renownLevels) do
            lookup_year = lookup.year and lookup.year or lookup_year
            lookup_month = lookup.month and lookup.month or lookup_month
            lookup_day = lookup.day and lookup.day or lookup_day
            if lookup_year > year then break end
            if lookup_year <= year and lookup_month > month then break end
            if lookup_year <= year and lookup_month <= month and lookup_day > day then break end
            if lookup_year <= year and lookup_month <= month and lookup_day <= day and daysUntilWeeklyReset < 0 then break end
            maxRenown = lookup.level
        end
        ns:CreateLabel({
            name = "renown",
            parent = Content,
            label = TextIcon(3726261) .. "  " .. TextColor(C_Covenants.GetCovenantData(covenant).name, covenants[covenant].color) .. TextColor(" Renown", "ffffff"),
            offsetY = -gigantic,
            fontObject = "GameFontNormalLarge",
            -- TODO Button not working
            -- width = width - (medium * 2) - 18,
            -- height = 22,
            -- showRenown = true,
        })
        -- Level of Renown
        ns:CreateLabel({
            name = "renown-level",
            parent = Content,
            label = TextColor("Level ", "ffffff") .. (renown < maxRenown and TextColor(renown .. "/" .. maxRenown, "ff3333") or TextColor(renown, "ffffff")),
            initialPoint = "LEFT",
            relativePoint = "RIGHT",
            offsetX = large,
            offsetY = 0,
            ignorePlacement = true,
            fontObject = "GameFontNormal",
        })
        -- Under Max Renown Note
        if renown < maxRenown then
            ns:CreateLabel({
                name = nil,
                parent = Content,
                label = TextColor("Try to work increasing your Renown to the current maximum!", "ff3333"),
            })
        end
    end
    -- For each Zone
    for i, zone in ipairs(zones) do
        local mapName = C_Map.GetMapInfo(zone.id).name
        local zoneCovenant = zone.covenant and C_Covenants.GetCovenantData(zone.covenant).name or nil
        local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
        local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
        -- Zone
        ns:CreateLabel({
            name = zone.id,
            parent = Content,
            label = TextIcon(zoneIcon) .. "  " .. TextColor(mapName, zoneColor),
            offsetY = -gigantic,
            fontObject = "GameFontNormalLarge",
        })
        if zoneCovenant then
            -- Covenant for Zone
            ns:CreateLabel({
                name = zone.id .. "-" .. zoneCovenant,
                parent = Content,
                label = TextColor("(" .. zoneCovenant .. ")", zoneColor),
                initialPoint = "LEFT",
                relativePoint = "RIGHT",
                offsetX = small,
                offsetY = 0,
                ignorePlacement = true,
            })
        end
        -- For each Rare in the Zone
        local j = 0
        for _, rare in ipairs(zone.rares) do
            if not rare.hidden then
                j = j + 1-- Build a list of items matching user options
                local items = {}
                if rare.items then
                    -- For each Item dropped by the Rare in the Zone
                    for _, item in ipairs(rare.items) do
                        local owned = ""
                        if item.mount then
                            local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(item.mount)
                            owned = isCollected == true and " " .. checkmark or ""
                        elseif item.achievement then
                            local _, _, _, completed = GetAchievementInfo(item.achievement)
                            owned = completed == true and " " .. checkmark or ""
                        end
                        if not GetItemInfo(item.id) then
                        elseif RAVFOR_data.options.showTransmog == false and item.transmog then
                        elseif RAVFOR_data.options.showMounts == false and item.mount then
                        elseif RAVFOR_data.options.showPets == false and item.pet then
                        elseif RAVFOR_data.options.showToys == false and item.toy then
                        elseif RAVFOR_data.options.showGear == false and not item.transmog and not item.mount and not item.pet and not item.toy then
                        elseif RAVFOR_data.options.showOtherCovenantItems == false and item.covenantOnly and (covenant ~= zone.covenant) then
                        elseif RAVFOR_data.options.showOwned == false and owned ~= "" then
                        else
                            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
                            local covenantOnly = item.covenantOnly and TextColor(" only for ") .. TextIcon(zoneIcon) .. " " .. TextColor(zoneCovenant, zoneColor) or ""
                            local guaranteed = item.guaranteed and TextColor(" 100% drop!") or ""
                            local achievement = item.achievement and TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
                            -- Insert Item into Items
                            table.insert(items, {
                                name = rare.id .. "-items",
                                parent = Content,
                                label = "    " .. TextIcon(itemTexture) .. " " .. itemLink .. guaranteed .. achievement .. covenantOnly .. owned,
                                width = Window:GetWidth() - (medium * 2) - 18,
                                offsetY = -small,
                                id = item.id,
                                mount = item.mount,
                            })
                        end
                    end
                end
                local killed = skull
                if rare.quest then
                    if type(rare.quest) == "table" then
                        for _, quest in ipairs(rare.quest) do
                            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then break end
                            killed = checkmark
                        end
                    else
                        killed = C_QuestLog.IsQuestFlaggedCompleted(rare.quest) and checkmark or skull
                    end
                end
                local drops = #items > 0 and  " " .. TextColor("drops:") or ""
                local covenantRequired = rare.covenantRequired and TextColor(", summoned by ") .. TextIcon(zoneIcon) .. " " .. TextColor(zoneCovenant, zoneColor) .. (#items > 0 and TextColor(",") or "") or ""
                if RAVFOR_data.options.showKilled == false and killed == skull then
                elseif RAVFOR_data.options.showNoDrops and #items == 0 then
                else
                    -- Rare
                    ns:CreateButton({
                        name = rare.id,
                        parent = Content,
                        label = killed .. " " .. TextColor(j .. ". ") .. rare.name .. covenantRequired .. drops,
                        width = Window:GetWidth() - (medium * 2) - 18,
                        rare = rare.name,
                        zone = zone.id,
                        zoneColor = zoneColor,
                        waypoint = rare.waypoint,
                    })
                    if #items > 0 then
                        for _, item in ipairs(items) do
                            ns:CreateButton(item)
                        end
                    end
                end
            end
        end
    end
    -- Notes
    if notes then
        ns:CreateLabel({
            name = "notes",
            parent = Content,
            label = TextIcon(1506451) .. "  " .. TextColor("Notes", "ffffff"),
            offsetY = -gigantic,
            fontObject = "GameFontNormalLarge",
        })
        for _, note in ipairs(notes) do
            ns:CreateLabel({
                name = nil,
                parent = Content,
                label = TextColor(note, "ffffff"),
                offsetY = -medium,
            })
        end
    end

    Window:SetScript("OnShow", nil)
end)
ns.Window = Window
