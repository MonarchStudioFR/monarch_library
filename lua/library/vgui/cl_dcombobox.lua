local PANEL = {}

Derma_Hook(PANEL, "Paint", "Paint", "ComboBox")
Derma_Install_Convar_Functions(PANEL)
AccessorFunc(PANEL, "m_bDoSort", "SortItems", FORCE_BOOL)

function PANEL:Init()
    self.DropButton = vgui.Create("DPanel", self)
    self.DropButton.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "ComboDownArrow", panel, w, h)
    end
    self.DropButton:SetMouseInputEnabled(false)
    self.DropButton.ComboBox = self

    self:SetFont("MAIN_Font:S16")
    self:SetTextColor(color_white)

    self:SetTall(22)
    self:Clear()

    self:SetContentAlignment(4)
    self:SetTextInset(8, 0)
    self:SetIsMenu(true)
    self:SetSortItems(true)

    self.hoverColor = color_white -- Définir une couleur par défaut
    self.slideColor = color_white -- Définir une couleur par défaut
end

function PANEL:Clear()
    self:SetText("")
    self:SetTextColor(color_white)
    self.Choices = {}
    self.Data = {}
    self.ChoiceIcons = {}
    self.Spacers = {}
    self.selected = nil

    if (self.Menu) then
        self.Menu:Remove()
        self.Menu = nil
    end
end

function PANEL:SetHoverColor(color)
    self.hoverColor = color
end

function PANEL:SetSlideColor(color)
    self.slideColor = color
end

function PANEL:GetOptionText(id)
    return self.Choices[id]
end

function PANEL:GetOptionData(id)
    return self.Data[id]
end

function PANEL:GetOptionTextByData(data)
    for id, dat in pairs(self.Data) do
        if (dat == data) then
            return self:GetOptionText(id)
        end
    end

    -- Try interpreting it as a number
    for id, dat in pairs(self.Data) do
        if (dat == tonumber(data)) then
            return self:GetOptionText(id)
        end
    end

    -- In case we fail
    return data
end

function PANEL:PerformLayout(w, h)
    self.DropButton:SetSize(15, 15)
    self.DropButton:AlignRight(4)
    self.DropButton:CenterVertical()
    self:SetTextColor(color_white)
    -- Make sure the text color is updated
    DButton.PerformLayout(self, w, h)
end

function PANEL:ChooseOption(value, index)
    if (self.Menu) then
        self.Menu:Remove()
        self.Menu = nil
    end

    self:SetText(value)
    self:SetTextColor(color_white)
    self:SetFont("MAIN_Font:S16")

    self.selected = index
    self:OnSelect(index, value, self.Data[index])
end

function PANEL:ChooseOptionID(index)
    local value = self:GetOptionText(index)
    self:ChooseOption(value, index)
end

function PANEL:GetSelectedID()
    return self.selected
end

function PANEL:GetSelected()
    if (not self.selected) then return end
    return self:GetOptionText(self.selected), self:GetOptionData(self.selected)
end

function PANEL:OnSelect(index, value, data)
    -- For override
end

function PANEL:OnMenuOpened(menu)
    -- For override
end

function PANEL:AddSpacer()
    self.Spacers[#self.Choices] = true
end

function PANEL:AddChoice(value, data, select, icon)
    local i = table.insert(self.Choices, value)

    if (data) then
        self.Data[i] = data
    end
    
    if (icon) then
        self.ChoiceIcons[i] = icon
    end

    if (select) then
        self:ChooseOption(value, i)
    end

    return i
end

function PANEL:IsMenuOpen()
    return IsValid(self.Menu) and self.Menu:IsVisible()
end

function PANEL:OpenMenu()
    if self:IsMenuOpen() then
        self:CloseMenu()
    end

    if #self.Choices == 0 then return end

    local parent = self
    while IsValid(parent) and not parent:IsModal() do
        parent = parent:GetParent()
    end
    if not IsValid(parent) then parent = self end

    self.Menu = DermaMenu(false, parent)
    self.Menu:SetMinimumWidth(self:GetWide())

    for k, v in pairs(self.Choices) do
        local option = self.Menu:AddOption(v, function() self:ChooseOption(v, k) end)
        if self.ChoiceIcons[k] then
            option:SetIcon(self.ChoiceIcons[k])
        end

        option:SetTextColor(color_white)

        option.OnCursorEntered = function()
            option.Paint = function(_, w, h)
                surface.SetDrawColor(self.hoverColor)
                surface.DrawRect(0, 0, w, h)
            end
            option:SetFont("MAIN_Font:R10") -- Set hover font
        end

        option.OnCursorExited = function()
            option.Paint = nil
            option:SetFont("MAIN_Font:B09") -- Revert to normal font
        end
    end

    local x, y = self:LocalToScreen(0, self:GetTall())
    self.Menu:Open(x, y, false, self)

    self.Menu.Paint = function(_, w, h)
        surface.SetDrawColor(self.slideColor)
        surface.DrawRect(0, 0, w, h)
    end

    self:OnMenuOpened(self.Menu)
end

function PANEL:CloseMenu()
    if (IsValid(self.Menu)) then
        self.Menu:Remove()
    end
end

function PANEL:CheckConVarChanges()
    if (not self.m_strConVar) then return end
    local strValue = GetConVarString(self.m_strConVar)
    if (self.m_strConVarValue == strValue) then return end
    self.m_strConVarValue = strValue
    self:SetValue(self:GetOptionTextByData(self.m_strConVarValue))
end

function PANEL:Think()
    self:CheckConVarChanges()
end

function PANEL:SetValue(strValue)
    self:SetText(strValue)
end

function PANEL:DoClick()
    if (self:IsMenuOpen()) then
        return self:CloseMenu()
    end
    self:OpenMenu()
end

function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
    local ctrl = vgui.Create(ClassName)
    ctrl:AddChoice("Some Choice")
    ctrl:AddChoice("Another Choice", "myData")
    ctrl:AddChoice("Default Choice", "myData2", true)
    ctrl:AddChoice("Icon Choice", "myData3", false, "icon16/star.png")
    ctrl:SetWide(150)
    PropertySheet:AddSheet(ClassName, ctrl, nil, true, true)
end

derma.DefineControl("Monarch_ComboBox", "", PANEL, "DButton")