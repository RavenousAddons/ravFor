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

function ns:SendTarget(rare, zone, x, y)
    local target = "target={" .. rare .. "," .. zone .. "," .. x .. "," .. y .. "}"
    local inInstance, _ = IsInInstance()
    if inInstance then
        C_ChatInfo.SendAddonMessage(name, target, "INSTANCE_CHAT")
    elseif IsInGroup() then
        if GetNumGroupMembers() > 5 then
            C_ChatInfo.SendAddonMessage(name, target, "RAID")
        end
        C_ChatInfo.SendAddonMessage(name, target, "PARTY")
    -- Disable for testing
    -- else
    --     print("Whisper")
    --     C_ChatInfo.SendAddonMessage(name, target, "WHISPER", UnitName("player"))
    end
end

function ns:NewTarget(rare, zone, x, y, zoneColor)
    local zoneName = C_Map.GetMapInfo(zone).name
    zoneColor = zoneColor and zoneColor or "ffffff"
    -- Print message to chat
    ns:PrettyPrint("\n" .. rare .. "  |cffffd100|Hworldmap:" .. zone .. ":" .. x * 100 .. ":" .. y * 100 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cff" .. zoneColor .. zoneName .. "|r |cffffffff" .. string.format("%.1f", x) .. ", " .. string.format("%.1f", y) .. "|r]|h|r")
    -- Add the waypoint to the map and track it
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(zone, x / 100, y / 100))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
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
    if cfg.rare and cfg.zone and cfg.waypoint and cfg.zoneColor then
        button:SetScript("OnClick", function()
            -- Mark the Rare
            ns:NewTarget(cfg.rare, cfg.zone, cfg.waypoint[1], cfg.waypoint[2], cfg.zoneColor)
            -- Send the Rare to Party/Raid Members
            ns:SendTarget(cfg.rare, cfg.zone, cfg.waypoint[1], cfg.waypoint[2], cfg.zoneColor)
        end)
    elseif cfg.id or cfg.mount then
        button:SetScript("OnClick", function()
            -- TODO Should open Mount Journal with Mount selected/opened
        end)
    elseif cfg.showRenown then
        button:SetScript("OnClick", function()
            -- TODO Should open Covenent Renown Frame
            -- print("showRenown")
            -- GarrisonLandingPage:Show()
            -- CovenantRenownFrame:Show()
        end)
    end

    if not cfg.ignorePlacement then
        prevControl = button
    end
    return button
end
