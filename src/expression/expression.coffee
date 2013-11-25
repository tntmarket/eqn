define [
  'angular'
  'pan_zoom/draggable'
  'text!./expression.html'
  'css!./expression.less'
], (angular, Draggable, template) ->

  module = angular.module 'expression', []

  module.directive 'expression', (paper) ->
    restrict: 'E'
    require: '^paper'
    template: template
    replace: true
    scope:
      model: '='

    link: (scope, el, attr, paperCtrl) ->
      paper.registerItem scope

      scope.select = (leftClick) ->
        if not scope.editing and leftClick
          paper.unselectAll()
          scope.selected = true

      scope.unselect = ->
        scope.selected = false
        scope.editing = false

      scope.deleteIfEmpty = ->
        if scope.model.src.length == 0
          paperCtrl.deleteItem scope.model.id

      scope.selected = false
      scope.editing = scope.model.focus or false


  module.directive 'draggable', (paper) ->
    restrict: 'A'
    link: (scope, el) ->
      syncXY = (x, y) ->
        scope.$apply ->
          scope.model.x = x
          scope.model.y = y

      draggable = Draggable.bindElement el,
        scope.model.x, scope.model.y, paper.panZoom

      draggable.onDrop = syncXY


  range = document.createRange()
  focus = (el, offset) ->
    sel = getSelection()
    range.setStart el[0].firstChild, offset
    range.collapse true
    sel.removeAllRanges()
    sel.addRange range
    el[0].focus()

  focusCaret = (el, zoom) ->
    pxFromStart = (event.offsetX - 5)/zoom
    stringWidth = el[0].clientWidth - 12
    offset = pxFromStart/stringWidth*(el.text().length)
    focus el, offset


  module.directive 'editable', (paper) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, el, attr, ngModel) ->
      ngModel.$render = ->
        el.html (ngModel.$viewValue || '')

      el.on 'blur keyup change', ->
        scope.$apply ->
          ngModel.$setViewValue el.html()

      el.on 'blur', ->
        el.attr 'contenteditable', false
        scope.$apply -> scope[attr.editable] = false

      el.on 'keydown', (event) ->
        if event.keyCode == 13
          event.preventDefault()
          el[0].blur()

      el.on 'dblclick', (event) ->
        event.stopPropagation()
        if not scope[attr.editable] and event.button == 0
          el.attr 'contenteditable', true
          scope.$apply -> scope[attr.editable] = true
          focusCaret el, paper.getZoom()

      scope.$watch attr.editable, (editable) ->
        el.attr 'contenteditable', editable
        if editable
          el[0].focus()

