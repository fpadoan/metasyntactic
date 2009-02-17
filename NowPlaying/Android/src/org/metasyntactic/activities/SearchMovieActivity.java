package org.metasyntactic.activities;

import android.app.Activity;
import android.app.SearchManager;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.utilities.StringUtilities;

/**
 * This activity shows a text field to ask the user to enter search terms and
 * then start the ThreadActivity with the correct postData to invoke a search.
 */

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class SearchMovieActivity extends Activity implements View.OnClickListener {
  private EditText mSearchText;
  private static String activityName;

  @Override
  public void onCreate(final Bundle icicle) {
    super.onCreate(icicle);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);

    setContentView(R.layout.search_bar);
    this.mSearchText = (EditText) findViewById(R.id.search_src_text);
    this.mSearchText.setOnClickListener(this);
    findViewById(R.id.search_go_btn).setOnClickListener(this);
    activityName = getIntent().getStringExtra("activity");
  }

  @Override protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");

    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
  }

  @Override protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }

  // View.OnClickListener
  public final void onClick(final View v) {
    if (this.mSearchText.length() != 0) {
      performSearch();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    super.onCreateOptionsMenu(menu);
    menu.add(0, 0, 0, R.string.search).setAlphabeticShortcut(SearchManager.MENU_KEY).setOnMenuItemClickListener(
        new MenuItem.OnMenuItemClickListener() {
          public boolean onMenuItemClick(final MenuItem item) {
            performSearch();
            return true;
          }
        });
    return true;
  }

  private void performSearch() {
    final String searchTerm = this.mSearchText.getText().toString();
    privatePerformSearch(this, getText(R.string.search) + " : " + searchTerm, searchTerm, null);
  }

  static public void performLabel(final Activity activity, final String label, final String title) {
    privatePerformSearch(activity, title, null, label);
  }

  private static void privatePerformSearch(final Activity activity, final String title, final String search,
                                           final String label) {
    if (!StringUtilities.isNullOrEmpty(search) || !StringUtilities.isNullOrEmpty(label)) {
      final Intent intent = new Intent();
      if ("NowPlayingActivity".equals(activityName)) {
        intent.setClass(activity, NowPlayingActivity.class);
      } else {
        intent.setClass(activity, UpcomingMoviesActivity.class);
      }
      intent.putExtra("movie", search);
      activity.startActivity(intent);
    }
  }
}