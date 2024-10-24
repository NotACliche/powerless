function burner(prototype)
  prototype.energy_source = {
    type = "burner",
    fuel_inventory_size = 1,
    smoke = data.raw["mining-drill"]["burner-mining-drill"].energy_source.smoke
  }
end

function adjust(usage, ext_mult)
  if usage == nil then return end
  local new_usage = 0
  local non_numbers = ""
  local multiplier = 12.25
  for i = 1, usage:len() do -- or maybe strlen(obj)
    if tonumber(usage:sub(-i,-i)) ~= nil then
      new_usage = new_usage + usage:sub(-i,-i) * 10^(i - non_numbers:len() - 1)
    else
      non_numbers = usage:sub(-i,-i) .. non_numbers
    end
  end
  return tostring(new_usage * (ext_mult or multiplier) * settings.startup["burner-multiplier"].value) .. non_numbers
end

for t, types in pairs(data.raw) do
  if t ~= "generator" and t ~= "lamp" and t ~= "electric-turret"  and t ~= "roboport" and t ~= "beacon" and t ~= "electric-turret" and t ~= "arithmetic-combinator" and t ~= "decider-combinator" and t ~= "constant-combinator" and t ~= "programmable-speaker" and t ~= "power-switch" and t ~= "item" and t ~= "recipe" and t ~= "tile" and t ~= "technology" and t ~= "fluid" and not t:find("category") then
    for p, prototype in pairs(types) do
      
      -- fix for combinator entities
      if string.find(t, "combinator") then prototype.energy_source = {type = "void"} end

      -- fix for lamp entities
      if t=="lamp" then prototype.energy_source = {type = "void"} end

      -- fix for power switch entities
      if t=="power-switch" then prototype.energy_source = {type = "void"} end

      -- fix for speaker entities
      if t=="programmable-speaker" then prototype.energy_source = {type = "void"} end

      -- personal roboport fix
      if t == "roboport-equipment" then
        prototype.burner = {
          type = "burner",
          fuel_inventory_size = 1
        }
        prototype.power = adjust(prototype.charging_energy, prototype.charging_station_count)
        prototype.energy_source.input_flow_limit = "0W"
      end

      -- long list of things so stuff doesn't break
      if not t:find("equipment") and prototype.energy_source and prototype.energy_source.type == "electric" and prototype.energy_source.usage_priority and prototype.energy_source.usage_priority:find("input") then

        -- make everything burner :p
        burner(prototype)

        -- inserter changes
        if t == "inserter" then
          -- energy bump
          prototype.energy_per_movement = adjust(prototype.energy_per_movement)
          prototype.energy_per_rotation = adjust(prototype.energy_per_rotation)
        else
          -- non-inserter changes
          prototype.energy_usage = adjust(prototype.energy_usage)
        end
      end
    end
  end
end

-- inserter leech setting
if settings.startup["inserter-leech"].value then
  for p, prototype in pairs(data.raw["inserter"]) do
    prototype.allow_burner_leech = true
  end
end

data.raw.inserter["burner-inserter"].next_upgrade = "inserter"