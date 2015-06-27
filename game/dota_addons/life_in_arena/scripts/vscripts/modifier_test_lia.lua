modifier_test_lia = class({})
   

function modifier_test_lia:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_test_lia:OnCreated(params)
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetParent(), damage = 100, damage_type = DAMAGE_TYPE_PURE})
	end
end


function modifier_test_lia:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			print("OnTakeDamage")
					
			for k,v in pairs(params) do 
					print(k,v)
					
				end
			print("------------------------")
			params.unit:RemoveModifierByName("modifier_test_lia")
		end
	end
end


