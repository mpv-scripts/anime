local msg = require"mp.msg"

local _M = {}
_M.play = function(env)
  msg.error[[Увы, на данный момент проприетарный плеер AniMy не поддерживается.]]
  msg.error[[Если вы можете реализовать его поддержку - пожалуйста, пришлите PR]]
  msg.error[[А пока - можете попробовать указать другой плеер (если для данного тайтла они доступны)]]
  msg.error[[Для этого можете добавить к URL параметр ?player=N (см. ссылки в кнопках смены плеера на странице тайтла)]]
  msg.error(("URL плеера: %s"):format(env.url))
  -- os.exit(1)
  mp.command[[quit]]
end

return _M

