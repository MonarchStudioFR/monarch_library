print("LOAD sh_functions/sh_mc_drawtext.lua")

function Monarch_DrawText(text, font, x, y, panelWidth, defaultColor, alignX, alignY)
    -- Fonction pour dessiner une ligne de texte avec des mots colorés
    local function DrawLineOfText(line, font, x, y, defaultColor, alignX)
        surface.SetFont(font)

        local currentX = x
        for _, wordData in ipairs(line) do
            local word = wordData.word
            local wordColor = wordData.color or defaultColor
            local wordWidth = surface.GetTextSize(word)
            
            -- Dessiner le mot avec la couleur appropriée
            draw.DrawText(word, font, currentX, y, wordColor, alignX)
            currentX = currentX + wordWidth + surface.GetTextSize(" ")
        end
    end
    
    -- Fonction pour découper le texte en lignes
    local function SplitTextIntoLines(text, panelWidth)
        local lines = {}
        local words = string.Explode(" ", text)
        local line = {}
        local lineWidth = 0
        local inGold = false

        for _, word in ipairs(words) do
            local wordWidth = surface.GetTextSize(word)

            if lineWidth + wordWidth > panelWidth then
                table.insert(lines, line)
                line = {}
                lineWidth = 0
            end

            -- Vérifier si le mot commence ou se termine par **
            if word:sub(1, 2) == "**" then
                inGold = true
                word = word:sub(3)
            end

            if word:sub(-2) == "**" then
                word = word:sub(1, -3)
                table.insert(line, {word = word, color = CONFIG.MAIN.COLOR.gold})
                inGold = false
            else
                table.insert(line, {word = word, color = inGold and CONFIG.MAIN.COLOR.gold or nil})
            end

            lineWidth = lineWidth + wordWidth + surface.GetTextSize(" ")
        end

        if #line > 0 then
            table.insert(lines, line)
        end

        return lines
    end
    
    local lines = SplitTextIntoLines(text, panelWidth)

    -- Dessiner chaque ligne
    local offsetY = y
    for _, lineData in ipairs(lines) do
        DrawLineOfText(lineData, font, x, offsetY, defaultColor, alignX)
        offsetY = offsetY + select(2, surface.GetTextSize("A")) * 1.2 -- Ajustement de l'espacement entre les lignes
    end
end
