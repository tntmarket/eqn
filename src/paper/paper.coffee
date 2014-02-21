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

   uid_counter = 100
   uid = -> (uid_counter += 1)

   module.controller 'PaperCtrl', ($scope) ->
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
            x: pageX - 8
            y: pageY - 17
            id: id
            src: ' '
            focus: true
         return id

      deselectors = []

      @registerDeselector = (deselect) ->
         deselectors.push deselect

      @unselectAll = $scope.unselectAll = ->
         deselectors.forEach (deselect) -> deselect()

      @deleteById = $scope.deleteById = (id) ->
         delete $scope.expressions[id]

      return

   module.directive 'paper', ->
      restrict: 'C'
      controller: 'PaperCtrl'
      link: (_, el) ->
         viewport = (angular.element document.body)[0]
         el.css 'width', viewport.offsetWidth * 4 + 'px'
         el.css 'height', viewport.offsetHeight * 4 + 'px'

         Draggable.setPaper el
         Draggable.setBounds (parseInt el.css 'width'),
                             (parseInt el.css 'height')
         PanZoom.bindElement el, Draggable.zoomGhost
