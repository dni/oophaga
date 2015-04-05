define [
  'cs!App'
  'cs!Oophaga'
  'i18n!./nls/language'
  'text!./configuration.json'
  'cs!./model/NavigationItem'
  'cs!./model/NavigationItems'
  'cs!./view/NavigationView'
  "css!lib/style/main"
  # "less!lib/style/main"
],
( App, Oophaga, i18n, Config, NavigationItem, Collection, NavigationView)->

  NavigationItems = new Collection
  SubNavigationItems = new Collection

  # show navigation
  App.navigationRegion.show new NavigationView collection: NavigationItems
  App.subnavigationRegion.show new NavigationView collection: SubNavigationItems, className: "btn-group-vertical", tagName: "div"

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

