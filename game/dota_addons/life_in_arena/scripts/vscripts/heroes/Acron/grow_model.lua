if IsServer() then
    function Spawn(entityKeyValues)
        Timers:CreateTimer({
            useGameTime = false,
            --endTime = 0.01, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
                -- thisEntity:SetOriginalModel("models/heroes/tiny/tiny_03/tiny_03.vmdl")
                -- thisEntity:NotifyWearablesOfModelChange(false)
                local model_name = thisEntity:GetModelName()
                if not (model_name == "models/items/tiny/scarlet_quarry/scarlet_quarry01.vmdl") then
                    local new_model_name = string.gsub(model_name,"01","03")
                    thisEntity:SetOriginalModel(new_model_name)
                else
                    thisEntity:SetOriginalModel("models/items/tiny/scarlet_quarry/scarlet_quarry_03.vmdl")
                end
            end
          })
    end
end