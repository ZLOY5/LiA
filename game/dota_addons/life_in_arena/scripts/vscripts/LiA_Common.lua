
function CalcPlayers()
	local playercounter = 0
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer(nPlayerID)  then 
			playercounter=playercounter+1
		end
	end	
	return playercounter
end

function RespawnAllHeroes() 
	--print("RespawnAllHeroes")
	DoWithAllHeroes(function(hero)
		--print("hero",hero:GetUnitName())
		if not hero:IsAlive() then
			--print("respawn",hero:GetUnitName())
			hero:RespawnHero(false,false,false)
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
		end
	end)
end

function ResetAllAbilitiesCooldown(unit)
	local abilities = unit:GetAbilityCount()
	for i = 1, abilities do
		if unit:GetAbilityByIndex(i) then
			unit:GetAbilityByIndex(i):EndCooldown()
		end
	end
end

function DoWithAllHeroes(whatDo)
	if type(whatDo) ~= "function" then
		print("DoWithAllHeroes:not func")
		return
	end
	--[[print("ALL HEROES")
	for k,v in pairs(heroes) do
		print(k,v:GetUnitName(),v:IsIllusion())
	end
	print("END")]]
	for i = 1, #tHeroes do
		whatDo(tHeroes[i])
	end
end

function ShowCenterMessage(msg, dur,wave)
	FireGameEvent("show_center_message",{message = msg,duration = dur}) 
	if wave then
		Timers:CreateTimer(0.01, function() FireGameEvent("show_center_message_fix",{wave = WAVE_NUM}) return nil end)
	end
end

function GetItemInInventory(unit,itemName)
	for i = 0, 5 do
		local Item = unit:GetItemInSlot(i) 
		if Item:GetName() == itemName then
			return Item 
		end
	end
	return nil
end

POPUP_SYMBOL_PRE_PLUS = 0
POPUP_SYMBOL_PRE_MINUS = 1
POPUP_SYMBOL_PRE_SADFACE = 2
POPUP_SYMBOL_PRE_BROKENARROW = 3
POPUP_SYMBOL_PRE_SHADES = 4
POPUP_SYMBOL_PRE_MISS = 5
POPUP_SYMBOL_PRE_EVADE = 6
POPUP_SYMBOL_PRE_DENY = 7
POPUP_SYMBOL_PRE_ARROW = 8

POPUP_SYMBOL_POST_EXCLAMATION = 0
POPUP_SYMBOL_POST_POINTZERO = 1
POPUP_SYMBOL_POST_MEDAL = 2
POPUP_SYMBOL_POST_DROP = 3
POPUP_SYMBOL_POST_LIGHTNING = 4
POPUP_SYMBOL_POST_SKULL = 5
POPUP_SYMBOL_POST_EYE = 6
POPUP_SYMBOL_POST_SHIELD = 7
POPUP_SYMBOL_POST_POINTFIVE = 8

function PopupNumbers(player,target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx
    if player then
    	pidx = ParticleManager:CreateParticleForPlayer(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target, player)
    else
    	pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()
    end
    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function giveUnitDataDrivenModifier(source, target, modifier,dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_modifiers", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end

function SetCameraToPosForAll(vector) 
	ConsoleCommands:SendToAll("dota_camera_set_lookatpos "..tostring(vector.x).." "..tostring(vector.y))
	print("dota_camera_set_lookatpos "..tostring(vector.x).." "..tostring(vector.y))
end

function SetCameraToPosForPlayer(player,vector)
	if type(player) == "number" then
		ConsoleCommands:SendToPlayer(player,"dota_camera_set_lookatpos "..tostring(vector.x).." "..tostring(vector.y))
	else
		ConsoleCommands:SendToPlayer(player:GetPlayerID(),"dota_camera_set_lookatpos "..tostring(vector.x).." "..tostring(vector.y))
	end
end

--[[can u help me with your ConsoleCommands? 
Kidney
i use ConsoleCommands:SendToAll("dota_camera_set_lookatpos "..tostring(vector.x).." "..tostring(vector.y)) 
BMD
i can try, what's up 
Kidney
in console i have[   Scaleform           ]: SF: [ConsoleCommands] ConsoleCommand received: -1 -- dota_camera_set_lookatpos -5024 -1860 
[   Scaleform           ]: SF: CONNECTED 
[   Scaleform           ]: SF: 0 
[   Scaleform           ]: SF: true 
[   Scaleform           ]: SF: WRITING 
[   Scaleform           ]: SF: WRITTEN 
BMD
so the thing about ConsoleCommands 
is that it won't work fi your console is open 
or if the individual player's console is open 
when you call the send command 
Kidney
oh 
BMD
and once you do send something to the console 
for the player 
if it succeeds it will lock their console and prevent it from being opened 
for the rest of the game 
whcih is due to limitations of the flash.net.Socket implementation 
that said, it's still the only known way to run console commands on individual player systems 
Kidney
thank you for help) 
BMD
there are some workarounds for camera stuff 
like spawning a dummy unit at the point you want and using PlayerResource:SetCameraTarget 
Kidney
this move camera not immediately 
BMD
SetCameraTarget doesn't yeah 
there's also spawning a dummy unit and using unit:AddNewModifier(hero, nil, 'modifier_camera_follow', {}) 
i'm not 100% positive that works for individual clients based on the casting hero 
but modifier_camera_follow does instantly move the camera to the unit 
Kidney
thanks again) 
BMD
np, let me know if you run into issues 
i may go back and try to update the consolecommands.swf, since right now if it fails ever (vbecause the console is open) it won't work ever for that jsession 
but it's possible to make it queue up commands and keep trying until it succeeds 
though if the client never closes the console it won't matter ]]