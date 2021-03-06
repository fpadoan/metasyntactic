package org.metasyntactic;

import org.metasyntactic.services.NowPlayingService;

import android.content.Context;

public interface RefreshableContext {
  /**
   * Updates the current tab view.
   */
  void refresh();
  
  Context getContext();
  NowPlayingService getService();
}