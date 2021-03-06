// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MovieDetailsViewController.h"

#import "BookmarkCache.h"
#import "BoxOfficeStockImages.h"
#import "CollapsedMovieDetailsCell.h"
#import "DVD.h"
#import "ExpandedMovieDetailsCell.h"
#import "FavoriteTheaterCache.h"
#import "LargeMoviePosterCache.h"
#import "LookupResult.h"
#import "Model.h"
#import "MovieCacheUpdater.h"
#import "MovieShowtimesCell.h"
#import "NetflixRatingsCell.h"
#import "NetflixStatusCell.h"
#import "Score.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"
#import "UpcomingCache.h"
#import "Utilities.h"

@interface MovieDetailsViewController()
@property (retain) Movie* movie;
@property (retain) DVD* dvd;
@property (retain) Movie* netflixMovie;
@property (retain) NSArray* netflixStatusCells;
@property (retain) NetflixAccount* netflixAccount;
@property (retain) NetflixRatingsCell* netflixRatingsCell;
@property (retain) NSMutableArray* filteredTheatersArray;
@property (retain) NSMutableArray* allTheatersArray;
@property (retain) NSMutableArray* showtimesArray;
@property (retain) NSArray* trailersArray;
@property (retain) NSArray* reviewsArray;
@property (retain) NSDictionary* websites;
@property (retain) ActionsView* actionsView;
@property (retain) UIImage* posterImage;
@property (retain) TappableImageView* posterImageView;
@property (retain) UIButton* bookmarkButton;
@property (retain) NSDictionary* buttonIndexToActionMap;
@property (retain) MPMoviePlayerController* moviePlayerController;
@end


@implementation MovieDetailsViewController

typedef enum {
  HeaderSection,
  TrailerSection,
  NetflixSection,
  FirstTheaterSection,
} Sections;

typedef enum {
  InstantQueue,
  TopOfInstantQueue,
  DVDQueue,
  TopOfDVDQueue,
  BlurayQueue,
  TopOfBlurayQueue
} AddToQueueAction;

//typedef enum {
//  MovieControlStyleNone,
//  MovieControlStyleEmbedded,
//  MovieControlStyleFullscreen,
//  MovieControlStyleDefault = MovieControlStyleFullscreen
//} MovieControlStyle;

@synthesize movie;
@synthesize dvd;
@synthesize netflixAccount;
@synthesize netflixMovie;
@synthesize netflixStatusCells;
@synthesize netflixRatingsCell;
@synthesize filteredTheatersArray;
@synthesize allTheatersArray;
@synthesize showtimesArray;
@synthesize trailersArray;
@synthesize reviewsArray;
@synthesize websites;
@synthesize actionsView;
@synthesize posterImage;
@synthesize posterImageView;
@synthesize bookmarkButton;
@synthesize buttonIndexToActionMap;
@synthesize moviePlayerController;

- (void) dealloc {
  self.movie = nil;
  self.dvd = nil;
  self.netflixAccount = nil;
  self.netflixMovie = nil;
  self.netflixStatusCells = nil;
  self.netflixRatingsCell = nil;
  self.filteredTheatersArray = nil;
  self.allTheatersArray = nil;
  self.showtimesArray = nil;
  self.trailersArray = nil;
  self.reviewsArray = nil;
  self.websites = nil;
  self.actionsView = nil;
  self.posterImage = nil;
  self.posterImageView = nil;
  self.bookmarkButton = nil;
  self.buttonIndexToActionMap = nil;
  self.moviePlayerController = nil;

  [super dealloc];
}


- (NetflixUpdater*) netflixUpdater {
  return [NetflixUpdater updater];
}


- (NSMutableArray*) orderTheaters:(NSMutableArray*) theatersArray {
  [theatersArray sortUsingFunction:compareTheatersByDistance
                           context:[Model model].theaterDistanceMap];

  NSMutableArray* favorites = [NSMutableArray array];
  NSMutableArray* nonFavorites = [NSMutableArray array];

  for (Theater* theater in theatersArray) {
    if ([[FavoriteTheaterCache cache] isFavoriteTheater:theater]) {
      [favorites addObject:theater];
    } else {
      [nonFavorites addObject:theater];
    }
  }

  NSMutableArray* result = [NSMutableArray array];
  [result addObjectsFromArray:favorites];
  [result addObjectsFromArray:nonFavorites];

  return result;
}


- (void) orderTheaters {
  self.allTheatersArray = [self orderTheaters:allTheatersArray];
  self.filteredTheatersArray = [self orderTheaters:filteredTheatersArray];
}


- (BOOL) isUpcomingMovie {
  for (Movie* upcomingMovie in [[UpcomingCache cache] movies]) {
    if (upcomingMovie == movie) {
      return YES;
    }
  }

  return NO;
}


- (BOOL) isDVD {
  return dvd != nil;
}


- (BOOL) isNetflix {
  return movie.isNetflix;
}


