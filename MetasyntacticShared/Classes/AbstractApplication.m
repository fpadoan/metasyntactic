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

#import "AbstractApplication.h"

#import "DeviceUtilities.h"
#import "MetasyntacticShared.h"

@implementation AbstractApplication

static NSLock* gate = nil;
static NSString* dirtyFile = nil;
static BOOL shutdownCleanly = NO;
static NSCondition* emptyTrashCondition = nil;

static NSMutableSet* directories;

static NSString* cacheDirectory = nil;
static NSString* supportDirectory = nil;
static NSString* tempDirectory = nil;
static NSString* trashDirectory = nil;
static NSString* imagesDirectory = nil;
static NSString* storeDirectory = nil;

+ (NSString*) name {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


+ (NSString*) version {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


+ (NSString*) nameAndVersion {
  NSString* appName = [self name];
  NSString* appVersion = [self version];

  return [NSString stringWithFormat:@"%@ v%@", appName, appVersion];
}


+ (void) addDirectory:(NSString *)directory {
  [directories addObject:directory];
}


+ (void) deleteDirectories {
  [gate lock];
  {
    for (NSString* directory in directories) {
      [self moveItemToTrash:directory];
    }
  }
  [gate unlock];
}


+ (void) createDirectories {
  [gate lock];
  {
    for (NSString* directory in directories) {
      [FileUtilities createDirectory:directory];
    }
  }
  [gate unlock];
}


+ (void) resetDirectories {
  [gate lock];
  {
    [self deleteDirectories];
    [self createDirectories];
  }
  [gate unlock];
}


+ (void) initializeDirectories {
  tempDirectory = [NSTemporaryDirectory() retain];

  {
    NSString* delegateDirectory = [MetasyntacticSharedApplication cacheDirectory];
    if (delegateDirectory.length > 0) {
      [self addDirectory:cacheDirectory = delegateDirectory];
    } else {
      NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, /*expandTilde:*/YES);
      NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
      [self addDirectory:cacheDirectory = [paths.firstObject stringByAppendingPathComponent:executableName]];
    }
  }

  {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
    NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    [self addDirectory:supportDirectory = [paths.firstObject stringByAppendingPathComponent:executableName]];
  }

  [self addDirectory:trashDirectory = [cacheDirectory stringByAppendingPathComponent:@"Trash"]];
  [self addDirectory:imagesDirectory = [cacheDirectory stringByAppendingPathComponent:@"Images"]];
  [self addDirectory:storeDirectory = [cacheDirectory stringByAppendingPathComponent:@"Store"]];

  dirtyFile = [[supportDirectory stringByAppendingPathComponent:@"Dirty.plist"] retain];

  [self createDirectories];
}


+ (void) initialize {
  if (self == [AbstractApplication class]) {
    gate = [[NSRecursiveLock alloc] init];
    emptyTrashCondition = [[NSCondition alloc] init];
    directories = [[NSMutableSet alloc] init];

    [self initializeDirectories];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    shutdownCleanly = ![FileUtilities fileExists:dirtyFile];
    [FileUtilities writeObject:@"" toFile:dirtyFile];

    [self performSelector:@selector(emptyTrash) withObject:nil afterDelay:10];
  }
}


+ (void) onApplicationWillTerminate:(id) argument {
  [self moveItemToTrash:dirtyFile];
}


+ (BOOL) shutdownCleanly {
  return shutdownCleanly;
}


+ (void) emptyTrash {
  [ThreadingUtilities backgroundSelector:@selector(emptyTrashBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:YES];
}


+ (NSLock*) gate {
  return gate;
}


+ (NSString*) cacheDirectory {
  return cacheDirectory;
}


+ (NSString*) supportDirectory {
  return supportDirectory;
}


+ (NSString*) trashDirectory {
  return trashDirectory;
}


+ (NSString*) imagesDirectory {
  return imagesDirectory;
}


+ (NSString*) tempDirectory {
  return tempDirectory;
}


+ (NSString*) storeDirectory {
  return storeDirectory;
}


+ (void) deleteTrash {
  NSLog(@"Application:emptyTrashBackgroundEntryPoint - start");
  NSFileManager* manager = [[[NSFileManager alloc] init] autorelease];
  NSDirectoryEnumerator* enumerator = [manager enumeratorAtPath:trashDirectory];

  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString* fileName;
    while ((fileName = [enumerator nextObject]) != nil) {
      NSString* fullPath = [trashDirectory stringByAppendingPathComponent:fileName];
      NSDictionary* attributes = [enumerator fileAttributes];

      // don't delete folders yet
      if (![[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
        NSLog(@"Application:emptyTrashBackgroundEntryPoint - %@", fullPath.lastPathComponent);
        [manager removeItemAtPath:fullPath error:NULL];
      }

      [NSThread sleepForTimeInterval:1];

      [pool release];
      pool = [[NSAutoreleasePool alloc] init];
    }

    [pool release];
  }

  // Now remove the directories.
  for (NSString* fileName in [FileUtilities directoryContentsNames:trashDirectory]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSString* fullPath = [trashDirectory stringByAppendingPathComponent:fileName];

      [manager removeItemAtPath:fullPath error:NULL];
      [NSThread sleepForTimeInterval:1];
    }
    [pool release];
  }

  NSLog(@"Application:emptyTrashBackgroundEntryPoint - stop");
}


+ (void) emptyTrashBackgroundEntryPointWorker {
  [emptyTrashCondition lock];
  {
    while ([FileUtilities directoryContentsNames:[self trashDirectory]].count == 0) {
      [emptyTrashCondition wait];
    }
  }
  [emptyTrashCondition unlock];

  [self deleteTrash];
}


+ (void) emptyTrashBackgroundEntryPoint {
  while (YES) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self emptyTrashBackgroundEntryPointWorker];
    }
    [pool release];
  }
}


