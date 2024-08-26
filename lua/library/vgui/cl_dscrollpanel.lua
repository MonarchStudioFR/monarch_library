local PANEL = {}

function PANEL:Init()
    self.VBar:SetWide(10)

    -- Custom scrollbar painting
    function self.VBar:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 150))
    end

    function self.VBar.btnUp:Paint(w, h) end

    function self.VBar.btnDown:Paint(w, h) end
    
    function self.VBar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 150))
    end

    -- Smooth scrolling effect
    self.targetScroll = 0
    self.currentScroll = 0

    self.hasScrollbar = self.VBar:IsVisible()
end

function PANEL:SmoothScroll(delta)
    self.targetScroll = self.targetScroll + delta
    local maxScroll = self:GetCanvas():GetTall() - self:GetTall()
    self.targetScroll = math.Clamp(self.targetScroll, 0, maxScroll)
end

function PANEL:OnMouseWheeled(delta)
    self:SmoothScroll(delta * -50)
    return true
end

function PANEL:Think()
    self.currentScroll = Lerp(0.05, self.currentScroll, self.targetScroll)
    self.VBar:SetScroll(self.currentScroll)
end

function PANEL:UpdateChildrenWidth()
    local hasScrollbar = self.VBar:IsVisible()
    local widthAdjustment = hasScrollbar and cw(15) or 0

    for _, child in ipairs(self:GetCanvas():GetChildren()) do
        if not child.originalWidth then
            child.originalWidth = child:GetWide()
        end
        child:SetWide(child.originalWidth - widthAdjustment)
    end
end

function PANEL:PerformLayout()
    self:UpdateChildrenWidth()
end

function PANEL:Paint(w, h)
    -- No background paint
end

vgui.Register("Monarch_ScrollPanel", PANEL, "DScrollPanel")
