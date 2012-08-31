package com.example.sudoku

import android.content.Context
import android.app.Activity
import android.util.Log
import android.view.Gravity
import android.widget.Toast
import java.util.ArrayList
import java.util.HashSet

class Game < Activity
  def self.easy_puzzle
    "360000000004230800000004200070460003820000014500013020001900000007048300000000045"
  end
  def self.medium_puzzle
    "650000070000506000014000005007009000002314700000700800500000630000201000030000097"
  end
  def self.hard_puzzle
    "009000000080605020501078000000000700706040102004000000000720903090301080000000600"
  end

  def onCreate(state)
    super state
    Log.d("Game", "onCreate")
    @res = getResources
    diff_key = @res.getString(R.string.difficulty_key)
    diff = getIntent.getIntExtra(diff_key, @res.getInteger(R.integer.easy_difficulty))
    @puzzle = getPuzzle(diff)
    Log.d("Game", "got puzzle")
    calculateUsedTiles
    @puzzle_view = PuzzleView.new(self)
    setContentView(@puzzle_view)
    @puzzle_view.requestFocus
    getIntent.putExtra(diff_key, @res.getInteger(R.integer.continue_difficutly))
  end

  def onResume()
    super
    Music.play(self, R.raw.game)
  end

  def onPause()
    super
    Music.stop(self)
    getPreferences(Context.MODE_PRIVATE).edit.putString("puzzle", @puzzle.to_s).commit
  end

  def getPuzzle(diff:int)
    if (diff == @res.getInteger(R.integer.continue_difficutly))
      return Puzzle.new(getPreferences(Context.MODE_PRIVATE).getString("puzzle", Game.easy_puzzle))
    elsif (diff == @res.getInteger(R.integer.easy_difficulty))
      return Puzzle.new(Game.easy_puzzle)
    elsif (diff == @res.getInteger(R.integer.medium_difficulty))
      return Puzzle.new(Game.medium_puzzle)
    elsif (diff == @res.getInteger(R.integer.hard_difficulty))
      return Puzzle.new(Game.hard_puzzle)
    else
      return Puzzle.new(Game.easy_puzzle)
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

  def getTileString(x:int, y:int):String
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