- (void) setupActionsView {
  NSMutableArray* selectors = [NSMutableArray array];
  NSMutableArray* titles = [NSMutableArray array];
  NSMutableArray* arguments = [NSMutableArray array];

  if (trailersArray.count > 0 &&
      ![Model model].isInReviewPeriod &&
      [Portability userInterfaceIdiom] == UserInterfaceIdiomPhone) {
    [selectors addObject:[NSValue valueWithPointer:@selector(playTrailer)]];
    [titles addObject:LocalizedString(@"Play trailer", @"Title for a button. Needs to be very short. 2-3 words *max*. User taps it when they want to watch the trailer for a movie")];
    [arguments addObject:[NSNull null]];
  }

  if (reviewsArray.count > 0) {
    [selectors addObject:[NSValue valueWithPointer:@selector(readReviews)]];
    [titles addObject:LocalizedString(@"Read reviews", @"Title for a button. Needs to be very short. 2-3 words *max*. User taps it when they want to read the critics' reviews for a movie")];
    [arguments addObject:[NSNull null]];
  }

  if (filteredTheatersArray.count > 0) {
    [selectors addObject:[NSValue valueWithPointer:@selector(emailListings)]];
    [titles addObject:LocalizedString(@"E-mail listings", nil)];
    [arguments addObject:[NSNull null]];
  }

  NetflixUser* user = [[NetflixUserCache cache] userForAccount:netflixAccount];
  if (netflixMovie != nil && netflixStatusCells.count == 0) {
    if ([[NetflixCache cache] user:user canRentMovie:netflixMovie]) {
      [selectors addObject:[NSValue valueWithPointer:@selector(addToQueue)]];
      [titles addObject:LocalizedString(@"Add to Netflix", @"Title for a button. Needs to be very short. 2-3 words *max*. User taps it when they want to add this movie to their Netflix queue")];
      [arguments addObject:[NSNull null]];
    }
  }

  if (![self isUpcomingMovie] && ![self isDVD] && ![self isNetflix]) {
    [selectors addObject:[NSValue valueWithPointer:@selector(changeDate)]];
    [titles addObject:LocalizedString(@"Change date", nil)];
    [arguments addObject:[NSNull null]];
  }

  if ((selectors.count + websites.count) > 6) {
    // condense to one button
    [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsites)]];
    [titles addObject:LocalizedString(@"Websites", @"Title for a button. Needs to be very short. 2-3 words *max*. When tapped, will show the user a list of websites with additional information about the movie")];
    [arguments addObject:[NSNull null]];
  } else {
    // show individual buttons
    for (NSString* name in [websites.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
      [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsite:)]];
      NSString* title = name;
      [titles addObject:title];
      [arguments addObject:[websites objectForKey:name]];
    }
  }

  if (selectors.count == 0) {
    self.actionsView = nil;
  } else {
    self.actionsView = [ActionsView viewWithTarget:self
                                         selectors:selectors
                                            titles:titles
                                         arguments:arguments];

    [actionsView sizeToFit];
  }
}


+ (UIImage*) posterForMovie:(Movie*) movie {
  UIImage* image = nil;

  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    image = [[LargeMoviePosterCache cache] posterForMovie:movie loadFromDisk:YES];
  }

  if (image == nil) {
    image = [[Model model] posterForMovie:movie];
  }

  if (image != nil) {
    return image;
  }

  return [BoxOfficeStockImages imageNotAvailable];
}


- (void) initializeWebsites {
  NSMutableDictionary* map = [NSMutableDictionary dictionary];

  if (![Model model].isInReviewPeriod) {
    NSString* imdbAddress = [[Model model] imdbAddressForMovie:movie];
    if (imdbAddress.length > 0) {
      [map setObject:imdbAddress forKey:@"IMDb"];
    }

    NSString* amazonAddress = [[Model model] amazonAddressForMovie:movie];
    if (amazonAddress.length > 0) {
      [map setObject:amazonAddress forKey:@"Amazon"];
    }

    NSString* wikipediaAddress = [[Model model] wikipediaAddressForMovie:movie];
    if (wikipediaAddress.length > 0) {
      [map setObject:wikipediaAddress forKey:@"Wikipedia"];
    }

    NSString* netflixAddress = [[Model model] netflixAddressForMovie:movie];
    if (netflixAddress.length > 0) {
      [map setObject:netflixAddress forKey:LocalizedString(@"Netflix", nil)];
    }

    NSString* rottenTomatoesAddress = [[Model model] rottenTomatoesAddressForMovie:movie];
    if (rottenTomatoesAddress.length > 0) {
      [map setObject:rottenTomatoesAddress forKey:@"RottenTomatoes"];
    }

    NSString* metacriticAddress = [[Model model] metacriticAddressForMovie:movie];
    if (metacriticAddress.length > 0) {
      [map setObject:metacriticAddress forKey:@"Metacritic"];
    }

    if (dvd != nil) {
      [map setObject:dvd.url forKey:@"VideoETA"];
    }
  }

  self.websites = map;
}


- (void) updateImage {
  UIImage* image = [MovieDetailsViewController posterForMovie:movie];

  // we currently have a poster.  only replace it if we have something better
  if (image != nil && image != [BoxOfficeStockImages imageNotAvailable]) {
    self.posterImage = image;
  }
}


- (void) initializeNetflixStatusCells {
  NSArray* statuses = [[NetflixCache cache] statusesForMovie:netflixMovie account:netflixAccount];

  NSMutableArray* cells = [NSMutableArray array];
  for (NSInteger i = 0; i < statuses.count; i++) {
    Status* status = [statuses objectAtIndex:i];
    NetflixStatusCell* cell = [[[NetflixStatusCell alloc] initWithStatus:status
                                                                     row:i
                                               tappableImageViewDelegate:self] autorelease];

    [cells addObject:cell];
  }

  // try to workaround the crash with released cells
  [netflixStatusCells retain];
  [netflixStatusCells performSelectorOnMainThread:@selector(autorelease) withObject:nil waitUntilDone:NO];

  self.netflixStatusCells = cells;
}


- (void) initializeTheaterArrays {
  self.allTheatersArray = [NSMutableArray arrayWithArray:[[Model model] theatersShowingMovie:movie]];

  if (filterTheatersByDistance) {
    self.filteredTheatersArray = [NSMutableArray arrayWithArray:[[Model model] theatersInRange:self.allTheatersArray]];
  } else {
    self.filteredTheatersArray = self.allTheatersArray;
  }

  [self orderTheaters];

  self.showtimesArray = [NSMutableArray array];

  for (Theater* theater in filteredTheatersArray) {
    [self.showtimesArray addObject:[[Model model] moviePerformances:movie forTheater:theater]];
  }
}


- (void) setupTrailersArray {
  NSArray* array = [[Model model] trailersForMovie:movie];
  NSMutableArray* result = [NSMutableArray array];

  for (NSString* trailer in array) {
    trailer = [trailer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trailer.length > 0) {
      [result addObject:trailer];
    }
  }

  self.trailersArray = result;
}


