local ADDON_NAME, ns = ...

local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

-- Default (English)
L.Version = "%s is the current version." -- ns.version
L.NotLoaded = "Please wait a moment while data is populated."
L.Install = "Thanks for installing |cff%1$sv%2$s|r! You can open the interface with |cff%1$s/%3$s|r." -- ns.color, ns.version, ns.command
L.Update = "Thanks for updating to |cff%1$sv%2$s|r! You can open the interface with |cff%1$s/%3$s|r." -- ns.color, ns.version, ns.command
L.Defaults = {
    {
        var = "macro",
        text = "Automatically create macro",
        tooltip = "When enabled, a macro called |cffffffff" .. ns.name .. "|r will be automatically created and managed for you under |cffffffffGeneral Macros|r.",
    },
    {
        var = "minimapButton",
        text = "Display Minimap button",
        tooltip = "When enabled, a button will be attached to your Minimap that can open/close the window.",
    },
    {
        var = "showReputation",
        text = "Show Reputation gains",
        tooltip = "When enabled, the list will show which Rares award reputation upon killing them.",
    },
    {
        var = "showOwned",
        text = "Show Collected Items",
        tooltip = "When enabled, Items which you have already collected will appear in lists.",
    },
    {
        var = "showCannotUse",
        text = "Show Items you cannot use",
        tooltip = "When enabled, Items which you cannot use (wrong Class/Covenant/etc.) will appear in lists.",
    },
    {
        var = "showNoDrops",
        text = "Show Rares with no drops/no reputation",
        tooltip = "When enabled, Rares which neither drop items nor award currency or reputation will appear in lists.",
    },
}
L.SupportHeading = "Help and Support:"
L.Support1 = "This Addon creates and maintains a macro called |r%s|cffffffff for you under |rGeneral Macros|cffffffff." -- ns.name
L.Support2 = "Check out the Addon on |rGitHub|cffffffff, |rWoWInterface|cffffffff, or |rCurse|cffffffff for more info and support!"
L.Support3 = "You can also get help directly from the author on Discord: |r%s|cffffffff" -- ns.discord
L.Faction = "%1$s with %2$s" -- Reputation Level, Faction Name
L.Reputation = "+%1$s Reputation with %2$s" -- Reputation Value, Faction Name
L.Drops = "drops:"
L.OnlyFor = " only for "
L.SummonedBy = ", summoned by "
L.TargetMessages = {
    "Moving out to",
    "Let's go and delete",
    "We ride for",
}
L.NoMacroSpace = "Unfortunately, you don't have enough global macro space for the macro to be created!"
L.alpha = "You must go to a rested area to disable War Mode."
L.beta = "You must go to %s to enable War Mode." -- factionCity

-- Check locale and assign appropriate
local CURRENT_LOCALE = GetLocale()

-- English
if CURRENT_LOCALE == "enUS" then return end

-- German
if CURRENT_LOCALE == "deDE" then return end

-- Spanish
if CURRENT_LOCALE == "esES" then return end

-- Latin-American Spanish
if CURRENT_LOCALE == "esMX" then return end

-- French
if CURRENT_LOCALE == "frFR" then return end

-- Italian
if CURRENT_LOCALE == "itIT" then return end

-- Brazilian Portuguese
if CURRENT_LOCALE == "ptBR" then return end

-- Russian
if CURRENT_LOCALE == "ruRU" then return end

-- Korean
if CURRENT_LOCALE == "koKR" then return end

-- Simplified Chinese
if CURRENT_LOCALE == "zhCN" then return end

-- Traditional Chinese
if CURRENT_LOCALE == "zhTW" then return end

-- Swedish
if CURRENT_LOCALE == "svSE" then return end
