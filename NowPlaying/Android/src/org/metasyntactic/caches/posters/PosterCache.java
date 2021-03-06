// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package org.metasyntactic.caches.posters;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractMovieCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;

public class PosterCache extends AbstractMovieCache {
  public PosterCache(final NowPlayingModel model) {
    super(model);
  }

  private static File posterFile(final Movie movie) {
    return new File(NowPlayingApplication.postersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()) + ".jpg");
  }

  @Override
  public void updateMovieDetailsWorker(final Movie movie) {
    if (movie == null) {
      return;
    }

    final File file = posterFile(movie);
    if (file.exists()) {
      return;
    }

    final byte[] data = downloadPosterWorker(movie);
    if (data != null) {
      FileUtilities.writeBytes(data, file);
      NowPlayingApplication.refresh();
    }
  }

  private byte[] downloadPosterWorker(final Movie movie) {
    if (shutdown) { return null; }
    byte[] data = NetworkUtilities.download(movie.getPoster(), false);
    if (data != null) {
      return data;
    }

    if (shutdown) { return null; }
    data = ApplePosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    if (shutdown) { return null; }
    data = FandangoPosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    /*
     * data = ImdbPosterDownloader.download(movie); if (data != null) { return
     * data; }
     */

    if (shutdown) { return null; }
    model.getLargePosterCache().downloadFirstPoster(movie);

    return null;
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.singletonList(NowPlayingApplication.postersDirectory);
  }

  public static byte[] getPoster(final Movie movie) {
    return FileUtilities.readBytes(posterFile(movie));
  }

  public static File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return posterFile(movie);
  }

  @Override
  public void onLowMemory() {
    super.onLowMemory();
    ApplePosterDownloader.onLowMemory();
    FandangoPosterDownloader.onLowMemory();
    ImdbPosterDownloader.onLowMemory();
  }
}
