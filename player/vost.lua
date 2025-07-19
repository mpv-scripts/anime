local msg = require"mp.msg"
local fetch = require"lib.fetch"

local _M = {}
_M.play = function(env)
  local player_url, o, req_o = env.url, env.curl_opts, env.cfg
  local q = {
    ["auto"] = "/hls",
    ["720p"] = "/hls/720",
    ["360p"] = "/hls/360",
  }

  -- local match_pattern = [=[https://mangavost.org/content/stream/[^"']+/hls/index.m3u8]=]
  -- local match_pattern = [=[https://mangavost.org/content/stream/[a-zA-Z0-9-_+.%%/]+/hls/index.m3u8]=]
  local match_pattern = [=[https?://[^/]+/content/stream/[a-zA-Z0-9-_+.%%/]+/hls/index.m3u8]=]
  local player_src = fetch(player_url, o) or ""
  local playlist = { "#EXTM3U" }
  local vid_url = player_src:match(match_pattern)
  if vid_url then
    local qual = q[req_o.q] or q["auto"]
    vid_url = vid_url:gsub("/hls", qual)
    local title = env.title
    if title then table.insert(playlist, ("#EXTINF:0,%s"):format(title)) end
    table.insert(playlist, vid_url)

    mp.set_property("stream-open-filename", ("memory://%s"):format(table.concat(playlist, "\n")))

    -- mp.set_property("title", title) -- this makes title to not replace when loading another video
    -- mp.set_property("stream-open-filename", vid_url)
  else
    msg.error[[Current player is MangaVost, but something gone wrong when we tried to get video URL. Please, report.]] -- luacheck: ignore
  end
end
return _M
