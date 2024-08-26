-- Variables pour l'animation de l'alpha
function Monarch:IsHovered(control, width, height, baseColor, callback)
    -- Assurer que chaque bouton a son propre état d'animation
    if not control.animationState then
        control.animationState = {
            hover = false,
            hoverStartTime = 0,
            hoverDuration = 0.2, -- Durée de l'animation en secondes
            alphaStart = 0, -- Alpha initial (transparent)
            alphaEnd = 150, -- Alpha final (opaque)
        }
    end

    local state = control.animationState
    local isHovered = control:IsHovered()

    -- Démarrer l'animation si survolé
    if isHovered and not state.hover then
        state.hover = true
        state.hoverStartTime = CurTime()
    end

    -- Arrêter l'animation si pas survolé
    if not isHovered and state.hover then
        state.hover = false
        state.hoverStartTime = CurTime()
    end

    -- Calculer l'alpha actuel
    local t = 0
    if state.hover then
        t = (CurTime() - state.hoverStartTime) / state.hoverDuration
        t = math.min(t, 1) -- Assurer que t ne dépasse pas 1
    else
        t = 1 - ((CurTime() - state.hoverStartTime) / state.hoverDuration)
        t = math.max(t, 0) -- Assurer que t ne descend pas en dessous de 0
    end
    local alpha = Lerp(t, state.alphaStart, state.alphaEnd)

    -- Récupérer la couleur de base et ajuster l'alpha
    local color = table.Copy(baseColor) -- Copier la couleur de base
    color.a = alpha -- Ajuster l'alpha de la couleur

    if callback then
        callback(color)
    end
end