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

local Window = CreateFrame("Frame", name .. "Window", UIScroller)
Window:SetFrameStrata("MEDIUM")
Window:SetWidth(width)
Window:SetHeight(height)
Window:SetScale(0.85)
Window:SetPoint("CENTER", 0, 0)
Window:EnableMouse(true)
Window:SetMovable(true)
Window:SetClampedToScreen(true)
Window:SetResizable(true)
Window:SetMinResize(width, height)
Window:SetMaxResize(width*1.5, height*2)
Window:RegisterForDrag("LeftButton")
Window:SetScript("OnMouseDown", function(self, button)
    self:StartMoving()
end)
Window:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
end)
tinsert(UISpecialFrames, Window:GetName())

local WindowBackground = Window:CreateTexture(nil, "BACKGROUND")
WindowBackground:SetColorTexture(0, 0, 0, 0.85)
WindowBackground:SetAllPoints(Window)
Window.texture = WindowBackground

local Close = CreateFrame("Button", name .. "WindowClose", Window, "UIPanelCloseButton")
Close:SetPoint("TOPRIGHT", Window, "TOPRIGHT")
Close:RegisterForClicks("AnyUp")
Close:SetScript("OnMouseUp", function(self)
    Window:StopMovingOrSizing()
    Window:Hide()
end)

local Settings = CreateFrame("Button", name .. "WindowSettings", Window, "UIPanelButtonTemplate")
Settings:SetText("Settings")
Settings:SetWidth(large*4)
Settings:SetPoint("RIGHT", Close, "LEFT")
Settings:RegisterForClicks("AnyUp")
Settings:SetScript("OnMouseUp", function(self)
    Window:StopMovingOrSizing()
    InterfaceOptionsFrame_OpenToCategory(ns.Options)
    InterfaceOptionsFrame_OpenToCategory(ns.Options)
end)

local Scroller = CreateFrame("ScrollFrame", name .. "WindowScroller", Window, "UIPanelScrollFrameTemplate")
Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
Scroller:SetHeight(Window:GetHeight() - (medium * 2) - (large * 2))
Scroller:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, large)

local Resize = CreateFrame("Button", name .. "WindowResize", Window)
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
        Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
        Scroller:SetHeight(Window:GetHeight() - (medium * 2) - (large * 2))
        self.isMoving = false
        self.hasMoved = true
    end
end)

local Content = CreateFrame("Frame", name .. "WindowScrollerContent", Scroller)
Content:SetWidth(1)
Content:SetHeight(1)
Scroller:SetScrollChild(Content)

Window:Hide()
Window:SetScript("OnShow", function()
    Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
    Scroller:SetHeight(Window:GetHeight() - (medium * 2) - (large * 2))
    -- Window Title
    ns:CreateLabel({
        name = name .. "Heading",
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
        name = name .. "Version",
        parent = Window,
        label = TextColor("v" .. ns.version),
        relativeTo = Settings,
        initialPoint = "RIGHT",
        relativePoint = "LEFT",
        offsetX = -small,
        offsetY = 0,
        width = large*3,
        justify = "RIGHT",
        ignorePlacement = true,
    })
    -- Introduction
    ns:CreateLabel({
        name = name .. "Introduction",
        parent = Content,
        label = TextColor(ns.notes, "ffffff"),
        relativeTo = Content,
        relativePoint = "TOPLEFT",
        offsetY = 0,
    })
    -- Great Vault
    ns:CreateGreatVault()
    -- PVP
    ns:CreatePVP()
    -- Covenant
    ns:CreateCovenant()
    -- Torghast
    ns:CreateTorghast()
    -- For each Zone
    for i, zone in ipairs(zones) do
        -- Zone
        ns:CreateZone(zone)
    end
    -- Notes
    ns:CreateNotes(notes)

    Window:SetScript("OnShow", function()
        Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
        Scroller:SetHeight(Window:GetHeight() - (medium * 2) - (large * 2))
    end)
end)
ns.Window = Window
ns.Content = Content
