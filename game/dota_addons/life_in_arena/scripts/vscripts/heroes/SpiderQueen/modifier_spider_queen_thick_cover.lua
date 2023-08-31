modifier_spider_queen_thick_cover = class({})

function modifier_spider_queen_thick_cover:IsHidden()
	return true
end

function modifier_spider_queen_thick_cover:IsPurgable()
	return false
end

function modifier_spider_queen_thick_cover:OnCreated( kv )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_spider_queen_thick_cover:OnRefresh( kv )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_spider_queen_thick_cover:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_spider_queen_thick_cover:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end