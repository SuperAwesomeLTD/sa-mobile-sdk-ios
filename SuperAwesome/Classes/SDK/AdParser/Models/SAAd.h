//
//  SAAd.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

// formward declarations
@class SACreative;

// @brief:
// This model class contains all information that is received from the server
// when an Ad is requested, as well as some aux fields that will be generated
// by the SDK
@interface SAAd : NSObject

// the original ad json, as sent from the server
// really need it for the Unity integration part
@property (nonatomic, assign) NSString *adJson;

// the SA server can send an error; if that's the case, this field will not be nill
@property (nonatomic, assign) NSInteger error;

// the App id
@property (nonatomic, assign) NSInteger appId;

// the ID of the placement that the ad was sent for
@property (nonatomic, assign) NSInteger placementId;

// line item
@property (nonatomic, assign) NSInteger lineItemId;

// the ID of the campaign that the ad is a part of
@property (nonatomic, assign) NSInteger campaignId;

// is true when the ad is a test ad
@property (nonatomic, assign) BOOL isTest;

// is true when ad is fallback (fallback ads are sent when there are no
// real ads to display for a certain placement)
@property (nonatomic, assign) BOOL isFallback;
@property (nonatomic, assign) BOOL isFill;
@property (nonatomic, assign) BOOL isHouse;

// the HTML of the ad - this is generated by the SDK based on the type of ad
// that is presented (see SAHTMLParser.h)
@property (nonatomic, strong) NSString *adHTML;

// pointer to the creative data associated with the ad
@property (nonatomic, strong) SACreative *creative;

// aux print func
- (void) print;

@end
