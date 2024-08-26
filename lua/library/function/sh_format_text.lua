print("LAOD sh_fonction/sh_format_text.lua")

function Monarch_FormatNumer(number)
    local formatted = tostring(number)
    local integerPart, fractionalPart = formatted:match("^(%d*)(%.?%d*)$")

    if integerPart == "" then
        integerPart = "0"
    end

    -- Format the integer part
    local k = #integerPart % 3
    if k == 0 and #integerPart > 0 then k = 3 end

    local result = integerPart:sub(1, k)
    for i = k + 1, #integerPart, 3 do
        result = result .. " " .. integerPart:sub(i, i + 2)
    end

    -- Append the fractional part if it exists
    if fractionalPart and fractionalPart ~= "" then
        result = result .. fractionalPart
    end

    return result
end


