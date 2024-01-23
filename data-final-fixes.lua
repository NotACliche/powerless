equipment={}

for t, types in pairs(data.raw) do
  if t ~= "generator" then
    for p, prototype in pairs(types) do
      
      -- fix for combinator entities
      if string.find(t, "combinator") then prototype.energy_source = {type = "void"} end

      -- fix for lamp entities
      if t=="lamp" then prototype.energy_source = {type = "void"} end

      -- fix for power switch entities
      if t=="power-switch" then prototype.energy_source = {type = "void"} end

      -- fix for speaker entities
      if t=="programmable-speaker" then prototype.energy_source = {type = "void"} end

      -- gather generator equipment for decomissioning
      if prototype.type=="generator-equipment" then
        -- log(string.format("generator: %s",p))
        table.insert(equipment, prototype)
      
      -- gather solar panels for decomissioning
      elseif prototype.type=="solar-panel-equipment" then
        -- log(string.format("solar panel: %s",p))
        table.insert(equipment, prototype)
      end

      -- personal roboport fix
      if t == "roboport-equipment" then
        prototype.burner = {
          type = "burner",
          fuel_inventory_size = 1
        }
        for i = 1, prototype.charging_energy:len(), 1 do
          if tonumber(prototype.charging_energy:sub(-i,-i)) ~= nil then
            prototype.power = tonumber(prototype.charging_energy:sub(1,-i)) * prototype.charging_station_count * 0.875 .. prototype.charging_energy:sub(-i+1)
            break
          end
        end
        prototype.energy_source.input_flow_limit = "0W"
      end

      -- normal entity check
      if prototype.energy_source and not string.find(p,"infinity") and prototype.energy_source.type == "electric" and (prototype.energy_source.usage_priority and (prototype.energy_source.usage_priority == "primary-input" or prototype.energy_source.usage_priority == "secondary-input")) then
        -- long list of things so stuff doesn't break
        if not string.find(t, "equipment") and p ~= "roboport" and p ~= "beacon" and p ~= "laser-turret" and p ~= "arithmetic-combinator" and p ~= "decider-combinator" and p ~= "constant-combinator" and p ~= "programmable-speaker" and p ~= "power-switch" then

          -- make everything burner :p
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
      else
        -- disable extra generators
        if t == "generator-equipment" then
          -- log(string.format("checked: %s",p))
          for e, eq in pairs(equipment) do
            -- log(string.format("against: %s",eq.name))
            -- log(string.format("checking %s against %s",prototype.placed_as_equipment_result, eq.name))
            -- log(string.format("checking %s against %s",prototype.name, eq.take_result))
            if eq.name==p then
              -- log(string.format("removed: %s",p))
              -- prototype.placed_as_equipment_result=nil
              data.raw["item"][p].placed_as_equipment_result=nil
              -- eq.take_result=nil
              data.raw["generator-equipment"][eq.name].take_result=nil
              -- log(string.format("check: prototype %s?",prototype.placed_as_equipment_result))
              -- log(string.format("check: generator %s?",eq.take_result))
            end
          end
        end
        -- disable extra solar panels
        if t == "solar-panel-equipment" then
          -- log(string.format("checked: %s",p))
          for e, eq in pairs(equipment) do
            -- log(string.format("against: %s",eq.name))
            -- log(string.format("checking %s against %s",prototype.placed_as_equipment_result, eq.name))
            -- log(string.format("checking %s against %s",prototype.name, eq.take_result))
            if eq.name==p then
              -- log(string.format("removed: %s",p))
              -- prototype.placed_as_equipment_result=nil
              data.raw["item"][p].placed_as_equipment_result=nil
              -- eq.take_result=nil
              data.raw["solar-panel-equipment"][eq.name].take_result=nil
              -- log(string.format("check: prototype %s?",prototype.placed_as_equipment_result))
              -- log(string.format("check: solar panel %s?",eq.take_result))
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