+ (void) clearStaleItem:(NSString*) fullPath
           inEnumerator:(NSDirectoryEnumerator*) enumerator
            withManager:(NSFileManager*) manager {
  NSDictionary* attributes = [enumerator fileAttributes];

  // don't delete folders
  if (![[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
    NSDate* lastModifiedDate = [attributes objectForKey:NSFileModificationDate];
    if (lastModifiedDate != nil) {
      if (ABS(lastModifiedDate.timeIntervalSinceNow) > CACHE_LIMIT) {
        NSLog(@"Application:clearStaleDataBackgroundEntryPoint - %@", fullPath.lastPathComponent);
        [manager removeItemAtPath:fullPath error:NULL];
      }
    }
  }
}


+ (NSArray*) directoriesToKeep AbstractMethod;


+ (void) clearStaleDataBackgroundEntryPoint {
  NSLog(@"Application:clearStaleDataBackgroundEntryPoint - start");
  NSFileManager* manager = [NSFileManager defaultManager];
  NSDirectoryEnumerator* enumerator = [manager enumeratorAtPath:cacheDirectory];
  NSArray* directoriesToKeep = [self directoriesToKeep];

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  NSString* fileName;
  while ((fileName = [enumerator nextObject]) != nil) {
    NSString* fullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
    if ([directoriesToKeep containsObject:fullPath]) {
      [enumerator skipDescendents];
    } else if ((rand() % 1000) < 100) {
      [self clearStaleItem:fullPath inEnumerator:enumerator withManager:manager];
    }

    [pool release];
    pool = [[NSAutoreleasePool alloc] init];
  }
  [pool release];
  NSLog(@"Application:clearStaleDataBackgroundEntryPoint - stop");
}


+ (void) clearStaleData {
  [ThreadingUtilities backgroundSelector:@selector(clearStaleDataBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:YES];
}


+ (void) moveItemToTrash:(NSString*) path {
  [gate lock];
  {
    NSFileManager* fileManager = [[[NSFileManager alloc] init] autorelease];
    NSString* trashPath = [self uniqueTrashDirectory];
    [fileManager moveItemAtPath:path toPath:trashPath error:NULL];

    // safeguard, just in case.
    [fileManager removeItemAtPath:path error:NULL];
  }
  [gate unlock];

  [emptyTrashCondition lock];
  {
    [emptyTrashCondition broadcast];
  }
  [emptyTrashCondition unlock];
}


+ (NSString*) uniqueDirectory:(NSString*) parentDirectory
                       create:(BOOL) create {
  NSString* finalDir;
  NSFileManager* fileManager = [[[NSFileManager alloc] init] autorelease];
  [gate lock];
  {
    do {
      NSString* random = [StringUtilities randomString:8];
      finalDir = [parentDirectory stringByAppendingPathComponent:random];
    } while ([fileManager fileExistsAtPath:finalDir]);

    if (create) {
      [FileUtilities createDirectory:finalDir];
    }
  }
  [gate unlock];

  return finalDir;
}


+ (NSString*) uniqueTemporaryDirectory {
  return [self uniqueDirectory:[self tempDirectory] create:YES];
}


+ (NSString*) uniqueTrashDirectory {
  return [self uniqueDirectory:[self trashDirectory] create:NO];
}


+ (void) openBrowser:(NSString*) address {
  if (address.length == 0) {
    return;
  }

  NSURL* url = [NSURL URLWithString:address];
  [[UIApplication sharedApplication] openURL:url];
}


+ (void) openMap:(NSString*) address {
  [self openBrowser:address];
}


+ (void) makeCall:(NSString*) phoneNumber {
  if (![DeviceUtilities isIPhone]) {
    return;
  }

  NSRange xRange = [phoneNumber rangeOfString:@"x"];
  if (xRange.length > 0 && xRange.location >= 12) {
    // 222-222-2222 x222
    // remove extension
    phoneNumber = [phoneNumber substringToIndex:xRange.location];
  }

  NSString* urlString = [NSString stringWithFormat:@"tel:%@", [StringUtilities stringByAddingPercentEscapes:phoneNumber]];

  [self openBrowser:urlString];
}


+ (BOOL) useKilometers {
  // yeah... so the UK supposedly uses metric...
  // except they don't. so we special case them to stick with 'miles' in the UI.
  BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
  BOOL isUK = [@"GB" isEqual:[LocaleUtilities isoCountry]];

  return isMetric && !isUK;
}


+ (BOOL) canSendMail {
  return [MFMailComposeViewController canSendMail];
}


+ (BOOL) canSendText {
  Class class = NSClassFromString(@"MFMessageComposeViewController");
  return
    class != nil &&
    [class respondsToSelector:@selector(canSendText)] &&
    [class canSendText];
}


+ (BOOL) canAccessCalendar {
  Class class = NSClassFromString(@"EKEventStore");
  return
  class != nil &&
  [class instancesRespondToSelector:@selector(eventWithIdentifier:)];
}

@end
