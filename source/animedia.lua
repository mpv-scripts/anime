local msg = require"mp.msg"
local fetch = require"lib.fetch"
local tr = require"lib.translate"

local _M = {}
_M.get_player = function(env)
  msg.verbose(tr[[Hello! Animedia link detected.]])

  local url = env.url
  env.curl_opts = env.cfg or {}
  env.curl_opts.ref = url
  -- env.curl_opts

  local main_src = fetch(url, env.curl_opts) or ""
  local player_url = main_src:match([=[<iframe[^>]+src="([^"]+)"]=])
  if player_url then
    env.title = main_src:match([=[og:title" content="([^"]+) смотреть онлайн"]=])
    env.url = player_url
    --- TODO: заполнить плейлист всеми эпизодами, если линк на весь сезон, а не на конкретную серию
    --- @diagnostic disable-next-line: codestyle-check
    if
    --- @diagnostic disable: codestyle-check
      player_url:match"mangavost%.org"
    or
      player_url:match"aser%.pro"
    then
      require"player.vost".play(env)
    elseif
      player_url:match"rutube%.ru"
    or
      player_url:match"vkvideo%.ru"
    or
      player_url:match"vk%.com"
    then
      require"player.ytdl".play(env)
    else
      require"player.unknown".play(env)
    end
  else
    msg.error(tr[[No supported player URLs was found]])
    if (main_src:match"не доступ.* для показа в России.") then
      msg.error(tr[[This title requires proxy]])
      os.exit(1)
    end
    msg.error(tr[[Maybe ytdl will handle this]])
  end
  -- mp.set_property("ytdl_hook-exclude", 'animedia')
end

return _M
