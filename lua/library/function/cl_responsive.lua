print("sh_responsive.lua has been loaded")

function cw(pixels, base)
    base = base or 1920
    return ScrW() / (base / pixels)
end

function ch(pixels, base)
    base = base or 1080
    return ScrH() / (base / pixels)
end