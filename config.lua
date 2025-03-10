Config = {} 
Config.RDR = GetGameName() == "redm" -- This script supports both FiveM and RedM, do not touch this.

local Colors = {
    none = '',
    red = Config.RDR and '~t8~' or '~r~', -- Basically, if RDR then ~t8~ else ~r~ for FiveM since they use different color codes
    darkred = Config.RDR and '~e~' or '~r~',
    orange = Config.RDR and '~t2~' or '~o~',
    gray = '~t~',
    blue = Config.RDR and '~t3~' or '~b~',
    purple = Config.RDR and '~t1~' or '~p~',
    green = Config.RDR and '~t6~' or '~g~',
    yellow = Config.RDR and '~t4~' or '',
}

Config.Distance = 8.0 -- Distance the player needs to be from a target before they can see their me's, do's, say's, tag's, focus', etc.
Config.BgAlpha = 150 -- Background Alpha for /me and /do
Config.Font = 1 -- What font to use for the text. The value must be a number
Config.Timer = 8 -- How long in Seconds does the /me, /do /say, etc. last on screen

--This will set the size multiplier of the text for when the player is On Foot or in a vehicle/on a mount
Config.FootScale = 2
Config.VehicleScale = 3

Config.PrintToChat = true -- Would allow for people to scroll back on missed /me's, /do's, etc. in the chat

Config.MeCommand = 'me'
Config.MeColor = Colors.yellow

Config.DoCommand = 'do'
Config.DoColor = Colors.blue

Config.HurtCommand = 'hurt'
Config.HurtColor = Colors.red

Config.ThinkCommand = 'think'
Config.ThinkColor = Colors.gray

Config.AllowSay = false
Config.SayCommand = 'say'
Config.SayColor = Colors.none

Config.AllowTags = true -- Tags are visible at all times if the player is within the visible distance
Config.TagCommand = 'tag'
Config.HideTagsCommand = 'hideTags' -- Allows the user to hide all tags. Useful for taking screenshots. (set to nil if you don't want to allow this)
Config.TagColor = Colors.none
Config.BgAlphaTag = 0 -- Background Alpha for tags
Config.AllowBoneTags = true -- Allows the player to attach the tag to their bone ( l_hand, r_hand, head, l_foot, r_foot, etc. ) "/tag l_foot bleeding"

Config.HideSelfTags = false --Hides the tags on the user with the tag (tags still visible to other players)
Config.HideSelfTagsCommand = 'hideSelfTags' -- Allows the user to hide the tags on themselves (still visible to other players) (set to nil if you don't want to allow this)

Config.AllowFocus = true -- Focus Tags are visible only if the player is aiming at the target with the focus tag.
Config.FocusCommand = 'focus'
Config.FocusColor = Colors.gray
Config.BgAlphaFocus = 150 -- Background Alpha for focus tags
Config.AllowBoneFocus = true -- Allows the player to attach the focus tag to their bone ( l_hand, r_hand, head, l_foot, r_foot, etc. ) "/tag l_foot missing toe"

Config.HideSelfFocus = false --Hides the focus tags on the user with the focus tag (focus tags still visible to other players)
Config.HideSelfFocusCommand = 'hideSelfFocus' -- Allows the user to hide the focus tags on themselves (still visible to other players) (set to nil if you don't want to allow this)

Config.AllowTry = true -- Will allow the player to do a /try <message> for a chance of failing or succeeding
Config.TryCommand = 'try'
Config.TryChance = 50 -- Chance to Fail

-- Background Sprites, only shows if BgAlpha-- is higher than 0. If nothing is set, like in GTA, it'll just be a black rectangle background.
Config.textureDict = Config.RDR and 'shard_backgrounds' or '' -- Set texture dictionary for RDR
Config.textureName = Config.RDR and 'shard_game_update' or '' -- Set texture name for RDR

Config.AllowCurlyCode = true -- If false, this will remove any curly code like ~pa~, ~n~, ~t4~, etc. from the text, stopping players from coloring their text

Config.Webhook = "" -- Leave empty if you don't want Discord Logs for these commands
Config.WebhookName = 'crimson-3dme'
Config.webhookAvatar = nil -- URL for an avatar image

Config.Blacklist = {
    ['report'] = {'nigger', 'bitch', 'cunt'}, 
    ['tags'] = {'thinking'}
}
Config.BlacklistWebhook = 'https://discord.com/api/webhooks/1339874674695340054/vQIRQ_CSriaPzgmb7xlswJ1rvxsP-BkO1udhDBggf96muA8vLHML4Il1XYBbqXh511tE'