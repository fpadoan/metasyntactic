// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "UnittestMset.pb.h"

@implementation UnittestMsetRoot
+ (void) initialize {
  if (self == [UnittestMsetRoot class]) {
  }
}
@end

@interface TestMessageSet ()
@end

@implementation TestMessageSet

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
  }
  return self;
}
static TestMessageSet* defaultTestMessageSetInstance = nil;
+ (void) initialize {
  if (self == [TestMessageSet class]) {
    defaultTestMessageSetInstance = [[TestMessageSet alloc] init];
  }
}
+ (TestMessageSet*) defaultInstance {
  return defaultTestMessageSetInstance;
}
- (TestMessageSet*) defaultInstance {
  return defaultTestMessageSetInstance;
}
- (BOOL) isInitialized {
  if (!self.extensionsAreInitialized) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self writeExtensionsToCodedOutputStream:output
                                      from:4
                                        to:536870912];
  [self.unknownFields writeAsMessageSetTo:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  size += [self extensionsSerializedSize];
  size += self.unknownFields.serializedSizeAsMessageSet;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMessageSet*) parseFromData:(NSData*) data {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromData:data] build];
}
+ (TestMessageSet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSet*) parseFromInputStream:(NSInputStream*) input {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromInputStream:input] build];
}
+ (TestMessageSet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromCodedInputStream:input] build];
}
+ (TestMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSet*)[[[TestMessageSet builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSet_Builder*) builder {
  return [[[TestMessageSet_Builder alloc] init] autorelease];
}
+ (TestMessageSet_Builder*) builderWithPrototype:(TestMessageSet*) prototype {
  return [[TestMessageSet builder] mergeFrom:prototype];
}
- (TestMessageSet_Builder*) builder {
  return [TestMessageSet builder];
}
@end

@interface TestMessageSet_Builder()
@property (retain) TestMessageSet* result;
@end

@implementation TestMessageSet_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[TestMessageSet alloc] init] autorelease];
  }
  return self;
}
- (PBExtendableMessage*) internalGetResult {
  return result;
}
- (TestMessageSet_Builder*) clear {
  self.result = [[[TestMessageSet alloc] init] autorelease];
  return self;
}
- (TestMessageSet_Builder*) clone {
  return [TestMessageSet builderWithPrototype:result];
}
- (TestMessageSet*) defaultInstance {
  return [TestMessageSet defaultInstance];
}
- (TestMessageSet*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (TestMessageSet*) buildPartial {
  TestMessageSet* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMessageSet_Builder*) mergeFrom:(TestMessageSet*) other {
  if (other == [TestMessageSet defaultInstance]) {
    return self;
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface TestMessageSetContainer ()
@property (retain) TestMessageSet* messageSet;
@end

@implementation TestMessageSetContainer

- (BOOL) hasMessageSet {
  return !!hasMessageSet_;
}
- (void) setHasMessageSet:(BOOL) value {
  hasMessageSet_ = !!value;
}
@synthesize messageSet;
- (void) dealloc {
  self.messageSet = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.messageSet = [TestMessageSet defaultInstance];
  }
  return self;
}
static TestMessageSetContainer* defaultTestMessageSetContainerInstance = nil;
+ (void) initialize {
  if (self == [TestMessageSetContainer class]) {
    defaultTestMessageSetContainerInstance = [[TestMessageSetContainer alloc] init];
  }
}
+ (TestMessageSetContainer*) defaultInstance {
  return defaultTestMessageSetContainerInstance;
}
- (TestMessageSetContainer*) defaultInstance {
  return defaultTestMessageSetContainerInstance;
}
- (BOOL) isInitialized {
  if (self.hasMessageSet) {
    if (!self.messageSet.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasMessageSet) {
    [output writeMessage:1 value:self.messageSet];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasMessageSet) {
    size += computeMessageSize(1, self.messageSet);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMessageSetContainer*) parseFromData:(NSData*) data {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromData:data] build];
}
+ (TestMessageSetContainer*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetContainer*) parseFromInputStream:(NSInputStream*) input {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromInputStream:input] build];
}
+ (TestMessageSetContainer*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetContainer*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromCodedInputStream:input] build];
}
+ (TestMessageSetContainer*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetContainer*)[[[TestMessageSetContainer builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetContainer_Builder*) builder {
  return [[[TestMessageSetContainer_Builder alloc] init] autorelease];
}
+ (TestMessageSetContainer_Builder*) builderWithPrototype:(TestMessageSetContainer*) prototype {
  return [[TestMessageSetContainer builder] mergeFrom:prototype];
}
- (TestMessageSetContainer_Builder*) builder {
  return [TestMessageSetContainer builder];
}
@end

@interface TestMessageSetContainer_Builder()
@property (retain) TestMessageSetContainer* result;
@end

@implementation TestMessageSetContainer_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[TestMessageSetContainer alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (TestMessageSetContainer_Builder*) clear {
  self.result = [[[TestMessageSetContainer alloc] init] autorelease];
  return self;
}
- (TestMessageSetContainer_Builder*) clone {
  return [TestMessageSetContainer builderWithPrototype:result];
}
- (TestMessageSetContainer*) defaultInstance {
  return [TestMessageSetContainer defaultInstance];
}
- (TestMessageSetContainer*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (TestMessageSetContainer*) buildPartial {
  TestMessageSetContainer* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMessageSetContainer_Builder*) mergeFrom:(TestMessageSetContainer*) other {
  if (other == [TestMessageSetContainer defaultInstance]) {
    return self;
  }
  if (other.hasMessageSet) {
    [self mergeMessageSet:other.messageSet];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMessageSetContainer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMessageSetContainer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestMessageSet_Builder* subBuilder = [TestMessageSet builder];
        if (self.hasMessageSet) {
          [subBuilder mergeFrom:self.messageSet];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setMessageSet:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasMessageSet {
  return result.hasMessageSet;
}
- (TestMessageSet*) messageSet {
  return result.messageSet;
}
- (TestMessageSetContainer_Builder*) setMessageSet:(TestMessageSet*) value {
  result.hasMessageSet = YES;
  result.messageSet = value;
  return self;
}
- (TestMessageSetContainer_Builder*) setMessageSetBuilder:(TestMessageSet_Builder*) builderForValue {
  return [self setMessageSet:[builderForValue build]];
}
- (TestMessageSetContainer_Builder*) mergeMessageSet:(TestMessageSet*) value {
  if (result.hasMessageSet &&
      result.messageSet != [TestMessageSet defaultInstance]) {
    result.messageSet =
      [[[TestMessageSet builderWithPrototype:result.messageSet] mergeFrom:value] buildPartial];
  } else {
    result.messageSet = value;
  }
  result.hasMessageSet = YES;
  return self;
}
- (TestMessageSetContainer_Builder*) clearMessageSet {
  result.hasMessageSet = NO;
  result.messageSet = [TestMessageSet defaultInstance];
  return self;
}
@end

@interface TestMessageSetExtension1 ()
@property int32_t i;
@end

@implementation TestMessageSetExtension1

- (BOOL) hasI {
  return !!hasI_;
}
- (void) setHasI:(BOOL) value {
  hasI_ = !!value;
}
@synthesize i;
- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.i = 0;
  }
  return self;
}
static id<PBExtensionField> TestMessageSetExtension1_messageSetExtension = nil;
+ (id<PBExtensionField>) messageSetExtension {
  return TestMessageSetExtension1_messageSetExtension;
}
static TestMessageSetExtension1* defaultTestMessageSetExtension1Instance = nil;
+ (void) initialize {
  if (self == [TestMessageSetExtension1 class]) {
    defaultTestMessageSetExtension1Instance = [[TestMessageSetExtension1 alloc] init];
     TestMessageSetExtension1_messageSetExtension =
  [[PBConcreteExtensionField extensionWithType:PBExtensionTypeMessage
                                 extendedClass:[TestMessageSet class]
                                   fieldNumber:1545008
                                  defaultValue:[TestMessageSetExtension1 defaultInstance]
                           messageOrGroupClass:[TestMessageSetExtension1 class]
                                    isRepeated:false
                                      isPacked:false
                        isMessageSetWireFormat:true] retain];
  }
}
+ (TestMessageSetExtension1*) defaultInstance {
  return defaultTestMessageSetExtension1Instance;
}
- (TestMessageSetExtension1*) defaultInstance {
  return defaultTestMessageSetExtension1Instance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasI) {
    [output writeInt32:15 value:self.i];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasI) {
    size += computeInt32Size(15, self.i);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMessageSetExtension1*) parseFromData:(NSData*) data {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromData:data] build];
}
+ (TestMessageSetExtension1*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension1*) parseFromInputStream:(NSInputStream*) input {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromInputStream:input] build];
}
+ (TestMessageSetExtension1*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension1*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromCodedInputStream:input] build];
}
+ (TestMessageSetExtension1*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension1*)[[[TestMessageSetExtension1 builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension1_Builder*) builder {
  return [[[TestMessageSetExtension1_Builder alloc] init] autorelease];
}
+ (TestMessageSetExtension1_Builder*) builderWithPrototype:(TestMessageSetExtension1*) prototype {
  return [[TestMessageSetExtension1 builder] mergeFrom:prototype];
}
- (TestMessageSetExtension1_Builder*) builder {
  return [TestMessageSetExtension1 builder];
}
@end

@interface TestMessageSetExtension1_Builder()
@property (retain) TestMessageSetExtension1* result;
@end

@implementation TestMessageSetExtension1_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[TestMessageSetExtension1 alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (TestMessageSetExtension1_Builder*) clear {
  self.result = [[[TestMessageSetExtension1 alloc] init] autorelease];
  return self;
}
- (TestMessageSetExtension1_Builder*) clone {
  return [TestMessageSetExtension1 builderWithPrototype:result];
}
- (TestMessageSetExtension1*) defaultInstance {
  return [TestMessageSetExtension1 defaultInstance];
}
- (TestMessageSetExtension1*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (TestMessageSetExtension1*) buildPartial {
  TestMessageSetExtension1* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMessageSetExtension1_Builder*) mergeFrom:(TestMessageSetExtension1*) other {
  if (other == [TestMessageSetExtension1 defaultInstance]) {
    return self;
  }
  if (other.hasI) {
    [self setI:other.i];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMessageSetExtension1_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMessageSetExtension1_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 120: {
        [self setI:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasI {
  return result.hasI;
}
- (int32_t) i {
  return result.i;
}
- (TestMessageSetExtension1_Builder*) setI:(int32_t) value {
  result.hasI = YES;
  result.i = value;
  return self;
}
- (TestMessageSetExtension1_Builder*) clearI {
  result.hasI = NO;
  result.i = 0;
  return self;
}
@end

@interface TestMessageSetExtension2 ()
@property (retain) NSString* str;
@end

@implementation TestMessageSetExtension2

- (BOOL) hasStr {
  return !!hasStr_;
}
- (void) setHasStr:(BOOL) value {
  hasStr_ = !!value;
}
@synthesize str;
- (void) dealloc {
  self.str = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.str = @"";
  }
  return self;
}
static id<PBExtensionField> TestMessageSetExtension2_messageSetExtension = nil;
+ (id<PBExtensionField>) messageSetExtension {
  return TestMessageSetExtension2_messageSetExtension;
}
static TestMessageSetExtension2* defaultTestMessageSetExtension2Instance = nil;
+ (void) initialize {
  if (self == [TestMessageSetExtension2 class]) {
    defaultTestMessageSetExtension2Instance = [[TestMessageSetExtension2 alloc] init];
     TestMessageSetExtension2_messageSetExtension =
  [[PBConcreteExtensionField extensionWithType:PBExtensionTypeMessage
                                 extendedClass:[TestMessageSet class]
                                   fieldNumber:1547769
                                  defaultValue:[TestMessageSetExtension2 defaultInstance]
                           messageOrGroupClass:[TestMessageSetExtension2 class]
                                    isRepeated:false
                                      isPacked:false
                        isMessageSetWireFormat:true] retain];
  }
}
+ (TestMessageSetExtension2*) defaultInstance {
  return defaultTestMessageSetExtension2Instance;
}
- (TestMessageSetExtension2*) defaultInstance {
  return defaultTestMessageSetExtension2Instance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasStr) {
    [output writeString:25 value:self.str];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasStr) {
    size += computeStringSize(25, self.str);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMessageSetExtension2*) parseFromData:(NSData*) data {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromData:data] build];
}
+ (TestMessageSetExtension2*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension2*) parseFromInputStream:(NSInputStream*) input {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromInputStream:input] build];
}
+ (TestMessageSetExtension2*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension2*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromCodedInputStream:input] build];
}
+ (TestMessageSetExtension2*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMessageSetExtension2*)[[[TestMessageSetExtension2 builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMessageSetExtension2_Builder*) builder {
  return [[[TestMessageSetExtension2_Builder alloc] init] autorelease];
}
+ (TestMessageSetExtension2_Builder*) builderWithPrototype:(TestMessageSetExtension2*) prototype {
  return [[TestMessageSetExtension2 builder] mergeFrom:prototype];
}
- (TestMessageSetExtension2_Builder*) builder {
  return [TestMessageSetExtension2 builder];
}
@end

@interface TestMessageSetExtension2_Builder()
@property (retain) TestMessageSetExtension2* result;
@end

@implementation TestMessageSetExtension2_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[TestMessageSetExtension2 alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (TestMessageSetExtension2_Builder*) clear {
  self.result = [[[TestMessageSetExtension2 alloc] init] autorelease];
  return self;
}
- (TestMessageSetExtension2_Builder*) clone {
  return [TestMessageSetExtension2 builderWithPrototype:result];
}
- (TestMessageSetExtension2*) defaultInstance {
  return [TestMessageSetExtension2 defaultInstance];
}
- (TestMessageSetExtension2*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (TestMessageSetExtension2*) buildPartial {
  TestMessageSetExtension2* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMessageSetExtension2_Builder*) mergeFrom:(TestMessageSetExtension2*) other {
  if (other == [TestMessageSetExtension2 defaultInstance]) {
    return self;
  }
  if (other.hasStr) {
    [self setStr:other.str];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMessageSetExtension2_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMessageSetExtension2_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 202: {
        [self setStr:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasStr {
  return result.hasStr;
}
- (NSString*) str {
  return result.str;
}
- (TestMessageSetExtension2_Builder*) setStr:(NSString*) value {
  result.hasStr = YES;
  result.str = value;
  return self;
}
- (TestMessageSetExtension2_Builder*) clearStr {
  result.hasStr = NO;
  result.str = @"";
  return self;
}
@end

@interface RawMessageSet ()
@property (retain) NSMutableArray* mutableItemList;
@end

@implementation RawMessageSet

@synthesize mutableItemList;
- (void) dealloc {
  self.mutableItemList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
  }
  return self;
}
static RawMessageSet* defaultRawMessageSetInstance = nil;
+ (void) initialize {
  if (self == [RawMessageSet class]) {
    defaultRawMessageSetInstance = [[RawMessageSet alloc] init];
  }
}
+ (RawMessageSet*) defaultInstance {
  return defaultRawMessageSetInstance;
}
- (RawMessageSet*) defaultInstance {
  return defaultRawMessageSetInstance;
}
- (NSArray*) itemList {
  return mutableItemList;
}
- (RawMessageSet_Item*) itemAtIndex:(int32_t) index {
  id value = [mutableItemList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  for (RawMessageSet_Item* element in self.itemList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (RawMessageSet_Item* element in self.itemList) {
    [output writeGroup:1 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  for (RawMessageSet_Item* element in self.itemList) {
    size += computeGroupSize(1, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (RawMessageSet*) parseFromData:(NSData*) data {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromData:data] build];
}
+ (RawMessageSet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet*) parseFromInputStream:(NSInputStream*) input {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromInputStream:input] build];
}
+ (RawMessageSet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromCodedInputStream:input] build];
}
+ (RawMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet*)[[[RawMessageSet builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet_Builder*) builder {
  return [[[RawMessageSet_Builder alloc] init] autorelease];
}
+ (RawMessageSet_Builder*) builderWithPrototype:(RawMessageSet*) prototype {
  return [[RawMessageSet builder] mergeFrom:prototype];
}
- (RawMessageSet_Builder*) builder {
  return [RawMessageSet builder];
}
@end

@interface RawMessageSet_Item ()
@property int32_t typeId;
@property (retain) NSData* message;
@end

@implementation RawMessageSet_Item

- (BOOL) hasTypeId {
  return !!hasTypeId_;
}
- (void) setHasTypeId:(BOOL) value {
  hasTypeId_ = !!value;
}
@synthesize typeId;
- (BOOL) hasMessage {
  return !!hasMessage_;
}
- (void) setHasMessage:(BOOL) value {
  hasMessage_ = !!value;
}
@synthesize message;
- (void) dealloc {
  self.message = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.typeId = 0;
    self.message = [NSData data];
  }
  return self;
}
static RawMessageSet_Item* defaultRawMessageSet_ItemInstance = nil;
+ (void) initialize {
  if (self == [RawMessageSet_Item class]) {
    defaultRawMessageSet_ItemInstance = [[RawMessageSet_Item alloc] init];
  }
}
+ (RawMessageSet_Item*) defaultInstance {
  return defaultRawMessageSet_ItemInstance;
}
- (RawMessageSet_Item*) defaultInstance {
  return defaultRawMessageSet_ItemInstance;
}
- (BOOL) isInitialized {
  if (!self.hasTypeId) {
    return NO;
  }
  if (!self.hasMessage) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasTypeId) {
    [output writeInt32:2 value:self.typeId];
  }
  if (self.hasMessage) {
    [output writeData:3 value:self.message];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasTypeId) {
    size += computeInt32Size(2, self.typeId);
  }
  if (self.hasMessage) {
    size += computeDataSize(3, self.message);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (RawMessageSet_Item*) parseFromData:(NSData*) data {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromData:data] build];
}
+ (RawMessageSet_Item*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet_Item*) parseFromInputStream:(NSInputStream*) input {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromInputStream:input] build];
}
+ (RawMessageSet_Item*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet_Item*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromCodedInputStream:input] build];
}
+ (RawMessageSet_Item*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RawMessageSet_Item*)[[[RawMessageSet_Item builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RawMessageSet_Item_Builder*) builder {
  return [[[RawMessageSet_Item_Builder alloc] init] autorelease];
}
+ (RawMessageSet_Item_Builder*) builderWithPrototype:(RawMessageSet_Item*) prototype {
  return [[RawMessageSet_Item builder] mergeFrom:prototype];
}
- (RawMessageSet_Item_Builder*) builder {
  return [RawMessageSet_Item builder];
}
@end

@interface RawMessageSet_Item_Builder()
@property (retain) RawMessageSet_Item* result;
@end

@implementation RawMessageSet_Item_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[RawMessageSet_Item alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (RawMessageSet_Item_Builder*) clear {
  self.result = [[[RawMessageSet_Item alloc] init] autorelease];
  return self;
}
- (RawMessageSet_Item_Builder*) clone {
  return [RawMessageSet_Item builderWithPrototype:result];
}
- (RawMessageSet_Item*) defaultInstance {
  return [RawMessageSet_Item defaultInstance];
}
- (RawMessageSet_Item*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (RawMessageSet_Item*) buildPartial {
  RawMessageSet_Item* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (RawMessageSet_Item_Builder*) mergeFrom:(RawMessageSet_Item*) other {
  if (other == [RawMessageSet_Item defaultInstance]) {
    return self;
  }
  if (other.hasTypeId) {
    [self setTypeId:other.typeId];
  }
  if (other.hasMessage) {
    [self setMessage:other.message];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (RawMessageSet_Item_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (RawMessageSet_Item_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 16: {
        [self setTypeId:[input readInt32]];
        break;
      }
      case 26: {
        [self setMessage:[input readData]];
        break;
      }
    }
  }
}
- (BOOL) hasTypeId {
  return result.hasTypeId;
}
- (int32_t) typeId {
  return result.typeId;
}
- (RawMessageSet_Item_Builder*) setTypeId:(int32_t) value {
  result.hasTypeId = YES;
  result.typeId = value;
  return self;
}
- (RawMessageSet_Item_Builder*) clearTypeId {
  result.hasTypeId = NO;
  result.typeId = 0;
  return self;
}
- (BOOL) hasMessage {
  return result.hasMessage;
}
- (NSData*) message {
  return result.message;
}
- (RawMessageSet_Item_Builder*) setMessage:(NSData*) value {
  result.hasMessage = YES;
  result.message = value;
  return self;
}
- (RawMessageSet_Item_Builder*) clearMessage {
  result.hasMessage = NO;
  result.message = [NSData data];
  return self;
}
@end

@interface RawMessageSet_Builder()
@property (retain) RawMessageSet* result;
@end

@implementation RawMessageSet_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[RawMessageSet alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (RawMessageSet_Builder*) clear {
  self.result = [[[RawMessageSet alloc] init] autorelease];
  return self;
}
- (RawMessageSet_Builder*) clone {
  return [RawMessageSet builderWithPrototype:result];
}
- (RawMessageSet*) defaultInstance {
  return [RawMessageSet defaultInstance];
}
- (RawMessageSet*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (RawMessageSet*) buildPartial {
  RawMessageSet* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (RawMessageSet_Builder*) mergeFrom:(RawMessageSet*) other {
  if (other == [RawMessageSet defaultInstance]) {
    return self;
  }
  if (other.mutableItemList.count > 0) {
    if (result.mutableItemList == nil) {
      result.mutableItemList = [NSMutableArray array];
    }
    [result.mutableItemList addObjectsFromArray:other.mutableItemList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (RawMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (RawMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 11: {
        RawMessageSet_Item_Builder* subBuilder = [RawMessageSet_Item builder];
        [input readGroup:1 builder:subBuilder extensionRegistry:extensionRegistry];
        [self addItem:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (NSArray*) itemList {
  if (result.mutableItemList == nil) { return [NSArray array]; }
  return result.mutableItemList;
}
- (RawMessageSet_Item*) itemAtIndex:(int32_t) index {
  return [result itemAtIndex:index];
}
- (RawMessageSet_Builder*) replaceItemAtIndex:(int32_t) index with:(RawMessageSet_Item*) value {
  [result.mutableItemList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (RawMessageSet_Builder*) addAllItem:(NSArray*) values {
  if (result.mutableItemList == nil) {
    result.mutableItemList = [NSMutableArray array];
  }
  [result.mutableItemList addObjectsFromArray:values];
  return self;
}
- (RawMessageSet_Builder*) clearItemList {
  result.mutableItemList = nil;
  return self;
}
- (RawMessageSet_Builder*) addItem:(RawMessageSet_Item*) value {
  if (result.mutableItemList == nil) {
    result.mutableItemList = [NSMutableArray array];
  }
  [result.mutableItemList addObject:value];
  return self;
}
@end

