local msg = require"mp.msg"

local _M = {}
_M.play = function(env)
  local player_url = env.url
  if player_url:match"rutube%.ru" then
    local id = player_url:match".*/(.+)/*$"
    mp.set_property("stream-open-filename", ("https://rutube.ru/video/%s"):format(id))
  elseif player_url:match"vk%.com" then
    msg.warn[[Обнаружен плеер с vk.com]]
    msg.warn[[Известно что он посылает кучу битых (хотя, похоже, шифрованных) пакетов, так что вы можете видеть в логе кучу "спама", связанного ffmpeg/demuxer,]]
    msg.warn[[а так же периодические пропадания кусков видеопотока (или пропажу звука, а так же огромные проблемы при запуске не с начала).]]
    msg.warn[[Возможно  так же, что разработчики в VK до сих пор полагаются на старый баг (неправильную интерпретацию стандарта), давно исправленный в ffmpeg]]
    msg.warn[[см. https://lleo.me/dnevnik/2022/02/15]]
    mp.set_property("stream-open-filename", player_url)
    -- elseif player_url:match"youtube%.com" or player_url:match"youtu%.be" then
    --   mp.set_property("stream-open-filename", player_url)
  else
    mp.set_property("stream-open-filename", player_url)
  end
end
return _M
