local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

function PANEL:Init()
    self:SetContentAlignment(5)
    self:SetDrawBorder(true)
    self:SetPaintBackground(true)
    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self:SetCursor("hand")
    self:SetFont("DermaDefault")

    self.originalX = 0 -- Position X originale du bouton
    self.targetX = 0 -- Position X cible pour l'animation
    self.animationDuration = 0.2 -- Durée de l'animation en secondes
    self.animationStartTime = 0 -- Temps de départ de l'animation
    self.isAnimating = false -- Booléen pour suivre l'état de l'animation
end

function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "Button", self, w, h)
    return false
end

function PANEL:PerformLayout(w, h)
    -- Mettez en page votre bouton ici
end

function PANEL:SetConsoleCommand(strName, strArgs)
    self.DoClick = function(slf, val)
        RunConsoleCommand(strName, strArgs)
        slf:PlayClickSound()
    end
end

-- Fonction pour ajouter un son de survol
function PANEL:AddSound(soundPath)
    self.hoverSound = "monarch_library/hovered.wav"
    self.clickSound = "monarch_library/click_main.mp3"
end

-- Fonction pour ajouter l'animation
function PANEL:AddAnimation()
    self.hasAnimation = true
end

function PANEL:OnCursorEntered()
    if self.hoverSound then
        surface.PlaySound(self.hoverSound)
    end

    if self.hasAnimation then
        self.originalX, self.originalY = self:GetPos() -- Récupère la position initiale du bouton
        self.targetX = self.originalX + cw(10) -- Déplace le bouton de 10 pixels vers la droite
        self.animationStartTime = CurTime()
        self.isAnimating = true
    end
end

function PANEL:OnCursorExited()
    if self.hasAnimation then
        self.targetX = self.originalX -- Retourne le bouton à sa position d'origine
        self.animationStartTime = CurTime()
        self.isAnimating = true
    end
end

function PANEL:OnMousePressed(code)
    if code == MOUSE_LEFT and self:IsHovered() then
        if self.clickSound then
            surface.PlaySound(self.clickSound)
        end
        self:DoClick()
    end
end

function PANEL:Think()
    if self.isAnimating then
        local elapsedTime = CurTime() - self.animationStartTime
        local fraction = math.min(elapsedTime / self.animationDuration, 1)
        local newX = Lerp(fraction, self.originalX, self.targetX)

        self:SetPos(newX, self.originalY)

        if fraction == 1 then
            self.isAnimating = false
        end
    end
end

derma.DefineControl("Monarch_Button", "A standard Button", PANEL, "DLabel")
