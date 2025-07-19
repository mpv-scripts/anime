local msg = require"mp.msg"
local fetch = require"lib.fetch"

local _M = {}
_M.get_player = function(env)
  msg.verbose[[Hello! pvashow link detected.]]
  env.curl_opts = {}

  local page = fetch(env.url, env.curl_opts)
  -- local title = page:match[=[<meta property="og:title" content="([^"]+)">]=]
  local player_url = page:match[=[<iframe src="([^"]+)"]=]
  if player_url then
    env.url = player_url
    if player_url:match"csst.online" then
      require"player.allvideo".play_list(env)
    else
      require"player.unknown".play(env)
    end
  end
end

return _M
