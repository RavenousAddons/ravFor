local name, ravShadowlands = ...
local L = ravShadowlands.L

function ravShadowlands:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ravShadowlands.color .. ravShadowlands.name .. ":|r " .. message)
end

function ravShadowlands:CreateLabel(cfg)
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -16
    cfg.relativeTo = cfg.relativeTo or prevControl
    cfg.fontObject = cfg.fontObject or "GameFontNormal"

    local label = cfg.parent:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label.label = cfg.label
    label.type = cfg.type
    label:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    if cfg.width then
        label:SetWidth(cfg.width)
    end
    label:SetText(cfg.label)

    if not cfg.ignorePlacement then
        prevControl = label
    end
    return label
end
