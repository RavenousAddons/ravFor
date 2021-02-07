local name, ns = ...
local L = ns.L

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
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

function ns:CreateLabel(cfg)
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -16
    cfg.relativeTo = cfg.relativeTo or prevControl
    cfg.fontObject = cfg.fontObject or "GameFontNormal"

    local label = cfg.parent:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    label:SetText(cfg.label)
    if cfg.width then
        label:SetWidth(cfg.width)
    end

    if not cfg.ignorePlacement then
        prevControl = label
    end
    return label
end

function ns:CreateButton(cfg)
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -16
    cfg.relativeTo = cfg.relativeTo or prevControl
    cfg.fontObject = cfg.fontObject or "GameFontNormal"

    local button = CreateFrame("Button", nil, cfg.parent)
    button:SetWidth(1)
    button:SetHeight(16)
    button:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    button:EnableMouse(true)
    local label = button:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetText(cfg.label)
    if cfg.width then
        button:SetWidth(cfg.width)
    end
    if cfg.height then
        button:SetHeight(cfg.height)
    end
    if cfg.rare and cfg.zone and cfg.waypoint then
        button:SetScript("OnClick", function()
            local zone = C_Map.GetMapInfo(cfg.zone).name
            ns:PrettyPrint("\n" .. cfg.rare .. "  |cffffd100|Hworldmap:" .. cfg.zone .. ":" .. cfg.waypoint[1] * 100 .. ":" .. cfg.waypoint[2] * 100 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cff" .. cfg.zoneColor .. zone .. "|r |cffffffff" .. string.format("%.1f", cfg.waypoint[1]) .. ", " .. string.format("%.1f", cfg.waypoint[2]) .. "|r]|h|r")
        end)
    elseif cfg.id or cfg.mount then
        button:SetScript("OnClick", function()
            -- print(cfg.id)
        end)
    elseif cfg.showRenown then
        print("cfg.showRenown")
        button:SetScript("OnClick", function()
            print("showRenown")
            GarrisonLandingPage:Show()
            CovenantRenownFrame:Show()
        end)
    end

    if not cfg.ignorePlacement then
        prevControl = button
    end
    return button
end
