@App = angular.module('app', ['headroom','mm.foundation.modal'])

App.run(['$rootScope', ($rootScope) ->
  $rootScope.openDonate = ((e, school_id=null, donation_amount=null)->
    school_id ||= $rootScope.school_id
    url = "/donate#{if school_id then '/'+school_id else ''}"

    donation_amount = donation_amount.replace('$','') if donation_amount
    url += "?donation_amount=#{donation_amount}" if donation_amount

    window.location.href = FF.insertSharableToken(url)
    e.stopPropagation()
    e.preventDefault()
    return false
  )
])

FF(->
  $('a.twitter-popup').each(->
    $(this).addClass('enabled')
    href = this.getAttribute('href')
    return if !href
    href = href.replace(/(\?|&)url=([^h]*)/,"$1url=#{encodeURIComponent(FF.browser.url)}$2")
    href = href.replace(/(\?|&)counturl=([^h]*)/,"$1counturl=#{encodeURIComponent(FF.browser.clean_url)}$2")
    this.setAttribute('href', href)
  )
)
$(window).load(->
  $(document).foundation()
  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=290039407831772&version=v2.0"
    fjs.parentNode.insertBefore js, fjs
    return
  )(document, 'script', 'facebook-jssdk')
  @fbShareDetails =(->
    url = FF.browser.clean_url
    title = window.document.title
    desc = "Growing Leaders for Georgia is a movement to bring Habitudes (a visual, character-based, student-leadership development curriculum) to Georgia high schools that cannot afford to purchase the program for their students"
    image = 'http://goo.gl/dS52U'
    winWidth = 520
    winHeight = 350
    winTop = (screen.height / 2) - (winHeight / 2)
    winLeft = (screen.width / 2) - (winWidth / 2)
    window.open "http://www.facebook.com/sharer.php?s=100&p[title]=" + title + "&p[summary]=" + desc + "&p[url]=" + url + "&p[img][0]=" + image, "sharer", "top=" + winTop + ",left=" + winLeft + ",toolbar=0,status=0,width=" + winWidth + ",height=" + winHeight
    return
  )
)