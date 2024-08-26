print("cl_circle_material.lua")

local PANEL = {}

function PANEL:Init()
    self.material = nil
    self.numSegments = 64  -- Nombre de segments pour dessiner le cercle
    self.zoom = 1
end

function PANEL:SetMaterial(material)
    self.material = material
    self:InvalidateLayout(true)
end

function PANEL:SetNumSegments(numSegments)
    self.numSegments = numSegments
end

function PANEL:SetZoom(zoom)
    self.zoom = math.Clamp(zoom, 1, 100) / 100  -- Convertir la valeur de zoom en un facteur entre 0.01 et 1
    self:InvalidateLayout(true)
end

function PANEL:Paint(w, h)
    if not self.material then return end

    local radius = math.min(w, h) / 2
    local centerX, centerY = w / 2, h / 2

    -- Enable stencils
    render.SetStencilEnable(true)
    render.ClearStencil()
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)

    -- Draw the circle stencil
    draw.NoTexture()
    surface.SetDrawColor(255, 255, 255, 255)

    local poly = {}
    for i = 0, self.numSegments - 1 do
        local theta = (i / self.numSegments) * 2 * math.pi
        local x = centerX + radius * math.cos(theta)
        local y = centerY + radius * math.sin(theta)
        table.insert(poly, { x = x, y = y })
    end

    surface.DrawPoly(poly)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_KEEP)

    -- Draw the material within the circle
    surface.SetMaterial(self.material)
    surface.SetDrawColor(255, 255, 255, 255)
    
    -- Zoom mode: draw the material centered and zoomed to fill the circle
    local materialWidth = self.material:Width()
    local materialHeight = self.material:Height()
    local aspectRatio = materialWidth / materialHeight
    local drawWidth, drawHeight

    if aspectRatio > 1 then
        drawHeight = h / self.zoom
        drawWidth = drawHeight * aspectRatio
    else
        drawWidth = w / self.zoom
        drawHeight = drawWidth / aspectRatio
    end

    local offsetX = (w - drawWidth) / 2
    local offsetY = (h - drawHeight) / 2
    surface.DrawTexturedRect(offsetX, offsetY, drawWidth, drawHeight)

    render.SetStencilEnable(false)
end

vgui.Register("Monarch_CircleMaterial", PANEL, "DPanel")
