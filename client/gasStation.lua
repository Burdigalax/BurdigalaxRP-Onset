local gasStation

function OnPackageStartGasStation()
	local width, height = GetScreenSize()
	--ZOrder = 5 and FrameRate = 10
	gasStation = CreateWebUI(width / 4.7, height / 4.7, 540, -1050, 5, 10)
	AddPlayerChat('package name :'..GetPackageName().." GasStation !");
    LoadWebFile(gasStation, "http://asset/"..GetPackageName().."/client/gui/gasStation.html")
	SetWebAlignment(gasStation, 0.0, 0.0)
	SetWebAnchors(gasStation, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(gasStation, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStartGasStation)

function OnPackageStopGasStation()
	DestroyWebUI(gasStation)
end
AddEvent("OnPackageStop", OnPackageStopGasStation)

function CloseUIGasStation()
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    Delay(100, function()
    	SetWebVisibility(gasStation, WEB_HIDDEN)
    end)
end
AddEvent("BURDIGALAX_gasStation_onClose", CloseUIGasStation)

function OpenUIGasStation()
    ExecuteWebJS(gasStation, "SetConfigGasStation()")
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    Delay(300, function()
        SetWebVisibility(gasStation, WEB_VISIBLE)
    end)
end

function OnKeyPressGasStation(key)
    if key == 'O' then
      ExecuteWebJS(gasStation, "UpdateGasStation()")
    end
    if key == "G" then
        local visibility = GetWebVisibility(gasStation)
        if visibility == WEB_HIDDEN then
           OpenUIGasStation()
        end
        if visibility == WEB_VISIBLE then
            CloseUIGasStation()
        end
    end
end
AddEvent("OnKeyPress", OnKeyPressGasStation)

function OnPaymentGasStation(event)
    ExecuteWebJS(gasStation, "SetErrorGasStation()")
end
AddEvent('BURDIGALAX_gasStation_onPayment', OnPaymentGasStation)