- (void) disconnectFromMoviePlayer {
  if ([Portability userInterfaceIdiom] != UserInterfaceIdiomPad) {
    return;
  }

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];

  //[moviePlayerController setShouldAutoplay:NO];
  [moviePlayerController stop];
  moviePlayerController = nil;
  playingTrailer = NO;
}


- (BOOL) hasTrailer {
  return trailersArray.count > 0;
}

enum {
  MovieControlStyleNone,
  MovieControlStyleEmbedded,
  MovieControlStyleFullscreen,
  MovieControlStyleDefault = MovieControlStyleFullscreen
};
typedef NSInteger MovieControlStyle;

- (void) setControlStyle:(MovieControlStyle) style {
}


- (void) setupMoviePlayer {
  if ([Portability userInterfaceIdiom] != UserInterfaceIdiomPad) {
    return;
  }

  [self disconnectFromMoviePlayer];
  if (!self.hasTrailer) {
    return;
  }

  NSString* address = trailersArray.firstObject;
  self.moviePlayerController = [[[MPMoviePlayerController alloc] initWithContentURL:
                                 [NSURL URLWithString:address]] autorelease];

  [(id)moviePlayerController setControlStyle:MovieControlStyleFullscreen];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(movieFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:moviePlayerController];

  [moviePlayerController play];
  playingTrailer = YES;
}


- (void) updateMovieTrailerRow {
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:TrailerSection];
  [self.tableView beginUpdates];
  {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
  }
  [self.tableView endUpdates];

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
  [self disconnectFromMoviePlayer];
  [self updateMovieTrailerRow];
}


- (void) initializeData {
  self.netflixAccount = [[NetflixAccountCache cache] currentAccount];
  self.netflixMovie = [[NetflixCache cache] correspondingNetflixMovie:movie];
  [self initializeNetflixStatusCells];

  [self setupTrailersArray];

  self.reviewsArray = [NSArray arrayWithArray:[[Model model] reviewsForMovie:movie]];

  [self initializeTheaterArrays];

  [self initializeWebsites];
  [self updateImage];
  [self setupActionsView];
}


- (id) initWithMovie:(Movie*) movie_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.movie = movie_;
  }

  return self;
}


//- (void) viewDidAppear:(BOOL) animated {
//  [super viewController:controller willAppear:animated];
//  [self connectToMoviePlayer];
//}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  [self disconnectFromMoviePlayer];
}


- (BOOL) isBookmarked {
  return [[BookmarkCache cache] isBookmarked:movie];
}


- (void) addBookmark {
  [[BookmarkCache cache] addBookmark:movie];
}


- (void) removeBookmark {
  [[BookmarkCache cache] removeBookmark:movie];
}


- (void) setBookmarkImage {
  self.bookmarkButton.selected = [self isBookmarked];
}


- (void) switchBookmark:(id) sender {
  if ([self isBookmarked]) {
    [self removeBookmark];
  } else {
    [self addBookmark];
  }

  [self setBookmarkImage];
}


- (void) initializeBookmarkButton {
  self.bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [bookmarkButton setImage:[BoxOfficeStockImages emptyStarImage] forState:UIControlStateNormal];
  [bookmarkButton setImage:[BoxOfficeStockImages filledYellowStarImage] forState:UIControlStateSelected];

  [bookmarkButton addTarget:self action:@selector(switchBookmark:) forControlEvents:UIControlEventTouchUpInside];

  CGRect frame = bookmarkButton.frame;
  frame.size = [BoxOfficeStockImages emptyStarImage].size;
  frame.size.width += 10;
  frame.size.height += 10;
  bookmarkButton.frame = frame;

  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];
  [self setBookmarkImage];
}


- (void) setupTitle:(NSString*) title {
  if (readonlyMode) {
    if (title.length == 0) {
      self.title = LocalizedString(@"Please Wait", nil);
    } else {
      self.title = title;
    }
  } else {
    self.title = movie.canonicalTitle;
  }
}


- (void) setupButtons {
  if (readonlyMode) {
//    UIActivityIndicatorView* activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
//    CGRect frame = activityIndicatorView.frame;
//    frame.size.width += 4;
//    [activityIndicatorView startAnimating];
//
//    UIView* activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
//    [activityView addSubview:activityIndicatorView];
//
//    UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];

    UIBarButtonItem* right = [self createActivityIndicator];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
  } else {
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self initializeBookmarkButton];
  }
}


- (void) loadView {
  [super loadView];

  self.dvd = [[Model model] dvdDetailsForMovie:movie];

  filterTheatersByDistance = YES;

  self.posterImage = [MovieDetailsViewController posterForMovie:movie];
  [self setupButtons];
  [self setupTitle:@""];

  // Load the movie details as the absolutely highest thing we can do.
  [[MovieCacheUpdater updater] prioritizeMovie:movie now:YES];
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.dvd = nil;
  self.allTheatersArray = nil;
  self.filteredTheatersArray = nil;
  self.showtimesArray = nil;
  self.trailersArray = nil;
  self.reviewsArray = nil;
  self.websites = nil;
  self.actionsView = nil;
  self.posterImage = nil;
  self.posterImageView = nil;
}


- (void) downloadPosterBackgroundEntryPoint {
  NSInteger count = [[LargeMoviePosterCache cache] posterCountForMovie:movie];

  [self performSelectorOnMainThread:@selector(reportPosterCount:)
                         withObject:[NSNumber numberWithInteger:count]
                      waitUntilDone:NO];

  [[LargeMoviePosterCache cache] downloadFirstPosterForMovie:movie];

  [self performSelectorOnMainThread:@selector(reportPoster)
                         withObject:nil
                      waitUntilDone:NO];
}


- (void) reportPosterCount:(NSNumber*) posterNumber {
  NSAssert([NSThread isMainThread], nil);
  if (!visible) { return; }
  posterCount = [posterNumber integerValue];
}


- (void) reportPoster {
  NSAssert([NSThread isMainThread], nil);
  if (!visible) { return; }
  [self minorRefresh];
}


