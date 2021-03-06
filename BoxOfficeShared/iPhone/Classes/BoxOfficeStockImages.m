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

#import "BoxOfficeStockImages.h"

UIImage* BoxOfficeStockImage(NSString* name) {
  return StockImage(@"BoxOfficeResources", name);
}

@implementation BoxOfficeStockImages


+ (UIImage*) whiteStar {
  return BoxOfficeStockImage(@"WhiteStar.png");
}


+ (UIImage*) freshImage {
  return BoxOfficeStockImage(@"Fresh.png");
}


+ (UIImage*) rottenFadedImage {
  return BoxOfficeStockImage(@"Rotten-Faded.png");
}


+ (UIImage*) rottenFullImage {
  return BoxOfficeStockImage(@"Rotten-Full.png");
}


+ (UIImage*) redRatingImage {
  return BoxOfficeStockImage(@"Rating-Red.png");
}


+ (UIImage*) yellowRatingImage {
  return BoxOfficeStockImage(@"Rating-Yellow.png");
}


+ (UIImage*) greenRatingImage {
  return BoxOfficeStockImage(@"Rating-Green.png");
}


+ (UIImage*) unknownRatingImage {
  return BoxOfficeStockImage(@"Rating-Unknown.png");
}


+ (UIImage*) emptyStarImage {
  return BoxOfficeStockImage(@"Empty Star.png");
}


+ (UIImage*) filledYellowStarImage {
  return BoxOfficeStockImage(@"Filled Star.png");
}


+ (UIImage*) redStar_0_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.0.png");
}


+ (UIImage*) redStar_1_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.2.png");
}


+ (UIImage*) redStar_2_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.4.png");
}


+ (UIImage*) redStar_3_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.6.png");
}


+ (UIImage*) redStar_4_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.8.png");
}


+ (UIImage*) redStar_5_5_Image {
  return BoxOfficeStockImage(@"RedStar-1.0.png");
}


+ (UIImage*) searchImage {
  return BoxOfficeStockImage(@"Search.png");
}


+ (UIImage*) imageLoading {
  return BoxOfficeStockImage(@"ImageLoading.png");
}


+ (UIImage*) imageLoadingNeutral {
  return BoxOfficeStockImage(@"ImageLoading-Neutral.png");
}


+ (UIImage*) imageNotAvailable {
  return BoxOfficeStockImage(@"ImageNotAvailable.png");
}


+ (UIImage*) upArrow {
  return BoxOfficeStockImage(@"UpArrow.png");
}


+ (UIImage*) downArrow {
  return BoxOfficeStockImage(@"DownArrow.png");
}


+ (UIImage*) neutralSquare {
  return BoxOfficeStockImage(@"NeutralSquare.png");
}


+ (UIImage*) warning16x16 {
  return BoxOfficeStockImage(@"Warning-16x16.png");
}


+ (UIImage*) warning32x32 {
  return BoxOfficeStockImage(@"Warning-32x32.png");
}

@end
