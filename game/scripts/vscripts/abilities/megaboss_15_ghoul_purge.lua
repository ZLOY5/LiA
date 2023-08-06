
megaboss_15_ghoul_purge = class({})
LinkLuaModifier( "modifier_megaboss_15_ghoul_purge", "abilities/megaboss_15_ghoul_purge.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function megaboss_15_ghoul_purge:GetIntrinsicModifierName()
	return "modifier_megaboss_15_ghoul_purge"
end

--------------------------------------------------------------------------------


modifier_megaboss_15_ghoul_purge = class({})

function modifier_megaboss_15_ghoul_purge:IsHidden()
	return true 		
end

--------------------------------------------------------------------------------

function modifier_megaboss_15_ghoul_purge:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE} 	
end

--------------------------------------------------------------------------------

function modifier_megaboss_15_ghoul_purge:OnTakeDamage(keys)
	if IsServer() then 																
		if not self:GetParent():PassivesDisabled() then						
			if keys.unit == self:GetParent() then 							--Если атакованный юнит носитель модификатора(просто эвент получения урона вызывается при получении урона любым существом на карте)
				if keys.unit:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then   --Если атаковавший не союзник
					self.takeddmg = self.takeddmg + keys.damage			 --Прибавляем переменной полученый урон
					if self.takeddmg >= self.dmglimit then 							 --Проверка, если полученный урон превысил порог
						self:GetParent():Purge(false,true,false,true,false)			 --Пурж
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage_cast_mid.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
						ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
						self:GetParent():EmitSound("Hero_LifeStealer.Assimilate.Destroy")
						self.takeddmg = 0											 --Обнуление полученного урона(Если тебе еще нужно, чтобы полученый урон отбавлялся через некоторое время, то просто добавь таймер, который через некоторое время будет выполнять такую строку: self.takeddmg = self.takeddmg - keys.original_damage)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_megaboss_15_ghoul_purge:OnCreated()
	self.takeddmg = 0												--Объявляем переменную
	self.dmglimit = self:GetAbility():GetSpecialValueFor("damage_threshold")--Получаем переменную из кв
end

--------------------------------------------------------------------------------

function modifier_megaboss_15_ghoul_purge:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 		--Чтобы модификатор не убирался при смерти и при неуязвимости
end
