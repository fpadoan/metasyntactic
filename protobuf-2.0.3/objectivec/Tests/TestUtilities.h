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

#import <SenTestingKit/SenTestingKit.h>

@class TestAllExtensions;
@class TestAllExtensions_Builder;
@class TestAllTypes;
@class TestAllTypes_Builder;
@class PBExtensionRegistry;
@class PBMutableExtensionRegistry;

@interface TestUtilities : SenTestCase {
}

+ (void) setAllFields:(TestAllTypes_Builder*) message;
+ (void) setAllExtensions:(TestAllExtensions_Builder*) message;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;

+ (TestAllTypes*) allSet;
+ (TestAllExtensions*) allExtensionsSet;

+ (void) assertAllFieldsSet:(TestAllTypes*) message;
+ (void) assertAllExtensionsSet:(TestAllExtensions*) message;
+ (void) assertRepeatedFieldsModified:(TestAllTypes*) message;
+ (void) assertRepeatedExtensionsModified:(TestAllExtensions*) message;
+ (void) assertExtensionsClear:(TestAllExtensions*) message;

+ (void) modifyRepeatedFields:(TestAllTypes_Builder*) message;
+ (void) modifyRepeatedExtensions:(TestAllExtensions_Builder*) message;

+ (PBExtensionRegistry*) extensionRegistry;

+ (NSData*) goldenData;

@end
