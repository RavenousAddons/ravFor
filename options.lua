local name, ns = ...
local L = ns.L

local small = 6
local medium = 12
local large = 16

local Options = CreateFrame("Frame", name .. "Options", InterfaceOptionsFramePanelContainer)
Options.name = ns.name
Options.controlTable = {}
Options.okay = function(self)
    for _, control in pairs(self.controls) do
        RAVFOR_data.options[control.var] = control:GetValue()
    end
    for _, control in pairs(self.controls) do
        if control.restart then
            ReloadUI()
        end
    end
end
Options.default = function(self)
    for _, control in pairs(self.controls) do
        RAVFOR_data.options[control.var] = true
    end
end
Options.cancel = function(self)
    for _, control in pairs(self.controls) do
        if control.oldValue and control.oldValue ~= control.getValue() then
            control:SetValue()
        end
    end
end
Options.refresh = function(self)
    ns:RefreshControls(self.controls)
end

Options:Hide()
Options:SetScript("OnShow", function()
    local width = Options:GetWidth() - (large * 2)
    local height = Options:GetHeight() - (large * 2)

    local Content = CreateFrame("Frame", name .. "OptionsContent", Options)
    Content:SetPoint("TOPLEFT", Options, "TOPLEFT", large, -large)
    Content:SetWidth(width)
    Content:SetHeight(height)

    local UIControls = {
        {
            type = "Label",
            name = name .. "OptionsTitle",
            parent = Options,
            label = ns.name .. " " .. ns.expansion .. " v" .. ns.version,
            relativeTo = Content,
            relativePoint = "TOPLEFT",
            offsetY = 0,
            fontObject = "GameFontNormalLarge",
        },
        {
            type = "Label",
            name = name .. "OptionsSubTitle",
            parent = Options,
            label = "|cffffffff" .. ns.notes .. "|r",
        },
        {
            type = "Label",
            name = name .. "OptionsHeading",
            parent = Options,
            label = L.OptionsHeading,
            fontObject = "GameFontNormalLarge",
        },
        {
            type = "Checkbox",
            parent = Options,
            label = L.MacroLabel,
            tooltip = string.format(L.MacroTooltip, ns.name),
            var = "macro",
        },
        {
            type = "Checkbox",
            parent = Options,
            label = L.ReputationLabel,
            tooltip = L.ReputationTooltip,
            var = "showReputation",
            needsRestart = true,
        },
        {
            type = "Checkbox",
            parent = Options,
            label = L.NoDropsLabel,
            tooltip = L.NoDropsTooltip,
            var = "showNoDrops",
            needsRestart = true,
        },
        {
            type = "Checkbox",
            parent = Options,
            label = L.CannotUseLabel,
            tooltip = L.CannotUseTooltip,
            var = "showCannotUse",
            needsRestart = true,
        },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = L.CollectedLabel,
        --     tooltip = L.CollectedTooltip,
        --     var = "showOwned",
        -- },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = "Gear Drops",
        --     tooltip = "Show gear-type Items.",
        --     var = "showGear",
        -- },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = "Transmog Drops",
        --     tooltip = "Show transmog Items.",
        --     var = "showTransmog",
        -- },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = "Mounts",
        --     tooltip = "Show dropped mounts.",
        --     var = "showMounts",
        -- },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = "Pets",
        --     tooltip = "Show dropped Pets.",
        --     var = "showPets",
        -- },
        -- {
        --     type = "Checkbox",
        --     parent = Options,
        --     label = "Toys",
        --     tooltip = "Show dropped Toys.",
        --     var = "showToys",
        -- },
        {
            type = "Label",
            name = "SupportHeading",
            parent = Options,
            label = L.SupportHeading,
            fontObject = "GameFontNormalLarge",
        },
        {
            type = "Label",
            name = "SubHeadingSupport1",
            parent = Options,
            label = "|cffffffff" .. string.format(L.Support1, ns.name) .. "|r",
        },
        {
            type = "Label",
            name = "SubHeadingSupport2",
            parent = Options,
            label = "|cffffffff" .. L.Support2 .. "|r",
        },
        {
            type = "Label",
            name = "SubHeadingSupport3",
            parent = Options,
            label = "|cffffffff" .. string.format(L.Support3, ns.discord) .. "|r",
        },
    }

    for _, control in pairs(UIControls) do
        if control.type == "Label" then
            ns:CreateLabel(control)
        elseif control.type == "Checkbox" then
            ns:CreateCheckbox(control)
        end
    end

    ns:RefreshControls(Options.controls)
    Options:SetScript("OnShow", nil)
end)
ns.Options = Options
