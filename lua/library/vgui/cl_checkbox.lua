local PANEL = {}

local cw, ch = ScrW(), ScrH()

function PANEL:Init()
    self:SetText("")
    self:SetSize(cw*0.1949, ch*0.05)
    self.RCDLerp = 0
    self.MCActivate = false
    self.RCDLerpColor = color_white
end

function PANEL:Paint(w, h)
    self.RCDLerp = Lerp(FrameTime() * 12, self.RCDLerp, self.MCActivate and h or 0)

    DrawCircle(h / 2, h / 2, h / 2, 1, Color(64, 64, 64))

    DrawCircle(h / 2, h / 2, self.RCDLerp / 2, 1, Color(45, 71, 122))

    local scale = math.floor(self.RCDLerp) * 1.2
    local divisedScale = math.floor(scale / 2)

    if self.MCActivate then
		surface.SetDrawColor(self.RCDLerpColor)
		surface.SetMaterial(Monarch_ImgurToMaterial("zyDyOg1"))
		surface.DrawTexturedRect(w / 2 - h * 0.3, h / 2 - h * 0.3, h * 0.6, h * 0.6)
    end

end


function PANEL:DoClick()
    self.MCActivate = !self.MCActivate
    surface.PlaySound( "monarch_library/click_main.mp3" )
    self:OnChange(self.MCActivate)
end

function PANEL:GetActive()
    return self.MCActivate
end

function PANEL:SetActive(bool)
    self.MCActivate = bool
end


derma.DefineControl("Monarch_CheckBox", "Monarch CheckBox", PANEL, "DButton")
