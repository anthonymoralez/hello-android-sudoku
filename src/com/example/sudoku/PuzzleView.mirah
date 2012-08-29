package com.example.sudoku

import android.content.Context
import android.graphics.Paint
import android.graphics.Paint.Style
import android.graphics.Rect
import android.view.KeyEvent
import android.view.View
import android.util.Log

class PuzzleView < View
  def initialize(context:Context)
    super context
    @selX = 0 
    @selY = 0 
    @game = Game(context)
    @selRect = Rect.new
    setFocusable true
    setFocusableInTouchMode true
    
    Log.d("PuzzleView", "constructed")
  end

  def onKeyDown(key, event)
    return select(@selX, @selY -1) if (key == KeyEvent.KEYCODE_DPAD_UP)
    return select(@selX, @selY +1) if (key == KeyEvent.KEYCODE_DPAD_DOWN)
    return select(@selX-1, @selY) if (key == KeyEvent.KEYCODE_DPAD_LEFT)
    return select(@selX+1, @selY) if (key == KeyEvent.KEYCODE_DPAD_RIGHT)
    return super key, event
  end

  def select(x:int, y:int)
    invalidate(@selRect)
    @selX = Math.min(Math.max(x, 0),8)
    @selY = Math.min(Math.max(y, 0),8)
    getRect(@selX, @selY, @selRect)
    invalidate(@selRect)
    true
  end

  def onSizeChanged(w, h, oldw, oldh)
    Log.d("PuzzleView", "size changed: #{w}x#{h}")
    @width = int(w/9.0)
    @height = int(h/9.0)
    getRect(@selX, @selY, @selRect)
    super w, h, oldw, oldh
  end

  def getRect(x:int, y:int, rect:Rect)
    rect.set(int(x*@width), int(y*@height), int(x*@width + @width), int(y*@height + @height))
  end

  def onDraw(canvas)
    Log.d("PuzzleView", "drawing bg")
    # draw background
    background = loadColor R.color.puzzle_background
    canvas.drawRect(0,0, getWidth, getHeight, background)

    Log.d("PuzzleView", "drawing lines")
    #draw board
    #line colors
    dark = loadColor R.color.puzzle_dark 
    hilite = loadColor R.color.puzzle_hilite 
    light = loadColor R.color.puzzle_light 

    #draw lines
    i = 0
    while (i < 9)
      #minor lines
      canvas.drawLine(0, i*@height, getWidth, i*@height, light)
      canvas.drawLine(0, i*@height+1, getWidth, i*@height+1, hilite)
      canvas.drawLine(i*@width, 0, i*@width, getHeight, light)
      canvas.drawLine(i*@width+1, 0, i*@width+1, getHeight, hilite)
      #major lines
      if (i % 3 == 0)
        canvas.drawLine(0, i*@height, getWidth, i*@height, dark)
        canvas.drawLine(0, i*@height+1, getWidth, i*@height+1, hilite)
        canvas.drawLine(i*@width, 0, i*@width, getHeight, dark)
        canvas.drawLine(i*@width+1, 0, i*@width+1, getHeight, hilite)
      end
      i+=1
    end

    #draw numbers
    Log.d("PuzzleView", "drawing numbers")
    foreground = loadColor(R.color.puzzle_foreground)
    foreground.setStyle(Style.FILL)
    foreground.setTextSize(float(@height * 0.75))
    foreground.setTextScaleX(@width/@height)
    foreground.setTextAlign(Paint.Align.CENTER)

    fm = foreground.getFontMetrics
    x = @width / 2
    y = @height / 2 - (fm.ascent + fm.descent) / 2
    i = 0
    while (i < 9)
      j = 0 
      while (j < 9)
        canvas.drawText(@game.getTileString(i, j), i * @width + x, j*@height + y, foreground)
        j+=1
      end
      i+=1
    end

    #draw hints
    #draw selection
    selected = loadColor(R.color.puzzle_selected)
    canvas.drawRect(@selRect, selected)
  end

  def loadColor(key:int)
    paint = Paint.new
    paint.setColor(getResources.getColor(key))
    paint
  end
end

