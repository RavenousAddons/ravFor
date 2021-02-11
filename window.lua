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

local Close = CreateFrame("Button", name .. "WindowClose", Window, "UIPanelCloseButton")
Close:SetPoint("TOPRIGHT", Window, "TOPRIGHT")
Close:RegisterForClicks("AnyUp")
Close:SetScript("OnMouseUp", function(self)
    Window:StopMovingOrSizing()
    Window:Hide()
    Window:SetWidth(width)
    Window:SetHeight(height)
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
        -- Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
        -- Scroller:SetHeight(Window:GetHeight() - small - (medium * 2) - (large * 2))
        self.isMoving = false
        self.hasMoved = true
    end
end)

local Scroller = CreateFrame("ScrollFrame", name .. "WindowScroller", Window, "UIPanelScrollFrameTemplate")
Scroller:SetWidth(Window:GetWidth() - (medium * 2) - 18) -- 18 seems to be width of the scrollbar
Scroller:SetHeight(Window:GetHeight() - (medium * 2) - (large * 2))
Scroller:SetPoint("BOTTOMLEFT", Window, "BOTTOMLEFT", medium, large)

local Content = CreateFrame("Frame", name .. "WindowScrollerContent", Scroller)
Content:SetWidth(1)
Content:SetHeight(1)
Scroller:SetScrollChild(Content)

Window:Hide()
Window:SetScript("OnShow", function()
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
    -- Renown
    ns:CreateRenown()
    -- For each Zone
    for i, zone in ipairs(zones) do
        local mapName = C_Map.GetMapInfo(zone.id).name
        local zoneCovenant = zone.covenant and C_Covenants.GetCovenantData(zone.covenant).name or nil
        local zoneColor = zone.covenant and covenants[zone.covenant].color or zone.color and zone.color or "ffffff"
        local zoneIcon = zone.covenant and covenants[zone.covenant].icon or zone.icon and zone.icon or nil
        -- Zone
        ns:CreateLabel({
            name = name .. "Zone" .. zone.id,
            parent = Content,
            label = TextIcon(zoneIcon) .. "  " .. TextColor(mapName, zoneColor),
            offsetY = -gigantic,
            fontObject = "GameFontNormalLarge",
        })
        if zoneCovenant then
            -- Covenant for Zone
            ns:CreateLabel({
                name = name .. "Zone" .. zone.id .. "Covenant" .. zone.covenant,
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
            if rare.hidden then
            elseif rare.waypoint[1] > 99 and rare.waypoint[2] > 99 then
            else
                local items = {}
                if rare.items then
                    -- For each Item dropped by the Rare in the Zone
                    for _, item in ipairs(rare.items) do
                        if not GetItemInfo(item.id) then
                        elseif RAVFOR_data.options.showTransmog == false and item.transmog then
                        elseif RAVFOR_data.options.showMounts == false and item.mount then
                        elseif RAVFOR_data.options.showPets == false and item.pet then
                        elseif RAVFOR_data.options.showToys == false and item.toy then
                        elseif RAVFOR_data.options.showGear == false and not item.transmog and not item.mount and not item.pet and not item.toy then
                        elseif RAVFOR_data.options.showOtherCovenantItems == false and item.covenantOnly and (covenant ~= zone.covenant) then
                        elseif RAVFOR_data.options.showOwned == false and ns:IsItemOwned(item) then
                        else
                            -- Insert Item into Items
                            table.insert(items, item)
                        end
                    end
                end
                if RAVFOR_data.options.showNoDrops == false and #items == 0 and not rare.reptuation then
                else
                    -- Rare
                    j = j + 1-- Build a list of items matching user options
                    ns:CreateRare(j, zone, rare, items, covenant)
                    if RAVFOR_data.options.showReputation == true and rare.reputation then
                        ns:CreateLabel({
                            name = name .. "Rare" .. rare.id .. "Reputation",
                            parent = Content,
                            label = "    " .. TextColor("+ " .. rare.reputation .. " reputation with Ve'nari", "8080ff"),
                            offsetY = -small,
                        })
                    end
                    if #items > 0 then
                        for _, item in ipairs(items) do
                            ns:CreateItem(zone, rare, item, covenant)
                        end
                    end
                end
            end
        end
    end
    -- Notes
    if notes then
        ns:CreateLabel({
            name = name .. "Notes",
            parent = Content,
            label = TextIcon(1506451) .. "  " .. TextColor("Notes", "ffffff"),
            offsetY = -gigantic,
            fontObject = "GameFontNormalLarge",
        })
        for i, note in ipairs(notes) do
            ns:CreateLabel({
                name = name .. "Note" .. i,
                parent = Content,
                label = TextColor(note, "ffffff"),
                offsetY = -medium,
            })
        end
    end

    Window:SetScript("OnShow", nil)
end)
ns.Window = Window
ns.Content = Content
