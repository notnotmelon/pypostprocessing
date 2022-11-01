return function()
    local mt = {
        __index = function(self, k)
            if not rawget(self, k) then
                rawset(self, k, {})
            end
            return rawget(self, k)
        end
    }
    local py_data = setmetatable({}, mt)
    local pre_data = setmetatable({}, mt)
    for k, v in pairs(data.raw) do
        for kk, vv in pairs(v) do
            py_data[k][kk] = vv.isPyPrototype
            pre_data[k][kk] = not vv.isPyPrototype and true or nil
        end
    end
    return {pre_data = pre_data, py_data = py_data}
end