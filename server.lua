RegisterNetEvent('crimson-3dme', function (message, id)
    TriggerClientEvent('crimson-3dme', -1, message, id)
end)

local tags = {}
RegisterNetEvent('crimson-3dme:tag', function (message, id, bone)
    if message == Config.TagColor then
        for i, v in pairs(tags) do
            if v.id == id and v.bone == bone then
                table.remove(tags, i)
            end
        end
    else
        local found = false
        for i, v in pairs(tags) do
            if v.id == id and v.bone == bone then
                tags[i].message = message
                found = true
                break
            end
        end
        if not found then
            table.insert(tags, {message = message, id = id, bone = bone or nil})
        end
    end
        TriggerClientEvent('crimson-3dme:tag', -1, tags)
end)

local focus = {}
RegisterNetEvent('crimson-3dme:focus', function (message, id, bone)
    if message == Config.FocusColor then
        for i, v in pairs(focus) do
            if v.id == id and v.bone == bone then
                table.remove(focus, i)
            end
        end
    else
        local found = false
        for i, v in pairs(focus) do
            if v.id == id and v.bone == bone then
                focus[i].message = message
                found = true
                break
            end
        end
        if not found then
            table.insert(focus, {message = message, id = id, bone = bone or nil})
        end
    end
        TriggerClientEvent('crimson-3dme:focus', -1, focus)
end)

AddEventHandler('playerLoaded', function(playerId)
    TriggerClientEvent('crimson-3dme:tag', playerId, tags)
    TriggerClientEvent('crimson-3dme:focus', playerId, focus)
end)
