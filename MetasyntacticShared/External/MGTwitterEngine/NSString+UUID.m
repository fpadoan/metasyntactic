//
//  NSString+UUID.m
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 16/09/2007.
//  Copyright 2008 Instinctive Code.
//

#import "NSString+UUID.h"

@implementation NSString(UUID)

+ (NSString*)stringWithNewUUID
{
  return CFAutoRelease(CFUUIDCreateString(nil,
           CFAutoRelease(CFUUIDCreate(nil))));
}

@end
