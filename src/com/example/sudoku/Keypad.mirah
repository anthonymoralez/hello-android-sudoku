package com.example.sudoku

import android.app.Dialog
import android.content.Context
import android.view.KeyEvent
import android.view.View
import android.view.View.OnClickListener
import java.util.ArrayList
import java.util.Set

class Keypad < Dialog
  def initialize(context:Context, useds:Set, puzzleView:PuzzleView)
    super context
    @useds = useds
    @puzzleView = puzzleView
  end

  def onCreate(state)
    super state
    setTitle(R.string.keypad_title)
    setContentView(R.layout.keypad)
    findViews
    for element in @useds
      i = Integer(element).byteValue - 1
      if (i < @keys.size)
        key = View(@keys.get(i))
        key.setVisibility(View.INVISIBLE)
      end
    end
    setListeners
  end

  def findViews
    @keypad = findViewById(R.id.keypad)
    @keys = ArrayList.new(9)
    @keys.add(findViewById(R.id.keypad_1))
    @keys.add(findViewById(R.id.keypad_2))
    @keys.add(findViewById(R.id.keypad_3))
    @keys.add(findViewById(R.id.keypad_4))
    @keys.add(findViewById(R.id.keypad_5))
    @keys.add(findViewById(R.id.keypad_6))
    @keys.add(findViewById(R.id.keypad_7))
    @keys.add(findViewById(R.id.keypad_8))
    @keys.add(findViewById(R.id.keypad_9))
  end

  class ReturnResult 
    implements OnClickListener
    def initialize(context:Keypad, ret:int)
      @ret = ret
      @context = context
    end
    def onClick(view)
      @context.returnResult(@ret) 
    end
  end

  def setListeners
    i = 0
    while(i < 9)
      key = View(@keys.get(i))
      key.setOnClickListener ReturnResult.new(self, i+1)
      i+=1
    end
    @keypad.setOnClickListener ReturnResult.new(self, 0)
  end

  def onKeyDown(code, event) 
    tile = -1
    tile = 0 if (KeyEvent.KEYCODE_0 == code or KeyEvent.KEYCODE_SPACE == code)
    tile = 1 if (KeyEvent.KEYCODE_1 == code)
    tile = 2 if (KeyEvent.KEYCODE_2 == code)
    tile = 3 if (KeyEvent.KEYCODE_3 == code)
    tile = 4 if (KeyEvent.KEYCODE_4 == code)
    tile = 5 if (KeyEvent.KEYCODE_5 == code)
    tile = 6 if (KeyEvent.KEYCODE_6 == code)
    tile = 7 if (KeyEvent.KEYCODE_7 == code)
    tile = 8 if (KeyEvent.KEYCODE_8 == code)
    tile = 9 if (KeyEvent.KEYCODE_9 == code)
    return super code, event if (tile == -1)

    if (isValid(tile))
      returnResult(tile)
    end
    true
  end

  def isValid(tile:int)
    for t in @useds
      if (t == Integer.valueOf(tile))
        return false
      end
    end
    true
  end

  def returnResult(tile:int)
    @puzzleView.setSelectedTile(tile)
    dismiss
  end
end
