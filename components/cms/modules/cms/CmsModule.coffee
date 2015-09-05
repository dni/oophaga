define [
  'cs!App'
  'cs!lib/Module'
  'cs!lib/view/OverlayView'
  'i18n!./nls/language'
  'text!./configuration.json'
  'cs!./model/NavigationItem'
  'cs!./model/NavigationItems'
  'cs!./view/Navbar'
  "css!lib/style/main"
  # "less!lib/style/main"
],
( App, Module, OverlayView, i18n, Config, NavigationItem, Collection, Navbar)->

  NavigationItems = new Collection
  SubNavigationItems = new Collection

  # show navigation
  App.view.navigationRegion.show new Navbar navitems: NavigationItems, subnavitems: SubNavigationItems

  # overlay view
  App.view.overlayRegion.show new OverlayView

  App.vent.on "CmsModule:addNavItem", (config, i18n)->
    config.label = i18n.navigation if i18n
    model = new NavigationItem config
    if config.navigation.sub
      SubNavigationItems.add model
    else
      NavigationItems.add model

  new Module
    Config: Config
    i18n: i18n
    disableRoutes: true

