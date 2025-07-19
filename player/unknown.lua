local msg = require"mp.msg"

local _M = {}
_M.play = function(env)
  msg.error[[Неизвестный плеер. Без понятия, как его обрабатывать. Пожалуйста, пришлите issue на github.]]
  msg.error(("URL плеера: %s"):format(env.url))
  -- os.exit(1)
  mp.command[[quit]]
end

return _M
