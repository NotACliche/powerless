for t, types in pairs(data.raw) do
  if t ~= "generator" and not string.find(t, "combinator") then
    for p, prototype in pairs(types) do
      if prototype.energy_source and prototype.energy_source.type == "electric" and (prototype.energy_source.usage_priority and (prototype.energy_source.usage_priority == "primary-input" or prototype.energy_source.usage_priority == "secondary-input")) then
        -- edge case personal equipment
        if p == "personal-roboport-equipment" then
          prototype.burner = {
            type = "burner",
            fuel_inventory_size = 1
          }
          prototype.power = "2MW"
          prototype.energy_source.input_flow_limit = "0W"
        end
        if p == "personal-roboport-mk2-equipment" then
          prototype.burner = {
            type = "burner",
            fuel_inventory_size = 1
          }
          prototype.power = "3.5MW"
          prototype.energy_source.input_flow_limit = "0W"
        end
        -- normal entities
        if not string.find(t, "equipment") and p ~= "roboport" and p ~= "beacon" and p ~= "laser-turret" and p ~= "arithmetic-combinator" and p ~= "decider-combinator" and p ~= "constant-combinator" and p ~= "programmable-speaker" and p ~= "power-switch" then
          prototype.energy_source = {
            type = "burner",
            fuel_inventory_size = 1
          }

          -- inserter manupulation
          if t == "inserter" then
            -- energy bump
            prototype.energy_per_movement = tostring(tonumber(prototype.energy_per_movement:sub(1,1)) + 1)..prototype.energy_per_movement:sub(2)
            prototype.energy_per_rotation = tostring(tonumber(prototype.energy_per_rotation:sub(1,1)) + 1)..prototype.energy_per_rotation:sub(2)
            -- energy multiplier
            for i = 1, string.len(prototype.energy_per_movement) do
              if tonumber(string.sub(prototype.energy_per_movement, i, i)) ~= nil then
                prototype.energy_per_movement = prototype.energy_per_movement:sub(1,i).."0"..prototype.energy_per_movement:sub(i+1)
                break
              end
            end
            for i = 1, string.len(prototype.energy_per_rotation) do
              if tonumber(string.sub(prototype.energy_per_rotation, i, i)) ~= nil then
                prototype.energy_per_rotation = prototype.energy_per_rotation:sub(1,i).."0"..prototype.energy_per_rotation:sub(i+1)
                break
              end
            end

            -- multiply energy usage by setting
            for i = 1, prototype.energy_per_movement:len(), 1 do
              if tonumber(prototype.energy_per_movement:sub(-i,-i)) ~= nil then
                prototype.energy_per_movement = tonumber(prototype.energy_per_movement:sub(1,-i)) * settings.startup["burner-multiplier"].value .. prototype.energy_per_movement:sub(-i+1)
                break
              end
            end
            for i = 1, prototype.energy_per_rotation:len(), 1 do
              if tonumber(prototype.energy_per_rotation:sub(-i,-i)) ~= nil then
                prototype.energy_per_rotation = tonumber(prototype.energy_per_rotation:sub(1,-i)) * settings.startup["burner-multiplier"].value .. prototype.energy_per_rotation:sub(-i+1)
                break
              end
            end
          end

          -- non inserter manipulation
          if t ~= "inserter" then
            -- energy bump
            prototype.energy_usage = tostring(tonumber(prototype.energy_usage:sub(1,1)) + 0)..prototype.energy_usage:sub(2)
            -- energy multuplier
            for i = 1, string.len(prototype.energy_usage) do
              if tonumber(string.sub(prototype.energy_usage, i, i)) ~= nil then
                prototype.energy_usage = prototype.energy_usage:sub(1,i)..""..prototype.energy_usage:sub(i+1)
                break
              end
            end
            
            -- multiply energy usage by setting
            for i = 1, prototype.energy_usage:len(), 1 do
              if tonumber(prototype.energy_usage:sub(-i,-i)) ~= nil then
                prototype.energy_usage = tonumber(prototype.energy_usage:sub(1,-i)) * settings.startup["burner-multiplier"].value .. prototype.energy_usage:sub(-i+1)
                break
              end
            end
          end
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