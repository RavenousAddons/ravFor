local name, ravShadowlands = ...
local L = ravShadowlands.L

local zones = ravShadowlands.data.zones

local width = 400
local height = 450

local small = 6
local medium = 12
local large = 16

local Window = CreateFrame("Frame", name .. "Window", UIParent)
Window.name = name .. "Window"
Window:SetFrameStrata("LOW")
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
Parent:SetWidth(width - (medium * 2) - 18) -- 22 seems to be width of the scrollbar
Parent:SetHeight(height - (medium * 2) - (large * 2))
Parent:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, medium)

local Content = CreateFrame("Frame", nil, ScrollFrame)
Content:SetWidth(1)
Content:SetHeight(1)
Parent:SetScrollChild(Content)

Window:Hide()
Window:SetScript("OnShow", function()
    ravShadowlands:CreateLabel({
        name = "Heading",
        parent = Window,
        label = "|cffffffff" .. ravShadowlands.title,
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
            label = "|T" .. zone.icon .. ":16|t |cff" .. zone.color .. mapName .. "|r",
            relativeTo = (i == 1 and Content or nil),
            relativePoint = (i == 1 and "TOPLEFT" or nil),
            offsetY = (i == 1 and 0 or -large*2),
            fontObject = "GameFontNormalLarge",
        })
        if covenant then
            -- Covenant for Zone
            ravShadowlands:CreateLabel({
                name = zone.id .. "-" .. covenant,
                parent = Content,
                label = "|cff" .. zone.color .. "(" .. covenant .. ")|r",
                initialPoint = "LEFT",
                relativePoint = "RIGHT",
                offsetX = small,
                offsetY = 0,
                ignorePlacement = true,
            })
        end
        -- For each Rare in the Zone
        for j, rare in ipairs(zone.rares) do
            local killed = "|T137025:16|t "
            if rare.quest then
                if type(rare.quest) == "table" then
                    for _, quest in ipairs(rare.quest) do
                        if not C_QuestLog.IsQuestFlaggedCompleted(quest) then break end
                        killed = "|T628564:16|t "
                    end
                else
                    killed = C_QuestLog.IsQuestFlaggedCompleted(rare.quest) and "|T628564:16|t " or "|T137025:16|t "
                end
            end
            local covenantRequired = rare.covenantRequired and "|cffbbbbbb, when|r |T" .. zone.icon .. ":16|t |cff" .. zone.color .. covenant .. "|r |cffbbbbbbsummon|r" or ""
            -- Rare
            ravShadowlands:CreateLabel({
                type = "Label",
                name = rare.id,
                parent = Content,
                label = killed .. "|cffbbbbbb" .. j .. ".|r " .. rare.name .. " |cffbbbbbbdrops|r" .. covenantRequired .. "|cffbbbbbb:|r"
            })
            -- For each Item dropped by the Rare in the Zone
            for _, item in ipairs(rare.items) do
                local itemName, itemLink = GetItemInfo(item.id)
                local covenantOnly = item.covenantOnly and " |cffbbbbbbonly for |T" .. zone.icon .. ":16|t |cff" .. zone.color .. "" .. covenant .. "|r" or ""
                local owned = ""
                if item.mount then
                    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(item.mount)
                    owned = isCollected == true and " |T628564:16|t" or ""
                end
                local guaranteed = item.guaranteed and " |cffbbbbbbGuaranteed drop!|r" or ""
                -- Item
                ravShadowlands:CreateLabel({
                    type = "Label",
                    name = rare.id .. "-items",
                    parent = Content,
                    label = "  " .. itemLink .. guaranteed .. covenantOnly .. owned,
                    link = itemLink,
                    offsetY = -small,
                })
            end
        end
    end

    Window:SetScript("OnShow", nil)
end)
ravShadowlands.Window = Window
