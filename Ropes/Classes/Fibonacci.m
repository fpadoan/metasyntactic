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

#import "Fibonacci.h"

@implementation Fibonacci

/**
 * BAP95
 * Let Fn be the nth Fibonacci number. A rope of depth n is balanced if its
 * length is at least Fn+2, e.g. a balanced rope of depth 1 must have length
 * at least 2. Note that balanced ropes may contain unbalanced subropes.
 */
static NSInteger* fibonacciArray;
static NSInteger fibonacciArrayLength;

+ (void) initialize {
  if (self == [Fibonacci class]) {
    // Dynamically generate the list of fibonacci numbers the first time this
    // class is accessed.
    NSMutableArray* numbers = [NSMutableArray array];
    
    // we skip the first fibonacci number (1).  So instead of: 1 1 2 3 5 8 ...
    // we have: 1 2 3 5 8 ...
    NSInteger f1 = 1;
    NSInteger f2 = 1;
    
    // get all the values until we roll over.
    while (f2 > 0) {
      [numbers addObject:[NSNumber numberWithInteger:f2]];
      NSInteger temp = f1 + f2;
      f1 = f2;
      f2 = temp;
    }
    
    // we include this here so that we can index this array to [x + 1] in the
    // loops below.
    [numbers addObject:[NSNumber numberWithInteger:NSIntegerMax]];
    
    fibonacciArrayLength = numbers.count;
    fibonacciArray = malloc(fibonacciArrayLength * sizeof(NSInteger));
    
    for (NSInteger i = 0; i < fibonacciArrayLength; i++) {
      fibonacciArray[i] = [[numbers objectAtIndex:i] integerValue];
    }
  }
}


+ (NSInteger*) fibonacciArray {
  return fibonacciArray;
}


+ (NSInteger) fibonacciArrayLength {
  return fibonacciArrayLength;
}

@end
