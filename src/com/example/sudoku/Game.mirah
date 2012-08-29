package com.example.sudoku

import android.app.Activity
import android.util.Log
import android.view.Gravity
import android.widget.Toast
import java.util.ArrayList
import java.util.HashSet

class Game < Activity
  def getPuzzle(diff:int)
    if (diff == @res.getInteger(R.integer.easy_difficulty))
      return Puzzle.new([ 3, 6, 0, 0, 0, 0, 0, 0, 0, 
               0, 0, 4, 2, 3, 0, 8, 0, 0, 
               0, 0, 0, 0, 0, 4, 2, 0, 0, 
               0, 7, 0, 4, 6, 0, 0, 0, 3, 
               8, 2, 0, 0, 0, 0, 0, 1, 4, 
               5, 0, 0, 0, 1, 3, 0, 2, 0, 
               0, 0, 1, 9, 0, 0, 0, 0, 0, 
               0, 0, 7, 0, 4, 8, 3, 0, 0, 
               0, 0, 0, 0, 0, 0, 0, 4, 5 ])
    elsif (diff == @res.getInteger(R.integer.medium_difficulty))
      return Puzzle.new([ 6, 5, 0, 0, 0, 0, 0, 7, 0,
               0, 0, 0, 5, 0, 6, 0, 0, 0, 
               0, 1, 4, 0, 0, 0, 0, 0, 5, 
               0, 0, 7, 0, 0, 9, 0, 0, 0, 
               0, 0, 2, 3, 1, 4, 7, 0, 0, 
               0, 0, 0, 7, 0, 0, 8, 0, 0, 
               5, 0, 0, 0, 0, 0, 6, 3, 0, 
               0, 0, 0, 2, 0, 1, 0, 0, 0, 
               0, 3, 0, 0, 0, 0, 0, 9, 7 ])
    elsif (diff == @res.getInteger(R.integer.hard_difficulty))
      return Puzzle.new([ 0, 0, 9, 0, 0, 0, 0, 0, 0, 
               0, 8, 0, 6, 0, 5, 0, 2, 0, 
               5, 0, 1, 0, 7, 8, 0, 0, 0, 
               0, 0, 0, 0, 0, 0, 7, 0, 0, 
               7, 0, 6, 0, 4, 0, 1, 0, 2, 
               0, 0, 4, 0, 0, 0, 0, 0, 0, 
               0, 0, 0, 7, 2, 0, 9, 0, 3, 
               0, 9, 0, 3, 0, 1, 0, 8, 0, 
               0, 0, 0, 0, 0, 0, 6, 0, 0 ])
    else
      return Puzzle.new([ 3, 6, 0, 0, 0, 0, 0, 0, 0, 
               0, 0, 4, 2, 3, 0, 8, 0, 0, 
               0, 0, 0, 0, 0, 4, 2, 0, 0, 
               0, 7, 0, 4, 6, 0, 0, 0, 3, 
               8, 2, 0, 0, 0, 0, 0, 1, 4, 
               5, 0, 0, 0, 1, 3, 0, 2, 0, 
               0, 0, 1, 9, 0, 0, 0, 0, 0, 
               0, 0, 7, 0, 4, 8, 3, 0, 0, 
               0, 0, 0, 0, 0, 0, 0, 4, 5 ])
    end
  end

  def calculateUsedTiles
    @used = ArrayList.new
    x=0
    while (x < 9)
      y=0
      x_used = ArrayList.new
      while (y < 9)
        y_used = @puzzle.calculateUsedTiles(x, y)
        x_used.add(y_used)
        y+=1 
      end
      @used.add(x_used)
      x+=1
    end
    Log.d("Game", "usedtiles: #{@used}")
  end

  def onCreate(state)
    super state
    Log.d("Game", "onCreate")
    @res = getResources
    diff = getIntent.getIntExtra(@res.getString(R.string.difficulty_key), @res.getInteger(R.integer.easy_difficulty))
    @puzzle = getPuzzle(diff)
    Log.d("Game", "got puzzle")
    calculateUsedTiles
    @puzzle_view = PuzzleView.new(self)
    setContentView(@puzzle_view)
    @puzzle_view.requestFocus
  end

  def getTileString(x:int, y:int)
    @puzzle.getTileString(x,y)
  end

  def showKeypadOrError(x:int, y:int)
    tiles = getUsedTiles(x,y)
    if (tiles.size == 9)
      toast = Toast.makeText(self, R.string.no_moves_label, Toast.LENGTH_SHORT)
      toast.setGravity(Gravity.CENTER, 0, 0)
      toast.show
    else
      Keypad.new(self, tiles, @puzzle_view).show
    end
    true
  end

  def setTileIfValid(x:int, y:int, value:int)
    tiles = getUsedTiles(x, y)
    if (value != 0)
      for tile in tiles
        if Integer(tile) == Integer.valueOf(value)
          return false
        end
      end
    end
    @puzzle.setTile(x,y,value)
    calculateUsedTiles
    true
  end

  def getUsedTiles(x:int, y:int)
    x_used = ArrayList(@used.get(x))
    HashSet(x_used.get(y))
  end
end
