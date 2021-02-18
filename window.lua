local name, ns = ...
local L = ns.L

local expansions = ns.data.expansions
local expansion = expansions[ns.expansion]
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

local Window = CreateFrame("Frame", name .. "Window", UIParent, "UIPanelDialogTemplate")
Window:SetFrameStrata("MEDIUM")
Window:SetWidth(width)
Window:SetHeight(height)
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
Settings:SetPoint("RIGHT", Close, "LEFT", small, 1)
Settings:RegisterForClicks("AnyUp")
Settings:SetScript("OnMouseUp", function(self)
    Window:StopMovingOrSizing()
    -- Window:Hide()
    InterfaceOptionsFrame_OpenToCategory(ns.Options)
    InterfaceOptionsFrame_OpenToCategory(ns.Options)
end)

local i = 0
local Scroller = {}
local Content = {}
local prevTab
for title, expansion in pairs(expansions) do
    i = i + 1

    local scroller = CreateFrame("ScrollFrame", name .. "Scroller" .. i, Window, "UIPanelScrollFrameTemplate")
    scroller:SetWidth(Window:GetWidth() - 42)
    scroller:SetHeight(Window:GetHeight() - 36)
    scroller:SetPoint("BOTTOMRIGHT", Window, "BOTTOMRIGHT", -28, 8)
    scroller:Hide()
    tinsert(Scroller, scroller)

    local content = CreateFrame("Frame", name .. "Content" .. i, scroller)
    content:SetWidth(1)
    content:SetHeight(1)
    tinsert(Content, content)

    scroller:SetScrollChild(content)
    scroller:SetScript("OnShow", function()
        scroller:SetScrollChild(content)
    end)

    local tab = CreateFrame("Button", name .. "Tab" .. i, Window, "CharacterFrameTabButtonTemplate")
    tab:SetFrameStrata("LOW")
    tab:SetText(title)
    tab:SetPoint("TOPLEFT", prevTab and prevTab or Window, prevTab and "TOPRIGHT" or "BOTTOMLEFT", prevTab and -medium or 0, prevTab and 0 or small)
    tab:RegisterForClicks("AnyUp")
    tab:SetScript("OnMouseUp", function(self)
        for _, frame in pairs(Scroller) do
            frame:Hide()
        end
        scroller:Show()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end)

    prevTab = tab
end

local Resize = CreateFrame("Button", name .. "WindowResize", Window)
Resize:SetWidth(10)
Resize:SetHeight(10)
Resize:SetPoint("TOPLEFT", Window, "BOTTOMRIGHT")
Resize:RegisterForClicks("AnyUp")
Resize:SetScript("OnMouseDown", function(self, button)
    Window:StartSizing()
    self.isMoving = true
    self.hasMoved = false
end)
Resize:SetScript("OnMouseUp", function(self)
    if self.isMoving then
        Window:StopMovingOrSizing()
        for _, frame in pairs(Scroller) do
            frame:SetWidth(Window:GetWidth() - 42)
            frame:SetHeight(Window:GetHeight() - 36)
        end
        self.isMoving = false
        self.hasMoved = true
    end
end)

Window:Hide()
Window:SetScript("OnShow", function()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    for _, frame in pairs(Scroller) do
        frame:SetWidth(Window:GetWidth() - 42)
        frame:SetHeight(Window:GetHeight() - 36)
    end
    -- Begin by highlighting the latest expansion
    ns.Scroller[1]:Show()
    -- Window Title
    local Heading = Window:CreateFontString(name .. "Heading", "ARTWORK", "GameFontNormal")
    Heading:SetHeight(20)
    Heading:SetPoint("TOPLEFT", Window, "TOPLEFT", medium+small, -small)
    Heading:SetJustifyH("LEFT")
    Heading:SetText(TextColor(ns.name, "ffffff") .. " " .. TextColor(ns.expansion, ns.color))
    -- Version
    ns:CreateLabel({
        name = name .. "Version",
        parent = Window,
        label = TextColor("v" .. ns.version),
        relativeTo = Heading,
        initialPoint = "LEFT",
        relativePoint = "RIGHT",
        offsetX = small,
        offsetY = 0,
        ignorePlacement = true,
    })
    local i = 0
    for title, expansion in pairs(expansions) do
        i = i + 1
        prevControl = Heading
        -- PVP
        ns:CreatePVP(Content[i])
        if title == "Shadowlands" then
            -- Covenant
            ns:CreateCovenant(Content[i], medium)
            -- Torghast
            ns:CreateTorghast(Content[i], medium)
            -- Great Vault
            ns:CreateGreatVault(Content[i])
            -- Sp-eye-glass
            ns:CreateSpeyeglass(Content[i])
        end
        -- For each Zone
        for j, zone in ipairs(expansion.zones) do
            -- Zone
            ns:CreateZone(Content[i], ((title ~= "Shadowlands" and j == 1) and medium or 0), zone)
        end
        -- Notes
        if expansion.notes then
            ns:CreateNotes(Content[i], 0, expansion.notes)
        end
    end

    Window:SetScript("OnShow", function()
        for _, frame in pairs(Scroller) do
            frame:SetWidth(Window:GetWidth() - 42)
            frame:SetHeight(Window:GetHeight() - 36)
        end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end)

    Window:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
    end)
end)

ns.Scroller = Scroller
ns.Content = Content
ns.Window = Window
