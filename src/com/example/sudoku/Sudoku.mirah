package com.example.sudoku

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.view.View.OnClickListener

class Sudoku < Activity
  implements OnClickListener
  def onCreate(state)
    super state
    setContentView R.layout.main

    findViewById(R.id.continue_button).setOnClickListener self
    findViewById(R.id.new_game_button).setOnClickListener self
    findViewById(R.id.about_button).setOnClickListener self
    findViewById(R.id.exit_button).setOnClickListener self
  end

  def onCreateOptionsMenu(menu)
    super menu
    inflater = getMenuInflater
    inflater.inflate(R.menu.menu, menu)
    true
  end

  def onOptionsItemSelected(item)
    if (item.getItemId == R.id.settings)
      startActivity(Intent.new(self, Prefs.class))
      return true
    end
    false
  end

  def onClick(v)
    view_id = v.getId
    if (view_id == R.id.about_button) 
      intent = Intent.new(self, About.class)
      startActivity(intent)
    end
  end

end
