local name, ravShadowlands = ...
local L = ravShadowlands.L

local zones = ravShadowlands.data.zones

local width = 500
local height = 400

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
Window:RegisterForDrag("LeftButton")
Window:SetScript("OnDragStart", function(self) self:StartMoving() end)
Window:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
Window:SetClampedToScreen(true)

-- This makes it close with ESC
tinsert(UISpecialFrames, Window:GetName())

local Texture = Window:CreateTexture(nil, "BACKGROUND")
Texture:SetColorTexture(0, 0, 0, 0.8)
Texture:SetAllPoints(Window)
Window.texture = Texture

local Parent = CreateFrame("ScrollFrame", nil, Window, "UIPanelScrollFrameTemplate")
Parent:SetWidth(width - (medium * 2) - 22) -- 22 seems to be width of the scrollbar
Parent:SetHeight(height - (medium * 2) - (large * 2))
Parent:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, medium)

local Content = CreateFrame("Frame", nil, ScrollFrame)
Content:SetWidth(1)
Content:SetHeight(1)
Parent:SetScrollChild(Content)

Window:SetScript("OnShow", function()
    ravShadowlands:CreateLabel({
        name = "Heading",
        parent = Window,
        label = "|cffffffff" .. ravShadowlands.title,
        relativeTo = Window,
        relativePoint = "TOPLEFT",
        fontObject = "GameFontNormalLarge",
        offsetX = medium,
    })
    -- For each Zone
    for i, zone in ipairs(zones) do
        local mapName = C_Map.GetMapInfo(zone.id).name
        -- Zone Heading
        ravShadowlands:CreateLabel({
            name = zone.id,
            parent = Content,
            label = "|cff" .. zone.color .. mapName .. ":|r",
            relativeTo = (i == 1 and Content or nil),
            relativePoint = (i == 1 and "TOPLEFT" or nil),
            offsetY = (i == 1 and 0 or nil),
            fontObject = "GameFontNormalLarge",
        })
        -- For each Boss in the Zone
        for _, bossData in ipairs(zone.bosses) do
            local itemName, itemLink = GetItemInfo(bossData.item)
            local owned = false
            local killed = false
            if bossData.mount then
                local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(bossData.mount)
                owned = isCollected == true and true or false
            end
            if bossData.quest then
                killed = C_QuestLog.IsQuestFlaggedCompleted(bossData.quest)
            end
            -- Boss List Item
            ravShadowlands:CreateLabel({
                type = "Label",
                name = bossData.id,
                parent = Content,
                label = (killed and "|T628564:16|t " or "|T137025:16|t ") .. bossData.name .. "|cffffffff drops " .. itemLink .. (owned and " |T628564:16|t" or "") -- .. " |cffffff00|Hworldmap:84:7222:2550|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a Location]|h|r",
            })
        end
    end

    Window:SetScript("OnShow", nil)
end)
ravShadowlands.Window = Window
