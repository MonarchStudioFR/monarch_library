print("LOAD vgui/portland_dtextentry.lua")

local PANEL = {}

AccessorFunc(PANEL, "m_strPlaceholder", "Placeholder", FORCE_STRING)
AccessorFunc(PANEL, "m_BackColor", "BackColor") 
AccessorFunc(PANEL, "m_TextColor", "TextColor")  
AccessorFunc(PANEL, "m_HighlightColor", "HighlightColor", FORCE_COLOR)


function PANEL:Init()
    self:SetText("")
    self:SetFont("MAIN_Font:R18")
    self:SetPlaceholder("")
    self:SetTextColor(Color(64, 64, 64))
    self:SetBackColor(Color(36, 36, 36))
    self:SetDrawLanguageID(false)
    
    self.AllCharacter = false
    self.hasFocus = false
    self.numeric = false
    self.minValue = nil
    self.maxValue = nil
    
    self.OnGetFocus = function(self)
        self.hasFocus = true
        if self:GetText() == self:GetPlaceholder() then
            self:SetText("")
        end
    end
    
    self.OnLoseFocus = function(self)
        self.hasFocus = false
        if self:GetText() == "" then
            self:SetText(self:GetPlaceholder())
        end
    end
end

function PANEL:SetNumeric(isNumeric)
    self.numeric = isNumeric
end

function PANEL:SetMinValue(minValue)
    self.minValue = tonumber(minValue)
end

function PANEL:SetMaxValue(maxValue)
    self.maxValue = tonumber(maxValue)
end

function PANEL:SetAllEnable(bEnable)
    self.AllCharacter = bEnable
end

function PANEL:SetRondedBox(bEnable)
    self.RoundedBox = bEnable
end

function PANEL:Paint(intW, intH)

    if self.RoundedBox then
        draw.RoundedBox(5, 0, 0, intW, intH, self:GetBackColor())  -- Utilisation de la couleur de fond définie
    else
        surface.SetDrawColor(self:GetBackColor())
        surface.DrawRect(0, 0, intW, intH)
    end

    if not self.hasFocus and self:GetPlaceholder() ~= "" and self:GetText() == "" then
        draw.SimpleText(self:GetPlaceholder(), self:GetFont(), 5, intH * 0.5, self:GetTextColor(), 0, 1)
    else
        local highlightColor = self:GetHighlightColor() or Color(38, 63, 118)
        self:DrawTextEntryText(self:GetTextColor(), highlightColor, self:GetTextColor())
    end
end

function PANEL:AllowInput(char)

    if self.AllCharacter then
        return false
    elseif self.numeric then
        return not char:match("%d")  -- Permet seulement les chiffres
    else
        -- Permet seulement les caractères alphabétiques et les accents
        return char:match("[%aÀ-ÖØ-öø-ÿ]") == nil
    end
end

function PANEL:OnValueChange(value)
    if self.numeric then
        local numValue = tonumber(value)
        if numValue then
            if self.minValue and numValue < self.minValue then
                self:SetText(self.minValue)
            elseif self.maxValue and numValue > self.maxValue then
                self:SetText(self.maxValue)
            end
        end
    end
end

function PANEL:HasValue()
    local text = self:GetText()
    return text ~= nil and text ~= "" and text ~= self:GetPlaceholder()
end

vgui.Register("Monarch_DTextEntry", PANEL, "DTextEntry")
