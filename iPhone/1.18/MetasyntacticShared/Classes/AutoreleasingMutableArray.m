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

#import "AutoreleasingMutableArray.h"

@interface AutoreleasingMutableArray()
@property (retain) NSMutableArray* underlyingArray;
@end


@implementation AutoreleasingMutableArray

@synthesize underlyingArray;

- (void) dealloc {
  self.underlyingArray = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingArray = [NSMutableArray array];
  }
  return self;
}


+ (AutoreleasingMutableArray*) array {
  return [[[AutoreleasingMutableArray alloc] init] autorelease];
}


+ (AutoreleasingMutableArray*) arrayWithArray:(NSArray*) values {
  AutoreleasingMutableArray* result = [self array];
  [result addObjectsFromArray:values];
  return result;
}


- (id) objectAtIndex:(NSUInteger)index {
  return [[[underlyingArray objectAtIndex:index] retain] autorelease];
}


- (NSUInteger) count {
  return [underlyingArray count];
}


- (void)addObject:(id)anObject {
  [underlyingArray addObject:anObject];
}


- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [underlyingArray insertObject:anObject atIndex:index];
}


- (void)removeLastObject {
  [underlyingArray removeLastObject];
}


- (void)removeObjectAtIndex:(NSUInteger)index {
  [underlyingArray removeObjectAtIndex:index];
}


- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  [underlyingArray replaceObjectAtIndex:index withObject:anObject];
}

@end
