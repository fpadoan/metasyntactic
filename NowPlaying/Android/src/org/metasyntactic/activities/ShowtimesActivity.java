package org.metasyntactic.activities;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.services.NowPlayingService;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;

import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class ShowtimesActivity extends AbstractNowPlayingListActivity {
  private final List<TheaterWrapper> theaterWrapperList = new ArrayList<TheaterWrapper>();
  private Movie movie;
  private Location userLocation;

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position,
      final long id) {
    if (position < theaterWrapperList.size()) {
      final Theater theater = theaterWrapperList.get(position).theater;
      if (theater != null) {
        final Intent intent = new Intent();
        intent.setClass(this, ShowtimesDetailsActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        intent.putExtra("theater", (Parcelable) theater);
        startActivity(intent);
      }
    }
    super.onListItemClick(listView, view, position, id);
  }

  @Override
  public void onCreate(final Bundle bundle) {
    super.onCreate(bundle);

    setContentView(R.layout.theaters_movie);
    movie = getIntent().getExtras().getParcelable("movie");
  }

  @Override
  protected void onResume() {
    super.onResume();
    bindView();
    final ListAdapter theaterAdapter = new TheaterListAdapter();
    setListAdapter(theaterAdapter);
  }

  @Override
  protected void onDestroy() {
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  private void bindView() {
    final TextView title = (TextView) findViewById(R.id.title);
    title.setText(movie.getDisplayTitle());
    // Get and set scores text and background image
    final View scoreImg = findViewById(R.id.score);
    final TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
    final Resources res = getResources();
    final Score score = getService().getScore(movie);
    int scoreValue = -1;
    if (score != null && score.getValue().length() != 0) {
      scoreValue = Integer.parseInt(score.getValue());
    }

    final ScoreType scoreType = getService().getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType, res));
    if (scoreValue != -1) {
      scoreLbl.setText(scoreValue + "%");
    }
    if (scoreType != ScoreType.RottenTomatoes) {
      scoreLbl.setTextColor(Color.BLACK);
    }
    final TextView ratingLengthLabel = (TextView) findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(movie.getLength(), res);
    final String ratingAndLength = getResources().getString(R.string.string_dot_string, rating, length);

    ratingLengthLabel.setText(ratingAndLength);

    userLocation = NowPlayingService.getLocationForAddress(getService().getUserAddress());
    final List<Theater> localTheaters = getService().getTheatersShowingMovie(movie);
    theaterWrapperList.clear();

    Collections.sort(localTheaters, DISTANCE_ORDER);
    Collections.sort(localTheaters, RATING_ORDER);
    boolean isHeaderAdded = false;
    for (final Theater theater : localTheaters) {
      if (userLocation != null &&
          userLocation.distanceTo(theater.getLocation()) > getService().getSearchDistance() &&
          !getService().isFavoriteTheater(theater) &&
          !isHeaderAdded) {
        theaterWrapperList.add(new TheaterWrapper(null, 2));
        isHeaderAdded = true;
      }
      theaterWrapperList.add(new TheaterWrapper(theater, 1));
    }
  }

  private final Comparator<Theater> DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      if (userLocation == null) {
        return Theater.TITLE_ORDER.compare(m1, m2);
      }
      final Double dist_m1 = userLocation.distanceTo(m1.getLocation());
      final Double dist_m2 = userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  private final Comparator<Theater> RATING_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final boolean isFavoriteM1 = getService().isFavoriteTheater(m1);
      final boolean isFavoriteM2 = getService().isFavoriteTheater(m2);
      if (isFavoriteM1 && isFavoriteM2 || !isFavoriteM1 && !isFavoriteM2) {
        return 0;
      }
      if (isFavoriteM1) {
        return -1;
      }
      return 1;
    }
  };

  private class TheaterListAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private TheaterListAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(ShowtimesActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      final TheaterWrapper theaterWrapper = theaterWrapperList.get(position);
      if (theaterWrapper.type == 1) {
        convertView = inflater.inflate(R.layout.theaterdetails_item, null);
        final TheaterDetailsViewHolder holder =
          new TheaterDetailsViewHolder((TextView) convertView.findViewById(R.id.label),
              (TextView) convertView.findViewById(R.id.data));
        final Theater theater = theaterWrapper.theater;
        holder.label.setText(theater.getName());

        final List<Performance> list = getService().getPerformancesForMovieAtTheater(movie, theater);
        if (CollectionUtilities.size(list) > 0) {
          final String performance = buildPerformanceString(list);
          showStaleShowtimesWarning(convertView, theater);
          holder.data.setText(performance);
        }

        if (getService().isFavoriteTheater(theater)) {
          final View ratingImage = convertView.findViewById(R.id.ratingImage);
          ratingImage.setVisibility(View.VISIBLE);
        }
      } else {
        convertView = inflater.inflate(R.layout.headerview, null);
        final TextView header = (TextView) convertView.findViewById(R.id.name);
        header.setText(getResources().getString(R.string.theaters_out_of_range));
      }
      return convertView;
    }

    private String buildPerformanceString(final Collection<Performance> list) {
      if (list.isEmpty()) {
        return "";
      }
      String performance = "";
      for (final Performance per : list) {
        performance += per.getTime() + ", ";
      }
      performance = performance.substring(0, performance.length() - 2);
      return performance;
    }

    private void showStaleShowtimesWarning(final View convertView, final Theater theater) {
      if (getService().isStale(theater)) {
        final View warningView = convertView.findViewById(R.id.warning);
        warningView.setVisibility(View.VISIBLE);
        final TextView warningText = (TextView) convertView.findViewById(R.id.warningText);
        warningText.setText(getService().getShowtimesRetrievedOnString(theater, getResources()));
      }
    }

    public int getCount() {
      return theaterWrapperList.size();
    }

    private class TheaterDetailsViewHolder {
      private final TextView label;
      private final TextView data;

      private TheaterDetailsViewHolder(final TextView label, final TextView data) {
        this.label = label;
        this.data = data;
      }
    }

    public Object getItem(final int position) {
      return theaterWrapperList.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }
  }

  private static class TheaterWrapper {
    private final Theater theater;
    private final int type; // 1 = theater, 2 = header

    private TheaterWrapper(final Theater theater, final int type) {
      this.theater = theater;
      this.type = type;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
    return super.onCreateOptionsMenu(menu);
  }
}
