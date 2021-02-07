local name, ns = ...
local L = ns.L

function RavenousFor_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
end

function RavenousFor_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            if not RAVFOR_version then
                ns:PrettyPrint(string.format(L.Install, ns.color, ns.version))
            elseif RAVFOR_version ~= ns.version then
                ns:PrettyPrint(string.format(L.Update, ns.color, ns.version))
            end
            RAVFOR_version = ns.version
        end
    elseif event == "MOUNT_JOURNAL_SEARCH_UPDATED" then

    end
end

SlashCmdList["RAVENOUSFOR"] = function(message, editbox)
    local command, argument = strsplit(" ", message)
    if command == "version" or command == "v" then
        ns:PrettyPrint(string.format(L.Version, ns.version))
    else
        ns.Window:Show()
    end
end
SLASH_RAVENOUSFOR1 = "/" .. ns.command
