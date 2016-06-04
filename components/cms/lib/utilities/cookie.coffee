define [], ->
  cookie =
    create: (name, value, days)->
      if days
         date = new Date()
         date.setTime(date.getTime()+(days*24*60*60*1000))
         expires = "; expires=#{date.toGMTString()}"
      else
        expires = ""
      document.cookie = "#{name}=#{value+expires}; path=/"

    read: (name)->
      nameEQ = "#{name}="
      ca = document.cookie.split ';'
      ca.forEach (c)->
        while c.charAt(0) is ' '
          c = c.substring 1, c.length
          return c.substring(nameEQ.length,c.length) if c.indexOf(nameEQ) is 0
          return null

    delete: (name)->
      @createCookie name,"",-1
