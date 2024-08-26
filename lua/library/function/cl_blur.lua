
local blur = Material("pp/blurscreen")

function Monarch:DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    
    -- Dessiner plusieurs copies de la texture pour augmenter l'intensité du flou
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    
    for i = 1, amount do
        blur:SetFloat("$blur", (i / amount) * 5)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end