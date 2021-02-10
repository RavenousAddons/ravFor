local name, ns = ...
local L = ns.L

local expansion = ns.data.expansions[ns.expansion]
local zones = expansion.zones

local targetMessages = ns.data.targetMessages

function ravFor_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
    self:RegisterEvent("WORLD_QUEST_COMPLETED_BY_SPELL")
    self:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
end

function ravFor_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            ns:SetDefaultOptions()
            if not RAVFOR_version then
                ns:PrettyPrint(string.format(L.Install, ns.color, ns.version, ns.command))
            elseif RAVFOR_version ~= ns.version then
                ns:PrettyPrint(string.format(L.Update, ns.color, ns.version, ns.command))
            end
            RAVFOR_version = ns.version
            C_ChatInfo.RegisterAddonMessagePrefix(name)
        elseif event == "CHAT_MSG_ADDON" then
            local message, _ = ...
            if string.match(message, "target") then
                local zoneID, rareID = strsplit(",", message)
                zoneID = math.floor(string.gsub(zoneID, "target={", ""))
                rareID = math.floor(string.gsub(rareID, "}", ""))
                local rare
                for _, zone in ipairs(zones) do
                    if zone.id == zoneID then
                        for _, rare in ipairs(zone.rares) do
                            if rare.id == rareID then
                                local n = random(#targetMessages)
                                local zoneName = C_Map.GetMapInfo(zoneID).name
                                RaidNotice_AddMessage(RaidBossEmoteFrame, targetMessages[n] .. " " .. rare.name .. " @ " .. zoneName .. " " .. string.format("%.1f", rare.waypoint[1]) .. ", " .. string.format("%.1f", rare.waypoint[2]) .. "!", ChatTypeInfo["RAID_WARNING"])
                                ns:NewTarget(zone, rare)
                                break
                            end
                        end
                        break
                    end
                end
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        ns:EnsureMacro()
    elseif event == "WORLD_QUEST_COMPLETED_BY_SPELL" then
        if ns.Content and ns.Content.rares then
            ns:RefreshRares(ns.Content.rares)
        end
    elseif event == "MOUNT_JOURNAL_SEARCH_UPDATED" then
        if ns.Content and ns.Content.items then
            ns:RefreshItems(ns.Content.items)
        end
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
