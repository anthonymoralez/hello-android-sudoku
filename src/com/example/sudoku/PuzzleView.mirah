package com.example.sudoku

import android.graphics.Rect
import android.view.View

class PuzzleView < View
  def initialize(context)
    super context
    
    @game = context
    @selRect = Rect.new
    setFocusable true
    setFocusableInTouchMode true
  end

  def onSizeChanged(w, h, oldw, oldh)
    super w, h, oldw, oldh
    @width = w/9.0
    @height = h/9.0
    getRect(@selX, @selY, @selRect)
  end

  def getRect(x, y, rect)
    rect.set(int(x*@width), int(y*@height), int(x*@width + @width), int(y*@height + @height))
  end
end

