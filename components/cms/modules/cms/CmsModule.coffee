define [
  'googlemaps!'
  'cs!App'
  'cs!Oophaga'
  'i18n!./nls/language'
  'text!./configuration.json'
  'cs!./model/NavigationItem'
  'cs!./model/NavigationItems'
  'cs!./view/Navbar'
  "css!lib/style/main"
  # "less!lib/style/main"
],
( google, App, Oophaga, i18n, Config, NavigationItem, Collection, Navbar)->

  App.google = google
  App.position =
    coords:
      accuracy: 13976
      altitude: null
      altitudeAccuracy: null
      heading: null
      latitude: 48.579068299999996
      longitude: 14.0396111
      speed: null
    timestamp: Date.now()

  if navigator.geolocation
    setInterval ->
      navigator.geolocation.getCurrentPosition (position)->
        App.position = position
        App.vent.trigger "newPosition"
    , 5000

  NavigationItems = new Collection
  SubNavigationItems = new Collection

  # show navigation
  App.navigationRegion.show new Navbar navitems: NavigationItems, subnavitems: SubNavigationItems

  # overlay view
  App.overlayRegion.show new Oophaga.View.OverlayView

  App.vent.on "CmsModule:addNavItem", (config, i18n)->
    config.label = i18n.navigation if i18n
    model = new NavigationItem config
    if config.navigation.sub
      SubNavigationItems.add model
    else
      NavigationItems.add model

  new Oophaga.Module
    Config: Config
    i18n: i18n
    disableRoutes: true

