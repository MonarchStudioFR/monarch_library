function Monarch:Pattern(x, y, w, h, material, color, texSize, speed, dirX, dirY)
    local time = CurTime() * speed

    local uOffset = (time * dirX) % 1
    local vOffset = (time * dirY) % 1

    surface.SetDrawColor(color or color_white)
    surface.SetMaterial(material)

    local tilesX = math.ceil(w / texSize) + 1
    local tilesY = math.ceil(h / texSize) + 1

    for i = 0, tilesX do
        for j = 0, tilesY do
            local drawX = x + (i - 1) * texSize
            local drawY = y + (j - 1) * texSize

            local u1 = uOffset
            local v1 = vOffset
            local u2 = uOffset + 1
            local v2 = vOffset + 1

            surface.DrawTexturedRectUV(drawX, drawY, texSize, texSize, u1, v1, u2, v2)
        end
    end
end
