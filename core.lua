local name, ns = ...
local L = ns.L

function ravFor_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
end

function ravFor_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            if not RAVFOR_version then
                ns:PrettyPrint(string.format(L.Install, ns.color, ns.version))
            elseif RAVFOR_version ~= ns.version then
                ns:PrettyPrint(string.format(L.Update, ns.color, ns.version))
            end
            RAVFOR_version = ns.version
            C_ChatInfo.RegisterAddonMessagePrefix(name)
        elseif event == "CHAT_MSG_ADDON" then
            local message, _ = ...
            if string.match(message, "target") then
                local rare, zone, x, y, zoneColor = strsplit(",", message)
                rare = string.gsub(rare, "target={", "")
                y = string.gsub(y, "}", "")
                ns:NewTarget(rare, zone, x, y, zoneColor)
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        ns:EnsureMacro()
    end
end

SlashCmdList["RAVFOR"] = function(message, editbox)
    local command, argument = strsplit(" ", message)
    if command == "version" or command == "v" then
        ns:PrettyPrint(string.format(L.Version, ns.version))
    else
        if (ns.Window:IsVisible()) then ns.Window:Hide() else ns.Window:Show() end
    end
end
SLASH_RAVFOR1 = "/" .. ns.command
