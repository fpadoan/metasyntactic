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

#import "NetflixCell.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"

@interface NetflixCell()
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* netflixTitleLabel;
@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;
@property (retain) UILabel* netflixLabel;
@property (retain) UILabel* availabilityLabel;
@property (retain) UILabel* formatsLabel;
@property (retain) UIButton* tappableArrow;
@end


@implementation NetflixCell

@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedTitleLabel;
@synthesize genreTitleLabel;
@synthesize netflixTitleLabel;

@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratedLabel;
@synthesize genreLabel;
@synthesize netflixLabel;
@synthesize availabilityLabel;
@synthesize formatsLabel;

@synthesize tappableArrow;

- (void) dealloc {
  self.directorTitleLabel = nil;
  self.castTitleLabel = nil;
  self.ratedTitleLabel = nil;
  self.genreTitleLabel = nil;
  self.netflixTitleLabel = nil;

  self.directorLabel = nil;
  self.castLabel = nil;
  self.ratedLabel = nil;
  self.genreLabel = nil;
  self.netflixLabel = nil;

  self.availabilityLabel = nil;
  self.formatsLabel = nil;

  self.tappableArrow = nil;

  [super dealloc];
}



- (NSArray*) titleLabels {
  return [NSArray arrayWithObjects:
          directorTitleLabel,
          castTitleLabel,
          genreTitleLabel,
          ratedTitleLabel,
          netflixTitleLabel,
          nil];
}


- (NSArray*) valueLabels {
  return [NSArray arrayWithObjects:
          directorLabel,
          castLabel,
          genreLabel,
          ratedLabel,
          netflixLabel,
          availabilityLabel,
          formatsLabel,
          nil];
}


- (NSArray*) allLabels {
  return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (void) setupTappableArrow {
  UIImage* image = [BoxOfficeStockImages upArrow];

  self.tappableArrow = [UIButton buttonWithType:UIButtonTypeCustom];
  [tappableArrow setImage:image forState:UIControlStateNormal];

  CGRect frame = tappableArrow.frame;
  frame.size = image.size;
  frame.size.width += 20;
  frame.size.height += 80;
  tappableArrow.frame = frame;
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [super initWithReuseIdentifier:reuseIdentifier
                         tableViewController:tableViewController_])) {
    self.directorTitleLabel = [self createTitleLabel:LocalizedString(@"Directors:", nil) yPosition:22];
    self.directorLabel = [self createValueLabel:22 forTitle:directorTitleLabel];

    self.castTitleLabel = [self createTitleLabel:LocalizedString(@"Cast:", nil) yPosition:37];
    self.castLabel = [self createValueLabel:37 forTitle:castTitleLabel];

    self.genreTitleLabel = [self createTitleLabel:LocalizedString(@"Genre:", nil) yPosition:52];
    self.genreLabel = [self createValueLabel:52 forTitle:genreTitleLabel];

    self.ratedTitleLabel = [self createTitleLabel:LocalizedString(@"Rated:", nil) yPosition:67];
    self.ratedLabel = [self createValueLabel:67 forTitle:ratedTitleLabel];

    self.netflixTitleLabel = [self createTitleLabel:@"Netflix:" yPosition:82];
    self.netflixLabel = [self createValueLabel:81 forTitle:netflixTitleLabel];
    netflixLabel.font = [UIFont systemFontOfSize:17];

    self.availabilityLabel = [self createValueLabel:67 forTitle:ratedTitleLabel];
    self.formatsLabel = [self createValueLabel:81 forTitle:netflixTitleLabel];

    titleWidth = 0;
    for (UILabel* label in self.titleLabels) {
      titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
    }

    for (UILabel* label in self.titleLabels) {
      CGRect frame = label.frame;
      frame.origin.x = (NSInteger)(imageView.frame.size.width + 2);
      frame.size.width = titleWidth;
      label.frame = frame;
    }

    [self setupTappableArrow];
  }

  return self;
}


