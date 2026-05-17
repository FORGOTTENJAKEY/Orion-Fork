local _b = {
    104,116,116,112,115,58,47,47,114,97,119,46,
    103,105,116,104,117,98,117,115,101,114,99,111,
    110,116,101,110,116,46,99,111,109,47,70,79,
    82,71,79,84,84,69,78,74,65,75,69,89,47,
    79,114,105,111,110,45,70,111,114,107,47,109,
    97,105,110,47,118,101,114,115,105,111,110,115,
    47,118,37,115,47,109,97,105,110,46,108,117,
    97
}

local lat = "1.0"

return function(v)
    v = v or lat
    local s, r = pcall(function()
        local url = ""
        for _, byte in ipairs(_b) do url = url .. string.char(byte) end

        local function fetch(ver)
            local fi = url:format(ver)
            local ok, res = pcall(function()
                return loadstring(game:HttpGet(fi))()
            end)
            return ok, res
        end

        local ok, res = fetch(v)

        if not ok and v ~= lat then
            warn("[OrionFork: Bootstrapper]: v" .. v .. " not found, falling back to v" .. lat)
            ok, res = fetch(lat)
        end

        if not ok then
            warn("[OrionFork: Bootstrapper]: Failed to fetch. Please retry.")
            return nil
        end

        return res
    end)

    if not s then
        warn("[OrionFork: Bootstrapper]: Internal error. (" .. tostring(r) .. ")")
        return nil
    end

    return r
end
