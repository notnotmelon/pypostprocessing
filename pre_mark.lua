return function()
    local pre_data = {}
    for k, v in pairs(data.raw) do
        pre_data[k] = pre_data[k] or {}
        for kk in pairs(v) do
            pre_data[k][kk] = true
        end
    end
    return pre_data
end