- (void) setNetflixLabel {
  NSMutableString* result = [NSMutableString string];
  NSString* rating = [[NetflixCache cache] userRatingForMovie:movie account:[[NetflixAccountCache cache] currentAccount]];
  if (rating.length > 0) {
    userRating = YES;
  } else {
    userRating = NO;
    rating = [[NetflixCache cache] netflixRatingForMovie:movie account:[[NetflixAccountCache cache] currentAccount]];
  }

  if (rating.length == 0) {
    netflixLabel.text = @"";
    return;
  }

  CGFloat score = [rating floatValue];

  for (NSInteger i = 0; i < 5; i++) {
    CGFloat value = score - i;
    if (value <= 0) {
      [result appendString:[StringUtilities emptyStarString]];
    } else if (value >= 1) {
      [result appendString:[StringUtilities starString]];
    } else {
      [result appendString:[StringUtilities halfStarString]];
    }
  }

  netflixLabel.text = result;
}


- (void) setNetflixLabelColor {
  if (userRating) {
    netflixLabel.textColor = [ColorCache starYellow];
  } else {
    netflixLabel.textColor = [UIColor redColor];
  }
}


- (void) loadMovieWorker:(UITableViewController*) owner {
  directorLabel.text  = [[[Model model] directorsForMovie:movie]  componentsJoinedByString:@", "];
  castLabel.text      = [[[Model model] castForMovie:movie]       componentsJoinedByString:@", "];
  genreLabel.text     = [[[Model model] genresForMovie:movie]     componentsJoinedByString:@", "];

  NSMutableArray* formats = [NSMutableArray array];
  if ([[NetflixCache cache] isInstantWatch:movie]) {
    [formats addObject:LocalizedString(@"Instant", nil)];
  }
  if ([[NetflixCache cache] isDvd:movie]) {
    [formats addObject:LocalizedString(@"DVD", nil)];
  }
  if ([[NetflixCache cache] isBluray:movie]) {
    [formats addObject:LocalizedString(@"Blu-ray", nil)];
  }

  formatsLabel.text   = [formats componentsJoinedByString:@"/"];
  availabilityLabel.text = [[NetflixCache cache] availabilityForMovie:movie];

  NSString* rating = [[Model model] ratingForMovie:movie];
  if (rating.length == 0) {		
    rating = LocalizedString(@"Unrated", nil);		
  }

  ratedLabel.text = rating;

  if (movie.directors.count <= 1) {
    directorTitleLabel.text = LocalizedString(@"Director:", nil);
  } else {
    directorTitleLabel.text = LocalizedString(@"Directors:", nil);
  }

  [self setNetflixLabel];
  [self setNetflixLabelColor];

  for (UILabel* label in self.allLabels) {
    [self.contentView addSubview:label];
  }

  [self setNeedsLayout];
}


- (void) refresh {
  [self loadMovie:nil];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
  [super setSelected:selected animated:animated];

  if (selected) {
  } else {
    [self setNetflixLabelColor];
  }
}


- (void) onSetSameMovie:(Movie*) movie_
                  owner:(id) owner  {
  [super onSetSameMovie:movie_ owner:owner];

  [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];
  [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
}


- (void) layoutSubviews {
  [super layoutSubviews];

  [availabilityLabel sizeToFit];
  [formatsLabel sizeToFit];

  CGRect frame = self.frame;
  BOOL grouped = self.tableView.style == UITableViewStyleGrouped;
  NSInteger padding = grouped ? (2 * groupedTableViewMargin) : 0;

  {
    CGRect formatFrame = formatsLabel.frame;
    formatFrame.origin.x = frame.size.width - formatFrame.size.width - 5 - padding;
    formatsLabel.frame = formatFrame;
  }

  {
    CGRect availabilityFrame = availabilityLabel.frame;
    availabilityFrame.origin.x = frame.size.width - availabilityFrame.size.width - 5 - padding;
    availabilityLabel.frame = availabilityFrame;
  }
}


- (void) setEditing:(BOOL) editing animated:(BOOL) animated {
  [super setEditing:editing animated:animated];

  [UIView beginAnimations:nil context:NULL];
  {
    if (editing) {
      availabilityLabel.alpha = 0;
      formatsLabel.alpha = 0;
    } else {
      availabilityLabel.alpha = 1;
      formatsLabel.alpha = 1;
    }
  }
  [UIView commitAnimations];
}

@end
