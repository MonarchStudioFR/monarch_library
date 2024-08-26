print("load sh_networking.lua")

if SERVER then
    util.AddNetworkString("Monarch.Net")
end

Monarch = Monarch or {}
Monarch.NetsList = Monarch.NetsList or {}

function Monarch:NetReceive(strName, fnCallback)
    Monarch.NetsList[strName] = fnCallback
end

function Monarch:NetStart(strName, ...)
    local dataToSend = {...}

    -- Construction des données brutes en une seule table
    local rawData = {
        strName = strName,
        data = dataToSend
    }

    -- Sérialisation des données en une chaîne de caractères
    local rawDataSerialized = util.TableToJSON(rawData)

    -- Compression des données
    local compressedData = util.Compress(rawDataSerialized)

    -- Envoi des données compressées
    net.Start("Monarch.Net")
    net.WriteData(compressedData, #compressedData)

    if SERVER then
        if select(#dataToSend, ...) then
            local pTo = select(#dataToSend, ...)
            net.Send(pTo)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
end

net.Receive("Monarch.Net", function(_, pSender)
    if SERVER then
        pSender.lastNetSent = pSender.lastNetSent or 0
        if pSender.lastNetSent > CurTime() then 
            return DarkRP.notify(pSender, 1, 5, "Monarch: Net delay") 
        end
        pSender.lastNetSent = CurTime() + 0.2
    end

    -- Lecture des données compressées
    local compressedData = net.ReadData(net.BytesLeft())

    -- Décompression des données
    local decompressedData = util.Decompress(compressedData)

    -- Désérialisation des données
    local rawData = util.JSONToTable(decompressedData)
    local strName = rawData.strName
    local dataReceived = rawData.data

    if not Monarch.NetsList[strName] then return end

    if SERVER then
        Monarch.NetsList[strName](pSender, unpack(dataReceived))
    else
        Monarch.NetsList[strName](unpack(dataReceived))
    end
end)


/*
print("load sh_networking.lua")

if SERVER then
    util.AddNetworkString("Monarch.Net")
end

Monarch = Monarch or {}
Monarch.NetsList = Monarch.NetsList or {}

-- Types de données supportés
local keyType = {
    ["table"] = 1,
    ["string"] = 2,
    ["number"] = 3,
    ["boolean"] = 4,
    ["nil"] = 5,
    ["Entity"] = 6
}

-- Inverse des types pour la lecture
local typeKey = {
    [1] = "table",
    [2] = "string",
    [3] = "number",
    [4] = "boolean",
    [5] = "nil",
    [6] = "Entity"
}

function Monarch:NetReceive(strName, fnCallback)
    Monarch.NetsList[strName] = fnCallback
end

function Monarch:NetStart(strName, ...)
    local dataToSend = {...}

    net.Start("Monarch.Net")
        net.WriteString(strName)
        net.WriteUInt(#dataToSend, 8) -- On écrit le nombre de paramètres

        for _, data in ipairs(dataToSend) do
            local dataType = type(data)
            local sInt = keyType[dataType] or 5
            net.WriteUInt(sInt, 3)

            if sInt == 1 then
                net.WriteTable(data or {})
            elseif sInt == 2 then
                net.WriteString(data or "")
            elseif sInt == 3 then
                net.WriteFloat(data or 0)
            elseif sInt == 4 then
                net.WriteBool(data or false)
            elseif sInt == 6 then
                net.WriteEntity(data or NULL)
            end
        end

    if SERVER then
        if select(#dataToSend, ...) then
            local pTo = select(#dataToSend, ...)
            net.Send(pTo)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
end

net.Receive("Monarch.Net", function(_, pSender)
    if SERVER then
        pSender.lastNetSent = pSender.lastNetSent or 0
        if pSender.lastNetSent > CurTime() then 
            return DarkRP.notify(pSender, 1, 5, "Monarch: Net delay") 
        end
        pSender.lastNetSent = CurTime() + 0.2
    end

    local strName = net.ReadString()
    local paramCount = net.ReadUInt(8) -- Lire le nombre de paramètres envoyés
    local dataReceived = {}

    for i = 1, paramCount do
        local sInt = net.ReadUInt(3)
        local data

        if sInt == 1 then
            data = net.ReadTable()
        elseif sInt == 2 then
            data = net.ReadString()
        elseif sInt == 3 then
            data = net.ReadFloat()
        elseif sInt == 4 then
            data = net.ReadBool()
        elseif sInt == 6 then
            data = net.ReadEntity()
        end

        table.insert(dataReceived, data)
    end

    if not Monarch.NetsList[strName] then return end

    if SERVER then
        Monarch.NetsList[strName](pSender, unpack(dataReceived))
    else
        Monarch.NetsList[strName](unpack(dataReceived))
    end
end)
