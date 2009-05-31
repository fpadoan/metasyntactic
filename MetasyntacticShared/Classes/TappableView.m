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

#import "TappableView.h"

@implementation TappableView

@synthesize delegate;

- (void) dealloc {
    self.delegate = nil;
    [super dealloc];
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    [super touchesEnded:touches withEvent:event];
    if (delegate != nil) {
        UITouch* touch = touches.anyObject;
        if (touch.tapCount > 0) {
            [delegate view:self wasTouched:touch tapCount:touch.tapCount];
        }
    }
}

@end