- (void) downloadPoster {
  [ThreadingUtilities backgroundSelector:@selector(downloadPosterBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:NO];
}


- (NetflixRatingsCell*) createNetflixRatingsCell {
  if (netflixRatingsCell == nil) {
    self.netflixRatingsCell =
    [[[NetflixRatingsCell alloc] initWithMovie:netflixMovie tableViewController:self] autorelease];
  }

  return netflixRatingsCell;
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];
  [self downloadPoster];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];

  [self initializeData];
  [[self createNetflixRatingsCell] refresh:netflixAccount];
}


- (void) minorRefresh {
  [self majorRefresh];
}


- (void) majorRefresh {
  if (playingTrailer) {
    return;
  }

  [super majorRefresh];
}


- (NSInteger) hiddenTheaterCount {
  return allTheatersArray.count - filteredTheatersArray.count;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  // Header
  NSInteger sections = 1;

  // Trailer
  sections += 1;

  // Netflix
  sections += 1;

  // theaters
  if (filteredTheatersArray.count > 0) {
    // Map button
    sections += 1;
  }

  sections += filteredTheatersArray.count;

  // show hidden theaters
  if (self.hiddenTheaterCount > 0) {
    sections += 1;
  }

  return sections;
}


- (NSInteger) numberOfRowsInHeaderSection {
  return 3;
}


- (BOOL) hasNetflixRating {
  return
  netflixMovie != nil &&
  [[NetflixCache cache] netflixRatingForMovie:netflixMovie account:netflixAccount].length > 0;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  //if (section == TrailerSection && self.hasTrailer) {
  //  return LocalizedString(@"Trailer", nil);
  //} else
  if (section == NetflixSection) {
    if ([self hasNetflixRating] || netflixStatusCells.count > 0) {
      return LocalizedString(@"Netflix", nil);
    }
  } else if (section == FirstTheaterSection && filteredTheatersArray.count > 0) {
    if ([Model model].isSearchDateToday) {
      //[DateUtilities isToday:[Model model].searchDate]) {
      return LocalizedString(@"Today", nil);
    } else {
      return [DateUtilities formatFullDate:[Model model].searchDate];
    }
  }

  return nil;
}


- (NSInteger) getTheaterIndex:(NSInteger) section {
  // subtract the first 3 sections (header, trailer, netflix) and then 1 more
  // for the "map" button.
  return section - 4;
}


- (NSInteger) isTheaterSection:(NSInteger) section {
  NSInteger theaterIndex = [self getTheaterIndex:section];
  return theaterIndex >= 0 && theaterIndex < filteredTheatersArray.count;
}


- (NSInteger) numberOfRowsInNetflixSection {
  if (netflixMovie != nil) {
    return 1 + netflixStatusCells.count;
  }

  return 0;
}


- (NSInteger) numberOfRowsInTrailerSection {
  if ([Portability userInterfaceIdiom] != UserInterfaceIdiomPad) {
    return 0;
  }

  if (self.hasTrailer && ![[Model model] isInReviewPeriod]) {
    return 1;
  }
  else {
    return 0;
  }
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (section == HeaderSection) {
    return [self numberOfRowsInHeaderSection];
  }

  if (section == TrailerSection) {
    return [self numberOfRowsInTrailerSection];
  }

  if (section == NetflixSection) {
    return [self numberOfRowsInNetflixSection];
  }

  if (section == FirstTheaterSection && filteredTheatersArray.count > 0) {
    return 1;
  }

  if ([self isTheaterSection:section]) {
    return 2;
  }

  // show hidden theaters
  return 1;
}


- (UITableViewCell*) createDvdDetailsCell {
  if (dvd == nil) {
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  }

  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  label.font = [UIFont boldSystemFontOfSize:14];
  label.adjustsFontSizeToFitWidth = YES;
  label.textAlignment = UITextAlignmentCenter;
  if ([@"1" isEqual:dvd.discs]) {
    label.text = [NSString stringWithFormat:LocalizedString(@"$%@. %@ - 1 disc.", @"$19.99.  Widescreen DVD - 1 disc."), dvd.price, dvd.format];
  } else {
    label.text = [NSString stringWithFormat:LocalizedString(@"$%@. %@ - %@ discs.", @"$19.99.  Widescreen DVD - 2 discs."), dvd.price, dvd.format, dvd.discs];
  }
  [label sizeToFit];
  CGRect frame = label.frame;
  frame.size.height = self.tableView.rowHeight - 16;
  frame.size.width = 300;
  label.frame = frame;

  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell.contentView addSubview:label];

  return cell;
}


- (UITableViewCell*) cellForNetflixRow:(NSInteger) row {
  if (row == 0) {
    return [self createNetflixRatingsCell];
  } else {
    return [netflixStatusCells objectAtIndex:row - 1];
  }
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
  if (row == 0) {
    self.posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];
    posterImageView.tag = ZOOM_POSTER_IMAGE_VIEW_TAG;
    posterImageView.delegate = self;
    BOOL limitLength = ([Portability userInterfaceIdiom] != UserInterfaceIdiomPad);

    return [SynopsisCell cellWithSynopsis:[[Model model] synopsisForMovie:movie]
                                imageView:posterImageView
                              limitLength:limitLength
                      tableViewController:self];
  }

  if (row == 1) {
    return [self createDvdDetailsCell];
  }

  if (expandedDetails) {
    return [[[ExpandedMovieDetailsCell alloc] initWithMovie:movie tableViewController:self] autorelease];
  } else {
    return [[[CollapsedMovieDetailsCell alloc] initWithMovie:movie tableViewController:self] autorelease];
  }
}


- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
  if (row == 1) {
    if (dvd != nil) {
      return self.tableView.rowHeight - 14;
    } else {
      return 0;
    }
  }

  id cell = [self cellForHeaderRow:row];
  CGFloat result = [cell height];
  return result;
}


