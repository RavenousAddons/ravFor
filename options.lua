local ADDON_NAME, ns = ...
local L = ns.L

local small = 6
local medium = 12
local large = 16
local gigantic = 24

---
-- Options Controls
---

local OptionsControls = {
    {
        type = "Label",
        name = ADDON_NAME .. "OptionsTitle",
        label = ns.name .. " " .. ns.expansion .. " v" .. ns.version,
        relativeTo = ns.Options,
        relativePoint = "TOPLEFT",
        offsetY = 0,
        fontObject = "GameFontNormalLarge",
    },
    {
        type = "Label",
        name = ADDON_NAME .. "OptionsSubTitle",
        label = "|cffffffff" .. ns.notes .. "|r",
    },
    {
        type = "Label",
        name = ADDON_NAME .. "OptionsHeading",
        label = L.OptionsHeading,
        fontObject = "GameFontNormalLarge",
    },
    {
        type = "Checkbox",
        label = L.MacroLabel,
        tooltip = string.format(L.MacroTooltip, ns.name),
        var = "macro",
    },
    {
        type = "Label",
        name = "SupportHeading",
        label = L.SupportHeading,
        fontObject = "GameFontNormalLarge",
    },
    {
        type = "Label",
        name = "SubHeadingSupport1",
        label = "|cffffffff" .. string.format(L.Support1, ns.name) .. "|r",
    },
    {
        type = "Label",
        name = "SubHeadingSupport2",
        label = "|cffffffff" .. L.Support2 .. "|r",
    },
    {
        type = "Label",
        name = "SubHeadingSupport3",
        label = "|cffffffff" .. string.format(L.Support3, ns.discord) .. "|r",
    },
}

---
-- Local Options Functions
---

local function RegisterControl(Control, Parent)
    if (not Parent) or (not Control) then
        return
    end
    Parent.Controls = Parent.Controls or {}
    table.insert(Parent.Controls, Control)
end

local function RefreshControls(Controls)
    for _, Control in pairs(Controls) do
        Control:SetValue(Control)
        Control.oldValue = Control:GetValue()
    end
end

---
-- Global Options Functions
---

function ns:RegisterDefaultOption(key, value)
    if RAVFOR_data.options[key] == nil then
        RAVFOR_data.options[key] = value
    end
end

function ns:SetDefaultOptions()
    if RAVFOR_data == nil then
        RAVFOR_data = {}
    end
    if RAVFOR_data.options == nil then
        RAVFOR_data.options = {}
    end
    for k, v in pairs(ns.defaults) do
        ns:RegisterDefaultOption(k, v)
    end
end

function ns:BuildOptions()
    local Options = CreateFrame("Frame", ADDON_NAME .. "Options", InterfaceOptionsFramePanelContainer)
    Options.name = ns.name .. " " .. ns.expansion
    Options.controlTable = {}
    Options.okay = function(self)
        for _, Control in pairs(self.Controls) do
            RAVFOR_data.options[Control.var] = Control:GetValue()
            if Control.restart then
                print("restart")
                ReloadUI()
            else
                print("nah")
            end
        end
    end
    Options.default = function(self)
        for _, Control in pairs(self.Controls) do
            RAVFOR_data.options[Control.var] = true
        end
    end
    Options.cancel = function(self)
        for _, Control in pairs(self.Controls) do
            if Control.oldValue and Control.oldValue ~= Control.getValue() then
                Control:SetValue()
            end
        end
    end
    Options.refresh = function(self)
        RefreshControls(self.Controls)
    end

    local OptionsHeading = Options:CreateFontString(ADDON_NAME .. "OptionsHeading", "ARTWORK", "GameFontNormalLarge")
    OptionsHeading:SetPoint("TOPLEFT", Options, "TOPLEFT", large, -large)
    OptionsHeading:SetJustifyH("LEFT")
    OptionsHeading:SetText(ns.name .. " " .. ns.expansion .. " v" .. ns.version)

    local OptionsSubHeading = Options:CreateFontString(ADDON_NAME .. "OptionsSubHeading", "ARTWORK", "GameFontNormal")
    OptionsSubHeading:SetPoint("TOPLEFT", OptionsHeading, "BOTTOMLEFT", 0, -large)
    OptionsSubHeading:SetJustifyH("LEFT")
    OptionsSubHeading:SetText("|cffffffff" .. ns.notes .. "|r")

    local OptionsConfiguration = Options:CreateFontString(ADDON_NAME .. "OptionsConfiguration", "ARTWORK", "GameFontNormalLarge")
    OptionsConfiguration:SetPoint("TOPLEFT", OptionsSubHeading, "BOTTOMLEFT", 0, -gigantic)
    OptionsConfiguration:SetJustifyH("LEFT")
    OptionsConfiguration:SetText(L.Configuration .. ":")

    local previous = OptionsConfiguration
    for k, v in pairs(ns.defaults) do
        local Checkbox = CreateFrame("CheckButton", ADDON_NAME .. "OptionsCheckbox" .. k, Options, "InterfaceOptionsCheckButtonTemplate")
        Checkbox:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -large)
        Checkbox.Text:SetText(L.Defaults[k].text)
        Checkbox.tooltipText = L.Defaults[k].tooltip
        Checkbox.restart = false
        Checkbox.tooltipText = Checkbox.tooltipText .. "\n" .. RED_FONT_COLOR:WrapTextInColorCode(REQUIRES_RELOAD)

        Checkbox.GetValue = function(self)
            return self:GetChecked()
        end
        Checkbox.SetValue = function(self)
            self:SetChecked(RAVFOR_data.options[k])
        end

        Checkbox:SetScript("OnClick", function(self)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            self.restart = not self.restart
            RAVFOR_data.options[k] = self:GetChecked()
            RefreshControls(Options.Controls)
        end)

        RegisterControl(Checkbox, Options)
        previous = Checkbox
    end

    ns.Options = Options
end
