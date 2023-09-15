require('timers')

function Spawn(entityKeyValues)
	Timers:CreateTimer(0.01,function()
		thisEntity:SetRenderColor(0,0,0)

   		local model = thisEntity:FirstMoveChild()
	    while model ~= nil do
	        if  model:GetClassname() == "dota_item_wearable" then
	            	model:SetRenderColor(0,0,0)
	        end
	        model = model:NextMovePeer()
	    end		
	end)
end