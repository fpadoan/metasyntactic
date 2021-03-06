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

#import "Leaf.h"

#import "Concatenation.h"
#import "NSString+Utilities.h"

@interface Leaf()
@property (copy) NSString* string;
@end

// Note: all reference to BAP95 refer to the paper by Boehm, Atkinson and
// Plass.  See the full details in Rope.java.

@implementation Leaf

/**
 * The empty string is always represented by this node.
 *
 * <p>Note the following invariant.  A rope is either only the empty leaf,
 * or it does not contain any empty leaves.
 */
static Leaf* emptyLeaf;

+ (void) initialize {
  if (self == [Leaf class]) {
    emptyLeaf = [[Leaf alloc] initWithString:@""];
  }
}

@synthesize string;

- (void) dealloc {
  self.string = nil;
  
  [super dealloc];
}


/**
 * Constructor for a Leaf.  Should only be called by {@link #createLeaf} and
 * the field constructor for {@link #emptyLeaf}.
 *
 * @param string the value to construct the Leaf out of.
 */
- (id) initWithString:(NSString*) string_ {
  if ((self = [super init])) {
    self.string = string_;
  }
  
  return self;
}


+ (Rope*) emptyLeaf {
  return emptyLeaf;
}


/**
 * Factory constructor for a Leaf.  Ensures that no one accidently creates
 * another {@link #emptyLeaf}.  Anyone who needs to construct a Leaf
 * should use this method.
 *
 * @param value the value to construct the Leaf out of.
 * @return the appropriate Leaf that represents the value provided.
 */
+ (Rope*) createLeaf:(NSString*) value {
  if (value.length == 0) {
    return emptyLeaf;
  }
  
  return [[[Leaf alloc] initWithString:value] autorelease];
}


- (NSUInteger) hash {
  if (hash == 0) {
    hash = [Rope hashString:string];
  }
  
  return hash;
}


- (void) addLeaves:(NSMutableArray *)leaves {
  [leaves addObject:self];
}


- (NSString*) stringValue {
  return string;
}


- (NSInteger) length {
  return string.length;
}


- (void) addToMutableString:(NSMutableString*) builder {
  [builder appendString:string];
}


- (Rope*) ropeByAppendingRopeWorker:(Rope *)other {
  // BAP95
  // For performance reasons, it is desirable to deal with the common case
  // in which the right argument is a short flat string specially. If both
  // arguments are short leaves, we produce a flat rope (leaf) consisting
  // of the concatenation.  This greatly reduces space consumption and
  // traversal times
  if ([other isKindOfClass:[Leaf class]]) {
    NSInteger finalLength = self.length + other.length;
    if (finalLength <= [Rope coalesceLeafLength]) {
      NSMutableString* result = [NSMutableString string];
      [result appendString:string];
      [result appendString:[(id)other string]];
      return [Leaf createLeaf:result];
    }
  }
  
  // BAP95
  // In the general case, concatenation involves simply allocating a
  // concatenation node containing two pointers to the two arguments.
  return [Concatenation createWithLeft:self right:other];
}


/**
 * BAP95
 * We define the depth of a leaf to be 0
 */
- (uint8_t) depth {
  return 0;
}


- (Rope*) subRopeFromIndexWorker:(NSInteger) fromIndex toIndex:(NSInteger)toIndex {
  return [Leaf createLeaf:[string substringWithRange:NSMakeRange(fromIndex, toIndex - fromIndex)]];
}


- (unichar) characterAtIndex:(NSInteger)index {
  return [string characterAtIndex:index];
}


- (NSInteger) indexOf:(unichar) character {
  NSRange range = [string rangeOfString:[NSString stringWithCharacter:character]];
  if (range.length > 0) {
    return NSNotFound;
  }
  
  return range.location;
}


- (Rope*) ropeByReplacingOccurrencesOfCharacter:(unichar) oldChar
                                  withCharacter:(unichar) newChar {
  NSString* result = [string stringByReplacingOccurrencesOfString:[NSString stringWithCharacter:oldChar]
                                                       withString:[NSString stringWithCharacter:newChar]];
  
  if (result == string) {
    // If the underlying string didn't change, then we didn't change.
    // Just return ourself.
    return self;
  }
  
  return [Leaf createLeaf:result];
}

@end
