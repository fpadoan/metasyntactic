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

#import "AbstractDeviceStore.h"

#import "AbstractApplication.h"
#import "AlertUtilities.h"
#import "Base64.h"
#import "MetasyntacticSharedApplication.h"
#import "PersistentDictionaryThreadsafeValue.h"
#import "StoreDelegate.h"
#import "StoreItem.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "UnlockResult.h"

@interface AbstractDeviceStore()
@property (retain) NSMutableSet* bypassingStoreItems;
@property (retain) ThreadsafeValue* itemPricesData;
- (void) recordTransaction:(SKPaymentTransaction*) transaction
                  forItem:(id<StoreItem>) item;
@end

@implementation AbstractDeviceStore

@synthesize bypassingStoreItems;
@synthesize itemPricesData;

- (void) dealloc {
  self.bypassingStoreItems = nil;
  self.itemPricesData = nil;
  [super dealloc];
}


- (NSString*) pricesFile {
  return [[AbstractApplication storeDirectory] stringByAppendingPathComponent:@"StoreItemPrices.plist"];
}


- (id) initWithDelegate:(id<StoreDelegate>) delegate_
                  vault:(StoreItemVault*) vault_ {
  if ((self = [super initWithDelegate:delegate_
                                vault:vault_])) {
    self.bypassingStoreItems = [NSMutableSet set];
    self.itemPricesData = [PersistentDictionaryThreadsafeValue valueWithGate:dataGate file:self.pricesFile];

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  }

  return self;
}


- (void) purchaseItem:(id<StoreItem>) item {
  if (item.isFree) {
    [bypassingStoreItems addObject:item.itunesIdentifier];
    [self bypassStore:item reason:@"Free"];
  } else {
    // 1) notify the payment queue that we want to order this product.
    NSString* storeIdentifier = item.itunesIdentifier;
    [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProductIdentifier:storeIdentifier]];
  }
}


- (void)   paymentQueue:(SKPaymentQueue*) queue
    updatedTransactions:(NSArray*) transactions {
  NSAssert([NSThread isMainThread], nil);

  for (SKPaymentTransaction* transaction in transactions) {
    id<StoreItem> item = [delegate itemForItunesIdentifier:transaction.payment.productIdentifier];

    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchasing:
        // 2a) Transaction is being added to the server queue.
        //     don't need to do anything.
        break;
      case SKPaymentTransactionStateFailed: {
        // 2b) Transaction was cancelled or failed before being added to the server queue.

        UnlockResult* result;
        if ([SKErrorDomain isEqual:transaction.error.domain]  &&
            transaction.error.code == SKErrorPaymentCancelled) {
          result = [UnlockResult resultWithItem:item
                                     transaction:transaction
                                       succeeded:NO
                                         message:@""];
        } else {
          NSString* error = [StringUtilities nonNilString:transaction.error.localizedDescription];
          NSString* message;
          if (item == nil) {
            message =
            [NSString stringWithFormat:
             LocalizedString(@"Failed to purchase item.\n\n%@\n\nYou have not been charged.", nil), error];
          } else {
            message =
            [NSString stringWithFormat:
             LocalizedString(@"Failed to purchase item: %@\n\n%@\n\nYou have not been charged.", nil), item.canonicalTitle, error];
          }

          result = [UnlockResult resultWithItem:item
                                     transaction:transaction
                                       succeeded:NO
                                         message:message];
        }

        // Report the error to the user.
        [ThreadingUtilities foregroundSelector:@selector(reportUnlockResult:)
                                      onTarget:self
                                    withObject:result];
        break;
      }
      case SKPaymentTransactionStatePurchased:
        // 2c)
        // Transaction is in queue, user has been charged.  Client should complete the transaction.
        NSLog(@"Got: SKPaymentTransactionStatePurchased");
        [self recordTransaction:transaction forItem:item];
        break;
      case SKPaymentTransactionStateRestored:
        // 2d)
        // Transaction was restored from user's purchase history.  Client should complete the transaction.
        NSLog(@"Got: SKPaymentTransactionStateRestored");
        [self recordTransaction:transaction forItem:item];
        break;
    }
  }
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) recordTransaction:(SKPaymentTransaction*) transaction
                  forItem:(id<StoreItem>) item {
  // 3) The iTunes store has recorded the purchase.  Now we need to record it on the
  //    comixology server.
  if (item == nil) {
    [AlertUtilities showOkAlert:LocalizedString(@"An unknown failure occurred when trying to communicate with the iTunes store.  You have not been charged.", nil)];
  } else {
    AbstractUnlockRequest* request = [delegate createUnlockRequest:item
                                         transactionIdentifier:transaction.transactionIdentifier
                                                       receipt:[Base64 encode:transaction.transactionReceipt]
                                                   transaction:transaction];
    [self sendUnlockRequest:request];
  }
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) reportUnlockResult:(UnlockResult*) unlockResult {
  NSAssert([NSThread isMainThread], nil);
  [super reportUnlockResult:unlockResult];
  if (unlockResult.item.itunesIdentifier.length > 0) {
    [bypassingStoreItems removeObject:unlockResult.item.itunesIdentifier];
  }

  if (unlockResult.transaction != nil) {
    [[SKPaymentQueue defaultQueue] finishTransaction:unlockResult.transaction];
  }

  [MetasyntacticSharedApplication majorRefresh];
}