- (CGFloat) heightForNetflixRatingRow {
  if ([self hasNetflixRating]) {
    return self.tableView.rowHeight;
  } else {
    return 0;
  }
}


- (CGFloat) heightForRowInNetflixSection:(NSInteger) row {
  if (row == 0) {
    return [self heightForNetflixRatingRow];
  } else {
    return self.tableView.rowHeight;
  }
}


- (CGFloat) heightForRowInTrailerSection:(NSInteger) row {
  if (playingTrailer) {
    return 321;
  } else {
    return self.tableView.rowHeight;
  }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == HeaderSection) {
    return [self heightForRowInHeaderSection:indexPath.row];
  }

  if (indexPath.section == TrailerSection) {
    return [self heightForRowInTrailerSection:indexPath.row];
  }

  if (indexPath.section == NetflixSection) {
    return [self heightForRowInNetflixSection:indexPath.row];
  }

  if ([self isTheaterSection:indexPath.section]) {
    // theater section
    if (indexPath.row == 0) {
      return tableView.rowHeight;
    } else {
      id cell = [self tableView:tableView
          cellForRowAtIndexPath:indexPath];
      return [cell height] + 18;
    }
  }

  // show hidden theaters / map theaters
  return tableView.rowHeight;
}


- (UITableViewCell*) cellForTheaterSection:(NSInteger) theaterIndex
                                       row:(NSInteger) row {
  if (row == 0) {
    static NSString* reuseIdentifier = @"theaterReuseIdentifier";
    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Theater* theater = [filteredTheatersArray objectAtIndex:theaterIndex];
    [cell setTheater:theater];

    return cell;
  } else {
    static NSString* reuseIdentifier = @"detailsReuseIdentifier";
    MovieShowtimesCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[MovieShowtimesCell alloc] initWithReuseIdentifier:reuseIdentifier tableViewController:self] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Theater* theater = [filteredTheatersArray objectAtIndex:theaterIndex];
    BOOL stale = [[Model model] isStale:theater];
    [cell setStale:stale];
    [cell setShowtimes:[showtimesArray objectAtIndex:theaterIndex]];

    return cell;
  }
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
  if (section == HeaderSection) {
    return actionsView;
  }

  return nil;
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
  if (section == HeaderSection) {
    CGFloat height = [actionsView height];
    return height;
  }

  return -1;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
  if (![self isTheaterSection:section]) {
    return nil;
  }

  Theater* theater = [filteredTheatersArray objectAtIndex:[self getTheaterIndex:section]];
  if (![[Model model] isStale:theater]) {
    return nil;
  }

  return [[Model model] showtimesRetrievedOnString:theater];
}


- (UITableViewCell*) showHiddenTheatersCell {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  cell.textLabel.textAlignment = UITextAlignmentCenter;

  if (self.hiddenTheaterCount == 1) {
    cell.textLabel.text = LocalizedString(@"Show 1 hidden theater", @"We hide theaters if they are too far away.  But we provide this button to let the user 'unhide' in case it's the only theater showing a movie they care about.");
  } else {
    cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"Show %d hidden theaters", @"We hide theaters if they are too far away.  But we provide this button to let the user 'unhide' in case it's the only theater showing a movie they care about."),
                           self.hiddenTheaterCount];
  }

  cell.textLabel.textColor = [ColorCache commandColor];
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14];

  return cell;
}


- (UITableViewCell*) mapTheatersCell {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  cell.textLabel.textAlignment = UITextAlignmentCenter;
  cell.textLabel.text = LocalizedString(@"Map Theaters", nil);
  cell.textLabel.textColor = [ColorCache commandColor];
  return cell;
}


- (void) setMoviePlayerFrame:(UIInterfaceOrientation) orientation {
  if ([Portability userInterfaceIdiom] != UserInterfaceIdiomPad) {
    return;
  }

  NSInteger width = UIInterfaceOrientationIsPortrait(orientation) ? 768 : 1024;

  NSInteger x = (width - (44 * 2) - 480) / 2;
  NSInteger y = 0;
  UIView* view = [(id)moviePlayerController view];
  view.frame = CGRectMake(x, y, 480, 320);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDuration:duration];
    [self setMoviePlayerFrame:interfaceOrientation];
  }
  [UIView commitAnimations];
}


- (UITableViewCell*) cellForTrailerRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  if (playingTrailer) {
    [self setMoviePlayerFrame:self.interfaceOrientation];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];


    [cell.contentView addSubview:[(id)moviePlayerController view]];
  } else {
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = LocalizedString(@"Play Trailer", nil);
    cell.textLabel.textColor = [ColorCache commandColor];
  }

  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == HeaderSection) {
    return [self cellForHeaderRow:indexPath.row];
  }

  if (indexPath.section == TrailerSection) {
    return [self cellForTrailerRow:indexPath.row];
  }

  if (indexPath.section == NetflixSection) {
    return [self cellForNetflixRow:indexPath.row];
  }

  if (indexPath.section == FirstTheaterSection && filteredTheatersArray.count > 0) {
    return [self mapTheatersCell];
  }

  if ([self isTheaterSection:indexPath.section]) {
    // theater section
    return [self cellForTheaterSection:[self getTheaterIndex:indexPath.section] row:indexPath.row];
  }

  return [self showHiddenTheatersCell];
}


