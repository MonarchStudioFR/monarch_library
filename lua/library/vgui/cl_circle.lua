function DrawCircle(posx, posy, radius, progress, color)
	local poly = { }
	local v = 220
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress+0.5 do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end