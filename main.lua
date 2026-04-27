-- luacheck: globals mp
-- local i=require"inspect"
local msg = require"mp.msg"
local mp = require"mp"

-- local fetch = require"lib.fetch"

local function check_site()
  local url = mp.get_property"path"
  -- local path = mp.get_property("stream-open-filename", "")
  local cfg = {}
  for k, v in url:gmatch[=[%#%#%#([^%=%#]+)%=([^%#]+)]=] do
    cfg[k] = v
  end
  url = url:gsub("###.+$", "")
  local proxy = mp.get_property"http-proxy"
  if not cfg.proxy and #proxy > 0 then
    cfg.proxy = proxy
  end

  local sources = {
    ["^(%a+://amedia%.[^/]+/.*)"] = "animedia",
    ["^(%a+://amd%.online/.*)"] = "animedia",
    ["^(%a+://animy%.org/.*)"] = "animy",
    ["^(%a+://[^/]+%.pvashow%.[^/]+/.*)"] = "pva",
    ["^(%a+://aser%.pro/vod/.*)"] = "direct_player",
    ["^(%a+://rutube%.ru/.*)"] = "direct_player",
    ["^(%a+://vk%.com/.*)"] = "direct_player",
    ["^(%a+://vkvideo%.ru/.*)"] = "direct_player",
  }

  for pat, src in pairs(sources) do
    if url:match(pat) then
      local ok, source = pcall(require, ("source.%s"):format(src))
      if ok then
        local env = {
          cfg = cfg,
          url = url
        }
        source.get_player(env)
      else
        msg.error"Unknown site"
      end
      break
    end
  end
end

mp.add_hook("on_load", 10, check_site)
