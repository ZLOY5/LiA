function RemoveInvalidModifies(hero,ItemName,ModifierName)
	--print("RemoveInvalidModifies| ItemName:"..ItemName.." ModifierName:"..ModifierName)
	local ItemCount=0
	for i=0,5 do
		local curr_item=hero:GetItemInSlot(i)
		if curr_item and curr_item:GetName()==ItemName then
			ItemCount=ItemCount+1
		end
	end
	
	local ModifierCount=0
	for i=0,hero:GetModifierCount() do
		if ModifierName==hero:GetModifierNameByIndex(i) then
			if ModifierCount<ItemCount then
				ModifierCount=ModifierCount+1
			else
				hero:RemoveModifierByName(ModifierName)
			end
		end
	end
end

function CheckItemModifies(hero)
	--print("CheckItemModifies!")
	local ModifiesChecked={}
	for i=0,hero:GetModifierCount()-1 do
		local ModifierName=hero:GetModifierNameByIndex(i)
		local ModifierClass=hero:FindModifierByName(ModifierName)
		local ItemName=nil
		--print("Modifier Index:"..tostring(i).." Name:"..ModifierName)
		if ModifierClass then
			local CheckCount=0
			local Ability=ModifierClass:GetAbility()
			if Ability then
				--确认Ability为物品
				if Ability:IsItem() then 
					CheckCount=CheckCount+1 
					ItemName=Ability:GetName()
				end 
			else
				if ModifierName:sub(0,14)=="modifier_item_" then
					CheckCount=CheckCount+1
					ItemName=ModifierName:sub(10)
				end
			end
			
			
			--确认Modifier未检测
			if not ModifiesChecked[ModifierName] then CheckCount=CheckCount+1 end
			
			--确认持续时间为-1
			if ModifierClass:GetDuration()==-1 then CheckCount=CheckCount+1 end
			
			--确认不可堆叠
			if ModifierClass:GetStackCount()==0 then CheckCount=CheckCount+1 end
			
			--确认Caster为自己
			if ModifierClass:GetCaster()==hero then CheckCount=CheckCount+1 end
			
			--确认Attributes为 MODIFIER_ATTRIBUTE_PERMANENT | MODIFIER_ATTRIBUTE_MULTIPLE
			if (CDOTA_Modifier_Lua.GetAttributes(ModifierClass)==MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE) then
				CheckCount=CheckCount+1
			end
			
			--print("CheckCount:"..tostring(CheckCount))
			if CheckCount==6 then
				ModifiesChecked[ModifierName]=true
				RemoveInvalidModifies(hero,ItemName,ModifierClass:GetName())
			end
		end
	end
end