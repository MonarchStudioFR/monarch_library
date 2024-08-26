print("load function sh_imgur.lua")

function Monarch_ImgurToMaterial(link, callback, parameter)
    local id = string.match(link, "imgur%.com/(%w+)")
    if not id then
        return
    end

    if file.Exists("monarch/imgur/" .. id .. ".png", "DATA") then
        callback(Material("../data/monarch/imgur/" .. id .. ".png", parameter or nil))
        return
    end

    http.Fetch("https://i.imgur.com/" .. id .. ".png",
        function(body, length, headers, code)
            if not file.IsDir("monarch/imgur/", "DATA") then
                file.CreateDir("monarch/imgur/")
            end
            file.Write("monarch/imgur/" .. id .. ".png", body)
            callback(Material("../data/monarch/imgur/" .. id .. ".png", parameter or nil))
        end,
        function(message)
            print("Failed to fetch Imgur image:", message)
            callback(Material("error"))
        end
    )
end
    