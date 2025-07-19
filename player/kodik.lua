local msg = require"mp.msg"

local _m = {}
_m.play = function(env)
  msg.error[[Увы, на данный момент плеер KODIK не поддерживается.]]
  msg.error[[Если вы можете реализовать его поддержку - пожалуйста, пришлите PR.]]
  msg.error[[Попробуйте использовать другой плеер на сайте.]]
  msg.error(("URL плеера: %s"):format(env.url))
  -- os.exit(1)
  mp.command[[quit]]
end

return _m
