RegisterNetEvent('crimson-3dme', function (message, id)
    TriggerClientEvent('crimson-3dme', -1, message, id)

    if Config.Webhook and Config.Webhook ~= "" then
        SendDiscordWebhook("ID: "..source, "```"..message.."```", nil, Config.Webhook, Config.WebhookName, Config.WebhookAvatar)
    end
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

        if Config.Webhook and Config.Webhook ~= "" then
            SendDiscordWebhook("ID: "..source, "```"..message.."```", nil, Config.Webhook, Config.WebhookName.. ' - /tag', Config.WebhookAvatar)
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

        if Config.Webhook and Config.Webhook ~= "" then
            SendDiscordWebhook("ID: "..source, "```"..message.."```", nil, Config.Webhook, Config.WebhookName.. ' - /focus', Config.WebhookAvatar)
        end
    end
        TriggerClientEvent('crimson-3dme:focus', -1, focus)
end)

RegisterNetEvent('crimson-3dme:BlacklistedWord', function (words, word)
    if Config.BlacklistWebhook then
        SendDiscordWebhook("ID: "..source, "# Blacklisted Word was used: "..word.."```"..words.."```", nil, Config.BlacklistWebhook, Config.WebhookName.. ' - /focus', Config.WebhookAvatar)
    end
end)

AddEventHandler('playerLoaded', function(playerId)
    TriggerClientEvent('crimson-3dme:tag', playerId, tags)
    TriggerClientEvent('crimson-3dme:focus', playerId, focus)
end)

AddEventHandler('playerDropped', function(source)
    for i,v in pairs(tags) do
        if v.id == source then
            table.remove(tags, i)
        end
    end
    
    for i,v in pairs(focus) do
        if v.id == source then
            table.remove(focus, i)
        end
    end
end)

function SendDiscordWebhook(name, description, embeds, webhookurl, webhookname, webhookavatar)
    local wname =  webhookname
    local avatar = webhookavatar
    local webhook = webhookurl

    if embeds == nil then
        embeds = {{
            color = 11342935,
            title = name,
            description = description
        }}
    end

    local payload = {
        username = wname,
        avatar_url = avatar,
        type = 'rich',
        embeds = embeds
    }

    PerformHttpRequest(webhook, function(err, text, headers)end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end