- (void) didSelectShowHiddenTheaters {
  NSIndexPath* startPath = self.tableView.indexPathForSelectedRow;
  [self.tableView deselectRowAtIndexPath:startPath animated:NO];

  filterTheatersByDistance = NO;

  [self majorRefresh];
  /*
  if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    [self majorRefresh];
    return;
  }

  NSInteger oldTheaterCount = self.filteredTheatersArray.count;
  [self initializeTheaterArrays];

  NSInteger newTheaterCount = self.filteredTheatersArray.count;
  if (oldTheaterCount >= newTheaterCount) {
    return;
  }

  NSInteger startSection = startPath.section;
  [self.tableView beginUpdates];
  {
    NSIndexSet* startIndexSet = [NSIndexSet indexSetWithIndex:startSection];
    if (oldTheaterCount == 0) {
      // Replace the 'Show Hidden Theaters' with the 'Map Theaters' button.
      [self.tableView reloadSections:startIndexSet withRowAnimation:UITableViewRowAnimationFade];
    } else {
      // Remove the 'Show Hidden Theaters' button.
      [self.tableView deleteSections:startIndexSet withRowAnimation:UITableViewRowAnimationFade];
    }

    // Now add in the new theaters.
    NSIndexSet* sectionsToAdd =
      [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startSection, newTheaterCount - oldTheaterCount)];

    [self.tableView insertSections:sectionsToAdd withRowAnimation:UITableViewRowAnimationFade];
  }
  [self.tableView endUpdates];

  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:startSection]
                        atScrollPosition:UITableViewScrollPositionMiddle
                                animated:YES];
   */
}


- (void) playTrailer {
  NSString* urlString = trailersArray.firstObject;
  [self playMovie:urlString];
}


- (void) readReviews {
  [self.commonNavigationController pushReviews:movie animated:YES];
}


- (void) visitWebsite:(NSString*) website {
  [self.commonNavigationController pushBrowser:website animated:YES];
}


- (void) visitWebsites {
  UIActionSheet* actionSheet =
  [[[UIActionSheet alloc] initWithTitle:nil
                               delegate:self
                      cancelButtonTitle:nil
                 destructiveButtonTitle:nil
                      otherButtonTitles:nil] autorelease];
  actionSheet.tag = VISIT_WEBSITES_ACTION_SHEET_TAG;

  NSArray* keys = [websites.allKeys sortedArrayUsingSelector:@selector(compare:)];
  for (NSString* key in keys) {
    [actionSheet addButtonWithTitle:key];
  }

  actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:LocalizedString(@"Cancel", nil)];
  //actionSheet.cancelButtonIndex = keys.count;

  [self showActionSheet:actionSheet];
}


- (void) setupStatusCells {
  for (NetflixStatusCell* cell in netflixStatusCells) {
    [cell enterReadonlyMode];
  }
}


- (void) enterReadonlyMode:(NSString*) title {
  if (readonlyMode) {
    return;
  }
  readonlyMode = YES;
  [self setupTitle:title];
  [self setupButtons];
  [self setupStatusCells];
}


- (void) exitReadonlyMode {
  readonlyMode = NO;
  [self setupTitle:@""];
  [self setupButtons];
}


- (void) netflixOperationSucceeded {
  [self exitReadonlyMode];
  [self majorRefresh];
}


- (void) netflixOperationFailedWithError:(NSString*) error {
  [AlertUtilities showOkAlert:error];
  [self exitReadonlyMode];
  [self majorRefresh];
}


- (void) addSucceeded {
  [self netflixOperationSucceeded];
}


- (void) addFailedWithError:(NSString*) error {
  [self netflixOperationFailedWithError:error];
}


- (void) moveSucceededForMovie:(Movie*) movie {
  [self netflixOperationSucceeded];
}


- (void) moveFailedWithError:(NSString*) error {
  [self netflixOperationFailedWithError:error];
}


- (void) modifySucceeded {
  [self netflixOperationSucceeded];
}


- (void) modifyFailedWithError:(NSString*) error {
  [self netflixOperationFailedWithError:error];
}


- (void) changeSucceeded {
  [self netflixOperationSucceeded];
}


- (void) changeFailedWithError:(NSString*) error {
  NSString* message = [NSString stringWithFormat:LocalizedString(@"Could not change rating:\n\n%@", @"%@ is the underlying error.  i.e. 'Could not connect to server'"), error];
  [self netflixOperationFailedWithError:message];
}


- (void) addAction:(AddToQueueAction) action
          withTitle:(NSString*) title
      toActionSheet:(UIActionSheet*) actionSheet
          actionMap:(NSMutableDictionary*) actionMap {
  NSInteger index = [actionSheet addButtonWithTitle:title];
  [actionMap setObject:[NSNumber numberWithInteger:action]
                forKey:[NSNumber numberWithInteger:index]];

}


- (void) moveNetflixMovieWasTappedForRow:(NSInteger) row {
  [self enterReadonlyMode:LocalizedString(@"Moving Movie", nil)];

  NetflixStatusCell* cell = [netflixStatusCells objectAtIndex:row];
  Status* status = [cell status];
  [self.netflixUpdater updateQueue:status.queue
                byMovingMovieToTop:status.movie
                          delegate:self
                           account:netflixAccount];
}


- (void) showRemovePromptForRow:(NSInteger) row {
  UIActionSheet* actionSheet =
  [[[UIActionSheet alloc] initWithTitle:LocalizedString(@"Remove Item from Queue?", nil)
                               delegate:self
                      cancelButtonTitle:LocalizedString(@"Cancel", nil)
                 destructiveButtonTitle:LocalizedString(@"Remove", nil)
                      otherButtonTitles:nil] autorelease];
  actionSheet.tag = SET_BITS(REMOVE_NETFLIX_MOVIE_ACTION_SHEET_TAG, row);

  [self showActionSheet:actionSheet];
}


- (void) removeNetflixMovieWasTappedForRow:(NSInteger) row {
  [self enterReadonlyMode:LocalizedString(@"Removing Movie", nil)];

  NetflixStatusCell* cell = [netflixStatusCells objectAtIndex:row];
  Status* status = [cell status];
  [self.netflixUpdater updateQueue:status.queue
                   byDeletingMovie:status.movie
                          delegate:self
                           account:netflixAccount];
}


