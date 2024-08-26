print("LOAD vgui/cl_portland_notify.lua")

local notifications = {}  -- Liste des notifications actives

net.Receive("NET_Monarch_Notify", function(_, ply)
    local type = net.ReadUInt(4)
    local title = net.ReadString()
    local text = net.ReadString()
    
    local time = 5
    local endTime = CurTime() + time 

    -- Calculer la position de la nouvelle notification
    local yPos = ch(10)
    for _, frame in ipairs(notifications) do
        yPos = yPos + frame:GetTall() + ch(10)
    end

    local tMaterial
    if type == 1 then
        tMaterial = CONFIG.MAIN.MATERIAL.info_notify
    elseif type == 2 then
        tMaterial = CONFIG.MAIN.MATERIAL.level_notify
    elseif type == 3 then
        tMaterial = CONFIG.MAIN.MATERIAL.sucess_notify
    elseif type == 4 then
        tMaterial = CONFIG.MAIN.MATERIAL.classement_notify
    elseif type == 5 then
        tMaterial = CONFIG.MAIN.MATERIAL.exp_notify
    else 
        print("type de notification inconnu : ".. type)
        tMaterial = CONFIG.MAIN.MATERIAL.default_notify
    end

    surface.PlaySound(CONFIG.MAIN.SOUND.notif)

    local frame = vgui.Create("DFrame")
    frame:SetSize(cw(300), ch(100))
    frame:SetPos(ScrW(), yPos)  -- Position initiale à droite en dehors de l'écran
    frame:SetTitle("")
    frame:ShowCloseButton()
    frame:SetDraggable()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, CONFIG.MAIN.COLOR.blue)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(CONFIG.MAIN.MATERIAL.background_notify)
        surface.DrawTexturedRect(cw(2), ch(2), w - cw(4), h - ch(4))

        local timeRemaining = endTime - CurTime()
        local barWidth = w * (timeRemaining / time)

        draw.RoundedBoxEx(8, 0, h - ch(10), w, ch(10), CONFIG.MAIN.COLOR.main, false, false, true, true)
        draw.RoundedBoxEx(8, 0, h - ch(10), barWidth, ch(10), CONFIG.MAIN.COLOR.outlined, false, false, true, true)

        draw.SimpleText(title, "MAIN_Font:R12", cw(10), ch(20), color_white, 0, 1)
        Monarch_DrawText(text, "MAIN_Font:B10", cw(10), ch(35), self:GetWide() - cw(50), CONFIG.MAIN.COLOR.text2, 0)
        
        surface.SetDrawColor(color_white)
        surface.SetMaterial(tMaterial)
        surface.DrawTexturedRect(w - cw(20 + 50), h / 2 - ch(50 / 2 + 5), ch(50), ch(50))
    end

    -- Ajouter la notification à la liste des notifications actives
    table.insert(notifications, frame)

    -- Animer l'entrée depuis la droite
    frame:MoveTo(ScrW() - frame:GetWide() - cw(10), yPos, 0.5, 0, -1, function()
        timer.Simple(time, function()
            frame:MoveTo(ScrW(), frame.y, 0.5, 0, -1, function()
                if IsValid(frame) then
                    frame:Close()
                end

                -- Supprimer la notification de la liste des notifications actives
                for i, v in ipairs(notifications) do
                    if v == frame then
                        table.remove(notifications, i)
                        break
                    end
                end

                -- Repositionner les notifications restantes
                for i, v in ipairs(notifications) do
                    local newPos = ch(10) + (i - 1) * (v:GetTall() + ch(10))
                    v:MoveTo(v.x, newPos, 0.5, 0, -1)
                end
            end)
        end)
    end)
end)

if SERVER then

    util.AddNetworkString("NET_Monarch_Notify")
    function Monarch_Notify(ply, type, title, text)
        if not ply:IsValid() and not ply:IsPlayer() then return end
        
        net.Start("NET_Monarch_Notify")
            net.WriteUInt(type, 4)
            net.WriteString(title)
            net.WriteString(text)
        net.Send(ply)
    end

    concommand.Add("Absurdity_Notify", function(ply)

        for i=1, 5 do 
            Monarch_Notify(ply, i, "Convoyeur - Experience", "Vous avez gagné **100xp en convoyeur.**")
        end
    end)
    
end
