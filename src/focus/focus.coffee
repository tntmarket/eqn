define ->
   range = document.createRange()

   focus = (el, offset) ->
      range.setStart el[0].firstChild, offset
      range.collapse true
      getSelection().removeAllRanges()
      getSelection().addRange range
      el[0].focus()

   return (
      firstChar: (el) ->
         range.setStart el[0].firstChild, 0
         range.setEnd el[0].firstChild, 1
         getSelection().removeAllRanges()
         getSelection().addRange range
         el[0].focus()

      whereClicked: (el, clickXOffset, zoom) ->
         LEFT_PADDING_AND_BORDER = 7
         PADDING_AND_BORDER = 14
         pxFromStart = (clickXOffset - LEFT_PADDING_AND_BORDER) / zoom
         stringPxWidth = el[0].clientWidth - PADDING_AND_BORDER
         numChars = el.text().length
         offset = Math.round (pxFromStart / stringPxWidth * numChars)
         if offset < 0
            offset = 0
         else if offset > numChars
            offset = numChars
         focus el, offset
   )
