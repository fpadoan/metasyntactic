// Copyright (C) 2008 Cyrus Najmabadi
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


@interface UnknownFieldSet : NSObject {
    NSMutableDictionary* fields;
}

@property (retain) NSMutableDictionary* fields;

+ (UnknownFieldSet_Builder*) newBuilder:(UnknownFieldSet*) copyFrom;
+ (UnknownFieldSet*) setWithFields:(NSMutableDictionary*) fields;

+ (UnknownFieldSet*) getDefaultInstance;

- (void) writeAsMessageSetTo:(CodedOutputStream*) output;
- (void) writeToCodedOutputStream:(CodedOutputStream*) output;

- (int32_t) getSerializedSize;
- (int32_t) getSerializedSizeAsMessageSet;

#if 0
+ (UnknownFieldSet_Builder*) newBuilder;
+ (UnknownFieldSet_Builder*) newBuilder:(UnknownFieldSet*) copyFrom;

+ (UnknownFieldSet*) parseFromCodedInputStream:(CodedInputStream*) input;
+ (UnknownFieldSet*) parseFromData:(NSData*) data;
+ (UnknownFieldSet*) parserFromInputStream:(NSInputStream*) input;

- (NSDictionary*) toDictionary;
- (BOOL) hasField:(int32_t) number;
- (UnknownFieldSet_Field*) getField:(int32_t) number;
- (void) writeToOutputStream:(NSOutputStream*) output;
- (NSData*) toData;
#endif

@end
