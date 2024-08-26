print("LOAD")

Monarch = Monarch or {}

local function LoadFiles(path)
	local files, _ = file.Find(path .. "/*", "LUA")

	for _, v in pairs(files) do
		if string.sub(v, 1, 3) == "sh_" then
			local filePath = path .. "/" .. v
			print("Attempting to load shared file: " .. filePath)
			if CLIENT then
				include(filePath)
			else
				AddCSLuaFile(filePath)
				include(filePath)
			end
		end
	end

	for _, v in pairs(files) do
		local filePath = path .. "/" .. v
		if string.sub(v, 1, 3) == "cl_" then
			print("Attempting to load client file: " .. filePath)
			if CLIENT then
				include(filePath)
			else
				AddCSLuaFile(filePath)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			print("Attempting to load server file: " .. filePath)
			include(filePath)
		end
	end
end

local function Initialize()
	LoadFiles("library")
	LoadFiles("library/function")
	LoadFiles("library/utils")
	LoadFiles("library/vgui")

end

timer.Simple(0, function()
	Initialize()
end)
