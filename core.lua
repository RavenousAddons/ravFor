local name, ns = ...
local L = ns.L

local expansion = ns.data.expansions[ns.expansion]
local zones = expansion.zones

function ravFor_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
    self:RegisterEvent("CHAT_MSG_CURRENCY")
    self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    self:RegisterEvent("UPDATE_FACTION")
    self:RegisterEvent("PLAYER_FLAGS_CHANGED")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
    self:RegisterEvent("NEW_TOY_ADDED")
    self:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
end

function ravFor_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            ns:SetDefaultOptions()
            InterfaceOptions_AddCategory(ns.Options)
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
                                local n = random(#L.TargetMessages)
                                local zoneName = C_Map.GetMapInfo(zoneID).name
                                local c = {}
                                for d in tostring(rare.waypoint):gmatch("[0-9][0-9]") do
                                    tinsert(c, d)
                                end
                                RaidNotice_AddMessage(RaidBossEmoteFrame, L.TargetMessages[n] .. " " .. rare.name .. " @ " .. zoneName .. " " .. c[1] .. "." .. c[2] .. ", " .. c[3] .. "." .. c[4] .. "!", ChatTypeInfo["RAID_WARNING"])
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
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    elseif event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" then
        if ns.currencies then
            ns:RefreshCurrencies()
        end
    elseif event == "UPDATE_FACTION" then
        if ns.factions then
            ns:RefreshFactions()
        end
    elseif event == "PLAYER_FLAGS_CHANGED" then
        if ns.warmodes then
            ns:RefreshWarmodes()
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subtype = CombatLogGetCurrentEventInfo()
        if subtype == "UNIT_DIED" or subtype == "UNIT_DESTROYED" then
            if ns.rares then
                ns:RefreshRares()
            end
        end
    elseif event == "MOUNT_JOURNAL_SEARCH_UPDATED" or event == "PET_JOURNAL_LIST_UPDATE" or event == "NEW_TOY_ADDED" then
        if ns.items then
            ns:RefreshItems()
        end
    elseif event == "COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED" then
        if ns.covenant and ns.renown then
            ns:RefreshCovenant()
        end
    end
end

SlashCmdList["RAVFOR"] = function(message, editbox)
    local command, argument = strsplit(" ", message)
    if command == "version" or command == "v" then
        ns:PrettyPrint(string.format(L.Version, ns.version))
    elseif message == "c" or string.match(message, "con") or message == "h" or string.match(message, "help") or message == "o" or string.match(message, "opt") or message == "s" or string.match(message, "sett") or string.match(message, "togg") then
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
        InterfaceOptionsFrame_OpenToCategory(ns.Options)
    else
        if (ns.Window:IsVisible()) then ns.Window:Hide() else ns.Window:Show() end
    end
end
SLASH_RAVFOR1 = "/" .. ns.command
SLASH_RAVFOR2 = "/r4"
