local RDR = Config.RDR

function DrawText3D(x, y, z, text, bgAlpha)
    if RDR then
        local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
        local dist = #(GetGameplayCamCoord() - vector3(x, y, z))
    
        if GetRenderingCam() ~= -1 then
            dist = #(GetCamCoord(GetRenderingCam()) - vector3(x, y, z))
        end

        local scale = (1 / dist) * (IsPedOnFoot(PlayerPedId()) and Config.FootScale or Config.VehicleScale)
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov
    
        if onScreen then
            SetTextScale(0.0, 0.35 * scale)
            SetTextColor(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)

            local lineCount = select(2, string.gsub(text, "~n~", "")) + 1
            local textLength = #text - (bgAlpha ~= 0 and 3 or 0)
            local endW = 0.005 * textLength / lineCount * scale
            local textWidth = endW + 0.01 * scale
            local textHeight = 0.03 * lineCount * scale

            if Config.textureDict ~= '' and Config.textureName ~= '' then
                local spriteWidth = textWidth
                local spriteHeight = textHeight
                DrawSprite(Config.textureDict, Config.textureName, _x, _y + textHeight / 2.2, spriteWidth, spriteHeight, 0, 0, 0, 0, bgAlpha)
            else
                local bgColor = {0, 0, 0, bgAlpha}
                DrawRect(_x, _y + textHeight / 2.2, textWidth, textHeight, bgColor[1], bgColor[2], bgColor[3], bgColor[4])
            end

            Citizen.InvokeNative(0xADA9255D, Config.Font)

            Citizen.InvokeNative(0xBE5261939FBECB8C, true)
            Citizen.InvokeNative(0xd79334a4bb99bad1,
                Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", text, Citizen.ResultAsLong()), _x, _y)
        end
    else

        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local camCoords = GetGameplayCamCoords()
        local dist = #(camCoords - vector3(x, y, z))

        local scale = (1 / dist) * (IsPedOnFoot(PlayerPedId()) and Config.FootScale or Config.VehicleScale)
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov

        if onScreen then
            SetTextScale(0.0, 0.35 * scale)
            SetTextFont(Config.Font)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(1)

            local lineCount = select(2, string.gsub(text, "~n~", "")) + 1
            local textLength = #text - (bgAlpha ~= 0 and 3 or 0)
            local endW = 0.005 * textLength / lineCount * scale
            local textWidth = endW + 0.01 * scale
            local textHeight = 0.03 * lineCount * scale

            if Config.textureDict ~= '' and Config.textureName ~= '' then
                local spriteWidth = textWidth
                local spriteHeight = textHeight
                DrawSprite(Config.textureDict, Config.textureName, _x, _y + textHeight / 2.2, spriteWidth, spriteHeight, 0, 0, 0, 0, bgAlpha)
            else
                local bgColor = {0, 0, 0, bgAlpha}
                DrawRect(_x, _y + textHeight / 2.2, textWidth, textHeight, bgColor[1], bgColor[2], bgColor[3], bgColor[4])
            end

            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(_x, _y)
        end
    end
end

local playerOffsets = {}
local offsetIncrement = 0.1
local baseOffset = 0.4

RegisterNetEvent('crimson-3dme', function(message, id)
    local playerPed = PlayerPedId()

    if not playerOffsets[id] then
        playerOffsets[id] = { offsets = {}, activeCount = 0 }
    end

    local endTime = GetGameTimer() + (Config.Timer * 1000)

    Citizen.CreateThread(function()
        playerOffsets[id].activeCount = playerOffsets[id].activeCount + 1

        local currentEventOffset = baseOffset + (playerOffsets[id].activeCount - 1) * offsetIncrement

        table.insert(playerOffsets[id].offsets, currentEventOffset)

        local offsetCount = #playerOffsets[id].offsets

        if Config.PrintToChat then
            local playerCoords = GetEntityCoords(playerPed)
            local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            local msg = string.gsub(message, "~.-~", "")

            if distance < Config.Distance then
                TriggerEvent('chat:addMessage', {args = {'['..id.. ']',msg}, color = {150, 0, 255}})
            end
        end

        while GetGameTimer() < endTime do
            Citizen.Wait(0)
            local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
            if targetPed then
                local playerCoords = GetEntityCoords(playerPed)
                local bType = (RDR and 'SKEL_' or 'IK_')
                local targetCoords = GetBoneCoords(targetPed, bType.."Head") or GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)

                if #playerOffsets[id].offsets < offsetCount then
                    currentEventOffset = currentEventOffset - 0.1
                    offsetCount = #playerOffsets[id].offsets
                end

                if distance < Config.Distance then
                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + currentEventOffset, message, Config.BgAlpha)
                end
            end
        end

        playerOffsets[id].activeCount = playerOffsets[id].activeCount - 1

        table.remove(playerOffsets[id].offsets)

        if playerOffsets[id].activeCount > 0 then
            local newBaseOffset = baseOffset + (playerOffsets[id].activeCount - 1) * offsetIncrement
            
            for i = 1, #playerOffsets[id].offsets do
                playerOffsets[id].offsets[i] = newBaseOffset + (i - 2) * offsetIncrement
            end
        end

        if playerOffsets[id].activeCount <= 0 then
            playerOffsets[id] = nil
        end
    end)
