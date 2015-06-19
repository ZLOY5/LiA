modifier_test_lia = class({})

function modifier_test_lia:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}
 
	return funcs
end


function modifier_test_lia:OnTakeDamage(params)
	if IsServer() then
		print("OnTakeDamage")
				
		for k,v in pairs(params) do 
				print(k,v)
				
			end
		print("------------------------")
	end
end

function modifier_test_lia:OnAttackRecord(params)
	if IsServer() then
		print("OnAttackRecord")
				
		for k,v in pairs(params) do 
				print(k,v)
				
			end
			print("------------------------")
	end
end

function modifier_test_lia:OnAttackLanded(params)
	if IsServer() then
		print("OnAttackLanded")
				
			for k,v in pairs(params) do 
				print(k,v)
				
			end
			print("------------------------")
		
	end
end
