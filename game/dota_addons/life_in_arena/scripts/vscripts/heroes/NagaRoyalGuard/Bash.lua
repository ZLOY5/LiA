function Bash(event)
	if event.caster:IsIllusion() then
		return 
	end

	local ability = event.ability
	local target = event.target

	target:AddNewModifier(event.caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
	target:EmitSound("DOTA_Item.MKB.Minibash")

--[[ if not string.find(target:GetUnitName(),"megaboss") and not target:IsHero() then
		target:AddNewModifier(event.caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
		target:EmitSound("DOTA_Item.MKB.Minibash")
	else
		if ability:IsCooldownReady() then
			target:AddNewModifier(event.caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
			target:EmitSound("DOTA_Item.MKB.Minibash")
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end]]--
end