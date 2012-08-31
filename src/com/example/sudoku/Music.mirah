package com.example.sudoku

import android.content.Context
import android.media.MediaPlayer

class Music
  @@mp = MediaPlayer(nil)

  def self.play(context:Context, res:int)
    stop(context)
    if (Prefs.getMusic(context))
      @@mp = MediaPlayer.create(context, res)
      @@mp.setLooping(true)
      @@mp.start
    end
  end

  def self.stop(context:Context)
    if (@@mp != nil)
      @@mp.stop
      @@mp.release
      @@mp = nil
    end
  end
end
