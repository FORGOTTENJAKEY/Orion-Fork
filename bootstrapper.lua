local _b = {
    104,116,116,112,115,58,47,47,114,97,119,46,
    103,105,116,104,117,98,117,115,101,114,99,111,
    110,116,101,110,116,46,99,111,109,47,70,79,
    82,71,79,84,84,69,78,74,65,75,69,89,47,
    79,114,105,111,110,45,70,111,114,107,47,114,
    101,102,115,47,104,101,97,100,115,47,109,97,
    105,110,47,118,101,114,115,105,111,110,115,47,
    118,37,115,47,109,97,105,110,46,108,117,97
}; local lat = "1.0"

return function(v)
    v = v or lat
    local s, r = pcall(function()
        local l = ""
        for _, bt in ipairs(_b) do l ..= string.char(bt) end

        local function ft(ver)
            local fi = l:format(ver)
            local ok, res = pcall(function()
                return loadstring(game:HttpGet(fi))()
            end)
            return ok, res
        end

        local s2, res = ft(v)
        if not s2 and v ~= lat then
            warn(`[OrionFork: Bootstrapper]: v{v} not found, falling back to v{lat}`)
            s2, res = ft(lat)
        end

        if not s2 then
            warn(`[OrionFork: Bootstrapper]: Failed to fetch. Please retry.`)
            return nil
        end

        return res
    end)

    if not s then
        warn(`[OrionFork: Bootstrapper]: Internal error. ({r})`)
        return nil
    end

    return r
end
