local name, ravShadowlands = ...
local L = ravShadowlands.L

local zones = ravShadowlands.data.zones

local width = 350
local height = 450

local small = 6
local medium = 12
local large = 16

local Window = CreateFrame("Frame", name .. "Window", UIParent)
Window.name = name .. "Window"
Window:SetFrameStrata("DIALOG")
Window:SetWidth(width)
Window:SetHeight(height)
Window:SetPoint("CENTER", 0, 0)
Window:EnableMouse(true)
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
        -- For each Rare in the Zone
        for _, rare in ipairs(zone.rares) do
            local killed = "|T137025:16|t "
            if rare.quest then
                killed = C_QuestLog.IsQuestFlaggedCompleted(rare.quest) and "|T628564:16|t " or "|T137025:16|t "
            end
            local covenantRequired = rare.covenantRequired and "|T" .. zone.icon .. ":16|t |cff" .. zone.color .. C_Covenants.GetCovenantData(zone.covenant).name .. " to summon|r " or ""
            -- Rare
            ravShadowlands:CreateLabel({
                type = "Label",
                name = rare.id,
                parent = Content,
                label = killed .. covenantRequired .. rare.name .. " |cffbbbbbbdrops:|r"
            })
            -- For each Item dropped by the Rare in the Zone
            for _, item in ipairs(rare.items) do
                local itemName, itemLink = GetItemInfo(item.id)
                local covenantOnly = item.covenantOnly and " |cff" .. zone.color .. "only for |T" .. zone.icon .. ":16|t " .. C_Covenants.GetCovenantData(zone.covenant).name .. "|r" or ""
                local owned = ""
                if item.mount then
                    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(item.mount)
                    owned = isCollected == true and " |T628564:16|t" or ""
                end
                local guaranteed = (not owned and item.guaranteed) and " |cffbbbbbbGuaranteed!|r" or ""
                -- Item
                ravShadowlands:CreateLabel({
                    type = "Label",
                    name = rare.id .. "-items",
                    parent = Content,
                    label = "  " .. itemLink .. guaranteed .. covenantOnly .. owned,
                    offsetY = -small,
                })
            end
        end
    end

    Window:SetScript("OnShow", nil)
end)
ravShadowlands.Window = Window
