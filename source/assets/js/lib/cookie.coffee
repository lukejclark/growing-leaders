BASE_DOMAIN = null if !BASE_DOMAIN?

class @Cookie
  @set: (name, value, options={})->
    options.domain ||= ".#{BASE_DOMAIN}" if BASE_DOMAIN and URL.parse(window.location.href).root_domain != '0.0'
    options.exdays ||= 0
    exdate = new Date()
    exdate.setDate(exdate.getDate() + options.exdays)
    value = "#{escape(value)}; path=/"
    value += "; expires=#{exdate.toUTCString()}" if options.exdays
    value += "; domain=#{options.domain}" if options.domain
    document.cookie = "#{name}=#{value}"

  @get: (name)->
    cookies = document.cookie.split(";")
    for cookie in cookies
      x = cookie.substr(0,cookie.indexOf("="))
      y = cookie.substr(cookie.indexOf("=")+1)
      x = x.replace(/^\s+|\s+$/g,"")
      return unescape(y) if (x==name)