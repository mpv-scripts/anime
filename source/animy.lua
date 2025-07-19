local msg = require"mp.msg"
local fetch = require"lib.fetch"

local _M = {}
_M.get_player = function(env)
  msg.verbose[[Hello! animy.org link detected.]]
  local o = {}
  local path = env.url

  o.ref = path -- or https://animy.org?

  local player_url

  if path:match("[%?]") then
    msg.warn[[Link with paramaters detected. It seems, you're trying to set some settings (like player, voiceover or format)]]                                 -- luacheck: ignore
    msg.warn[[Because of shitty-coded backend of animy.org, which uses non-standard headers, and proprietary cookies, this requires some additional handling]] -- luacheck: ignore
    msg.warn[[And even with it, it can still refuse work as expected]]
    local r = fetch(path, o):match[=[efresh: .+URL=([a-zA-Z0-9:/_+.-]+)]=]
    if not r then
      msg.error"Something gone wrong"
      mp.command[[quit]]
      -- os.exit(9)
    else
      o = { ref = path }
      player_url = fetch(r, o):match([=[<meta property="og:video" content="([^"]+)"]=])
      -- msg.warn[[Paramaters should be applied now.]]
      -- msg.warn[[This fucking shit doesn't work as expected if we'll try re-fetch episode URL automatically in this mpv instance.]]          -- luacheck: ignore
      -- msg.warn[[So, please, now *RE-RUN* mpv *WITHOUT* "?param=value" part of URL (pass just episode URL itself)]]                          -- luacheck: ignore
      -- msg.warn[[Although, be noticed, that we just requested a page with settings, and just recieved cookies with corresponding settings.]] -- luacheck: ignore
      -- msg.warn[[But this fucking shit can still randomly return another player, another voiceover and even another format.]]                -- luacheck: ignore
      -- msg.warn[[We just doing our best on trying to get this black box to work SOMEHOW, don't blame us if it doesn't work...]]              -- luacheck: ignore
      -- mp.command[[quit]]
    end
  end

  player_url = fetch(path, o):match([=[<meta property="og:video" content="([^"]+)"]=])
  if player_url then
    -- msg.info(player_url)
    if player_url:match"vk%.com" or player_url:match"youtube%.com" or player_url:match"youtu%.be" then
      require"player.ytdl".play_single(env)
    elseif player_url:match"csst.online" then
      require"player.allvideo".play_single(env)
    elseif player_url:match"^//anivod%.com" or player_url:match"^//aniqit%.com" then
      -- player_url:match"^//ani...%.com/seria"
      -- player_url=(player_url:gsub("^//","https://"))
      require"player.kodik".play(env)
    elseif player_url:match"^//player%.animy%.org" then
      -- player_url=(player_url:gsub("^//","https://"))
      require"player.animy".play(env)
    else
      require"player.unknown".play(env)
    end
  end
  -- mp.set_property("ytdl_hook-exclude", 'animy')
end

return _M
