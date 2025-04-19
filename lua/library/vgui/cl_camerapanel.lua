local PANEL = {}

function PANEL:Init()
    self:SetSize(640, 480)
    self:Center()

    self.camPos = Vector(0, 0, 0)
    self.camAng = Angle(0, 0, 0)

    self.readyToRender = false
    self.rendered = false
    self.uniqueID = "default"
end

function PANEL:SetID(id)
    self.uniqueID = tostring(id)

    local rtName = "MC_Camera_RT_" .. self.uniqueID
    self.rt = GetRenderTarget(rtName, 640, 480, false)

    self.mat = CreateMaterial("MC_Camera_Mat_" .. self.uniqueID, "UnlitGeneric", {
        ["$basetexture"] = rtName,
        ["$ignorez"] = 1,
        ["$vertexcolor"] = 1,
        ["$vertexalpha"] = 1
    })
end

function PANEL:SetCameraPos(pos)
    self.camPos = pos
end

function PANEL:SetCameraAng(ang)
    self.camAng = ang
end

function PANEL:Think()
    if not self.rendered and self.readyToRender then
        self:RenderOnce()
    end
end

function PANEL:RenderOnce()
    self.rendered = true

    local hiddenEnts = {}
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and (ent:IsPlayer() or ent:GetClass() == "prop_physics") then
            ent:SetNoDraw(true)
            table.insert(hiddenEnts, ent)
        end
    end

    render.PushRenderTarget(self.rt)
    render.Clear(0, 0, 0, 255, true, true)

    render.RenderView({
        origin = self.camPos,
        angles = self.camAng,
        fov = 90,
        znear = 5,
        zfar = 1000,
        drawhud = false,
        drawviewmodel = false
    })

    render.PopRenderTarget()

    for _, ent in ipairs(hiddenEnts) do
        if IsValid(ent) then ent:SetNoDraw(false) end
    end
end

function PANEL:Paint(w, h)
    if not self.rendered and not self.readyToRender then
        self.readyToRender = true
        return
    end

    if self.mat then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end
end

vgui.Register("Monarch_CameraPanel", PANEL, "DPanel")
