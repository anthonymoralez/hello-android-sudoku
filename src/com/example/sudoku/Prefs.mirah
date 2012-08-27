package com.example.sudoku

import android.preference.PreferenceActivity

class Prefs < PreferenceActivity
  def onCreate(state)
    super state
    addPreferencesFromResource(R.xml.settings)
  end
end
