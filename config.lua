Config = {} 
Config.RDR = GetGameName() == "redm" -- This script supports both FiveM and RedM, do not touch this.

local Colors = {
    none = '',
    red = Config.RDR and '~e~' or '~r~', -- Basically, if RDR then ~e~ else ~r~ for FiveM
    orange = Config.RDR and '~t2~' or '~o~',
    gray = '~t~',
    blue = Config.RDR and '~t3~' or '~b~',
    purple = Config.RDR and '~t1~' or '~p~',
    green = Config.RDR and '~t6~' or '~g~',
}

Config.Distance = 8.0 -- Distance the player needs to be from a target before they can see their me's, do's, say's, tag's, focus', etc.
Config.BgAlpha = 150 -- Background Alpha for /me and /do
Config.Font = 0 -- What font to use for the text. The value must be a number
Config.Timer = 6 -- How long in Seconds does the /me, /do or /say last on screen

--This will set the size multiplier of the text for when the player is On Foot or in a vehicle/on a mount
Config.FootScale = 2
Config.VehicleScale = 3

Config.PrintToChat = false -- Would allow for people to scroll back on missed /me's, /do's, etc. in the chat

Config.MeCommand = 'me'
Config.MeColor = Colors.orange

Config.DoCommand = 'do'
Config.DoColor = Colors.blue

Config.AllowSay = true
Config.SayCommand = 'say'
Config.SayColor = Colors.none

Config.AllowTags = true -- Tags are visible at all times if the player is within the visible distance
Config.TagCommand = 'tag'
Config.TagColor = Colors.none
Config.BgAlphaTag = 0 -- Background Alpha for tags
Config.AllowBoneTags = true -- Allows the player to attach the tag to their bone ( l_hand, r_hand, head, l_foot, r_foot, etc. )

Config.AllowFocus = true -- Focus Tags are visible only if the player is aiming at the target with the focus tag. (UNTESTED)
Config.FocusCommand = 'focus'
Config.FocusColor = Colors.gray
Config.BgAlphaFocus = 150 -- Background Alpha for focus tags
Config.AllowBoneFocus = true -- Allows the player to attach the focus tag to their bone ( l_hand, r_hand, head, l_foot, r_foot, etc. )

Config.AllowTry = true -- Will allow the player to do a /try <message> for a chance of failing or succeeding
Config.TryCommand = 'try'
Config.TryChance = 50 -- Chance to Fail

-- Background Sprites, only shows if BgAlpha-- is higher than 0. If nothing is set, like in GTA, it'll just be a black rectangle background.
Config.textureDict = Config.RDR and 'shard_backgrounds' or '' -- Set texture dictionary for RDR
Config.textureName = Config.RDR and 'shard_game_update' or '' -- Set texture name for RDR