define [
  'cs!lib/view/ShowView'
  'tpl!../templates/show.html'
], (ShowView, Template ) ->
  class ShowSettingView extends ShowView
    template: Template
