local msg = require"mp.msg"
local fetch = require"lib.fetch"

local _M = {}

_M.play_list = function(env)
  local player_url, o, req_o = env.url, env.curl_opts, env.cfg
  local player_src = fetch(player_url, o)
  local playlist = { "#EXTM3U" }
  local dups = {}

  local q = {
    ["1080p"] = "",
    ["720p"] = "_720p",
    ["360p"] = "_360p",
  }
  local ii = require"inspect"
  local match_pattern = [=[%{"comment": ?[^"]+"([^"]+)","file":"[^"]+](https://[^,%[]*%d__PH__%.mp4)[",]]=]
  local ph = q[req_o.q] or "_720p"
  match_pattern = match_pattern:gsub("__PH__", ph)
  for title, url in player_src:gmatch(match_pattern) do
    if dups[url] then break end
    table.insert(playlist, ("#EXTINF:0,%s"):format(title))
    table.insert(playlist, url)
    dups[url] = true
  end
  if playlist and #playlist > 1 then
    mp.set_property_number("playlist-start", req_o and req_o.ep and req_o.ep - 1 or 0)
    mp.set_property("stream-open-filename",
      ("memory://%s"):format(table.concat(playlist, "\n")))
  else
    msg.error[[Current player is AllVideo, but something gone wrong when we tried to get video URL. Please, report.]] -- luacheck: ignore
  end
end

_M.play_single = function(env)
  local player_url, o, req_o = env.url, env.curl_opts, env.cfg
  local q = {
    ["1080p"] = "",
    ["720p"] = "_720p",
    ["360p"] = "_360p",
  }

  local match_pattern = [=[https://[^,%[]*%d__PH__%.mp4]=]
  local ph = q[req_o.q] or "_720p"
  match_pattern = match_pattern:gsub("__PH__", ph)
  local player_src = fetch(player_url, o)
  local vid_url = player_src:match(match_pattern)
  local subs_ru_url = player_src:match[=[subtitle: "[^"]+(https://[^"%]%[,]*rus?%.[as][sr][st])[,"]]=]
  local subs_en_url = player_src:match[=[subtitle: "[^"]+(https://[^"%]%[,]*eng?%.[as][sr][st])[,"]]=]
  if vid_url then
    mp.set_property("stream-open-filename", vid_url)
    if subs_en_url then
      mp.commandv("sub_add", subs_en_url)
    end
    if subs_ru_url then
      mp.commandv("sub_add", subs_ru_url)
    end
    -- TODO: fill playlist with neighbour episodes
  else
    msg.error[[Current player is AllVideo, but something gone wrong when we tried to get video URL. Please, report.]] -- luacheck: ignore
  end
end

_M.play = _M.play_single --- TODO: merge?

return _M