- (void) addToQueue {
  if (readonlyMode) {
    return;
  }

  UIActionSheet* actionSheet =
  [[[UIActionSheet alloc] initWithTitle:nil
                               delegate:self
                      cancelButtonTitle:nil
                 destructiveButtonTitle:nil
                      otherButtonTitles:nil] autorelease];
  actionSheet.tag = ADD_NETFLIX_MOVIE_ACTION_SHEET_TAG;

  NetflixUser* user = [[NetflixUserCache cache] userForAccount:netflixAccount];

  NSMutableDictionary* actionMap = [NSMutableDictionary dictionary];
  if ([[NetflixCache cache] isInstantWatch:netflixMovie] && user.canInstantWatch) {
    [self addAction:InstantQueue      withTitle:LocalizedString(@"Instant Queue", nil)        toActionSheet:actionSheet actionMap:actionMap];
    [self addAction:TopOfInstantQueue withTitle:LocalizedString(@"Top of Instant Queue", nil) toActionSheet:actionSheet actionMap:actionMap];
  }
  if ([[NetflixCache cache] isDvd:netflixMovie]) {
    [self addAction:DVDQueue      withTitle:LocalizedString(@"DVD Queue", nil)        toActionSheet:actionSheet actionMap:actionMap];
    [self addAction:TopOfDVDQueue withTitle:LocalizedString(@"Top of DVD Queue", nil) toActionSheet:actionSheet actionMap:actionMap];
  }
  if ([[NetflixCache cache] isBluray:netflixMovie] && user.canBlurayWatch) {
    [self addAction:BlurayQueue      withTitle:LocalizedString(@"Blu-ray Queue", nil)        toActionSheet:actionSheet actionMap:actionMap];
    [self addAction:TopOfBlurayQueue withTitle:LocalizedString(@"Top of Blu-ray Queue", nil) toActionSheet:actionSheet actionMap:actionMap];
  }
  self.buttonIndexToActionMap = actionMap;

  actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:LocalizedString(@"Cancel", nil)];

  [self showActionSheet:actionSheet];
}


- (void) didDismissAddToNetflixActionSheet:(Queue*) queue
                                    format:(NSString*) format
                                       top:(BOOL) top {
  [self enterReadonlyMode:LocalizedString(@"Adding Movie", nil)];
  if (top) {
    [self.netflixUpdater updateQueue:queue byAddingMovie:netflixMovie withFormat:format toPosition:0 delegate:self account:netflixAccount];
  } else {
    [self.netflixUpdater updateQueue:queue byAddingMovie:netflixMovie withFormat:format delegate:self account:netflixAccount];
  }
}


- (void) didDismissAddToNetflixActionSheet:(UIActionSheet*) actionSheet
                           withButtonIndex:(NSInteger) buttonIndex {
  AddToQueueAction action = [[buttonIndexToActionMap objectForKey:[NSNumber numberWithInt:buttonIndex]] integerValue];

  Queue* queue = nil;
  NSString* format = nil;
  switch (action) {
    case InstantQueue:
    case TopOfInstantQueue:
      format = [NetflixConstants instantFormat];
      queue = [[NetflixFeedCache cache] queueForKey:[NetflixConstants instantQueueKey] account:netflixAccount];
      break;
    case DVDQueue:
    case TopOfDVDQueue:
      format = [NetflixConstants dvdFormat];
      queue = [[NetflixFeedCache cache] queueForKey:[NetflixConstants discQueueKey] account:netflixAccount];
      break;
    case BlurayQueue:
    case TopOfBlurayQueue:
      format = [NetflixConstants blurayFormat];
      queue = [[NetflixFeedCache cache] queueForKey:[NetflixConstants discQueueKey] account:netflixAccount];
      break;
    default:
      return;
  }

  BOOL top = NO;
  switch (action) {
    case TopOfInstantQueue:
    case TopOfDVDQueue:
    case TopOfBlurayQueue:
      top = YES;
      break;
  }

  [self didDismissAddToNetflixActionSheet:queue format:format top:top];
}


- (void) didDismissVisitWebsitesActionSheet:(UIActionSheet*) actionSheet
                            withButtonIndex:(NSInteger) buttonIndex {
  NSString* url = [websites objectForKey:[actionSheet buttonTitleAtIndex:buttonIndex]];
  [self.commonNavigationController pushBrowser:url animated:YES];
}


- (void) didDismissRemoveNetflixMovieActionSheet:(UIActionSheet*) actionSheet
                          withButtonIndex:(NSInteger) buttonIndex {
  NSInteger row = CLEAR_BITS(actionSheet.tag, REMOVE_NETFLIX_MOVIE_ACTION_SHEET_TAG);
  [self removeNetflixMovieWasTappedForRow:row];
}


- (void)            actionSheet:(UIActionSheet*) actionSheet
           clickedButtonAtIndex:(NSInteger) buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }

  if (BITS_ARE_SET(actionSheet.tag, ADD_NETFLIX_MOVIE_ACTION_SHEET_TAG)) {
    [self didDismissAddToNetflixActionSheet:actionSheet
                            withButtonIndex:buttonIndex];
  } else if (BITS_ARE_SET(actionSheet.tag, VISIT_WEBSITES_ACTION_SHEET_TAG)) {
    [self didDismissVisitWebsitesActionSheet:actionSheet
                             withButtonIndex:buttonIndex];
  } else if (BITS_ARE_SET(actionSheet.tag, REMOVE_NETFLIX_MOVIE_ACTION_SHEET_TAG)) {
    [self didDismissRemoveNetflixMovieActionSheet:actionSheet
                                  withButtonIndex:buttonIndex];
  }
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(NSArray*) array {
  if (updateId != [array.firstObject integerValue]) {
    return;
  }

  NSDate* searchDate = array.lastObject;

  if (![lookupResult.movies containsObject:movie]) {
    NSString* text =
    [NSString stringWithFormat:
     LocalizedString(@"No listings found for '%@' on %@", @"No listings found for 'The Dark Knight' on 5/18/2008"),
     movie.canonicalTitle,
     [DateUtilities formatShortDate:searchDate]];

    [self onDataProviderUpdateFailure:text context:array];
  } else {
    // Find the most up to date version of this movie
    self.movie = [lookupResult.movies objectAtIndex:[lookupResult.movies indexOfObject:movie]];

    [super onDataProviderUpdateSuccess:lookupResult context:array];
  }
}


