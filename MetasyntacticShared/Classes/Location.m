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

#import "Location.h"

#import "AbstractApplication.h"
#import "StringUtilities.h"

@interface Location()
@property double latitude;
@property double longitude;
@property (copy) NSString* address;
@property (copy) NSString* city;
@property (copy) NSString* state;
@property (copy) NSString* postalCode;
@property (copy) NSString* country;
@end


@implementation Location

property_definition(latitude);
property_definition(longitude);
property_definition(address);
property_definition(city);
property_definition(state);
property_definition(postalCode);
property_definition(country);

- (void) dealloc {
  self.latitude = 0;
  self.longitude = 0;
  self.address = nil;
  self.city = nil;
  self.state = nil;
  self.postalCode = nil;
  self.country = nil;

  [super dealloc];
}


- (id) initWithLatitude:(double) latitude_
              longitude:(double) longitude_
                address:(NSString*) address_
                   city:(NSString*) city_
                  state:(NSString*) state_
             postalCode:(NSString*) postalCode_
                country:(NSString*) country_ {
  if ((self = [super init])) {
    latitude        = latitude_;
    longitude       = longitude_;
    self.address    = [StringUtilities nonNilString:address_];
    self.city       = [StringUtilities nonNilString:city_];
    self.state      = [StringUtilities nonNilString:state_];
    self.postalCode = [StringUtilities nonNilString:postalCode_];
    self.country    = [StringUtilities nonNilString:country_];

    if ([country isEqual:@"US"] && [postalCode rangeOfString:@"-"].length > 0) {
      NSRange range = [postalCode rangeOfString:@"-"];
      self.postalCode = [postalCode substringToIndex:range.location];
    }
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithLatitude:[coder decodeDoubleForKey:latitude_key]
                      longitude:[coder decodeDoubleForKey:longitude_key]
                        address:[coder decodeObjectForKey:address_key]
                           city:[coder decodeObjectForKey:city_key]
                          state:[coder decodeObjectForKey:state_key]
                     postalCode:[coder decodeObjectForKey:postalCode_key]
                        country:[coder decodeObjectForKey:country_key]];
}


+ (Location*) locationWithDictionary:(NSDictionary*) dictionary {
  return [[[self alloc] initWithLatitude:[[dictionary objectForKey:latitude_key] doubleValue]
                          longitude:[[dictionary objectForKey:longitude_key] doubleValue]
                            address:[dictionary objectForKey:address_key]
                               city:[dictionary objectForKey:city_key]
                              state:[dictionary objectForKey:state_key]
                         postalCode:[dictionary objectForKey:postalCode_key]
                            country:[dictionary objectForKey:country_key]] autorelease];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
                           address:(NSString*) address
                              city:(NSString*) city
                             state:(NSString*) state
                        postalCode:(NSString*) postalCode
                           country:(NSString*) country{
  return [[[Location alloc] initWithLatitude:latitude
                                   longitude:longitude
                                     address:address
                                        city:city
                                       state:state
                                  postalCode:postalCode
                                     country:country] autorelease];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude {
  return [Location locationWithLatitude:latitude
                              longitude:longitude
                                address:nil
                                   city:nil
                                  state:nil
                             postalCode:nil
                                country:nil];
}



- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeDouble:latitude    forKey:latitude_key];
  [coder encodeDouble:longitude   forKey:longitude_key];
  [coder encodeObject:address     forKey:address_key];
  [coder encodeObject:city        forKey:city_key];
  [coder encodeObject:state       forKey:state_key];
  [coder encodeObject:postalCode  forKey:postalCode_key];
  [coder encodeObject:country     forKey:country_key];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dict = [NSMutableDictionary dictionary];
  [dict setObject:[NSNumber numberWithDouble:latitude]    forKey:latitude_key];
  [dict setObject:[NSNumber numberWithDouble:longitude]   forKey:longitude_key];
  [dict setObject:address                                 forKey:address_key];
  [dict setObject:city                                    forKey:city_key];
  [dict setObject:state                                   forKey:state_key];
  [dict setObject:postalCode                              forKey:postalCode_key];
  [dict setObject:country                                 forKey:country_key];
  return dict;
}


