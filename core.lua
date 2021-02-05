local name, ravShadowlands = ...
local L = ravShadowlands.L

function ravShadowlands_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
end

function ravShadowlands_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            if not ravShadowlands_version then
                ravShadowlands:PrettyPrint(string.format(L.Install, ravShadowlands.color, ravShadowlands.version))
            elseif ravShadowlands_version ~= ravShadowlands.version then
                ravShadowlands:PrettyPrint(string.format(L.Update, ravShadowlands.color, ravShadowlands.version))
            end
            ravShadowlands_version = ravShadowlands.version
        end
    elseif event == "MOUNT_JOURNAL_SEARCH_UPDATED" then

    end
end

SlashCmdList["RAVSHADOWLANDS"] = function(message, editbox)
    local command, argument = strsplit(" ", message)
    if command == "version" or command == "v" then
        ravShadowlands:PrettyPrint(string.format(L.Version, ravShadowlands.version))
    else
        ravShadowlands.Window:Show()
    end
end
SLASH_RAVSHADOWLANDS1 = "/" .. ravShadowlands.command
