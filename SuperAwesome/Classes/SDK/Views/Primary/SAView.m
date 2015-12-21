//
//  SAView.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

#import "SAView.h"

// import model
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import subview
#import "SAParentalGate.h"
#import "SAPadlock.h"

@implementation SAView

// overwriting init functions
- (id) init {
    if (self = [super init]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
    }
    
    return self;
}

#pragma mark Playing and displaying

- (void) play {
    // init parental gate
    gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    gate.delegate = _parentalGateDelegate;
    
    // init the pad
    pad = [[SAPadlock alloc] initWithWeakRefToView:self];
}


#pragma mark Click Handling

- (void) tryToGoToURL:(NSURL*)url {
    
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    // form the correct final URL
    if (!_ad.creative.isFullClickURLReliable) {
        _ad.creative.fullClickURL = [NSString stringWithFormat:@"%@&redir=%@", _ad.creative.trackingURL, [url absoluteString]];
    }
    
    if (_isParentalGateEnabled) {
        [gate show];
    } else {
        [self advanceToClick];
    }
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", _ad.creative.fullClickURL);
    NSURL *url = [NSURL URLWithString:_ad.creative.fullClickURL];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark Resize to Frame

- (void) resizeToFrame:(CGRect)frame {
    // do nothing
}

@end