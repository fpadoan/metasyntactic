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

@protocol DataProvider<NSObject>
- (void) update:(NSDate*) searchDate delegate:(id<DataProviderUpdateDelegate>) delegate context:(id) context force:(BOOL) force;
- (void) saveResult:(LookupResult*) result;

- (void) markOutOfDate;
- (NSDate*) lastLookupDate;

- (BOOL) isStale:(Theater*) theater;

- (NSArray*) movies;
- (NSArray*) theaters;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSDate*) synchronizationDateForTheater:(Theater*) theater;

- (void) addBookmark:(NSString*) canonicalTitle;
- (void) removeBookmark:(NSString*) canonicalTitle;
@end