- (BOOL) isPurchasing:(id<StoreItem>) item {
  if ([bypassingStoreItems containsObject:item.itunesIdentifier]) {
    return YES;
  }

  for (SKPaymentTransaction* transaction in [[SKPaymentQueue defaultQueue] transactions]) {
    if ([item.itunesIdentifier isEqual:transaction.payment.productIdentifier] &&
        (transaction.transactionState == SKPaymentTransactionStatePurchasing ||
         transaction.transactionState == SKPaymentTransactionStatePurchased ||
         transaction.transactionState == SKPaymentTransactionStateRestored)) {
          return YES;
        }
  }

  return NO;
}


- (void) updatePrices:(NSSet*) items {
  NSMutableSet* identifiers = [NSMutableSet set];
  for (id<StoreItem> item in items) {
    [identifiers addObject:item.itunesIdentifier];
  }
  SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
  request.delegate = self;
  [request start];
}


- (NSDictionary*) itemPrices {
  return itemPricesData.value;
}


- (NSString*) priceForItem:(id<StoreItem>) item {
  if (item.isFree) {
    return item.price;
  }

  NSString* result = [self.itemPrices objectForKey:item.itunesIdentifier];
  if (result.length == 0) {
    return [NSString stringWithFormat:@"$%@", item.price];
  }

  return result;
}


- (NSNumberFormatter*) priceFormatter {
  NSNumberFormatter *priceFormatter = [[[NSNumberFormatter alloc] init] autorelease];
  [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  return priceFormatter;
}


- (void) productsRequest:(SKProductsRequest *)request
      didReceiveResponse:(SKProductsResponse *)response {
  NSMutableDictionary* prices = [NSMutableDictionary dictionaryWithDictionary:self.itemPrices];
  for (SKProduct* product in response.products) {
    if (product.productIdentifier.length > 0 && product.price != nil) {
      NSNumberFormatter* priceFormatter = self.priceFormatter;
      [priceFormatter setLocale:product.priceLocale];
      NSString* formattedString = [priceFormatter stringFromNumber:product.price];

      if (formattedString.length > 0) {
        [prices setObject:formattedString forKey:product.productIdentifier];
      }
    }
  }
  itemPricesData.value = prices;
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  NSLog(@"%@", error);

  [request autorelease];
}


- (void)requestDidFinish:(SKRequest *)request {
  [request autorelease];
}

@end
