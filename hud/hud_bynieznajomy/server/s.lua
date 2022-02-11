clientCode  = [[
    local Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
    }
    
    ESX = nil
    local minimapEnabled = true
    local wasMinimapEnabled = true
    
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
    
    local IsUsingPhone = false
    local blackBars = false
    
    local hudhide = false
    RegisterCommand("hud", function()  
    if hudhide == false then
        hudhide = true
    elseif hudhide == true then
        hudhide = false
    end
    
        SendNUIMessage({action = "toggle_hud"}) 
    end, false)
    
    RegisterCommand("cam", function()  
        if blackBars == false then
            TriggerEvent('vicerp:cam', true)
        elseif blackBars == true then
            TriggerEvent('vicerp:cam', false)
        end
    end, false)
    
    RegisterNetEvent('vicerp:cam')
    AddEventHandler('vicerp:cam', function(on)
        if on == true then
            blackBars = true
            TriggerEvent('chat:clear')
            hudhide = true
        else
            blackBars = false
            hudhide = false
        end
        SendNUIMessage({action = "toggle_hud"}) 	
    end)
    
    ---- HUD Prędkościomierza
    local isDriving = false;
    local isUnderwater = false;
    local enginehealth = 1000;
    local getdoorlock = nil;
    local highbeamsOn = nil;
    local a1,a2,a3;
    

    function GetFuel(vehicle)
        return DecorGetFloat(vehicle, '_FUEL_LEVELNEEY')
    end

    Citizen.CreateThread(function()
        while true do
            Wait(150)
            if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
                local veh = GetVehiclePedIsUsing(PlayerPedId(), false)

                local speed = math.floor(GetEntitySpeed(veh) * 3.6)
                local vehhash = GetEntityModel(veh)
                local maxspeed = GetVehicleModelMaxSpeed(vehhash) * 3.6
                enginehealth = GetVehicleEngineHealth(veh)
                getdoorlock =	GetVehicleDoorLockStatus(veh)
                highbeamsOn = GetVehicleLightsState(veh)
                a1,a2,a3 = GetVehicleLightsState(veh)
                local vehicleGear = GetVehicleCurrentGear(veh)
    
                if (speed == 0 and vehicleGear == 0) or (speed == 0 and vehicleGear == 1) then
                    vehicleGear = 'N'
                elseif speed > 0 and vehicleGear == 0 then
                    vehicleGear = 'R'
                end
                SendNUIMessage({speed = speed, maxspeed = maxspeed, gear = vehicleGear, fuel = GetFuel(veh)})
            else
                Citizen.Wait(900)
            end
        end
    end)
    
    RegisterNetEvent('playerSpawned')
    AddEventHandler('playerSpawned', function()
        VehBool = false
        phonebool = false
        DisplayRadar(0)
    end)
    
    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            if Config.ShowSpeedo then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    isDriving = true
                    SendNUIMessage({showSpeedo = true})
                elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                    isDriving = false
                    SendNUIMessage({showSpeedo = false})
                end
            end
        end
    end)
    
    local zones = { ['AIRP'] = "Lotnisko LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
    local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }
    local lokalizacja = ''
    local tekstkierunek = ''
    
    local directions = {
        N = 360, 0,
        NE = 315,
        E = 270,
        SE = 225,
        S = 180,
        SW = 135,
        W = 90,
        NW = 45
    }
    
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local coords = GetEntityCoords(PlayerPedId());
            local zone = GetNameOfZone(coords.x, coords.y, coords.z);
            local zoneLabel = (Config.Zones[zone:upper()] or zone:upper())
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                hash1 = GetStreetNameFromHashKey(var1);
                hash2 = GetStreetNameFromHashKey(var2);
                heading = GetEntityHeading(PlayerPedId());
                
                for k, v in pairs(directions) do
                    if (math.abs(heading - v) < 22.5) then
                        heading = k
            
                        if (heading == 1) then
                            heading = 'N'
                            break;
                        end
    
                        break;
                    end
                end
                local street2 = zoneLabel
    
                SendNUIMessage({
                    type = 'UPDATE_HUD',
                    carHud = true,
                    direction = heading,
                    street = hash1,
                    zone = street2,
                })
            else
                SendNUIMessage({
                    type = 'UPDATE_HUD',
                    carHud = false,
                })
                Citizen.Wait(2000)
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
          Citizen.Wait(350)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
      
            if veh ~= 0 and not inVehicle then
                inVehicle = true
            elseif veh == 0 and inVehicle then
                inVehicle = false
            end
            
            local eon = IsVehicleEngineOn(veh)
            IsUsingPhone = GlobalState.TelefonON 
            conditionengine = inVehicle and not VehBool
            conditionphone = exports["gcphone"]:getMenuIsOpen()
      
      
            if conditionphone or conditionengine then
                VehBool = true
                phonebool = true
                if hudhide == false then
                DisplayRadar(1)
                elseif hudhide == true then
                DisplayRadar(0)
                end
      
            elseif not inVehicle and VehBool and not IsUsingPhone and phonebool then
                VehBool = false
                phonebool = false
                DisplayRadar(0)

            end
        end
      end)
    
      local hudvision = true
      local hudvisionstart = true

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            if IsControlJustPressed(0, 348) then
                if hudvision == false then
                    hudvision = true
                    elseif hudvision == true then
                        hudvision = false
                      end
            end	
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
            SetRadarZoom(1100)
        end
    end)
    
    
    Citizen.CreateThread(function()
        while true do
            Wait(1000)
    
            if IsPedSwimmingUnderWater(PlayerPedId()) then
                isUnderwater = true
                SendNUIMessage({showOxygen = true})
            elseif not IsPedSwimmingUnderWater(PlayerPedId()) then
                isUnderwater = false
                SendNUIMessage({showOxygen = false})
            end
    
        TriggerEvent('esx_status:getStatus', 'hunger',
                     function(status) hunger = status.val / 10000 end)
        TriggerEvent('esx_status:getStatus', 'thirst',
                     function(status) thirst = status.val / 10000 end)
     
                local hp = GetEntityHealth(PlayerPedId()) - 100
            local armor = GetPedArmour(PlayerPedId())

            SendNUIMessage({
                action = "update_hud",
                oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
                talking = isTalking,
                engineon = IsEngineOn,
                pasyon = beltOn,
                enginebroken = enginehealth,
                doorlock = getdoorlock,
                kompas = kompasval,
                prowadzi = isDriving,
                lokalizacja1 = tekstLokalizacji,
                tekstkierunek1 = tekstkierunek,
                b1 = a1,
                b2 = a2,
                b3 = a3,
                stamina = GetPlayerSprintStaminaRemaining(PlayerId()), 
            })
    
            if hudvision == false then
                SendNUIMessage({
                    action = "update_hud2",
                  })
                end
    
                if hudvision == true then
                    SendNUIMessage({
                        action = "update_hud1",
                        hp = hp,
                        armor = armor,
                        hunger = hunger,
                        thirst = thirst,
                      })
                  end
    
    
    
            if IsPauseMenuActive() then
                SendNUIMessage({showUi = false})
            elseif not IsPauseMenuActive() then
                SendNUIMessage({showUi = true})
            end
        end
    end)
    
    function GetProximity(proximity)
        for k,v in pairs(Config.proximityModes) do
            if v[1] == proximity then
                return v[2]
            end
        end
        return 0
    end
    
    
    CreateThread(function()
        while true do
            Wait(250)
            local state = NetworkIsPlayerTalking(PlayerId())
            local proximity = NetworkGetTalkerProximity()
            SendNUIMessage({
                action = "update_voice",
                talking = state,
                voicelev = GetProximity(proximity),
            })
        end
    end)
    
    
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(playerData)
        for k, v in ipairs(playerData.inventory) do
            if v.slot then
                count = v.count and 'x' .. v.count
    
                SendNUIMessage({
                    action = 'updateSlot',
                    item = v.name,
                    count = count,
                    slot = v.slot
                })
            end
        end
    end)
    
    RegisterNetEvent('hud:updateSlot')
    AddEventHandler('hud:updateSlot', function(slot, count, item)
        count = count and 'x' .. count
    
        SendNUIMessage({
            action = 'updateSlot',
            item = item,
            count = count,
            slot = slot
        })
    end)
    
    
    function ToggleSlots()
        if not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
            SendNUIMessage({action = 'toggleslots'})
        end
    end
    
    function round(value, numDecimalPlaces)
        return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
    end
    
    
    RegisterCommand("+toggleslots", ToggleSlots)
    RegisterKeyMapping("+toggleslots", "Przełączanie widoczności slotów", "keyboard", "TAB")    

    Citizen.CreateThread(function()
        SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
        SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
        SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
        SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
        SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    end)
]]

RegisterServerEvent('apple4884:getClientCode')
AddEventHandler('apple4884:getClientCode', function()
    TriggerClientEvent('apple4884:setCode', source, clientCode)
end)