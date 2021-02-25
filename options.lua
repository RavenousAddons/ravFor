local ADDON_NAME, ns = ...
local L = ns.L

local small = 6
local medium = 12
local large = 16
local gigantic = 24

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
                ReloadUI()
            end
        end
    end
    Options.default = function(self)
        for _, Control in pairs(self.Controls) do
            RAVFOR_data.options[Control.var] = ns.defaults[Control.var]
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
    for _, Default in pairs(L.Defaults) do
        local defaultValue = ns.defaults[Default.var]
        if type(defaultValue) == "boolean" then
            local Checkbox = CreateFrame("CheckButton", ADDON_NAME .. "OptionsCheckbox" .. Default.var, Options, "InterfaceOptionsCheckButtonTemplate")
            Checkbox:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -large)
            Checkbox.Text:SetText(Default.text)
            Checkbox.tooltipText = Default.tooltip
            Checkbox.restart = false
            Checkbox.tooltipText = Checkbox.tooltipText .. "\n" .. RED_FONT_COLOR:WrapTextInColorCode(REQUIRES_RELOAD)

            Checkbox.GetValue = function(self)
                return self:GetChecked()
            end
            Checkbox.SetValue = function(self)
                self:SetChecked(RAVFOR_data.options[Default.var])
            end

            Checkbox:SetScript("OnClick", function(self)
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
                self.restart = not self.restart
                RAVFOR_data.options[Default.var] = self:GetChecked()
                RefreshControls(Options.Controls)
            end)

            RegisterControl(Checkbox, Options)
            previous = Checkbox
        end
    end

    ns.Options = Options
end
