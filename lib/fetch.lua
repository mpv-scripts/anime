return function(url, opts)
  local safe_url = url:match("[0-9a-zA-Z%%+~:/._-]+")
  local UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
  -- local UA = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/111.0"
  local luacurl_available, cURL = pcall(require, 'cURL')
  if luacurl_available then
    local buf = {}
    local o = opts or {}
    local c = cURL.easy_init()
    local headers = {
      "Accept: */*",
      -- "Accept-Language: ru,en",
      -- "Accept-Charset: utf-8,cp1251,koi8-r,iso-8859-5,*",
      "Cache-Control: no-cache",
    }
    if o.ref then
      headers[#headers + 1] = ("Referer: %s"):format(o.ref)
    end
    c:setopt_httpheader(headers)
    c:setopt_followlocation(1)
    c:setopt_header(1)
    if o.proxy then
      c:setopt_proxy(o.proxy)
    end
    c:setopt_useragent(UA)
    if o.cookiejar then
      c:setopt_cookiejar(o.cookiejar)
      c:setopt_cookiefile(o.cookiejar)
    end
    c:setopt_url(safe_url)
    c:setopt_writefunction(function(chunk)
      table.insert(buf, chunk); return true;
    end)
    pcall(c.perform, c)
    c:close()
    return table.concat(buf)
  else
    local conditional_opts = function()
      local ret = {}
      if opts.cookiejar then
        for _,o in ipairs({"--cookie-jar", tostring(opts.cookiejar), "--cookie", tostring(opts.cookiejar)}) do table.insert(ret, o) end
      end
      if opts.proxy then for _,o in ipairs({"--proxy", tostring(opts.proxy)}) do table.insert(ret, o) end end
      if opts.ref then for _,o in ipairs({"--referer", tostring(opts.ref)}) do table.insert(ret, o) end end
      return table.unpack(ret)
    end

    local curl_cmd = {
      "curl",
      "--url", tostring(safe_url),
      "--location",
      "--silent",
      "--show-error",
      "--user-agent", UA,
      conditional_opts(),
    }
    local curl = mp.command_native{
      name = "subprocess",
      capture_stdout = true,
      playback_only = false,
      args = curl_cmd
    }
    return curl.stdout
  end
end