end)

local tags = {}
local focus = {}

RegisterNetEvent('crimson-3dme:tag', function(t)
    tags = t
end)
RegisterNetEvent('crimson-3dme:focus', function(t)
    focus = t
end)

local hideTags, hideSelfTags, hideSelfFocus = false, Config.HideSelfTags, Config.HideSelfFocus

if Config.AllowFocus or Config.AllowTags then
    CreateThread(function()
        while true do
            Wait(0)
            local playerPed = GetPlayerPed(PlayerId())
            local playerCoords = GetEntityCoords(playerPed)

            local Focused = false
            if not RDR then
                Focused = true
            end

            for _, v in pairs(tags) do
                local targetPed = GetPlayerPed(GetPlayerFromServerId(v.id))
                if targetPed and DoesEntityExist(targetPed) then
                    local targetCoords = (v.bone and GetBoneCoords(targetPed, v.bone) or GetEntityCoords(targetPed))
                    if targetCoords then
                        local distance = #(playerCoords - targetCoords)
                        if distance < Config.Distance then
                            local offset = (GetPedStealthMovement(targetPed) and 0.15 or 0.2)
                            if v.bone then offset = 0.0 end
                            if targetPed == playerPed and not hideSelfTags then
                                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + offset, v.message, Config.BgAlphaTag)
                            end
                            if not hideTags and targetPed ~= playerPed then
                                DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + offset, v.message, Config.BgAlphaTag)
                            end
                        end
                    end
                end
            end
            for _, v in pairs(focus) do
                local targetPed = GetPlayerPed(GetPlayerFromServerId(v.id))
                if targetPed and DoesEntityExist(targetPed) then
                    local targetCoords = (v.bone and GetBoneCoords(targetPed, v.bone) or GetEntityCoords(targetPed))
                    if targetCoords then
                        local distance = #(playerCoords - targetCoords)
                        if distance < Config.Distance then
                            if RDR then
                                local _, tPed = GetPlayerTargetEntity(PlayerId())

                                if tPed == targetPed then
                                    Focused = true
                                else 
                                    Focused = false
                                end
                            end
                            if Focused or (targetPed == playerPed and not hideSelfFocus) then
                                local offset = (GetPedStealthMovement(targetPed) and 0.25 or 0.3)
                                if v.bone then offset = 0.2 end
                                DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + offset, v.message, Config.BgAlphaFocus)
                            end
                        end
                    end
                end
            end
        end
    end)
end

if Config.HideTagsCommand then
    RegisterCommand(Config.HideTagsCommand, function (source, args)
        hideTags = not hideTags
    end)
end
if Config.HideSelfTagsCommand then
    RegisterCommand(Config.HideSelfTagsCommand, function (source, args)
        hideSelfTags = not hideSelfTags
    end)
end
if Config.HideSelfFocusCommand then
    RegisterCommand(Config.HideSelfFocusCommand, function (source, args)
        hideSelfFocus = not hideSelfFocus
    end)
end

if Config.AllowTags then
    RegisterCommand(Config.TagCommand, function (source, args, raw)
        local bone = nil
        if #args > 0 then
            local bType = (RDR and 'SKEL_' or 'IK_')
            if (GetEntityBoneIndexByName(PlayerPedId(), bType..args[1]) ~= -1) and Config.AllowBoneTags == true then
                if Config.AllowBoneTags then bone = bType..args[1] end
                table.remove(args, 1)
            end
        end
        local color = Config.TagColor
        local message = color..table.concat(args, " ")

        if not Config.AllowCurlyCode then
            message = color..string.gsub(table.concat(args, " "), "~.-~", "")
        end

        TriggerServerEvent('crimson-3dme:tag', message, GetPlayerServerId(PlayerId()), bone or nil)
    end)
