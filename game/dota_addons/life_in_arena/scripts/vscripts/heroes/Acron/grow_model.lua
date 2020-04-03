if IsServer() then
    function Spawn(entityKeyValues)
        Timers:CreateTimer(0.01,function()
            print("fjkdsjfgnskdjgbkdsjf")
            thisEntity:SetOriginalModel("models/heroes/tiny_04/tiny_04.vmdl")
            thisEntity:NotifyWearablesOfModelChange(true)
            return 0
        end)
    end
end