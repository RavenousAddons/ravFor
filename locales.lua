local name, ns = ...

local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

-- Default (English)
L.Version = "%s is the current version." -- ns.version
L.Install = "Thanks for installing |cff%1$sv%2$s|r!" -- ns.color, ns.version
L.Update = "Thanks for updating to |cff%1$sv%2$s|r!" -- ns.color, ns.version

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
