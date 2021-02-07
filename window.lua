local name, ravShadowlands = ...
local L = ravShadowlands.L

local zones = ravShadowlands.data.zones

local width = 400
local height = 450

local small = 6
local medium = 12
local large = 16

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
Window:SetResizable(true)
Window:SetMovable(true)
Window:SetClampedToScreen(true)
Window:RegisterForDrag("LeftButton")
Window:SetScript("OnDragStart", function(self) self:StartMoving() end)
Window:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

local WindowBackground = Window:CreateTexture(nil, "BACKGROUND")
WindowBackground:SetColorTexture(0, 0, 0, 0.85)
WindowBackground:SetAllPoints(Window)
Window.texture = WindowBackground

local Close = CreateFrame("Button", nil, Window, "UIPanelCloseButton")
Close:SetPoint("TOPRIGHT", Window, "TOPRIGHT")
Close:RegisterForClicks("AnyUp")
Close:SetScript("OnClick", function(self)
    Window:Hide()
end)

local Parent = CreateFrame("ScrollFrame", nil, Window, "UIPanelScrollFrameTemplate")
Parent:SetWidth(width - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
Parent:SetHeight(height - small - (medium * 2) - (large * 2))
Parent:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, large)

local Content = CreateFrame("Frame", nil, ScrollFrame)
Content:SetWidth(1)
Content:SetHeight(1)
Parent:SetScrollChild(Content)

Window:Hide()
Window:SetScript("OnShow", function()
    ravShadowlands:CreateLabel({
        name = "Heading",
        parent = Window,
        label = TextColor(ravShadowlands.title, "ffffff"),
        relativeTo = Window,
        relativePoint = "TOPLEFT",
        fontObject = "GameFontNormalLarge",
        offsetX = medium,
        offsetY = -12,
    })
    -- For each Zone
    for i, zone in ipairs(zones) do
        local mapName = C_Map.GetMapInfo(zone.id).name
        local covenant = zone.covenant and C_Covenants.GetCovenantData(zone.covenant).name:gsub("%Necrolord", "Necrolords") or nil
        -- Zone
        ravShadowlands:CreateLabel({
            name = zone.id,
            parent = Content,
            label = TextIcon(zone.icon) .. "  " .. TextColor(mapName, zone.color),
            relativeTo = (i == 1 and Content or nil),
            relativePoint = (i == 1 and "TOPLEFT" or nil),
            offsetY = (i == 1 and 0 or -large*3),
            fontObject = "GameFontNormalLarge",
        })
        if covenant then
            -- Covenant for Zone
            ravShadowlands:CreateLabel({
                name = zone.id .. "-" .. covenant,
                parent = Content,
                label = TextColor("(" .. covenant .. ")", zone.color),
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
                j = j + 1
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
                local covenantRequired = rare.covenantRequired and TextColor(", summoned by ") .. TextIcon(zone.icon) .. " " .. TextColor(covenant, zone.color) .. TextColor(",") or ""
                local drops = rare.items and  " " .. TextColor("drops:") or ""
                -- Rare
                ravShadowlands:CreateButton({
                    name = rare.id,
                    parent = Content,
                    label = killed .. " " .. TextColor(j .. ". ") .. rare.name .. covenantRequired .. drops,
                    width = width - (medium * 2) - 18,
                    rare = rare.name,
                    zone = zone.id,
                    zoneColor = zone.color,
                    waypoint = rare.waypoint,
                })
                if rare.items then
                    -- For each Item dropped by the Rare in the Zone
                    for _, item in ipairs(rare.items) do
                        if not GetItemInfo(item.id) then break end
                        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
                        local covenantOnly = item.covenantOnly and TextColor(" only for ") .. TextIcon(zone.icon) .. " " .. TextColor(covenant, zone.color) or ""
                        local owned = ""
                        if item.mount then
                            local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(item.mount)
                            owned = isCollected == true and " " .. checkmark or ""
                        elseif item.achievement then
                            local _, _, _, completed = GetAchievementInfo(item.achievement)
                            owned = completed == true and " " .. checkmark or ""
                        end
                        local guaranteed = item.guaranteed and TextColor(" Guaranteed drop!") or ""
                        local achievement = item.achievement and TextColor(" from ") .. GetAchievementLink(item.achievement) or ""
                        -- Item
                        ravShadowlands:CreateButton({
                            name = rare.id .. "-items",
                            parent = Content,
                            label = "    " .. TextIcon(itemTexture) .. " " .. itemLink .. guaranteed .. achievement .. covenantOnly .. owned,
                            width = width - (medium * 2) - 18,
                            offsetY = -small,
                            id = item.id,
                            mount = item.mount,
                        })
                    end
                end
            end
        end
    end

    Window:SetScript("OnShow", nil)
end)
ravShadowlands.Window = Window
