define [
   'angular'
   'pan_zoom/pan_zoom'
   'pan_zoom/draggable'
   'text!./paper.html'
   'css!./paper.less'
], (
   angular
   PanZoom
   Draggable
   template
) ->
   module = angular.module 'paper', []

   module.service 'body', ->
      return document.body

   uid_counter = 100
   uid = -> (uid_counter += 1)

   module.controller 'PaperCtrl', ($scope) ->
      $scope.newItem = (paperX, paperY) ->
         id = uid()
         $scope.expressions[id] =
            x: paperX - 8
            y: paperY - 17
            id: id
            src: ' '
            focus: true
         return id

      deselectors = []

      @registerDeselector = (deselect) ->
         deselectors.push deselect

      @deselectAll = $scope.deselectAll = ->
         deselectors.forEach (deselect) -> deselect()

      @deleteById = (id) ->
         delete $scope.expressions[id]

      return

   module.directive 'paper', ->
      restrict: 'E'
      template: template
      replace: true
      transclude: true
      controller: 'PaperCtrl'
      link: (_, el) ->
         width = 4000
         height = 4000
         el.css 'width',  width + 'px'
         el.css 'height',  height + 'px'

         Draggable.setPaper el
         Draggable.setBounds width, height
         PanZoom.bindElement el, Draggable.zoomGhost
