local name, ravShadowlands = ...
local L = ravShadowlands.L

local zones = ravShadowlands.data.zones

local small = 6
local medium = 12
local large = 16

local function FixScrollOnUpdate(frame)
    frame:SetScript("OnUpdate", nil)
    frame.scrollframe.obj:FixScroll()
end

local function ScrollFrame_OnMouseWheel(frame, value)
    frame.obj:MoveScroll(value)
end

local function ScrollFrame_OnSizeChanged(frame)
    frame:SetScript("OnUpdate", FixScrollOnUpdate)
end

local function ScrollBar_OnScrollValueChanged(frame, value)
    frame.obj:SetScroll(value)
end

local Window = CreateFrame("ScrollFrame", name .. "Window", UIParent, "FauxScrollFrameTemplate")
Window.name = name .. "Window"
Window:SetFrameStrata("DIALOG")
Window:SetWidth(600)
Window:SetHeight(450)
Window:SetPoint("CENTER", 0, 0)
Window:SetMovable(true)
Window:EnableMouse(true)
Window:EnableMouseWheel(true)
Window:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
Window:SetScript("OnSizeChanged", ScrollFrame_OnSizeChanged)
Window:RegisterForDrag("LeftButton")
Window:SetScript("OnDragStart", Window.StartMoving)
Window:SetScript("OnDragStop", Window.StopMovingOrSizing)
Window:SetClampedToScreen(true)

-- This makes it close with ESC
tinsert(UISpecialFrames, Window:GetName())

local Texture = Window:CreateTexture(nil, "BACKGROUND")
Texture:SetColorTexture(0, 0, 0, 0.8)
Texture:SetAllPoints(Window)
Window.texture = Texture

Window:Hide()
Window:SetScript("OnShow", function()
    local fullWidth = Window:GetWidth() - (small * 2)
    local columns = {
        "A",
        "B",
        "C",
        "D",
    }

    local HeaderPanel = CreateFrame("Frame", "HeaderPanel", Window)
    HeaderPanel:SetPoint("TOPLEFT", Window, "TOPLEFT", small, small * -1)
    HeaderPanel:SetWidth(fullWidth)
    HeaderPanel:SetHeight(small * 3)

    for _, title in ipairs(columns) do
        columns[title] = CreateFrame("Frame", "Column" .. title, Window)
        columns[title]:SetPoint("TOPLEFT", HeaderPanel, "BOTTOMLEFT", 0, small * -1)
        columns[title]:SetWidth(fullWidth / 4 - small)
        columns[title]:SetHeight(Window:GetHeight() - HeaderPanel:GetHeight() - (small * 2))
    end

    local WindowElements = {
        {
            name = "Heading",
            parent = Window,
            label = "|cffdcdde2" .. ravShadowlands.name .. ":",
            relativeTo = HeaderPanel,
            relativePoint = "TOPLEFT",
            fontObject = "GameFontNormalLarge",
            offsetX = 16,
        },
    }

    for _, control in pairs(WindowElements) do
        ravShadowlands:CreateLabel(control)
    end

    -- For each Zone
    for _, zone in pairs(zones) do
        local mapName = C_Map.GetMapInfo(zone.id).name
        -- Zone Heading
        ravShadowlands:CreateLabel({
            name = zone.id,
            parent = Window,
            label = "|cff" .. zone.color .. mapName .. ":|r",
            fontObject = "GameFontNormalLarge",
        })
        -- For each Boss in the Zone
        for i, bossData in ipairs(zone.bosses) do
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
                parent = Window,
                label = "|cffffffff" .. i .. ".|r " .. (killed and "{rt8} " or "") .. bossData.name .. "|cffffffff drops " .. itemLink .. (owned and " {rt3}" or ""),
            })
        end
    end

    Window:SetScript("OnShow", nil)
end)
ravShadowlands.Window = Window
