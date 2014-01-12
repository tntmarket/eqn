define [
   'angular'
   'pan_zoom/pan_zoom'
   'pan_zoom/draggable'
   'css!./paper.less'
], (
   angular
   PanZoom
   Draggable
) ->
   module = angular.module 'paper', []

   module.service 'paperSizes', ->
      @panZoom = null

      @zoom = ->
         @panZoom.zoom
      @initWidth = ->
         @panZoom.initWidth
      @initHeight = ->
         @panZoom.initHeight

      return

   uid_counter = 100
   uid = -> (uid_counter += 1)

   module.directive 'paper', (paperSizes) ->
      restrict: 'C'
      link: (_, el) ->
         viewport = (angular.element document.body)[0]
         el.css 'width', viewport.offsetWidth * 4 + 'px'
         el.css 'height', viewport.offsetHeight * 4 + 'px'

         paperSizes.panZoom = (PanZoom.bindElement el).panZoom
         Draggable.setPaper el

      controller: ($scope, paperSizes) ->
         $scope.expressions =
            1:
               x: 100
               y: 100
               src: '-0 = 0'
               id: 1
            2:
               x: 200
               y: 200
               src: 'F = -kx'
               id: 2

         $scope.newItem = (pageX, pageY) ->
            id = uid()
            $scope.expressions[id] =
               x: pageX / paperSizes.zoom() - 8
               y: pageY / paperSizes.zoom() - 17
               id: id
               src: ' '
               focus: true

         @deleteItem = $scope.deleteItem = (index) ->
            delete $scope.expressions[index]

         deselectors = []

         @registerDeselector = (deselect) ->
            deselectors.push deselect

         @unselectAll = $scope.unselectAll = ->
            deselectors.forEach (deselect) ->
               deselect()

         return
