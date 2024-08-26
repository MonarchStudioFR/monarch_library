local PANEL = {}

local scale_h = ScrH()

-- Accessor functions for colors
AccessorFunc(PANEL, "m_ColorSlider", "SliderColor", FORCE_COLOR)
AccessorFunc(PANEL, "m_ColorFill", "FillColor", FORCE_COLOR)
AccessorFunc(PANEL, "m_ColorBackground", "BackgroundColor", FORCE_COLOR)

function PANEL:Init()
    -- Set default colors
    self:SetSliderColor(Color(45, 71, 122))
    self:SetFillColor(Color(38, 63, 118))
    self:SetBackgroundColor(Color(125, 125, 125))
    
    self:SetSize(cw(600), ch(20)) -- Taille par défaut
    self:SetDecimals(0) -- Définit le nombre de décimales à 0 pour des valeurs entières
    
    function self.Slider.Knob:Paint(w, h)
        draw.RoundedBox(30, 0, 0, w, h, Color( 240, 240, 240)) -- Dessine le bouton avec la couleur définie
    end

    function self.Slider:Paint() end -- Désactive le dessin du slider

    function self:Paint(w, h)
        local coef = math.Remap(self:GetValue(), self:GetMin(), self:GetMax(), 0, 1)

        -- Dessine la barre de fond
        draw.RoundedBox(0, 0, h * 0.5 - scale_h * 0.005 / 2, w * 0.99, scale_h * 0.008, self:GetBackgroundColor())
        
        -- Dessine la barre de remplissage
        draw.RoundedBox(0, 0, h * 0.5 - scale_h * 0.005 / 2, w * coef * 0.99, scale_h * 0.008, self:GetFillColor())
    end

    self.TextArea:SetVisible(false) -- Cache la zone de texte
    self.Label:SetVisible(false) -- Cache le label
end

-- Definition of the control
derma.DefineControl("Monarch_DNumSlider", "PSlider", PANEL, "DNumSlider")
