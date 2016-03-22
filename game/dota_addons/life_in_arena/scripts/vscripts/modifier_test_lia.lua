modifier_test_lia = class({})


   
function modifier_test_lia:IsHidden()
	return true 
end


function modifier_test_lia:OnCreated(params)
	if IsClient() then
		SendToConsole("dota_camera_disable_zoom 1")
		self:StartIntervalThink(0.1)
	end
end

function modifier_test_lia:OnIntervalThink()
	if IsClient() then
		SendToConsole("dota_camera_disable_zoom 0")
	end
	self:Destroy()
	return nil
end




