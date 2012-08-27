package com.example.sudoku

import android.app.Activity

class Game < Activity
  KEY_DIFFICULTY = "com.example.sudoku.difficulty"
  DIFFICULTY_EASY = 0
  DIFFICULTY_MEDIUM = 1
  DIFFICULTY_HARD = 2

  def onCreate(state)
    super state

    diff = getIntents().getIntExtra(KEY_DIFFICULTY, DIFFICULTY_EASY)
    @puzzle = getPuzzle(diff)
    calculateUsedTiles
    @puzzle_view = PuzzleView.new(self)
    setContentView(@puzzle_view)
    puzzle_view.requestFocus
  end
end