end

if Config.AllowFocus then
    RegisterCommand(Config.FocusCommand, function (source, args, raw)
        local bone = nil
        if #args > 0 then
            local bType = (RDR and 'SKEL_' or 'IK_')
            if (GetEntityBoneIndexByName(PlayerPedId(), bType..args[1]) ~= -1) and Config.AllowBoneFocus == true then
                if Config.AllowBoneFocus then bone = bType..args[1] end
                table.remove(args, 1)
            end
        end
        local color = Config.FocusColor
        local message = color..table.concat(args, " ")

        if not Config.AllowCurlyCode then
            message = color..string.gsub(table.concat(args, " "), "~.-~", "")
        end

        TriggerServerEvent('crimson-3dme:focus', message, GetPlayerServerId(PlayerId()), bone or nil)
    end)
end

function GetBoneCoords(playerPed, boneName)
    local boneIndex = GetEntityBoneIndexByName(playerPed, boneName)
    if boneIndex ~= -1 then
        local boneCoords = GetWorldPositionOfEntityBone(playerPed, boneIndex)
        return boneCoords
    else
        return nil
    end
end

RegisterCommand(Config.MeCommand, function(source, args)
    local color = Config.MeColor
    local message = color..table.concat(args, " ")

    if not Config.AllowCurlyCode then
        message = color..string.gsub(table.concat(args, " "), "~.-~", "")
    end
    if message == "" then
        return
    end

    TriggerServerEvent('crimson-3dme', message, GetPlayerServerId(PlayerId()))
end)
RegisterCommand(Config.DoCommand, function(source, args)
    local color = Config.DoColor
    local message = color..table.concat(args, " ")

    if not Config.AllowCurlyCode then
        message = color..string.gsub(table.concat(args, " "), "~.-~", "")
    end
    if message == "" then
        return
    end

    TriggerServerEvent('crimson-3dme', message, GetPlayerServerId(PlayerId()))
end)

if Config.AllowSay then
    RegisterCommand(Config.SayCommand, function(source, args)
        local color = Config.SayColor
        local message = color..' "'..table.concat(args, " ")..'" '

        if not Config.AllowCurlyCode then
            message = color..' "'..string.gsub(table.concat(args, " "), "~.-~", "")..'" '
        end
        if message == "" then
            return
        end

        TriggerServerEvent('crimson-3dme', message, GetPlayerServerId(PlayerId()))
    end)
end

if Config.AllowTry then
    RegisterCommand(Config.TryCommand, function(source, args)
        local chance = math.random(0, 100)
        if message == "" then
            return
        end
        local color = (RDR and '~e~' or '~r~')
        local message = color..'Tried '..table.concat(args, " ")..' and failed...'

        if not Config.AllowCurlyCode then
            message = color..'Tried '..string.gsub(table.concat(args, " "), "~.-~", "")..' and failed...'
        end

        if chance >= Config.TryChance then
            color = (RDR and '~t6~' or '~g~')
            message = color..'Tried '..table.concat(args, " ")..' and succeeded!'

        if not Config.AllowCurlyCode then
            message = color..'Tried '..string.gsub(table.concat(args, " "), "~.-~", "")..' and succeeded!'
        end
        end

        TriggerServerEvent('crimson-3dme', message, GetPlayerServerId(PlayerId()))
    end)
end

Citizen.CreateThread(function ()
    while true do
        Wait(0)

        local players = GetActivePlayers()
        
        if IsControlPressed(0, `INPUT_PLAYER_MENU`) then
            for i, v in pairs(players) do
                --if v == PlayerId() then return end
                local ped = GetPlayerPed(v)
                local coords = GetPedBoneCoords(ped, 27981)
                local id = GetPlayerServerId(v)

                if #(coords - GetEntityCoords(PlayerPedId())) > 15.0 then
                    return
                end

                DrawText3D(coords.x, coords.y, coords.z + 0.3, "ID: ~t1~"..id, 0)
            end
        end
    end
end)