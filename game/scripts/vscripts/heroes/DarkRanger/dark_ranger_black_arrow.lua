---@class dark_ranger_black_arrow:CDOTA_Ability_Lua
dark_ranger_black_arrow = class({})

LinkLuaModifier("modifier_dark_ranger_black_arrow", "heroes/DarkRanger/dark_ranger_black_arrow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_ranger_black_arrow_debuff", "heroes/DarkRanger/dark_ranger_black_arrow", LUA_MODIFIER_MOTION_NONE)

function dark_ranger_black_arrow:GetIntrinsicModifierName()
	return "modifier_dark_ranger_black_arrow"
end

function dark_ranger_black_arrow:GetManaCost(level)
	if self:GetCaster():HasModifier("dark_ranger_fury") then return 0 end
	return self.BaseClass.GetManaCost(self, level)
end

---@class modifier_dark_ranger_black_arrow:CDOTA_Modifier_Lua
modifier_dark_ranger_black_arrow = class({})

function modifier_dark_ranger_black_arrow:IsHidden() return true end
function modifier_dark_ranger_black_arrow:IsPurgable() return false end
function modifier_dark_ranger_black_arrow:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_dark_ranger_black_arrow:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self:OnRefresh()
end

function modifier_dark_ranger_black_arrow:OnRefresh()
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_dark_ranger_black_arrow:GetOrbProjectileName()
	return "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"
end

function modifier_dark_ranger_black_arrow:IsOrbActive(event)
	if self.parent:GetCurrentActiveAbility() ~= self.ability and not self.ability:GetAutoCastState() then return false end
	if event.target:IsMagicImmune() then return false end

	if self.ability:IsFullyCastable() and self.ability:IsOwnersManaEnough() and self.ability:IsCooldownReady() then return true end
end

function modifier_dark_ranger_black_arrow:OnOrbFire(event)
	self.ability:UseResources(true, true, true, true)
end

function modifier_dark_ranger_black_arrow:OnOrbImpact(event)
	local target = event.target

	target:EmitSound("Hero_Medusa.MysticSnake.Target")

	if not target:IsBuilding() and not target:IsHero() and not target:IsIllusion() 
	and not target:HasModifier("modifier_kill") and not string.find(target:GetUnitName(),"megaboss") then 
		target:AddNewModifier(self.parent, self.ability, "modifier_dark_ranger_black_arrow_debuff", {duration = self.duration})
	end

	ApplyDamage({
		victim = target,
		attacker = self.parent,
		damage = self.ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	})
end


---@class modifier_dark_ranger_black_arrow_debuff:CDOTA_Modifier_Lua
modifier_dark_ranger_black_arrow_debuff = class({})

function modifier_dark_ranger_black_arrow_debuff:OnDestroy()
	if IsClient() then return end

	local parent = self:GetParent()

	if not parent:IsAlive() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local lifetime = ability:GetSpecialValueFor("lifetime")

		local creep = CreateUnitByName(parent:GetUnitName(), parent:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		creep:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		creep:AddNewModifier(caster, ability, "modifier_kill", {duration = lifetime})
		creep:AddNewModifier(caster, ability, "modifier_dark_ranger_black_arrow_unit", nil)
		creep:SetRenderColor(249, 127, 127)
		creep:MakeIllusion()
		creep:SetAcquisitionRange(800)

		ResolveNPCPositions(creep:GetAbsOrigin(),65)
	end
end

---@class modifier_dark_ranger_black_arrow_illusion:CDOTA_Modifier_Lua
modifier_dark_ranger_black_arrow_unit = class({})

function modifier_dark_ranger_black_arrow_unit:IsHidden() return true end
function modifier_dark_ranger_black_arrow_unit:IsPurgable() return false end

function modifier_dark_ranger_black_arrow_unit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IS_ILLUSION,
	}
end

function modifier_dark_ranger_black_arrow_unit:GetIsIllusion() return 1 end
