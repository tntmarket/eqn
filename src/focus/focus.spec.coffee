define [
   'angular'
   'focus/focus'
], (
   angular
   Focus
) ->
   describe "Focus", ->
      el = null
      WIDTH_OF_12PX_M = 10
      SIDE_PADDING = 7

      before ->
         el = angular.element "<div style=\"
            display: inline-block;
            font-size: 12px;
            padding: 3px #{SIDE_PADDING}px 3px #{SIDE_PADDING}px;
         \">MMMMM</div>"
         (angular.element document.body).append el

      caretShouldBeAt = (caretPosition) ->
         getSelection().anchorOffset.should.equal caretPosition
         getSelection().isCollapsed.should.equal true

      it "focuses the first character", ->
         Focus.firstChar el
         getSelection().anchorOffset.should.equal 0
         getSelection().focusOffset.should.equal  1

      it "puts the caret next to the clicked character", ->
         Focus.whereClicked el, WIDTH_OF_12PX_M * 2.1 + SIDE_PADDING, 1
         caretShouldBeAt 2

      it "puts the caret next to the clicked first character", ->
         Focus.whereClicked el, WIDTH_OF_12PX_M * 0.1 + SIDE_PADDING, 1
         caretShouldBeAt 0

      it "puts the caret at the start when left padding is clicked", ->
         Focus.whereClicked el, 0, 1
         caretShouldBeAt 0

      it "puts the caret at the end when right padding is clicked", ->
         Focus.whereClicked el, el[0].clientWidth, 1
         caretShouldBeAt 5

      after ->
         (angular.element document.body).remove el