- (void) emailListings {
  NSString* subject = [NSString stringWithFormat:@"%@ - %@",
                       movie.canonicalTitle,
                       [DateUtilities formatFullDate:[Model model].searchDate]];

  NSMutableString* body = [NSMutableString string];

  for (NSInteger i = 0; i < filteredTheatersArray.count; i++) {
    [body appendString:@"<p>"];

    Theater* theater = [filteredTheatersArray objectAtIndex:i];
    NSArray* performances = [showtimesArray objectAtIndex:i];

    [body appendString:theater.name];
    [body appendString:@"<br/>"];
    [body appendString:@"<a href=\""];
    [body appendString:theater.mapUrl];
    [body appendString:@"\">"];
    [body appendString:[[Model model] simpleAddressForTheater:theater]];
    [body appendString:@"</a>"];

    [body appendString:@"<br/>"];
    [body appendString:[Utilities generateShowtimeLinks:[Model model]
                                                  movie:movie
                                                theater:theater
                                           performances:performances]];
  }

  [self openMailTo:nil
       withSubject:subject
              body:body
            isHTML:YES];
}


- (void) pushTicketsView:(Theater*) theater
                animated:(BOOL) animated {
  [self.commonNavigationController pushTicketsView:movie
   theater:theater
   title:theater.name
   animated:animated];
}


- (void)       tableView:(UITableView*) tableView
      didSelectHeaderRow:(NSInteger) row {
  if (row == 2) {
    expandedDetails = !expandedDetails;

    NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
    [tableView beginUpdates];
    {
      NSArray* paths = [NSArray arrayWithObject:path];
      [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];

    //[tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // hack: when shrinking the details pane, the 'actions view' can
    // sometimes go missing.  To prevent that, we refresh explicitly.
    if (!expandedDetails) {
      [MetasyntacticSharedApplication majorRefresh:YES];
    }
  }
}


- (void) didSelectMapTheatersRow {
  Theater* theater = filteredTheatersArray.firstObject;
  [self.abstractNavigationController pushMapWithCenter:theater
                                             locations:filteredTheatersArray
                                              delegate:self animated:YES];
}


- (void)                 tableView:(UITableView*) tableView
    didSelectTrailerRowAtIndexPath:(NSIndexPath*) path {
  if (playingTrailer) {
    return;
  }

  [tableView deselectRowAtIndexPath:path animated:YES];
  [self setupMoviePlayer];
  [self updateMovieTrailerRow];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == HeaderSection) {
    return [self tableView:tableView didSelectHeaderRow:indexPath.row];
  }

  if (indexPath.section == TrailerSection) {
    return [self tableView:tableView didSelectTrailerRowAtIndexPath:indexPath];
  }

  if (indexPath.section == NetflixSection) {
    return;
  }

  if (indexPath.section == FirstTheaterSection && filteredTheatersArray.count > 0) {
    return [self didSelectMapTheatersRow];
  }

  if ([self isTheaterSection:indexPath.section]) {
    // theater section
    Theater* theater = [filteredTheatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];

    if (indexPath.row == 0) {
      [self.commonNavigationController pushTheaterDetails:theater animated:YES];
    } else {
      [self pushTicketsView:theater animated:YES];
    }
    return;
  }

  [self didSelectShowHiddenTheaters];
}


- (void) posterImageViewWasTapped {
  if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    return;
  }

  if (posterCount <= 0) {
    return;
  }

  [[OperationQueue operationQueue] performSelector:@selector(downloadAllPostersForMovie:)
                                          onTarget:[LargeMoviePosterCache cache]
                                        withObject:movie
                                              gate:nil
                                          priority:Now];

  [self.commonNavigationController showPostersView:movie
                                       posterCount:posterCount];
}


- (void) rateNetflixMovieWasTapped:(NSInteger) value {
  NSInteger currentUserRating =
    (NSInteger)[[[NetflixCache cache] userRatingForMovie:netflixMovie
                                                 account:netflixAccount] floatValue];

  // Don't need to do anything in this case.
  if (value == currentUserRating) {
    return;
  }

  // now, update in the background.
  [self enterReadonlyMode:LocalizedString(@"Changing Rating", nil)];
  NSString* rating = value == 0 ? @"" : [NSString stringWithFormat:@"%d", value];
  [self.netflixUpdater changeRatingTo:rating
                             forMovie:netflixMovie
                             delegate:self
                              account:netflixAccount];

  // now, update the UI to reflect the temporary value
  [netflixRatingsCell refresh:netflixAccount];
}


- (void) imageView:(TappableImageView*) imageView
        wasTouched:(UITouch*) touch
          tapCount:(NSInteger) tapCount {
  if (readonlyMode) {
    return;
  }

  if (BITS_ARE_SET(imageView.tag, ZOOM_POSTER_IMAGE_VIEW_TAG)) {
    [self posterImageViewWasTapped];
  } else if (BITS_ARE_SET(imageView.tag, RATE_NETFLIX_MOVIE_IMAGE_VIEW_TAG)) {
    NSInteger value = CLEAR_BITS(imageView.tag, RATE_NETFLIX_MOVIE_IMAGE_VIEW_TAG);
    [self rateNetflixMovieWasTapped:value];
  } else if (BITS_ARE_SET(imageView.tag, MOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG)) {
    NSInteger row = CLEAR_BITS(imageView.tag, MOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG);
    [self moveNetflixMovieWasTappedForRow:row];
  } else if (BITS_ARE_SET(imageView.tag, REMOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG)) {
    NSInteger row = CLEAR_BITS(imageView.tag, REMOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG);
    [self showRemovePromptForRow:row];
  }
}


- (BOOL) hasDetailsForAnnotation:(id<MKAnnotation>) annotation {
  return YES;
}


- (void) detailsButtonTappedForAnnotation:(Theater*) theater {
  [self.commonNavigationController pushTheaterDetails:theater animated:YES];
}

@end
