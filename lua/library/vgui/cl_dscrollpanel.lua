local PANEL = {}

function PANEL:Init()
    self.VBar:SetWide(10)

    -- Style de la scrollbar
    function self.VBar:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 150))
    end

    function self.VBar.btnUp:Paint(w, h) end
    function self.VBar.btnDown:Paint(w, h) end

    function self.VBar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100, 150))
    end

    -- Smooth scroll vars
    self.targetScroll = 0
    self.currentScroll = 0

    -- On enlève tout ce qui modifie les enfants
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
    self.currentScroll = Lerp(0.1, self.currentScroll, self.targetScroll)
    self.VBar:SetScroll(self.currentScroll)
end

-- On override PerformLayout pour que la scrollbar soit par-dessus
function PANEL:PerformLayout(width, height)
    local scrollBar = self.VBar
    local canvas = self:GetCanvas()

    -- On layout le canvas normalement
    local canvasWidth = width
    local canvasHeight = canvas:GetTall()

    canvas:SetWide(canvasWidth)

    scrollBar:SetUp(height, canvasHeight)
    scrollBar:SetTall(height)
    scrollBar:SetPos(width - scrollBar:GetWide(), 0) -- Important : positionné par-dessus à droite

    canvas:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    -- Pas de fond
end

vgui.Register("Monarch_ScrollPanel", PANEL, "DScrollPanel")
