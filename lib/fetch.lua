return function(url, opts)
  local safe_url = url:match("[0-9a-zA-Z%%+~:/._-]+")
  local UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
  local luacurl_available, cURL = pcall(require, 'cURL')
  if luacurl_available then
    local buf = {}
    local o = opts or {}
    -- local UA = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/111.0"
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
    -- print(i(buf))
    return table.concat(buf)
  else
    local check_cookie = function()
      if opts.cookiejar then return "--cookie-jar", opts.cookiejar, "--cookie", opts.cookiejar end
    end
    local check_proxy = function() if opts.proxy then return "-x", opts.proxy end end
    local check_ref = function() if opts.ref then return "--referrer", opts.ref end end

    local curl_cmd = {
      "curl",
      "-L", "-S", "-s",
      "-A", UA,
      check_cookie(),
      check_proxy(),
      check_ref(),
      ("%q"):format(url),
    }
    local curl = mp.command_native{
      name = "subprocess",
      capture_stdout = true,
      playback_only = false,
      args = curl_cmd
    }
    return curl.stdout
    -- msg.error"Sorry, I need Lua-cURL (https://github.com/Lua-cURL/Lua-cURLv3) for work."
    -- msg.error"Please, install it using system package manager or any other method"
    -- msg.error"The goal is that Lua interpreter that mpv was built with should be able to find it"
  end
end

