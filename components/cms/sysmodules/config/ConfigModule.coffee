define [
  'cs!App'
  'cs!lib/Module'
  'cs!lib/view/OverlayView'
  'cs!./view/Navbar'
  "css!lib/style/main"
  # "less!lib/style/main"
],
( App, Module, OverlayView, Navbar)->

  # show navigation
  App.view.navigationRegion.show new Navbar
    navitems: App.NavItems

  # overlay view
  App.view.overlayRegion.show new OverlayView

  new Module
    moduleName: "ConfigModule"

