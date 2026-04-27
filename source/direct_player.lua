local msg = require"mp.msg"

local _M = {}
_M.get_player = function(env)
  msg.verbose[[Hello! Direct player link detected.]]

  local url = env.url
  if url then
    --- TODO: заполнить плейлист всеми эпизодами, если линк на весь сезон, а не на конкретную серию
    if url:match"mangavost%.org" or url:match"aser%.pro" then
      require"player.vost".play(env)
    elseif
        url:match"rutube%.ru"
        or
        url:match"vk%.com"
        or
        url:match"vkvideo%.ru"
    then
      require"player.ytdl".play(env)
    else
      require"player.unknown".play(env)
    end
  end
  -- mp.set_property("ytdl_hook-exclude", 'animedia')
end

return _M
