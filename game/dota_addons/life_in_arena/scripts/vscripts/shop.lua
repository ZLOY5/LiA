
if trigger_shop = nil then
	trigger_shop = Entities:FindByClassname(nil, "trigger_shop") --находим триггер отвечающий за работу магазина
end

function DisableShop()
	trigger_shop:Disable()
end

function EnableShop()
	trigger_shop:Enable()
end