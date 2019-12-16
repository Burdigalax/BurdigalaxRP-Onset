local shop

function OnPackageStart()
	local width, height = GetScreenSize()
	--ZOrder = 5 and FrameRate = 10
	shop = CreateWebUI(width / 4.7, height / 4.7, 540, -1050, 5, 10)
	--shop = CreateWebUI(850.0, 400.0, 800.0, 650.0, 5, 10)
    LoadWebFile(shop, "http://asset/"..GetPackageName().."/client/gui/onShop.html")
	SetWebAlignment(shop, 0.0, 0.0)
	SetWebAnchors(shop, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(shop, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	DestroyWebUI(shop)
end
AddEvent("OnPackageStop", OnPackageStop)

function CloseUI()
    ExecuteWebJS(shop, "ResetBasket()")
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    Delay(100, function()
    	SetWebVisibility(shop, WEB_HIDDEN)
    end)

end
AddEvent("OnClose", CloseUI)

function OpenUI()
    ExecuteWebJS(shop, "SetConfig()")
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(shop, WEB_VISIBLE)
end

function OnKeyPress(key)
	if key == "G" then
        local visibility = GetWebVisibility(shop)
        if visibility == WEB_HIDDEN then
           OpenUI()
        end
        if visibility == WEB_VISIBLE then
            CloseUI()
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnPayment(event)
    local test = json.decode(event)
    if test.type == "cash" then
       ExecuteWebJS(shop, "SetSuccess()")
    end
    if test.type == "card" then
       ExecuteWebJS(shop, "SetError()")
    end
end
AddEvent('OnPayment', OnPayment)