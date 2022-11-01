--https://github.com/wube/factorio-data/blob/99236f344ab972c01c4c0e50b6e6983cacdce060/core/lualib/noise.lua#L5
local function csloc(level)
  if level == nil then level = 0 end
  -- to debug.getinfo,
  --   1 = this very function (csloc)
  --   2 = the caller
  -- etc.
  -- we want our level = 0 to mean the caller of csloc,
  -- level = 1 to be the caller of that, etc.  So add 2.
  local info = debug.getinfo(level+2, "Sl")
  local filename
  if string.sub(info.source, 1, 1) == "@" then
    filename = string.sub(info.source, 2)
  else
    filename = "data:" .. info.source
  end
  return
  {
    filename = filename,
    line_number = info.currentline
  }
end

local function hasPyBarrel(proto)
  if proto.isPyPrototype or not proto.name:find("%-barrel$") then
    return nil
  end
  local target_fluid
  if proto.type == "item" or proto.type == "recipe" then
    target_fluid = proto.name:gsub("%-barrel$", "")
    target_fluid = target_fluid:gsub("^fill%-", "")
    target_fluid = target_fluid:gsub("^empty%-", "")
  else
    return nil
  end
  target_fluid = target_fluid and data.raw.fluid[target_fluid]
  return target_fluid and target_fluid.isPyPrototype
end

return function(mixed_data)
    local pre_data = mixed_data.pre_data
    local py_data = mixed_data.py_data
    local new_protos = {}
    for k, v in pairs(data.raw) do
        for kk, vv in pairs(v) do
            if py_data[k][kk] then
              vv.isPyPrototype = true
            elseif not pre_data[k][kk] then
              new_protos[#new_protos+1] = k .. "." .. kk
              vv.isPyPrototype = true
            else
              vv.isPyPrototype = hasPyBarrel(vv)
            end
        end
    end
    --log(csloc(1).filename .. "\tNEW PROTOS:")
    --log(serpent.block(new_protos))
    --log("END PROTOS")
end