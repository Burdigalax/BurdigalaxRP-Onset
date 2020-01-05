local inventory

function OnPackageStartInventory()
	local width, height = GetScreenSize()
	--ZOrder = 5 and FrameRate = 10
	inventory = CreateWebUI(0, 0, 0, 0, 10, 30)
	AddPlayerChat('package name :'..GetPackageName().." Inventory !");
    LoadWebFile(inventory, "http://asset/"..GetPackageName().."/client/gui/inventory.html")
	SetWebAlignment(inventory, 0.0, 0.0)
	SetWebAnchors(inventory, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(inventory, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStartInventory)

function OnPackageStopInventory()
	DestroyWebUI(inventory)
end
AddEvent("OnPackageStop", OnPackageStopInventory)

function CloseUIInventory(context)
    if context == '"transfer"' then
        ExecuteWebJS(inventory, "ResetSelectedNearbyInventory()")
    else
        --SetIgnoreLookInput(false)
        --SetIgnoreMoveInput(false)
        ShowMouseCursor(false)
        SetInputMode(INPUT_GAME)
        Delay(100, function()
            SetWebVisibility(inventory, WEB_HIDDEN)
        end)
    end
end
AddEvent("BURDIGALAX_inventory_onClose", CloseUIInventory)

function OpenUIInventory(key)
    ExecuteWebJS(inventory, "SetConfigInventory('"..key.."');")
    --SetIgnoreLookInput(true)
    --SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(inventory, WEB_VISIBLE)
end

function OnKeyPressInventory(key)
    if key == "I" or key == "J" then
        local visibility = GetWebVisibility(inventory)
        if visibility == WEB_HIDDEN then
           OpenUIInventory(key)
        end
        if visibility == WEB_VISIBLE then
            CloseUIInventory()
        end
    end
end
AddEvent("OnKeyPress", OnKeyPressInventory)


function updateItemsInventory(event)
    local data = json_decode(event)
    ExecuteWebJS(inventory, "setUpdateItemsInventories("..data.idInventory..","..data.idItem..","..data.newQuantity..");")
end
AddEvent('BURDIGALAX_inventory_onUse', updateItemsInventory)
AddEvent('BURDIGALAX_inventory_onDelete', updateItemsInventory)

function onEquipItemInventory(event)
    local data = json_decode(event)
    ExecuteWebJS(inventory, 'setEquipItemInventory('..data.idInventory..','..data.idItem..','..tostring(data.isEquipped)..');')
end
AddEvent('BURDIGALAX_inventory_onEquip', onEquipItemInventory)

function onTransferItems(event)
    local data = json_decode(event)
    ExecuteWebJS(inventory, "setUpdateItemsInventories("..data.destinationInventoryId..","..data.idItem..","..data.newQuantityDestination..");")
    ExecuteWebJS(inventory, "setUpdateItemsInventories("..data.originInventoryId..","..data.idItem..","..data.newQuantityOrigin..");")
end
AddEvent('BURDIGALAX_inventory_onTransfer', onTransferItems)