- (CLLocationCoordinate2D) coordinate {
  CLLocationCoordinate2D result = { latitude, longitude };
  return result;
}


+ (double) distanceFrom:(CLLocationCoordinate2D) from
                     to:(CLLocationCoordinate2D) to
           useKilometers:(BOOL) useKilometers {
  const double GREAT_CIRCLE_RADIUS_KILOMETERS = 6371.797;
  const double GREAT_CIRCLE_RADIUS_MILES = 3438.461;

  double lat1 = (from.latitude / 180) * M_PI;
  double lng1 = (from.longitude / 180) * M_PI;
  double lat2 = (to.latitude / 180) * M_PI;
  double lng2 = (to.longitude / 180) * M_PI;

  double diff = lng1 - lng2;

  if (diff < 0) { diff = -diff; }
  if (diff > M_PI) { diff = 2 * M_PI; }

  double distance =
  acos(sin(lat2) * sin(lat1) +
       cos(lat2) * cos(lat1) * cos(diff));

  if (useKilometers) {
    distance *= GREAT_CIRCLE_RADIUS_KILOMETERS;
  } else {
    distance *= GREAT_CIRCLE_RADIUS_MILES;
  }

  return distance;
}


- (double) distanceTo:(Location*) to
        useKilometers:(BOOL) useKilometers {
  if (self == to) {
    return 0;
  }

  if (to == nil) {
    return UNKNOWN_DISTANCE;
  }

  return [Location distanceFrom:self.coordinate to:to.coordinate useKilometers:useKilometers];
}


- (double) distanceTo:(Location*) to {
  return [self distanceTo:to useKilometers:[AbstractApplication useKilometers]];
}


- (double) distanceToMiles:(Location*) to {
  return [self distanceTo:to useKilometers:NO];
}


- (double) distanceToKilometers:(Location*) to {
  return [self distanceTo:to useKilometers:YES];
}


- (BOOL) isEqual:(id) anObject {
  if (self == anObject) {
    return YES;
  }

  if (![anObject isKindOfClass:[Location class]]) {
    return NO;
  }

  Location* other = anObject;

  return latitude == other.latitude &&
  longitude == other.longitude;
}


- (NSUInteger) hash {
  double hash = latitude + longitude;

  return *(NSUInteger*)&hash;
}


- (NSString*) description {
  return [NSString stringWithFormat:@"(%d,%d)", latitude, longitude];
}


- (NSString*) fullDisplayString {
  //TODO: switch on Locale here

  if (city.length || state.length || postalCode.length) {
    if (city.length) {
      if (state.length || postalCode.length) {
        return [NSString stringWithFormat:@"%@, %@ %@", city, state, postalCode];
      } else {
        return city;
      }
    } else {
      return [NSString stringWithFormat:@"%@ %@", state, postalCode];
    }
  }

  return @"";
}


- (id) copyWithZone:(NSZone*) zone {
  return [self retain];
}


- (NSString*) japaneseMapArguments {
  return [NSString stringWithFormat:@"%@%@%@", state, city, address];
}


- (NSString*) defaultMapArguments {
  return [NSString stringWithFormat:@"%@, %@, %@ %@",
          address,
          city,
          state,
          postalCode];
}


- (NSString*) mapUrl {
  NSString* arguments;
  if ([@"JP" isEqual:country]) {
    arguments = [self japaneseMapArguments];
  } else {
    arguments = [self defaultMapArguments];
  }

  NSString* encoded = [StringUtilities stringByAddingPercentEscapes:arguments];
  if (encoded.length > 0) {
    return [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", encoded];
  } else {
    return [NSString stringWithFormat:@"http://maps.google.com/maps?sll=%f,%f", latitude, longitude];
  }
}

@end
