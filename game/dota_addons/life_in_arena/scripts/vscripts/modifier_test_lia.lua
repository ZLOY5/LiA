modifier_test_lia = class({})


   
function modifier_test_lia:IsHidden()
	return true 
end


function modifier_test_lia:OnCreated(params)
	if IsClient() then
		SendToConsole("dota_camera_disable_zoom 1")
	end
	self:SetDuration(1,true)
end

function modifier_test_lia:OnDestroy()
	if IsClient() then
		SendToConsole("dota_camera_disable_zoom 0")
	end
end




