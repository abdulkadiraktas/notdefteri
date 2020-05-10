local display = false
local t = {"This is a note."}

RegisterCommand("notdefteri", function(source, args)
    PlaySound(source, "CANCEL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    if args[1] == "open" then -- these args are pretty useless ngl
        SetGui(true)
    elseif args[1] == "close" then 
        SetGui(false)
    else 
        SetGui(not display)
    end
end)
TriggerEvent('chat:addSuggestion', '/notdefteri', 'Birşey yazın.', {
    {name="toggle", help="Not defterini açın"}
})

RegisterNUICallback('exit', function(data)
    updateNotes(t)
    SetGui(false)
end)

RegisterNUICallback('error', function(data)
    updateNotes(t)
    SetGui(false)
    notify("~r~Hata:~s~\n"..data.error)
end)

RegisterNUICallback('save', function(data)
    SetGui(false)
    table.insert(t, data.main)
    notify("Not kayıt edildi ~h~#"..table.length(t))
    updateNotes(t)
end)

RegisterNUICallback('clear', function(data)
    SetGui(false)
    notify("~h~"..table.length(t).."~s~ not silindi")
    t = {}
    updateNotes(t)
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

-- for debugging idk
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end


 
function SetGui(enable)
    SetNuiFocus(enable, enable)
    display = enable

    SendNUIMessage({
        type = "ui",
        enable = enable,
        data = t
    })
end

function table.length(tbl)
    local cnt = 0
    for _ in pairs(tbl) do cnt = cnt + 1 end
    return cnt
  end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~y~~h~"..GetCurrentResourceName()..":~s~~n~"..string)
    DrawNotification(true, false)
    DrawNotificationWithIcon(1,1,"asd")
end

function updateNotes(tbl)
    SendNUIMessage({
        type = "ui",
        data = json.encode(tbl)
    })
end
