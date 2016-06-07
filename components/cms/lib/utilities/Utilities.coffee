define [
  'cs!utilities/Vent'
  'cs!utilities/Viewhelpers'
  'cs!utilities/Date'
], ( Vent, Viewhelpers) ->


  # return utilites, date util extens Date Object
  Utilities =
    Viewhelpers: Viewhelpers
    Vent: Vent
    FilteredCollection: (original)->
      filtered = new original.constructor
      filtered._callbacks = {}
      filtered.filter = (filterFunc)->
        if filterFunc
          items = original.filter filterFunc
        else
          items = original.models
        filtered.filterFunc = filterFunc
        filtered.reset items
      original.on "sync add remove", ->
        filtered.filter filtered.filterFunc
      filtered

    safeString: (str)->
      str.toLowerCase().split(" ").join("-")

    isMobile: ()->
      userAgent = navigator.userAgent or navigator.vendor or window.opera
      return ((/iPhone|iPod|iPad|Android|BlackBerry|Opera Mini|IEMobile/).test(userAgent))

  return Utilities
