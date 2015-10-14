//
//  SAHalfscreenView.m
//  Pods
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

#import "SAHalfscreenView.h"

#import "SKMRAIDView.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SASender.h"

@interface SAView ()
- (void) display;
- (CGRect) arrangeAdInFrame:(CGRect)frame;
- (void) clickOnAd;
- (void) createPadlockButtonWithParent:(UIView *)parent;
- (void) removePadlockButtonFromParent;
@end

@interface SAHalfscreenView () <SKMRAIDViewDelegate>
@end

@implementation SAHalfscreenView

- (id) initWithPlacementId:(NSInteger)placementId andFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        super.placementId = placementId;
        super.isParentalGateEnabled = YES;
    }
    
    return self;
}

// specific to the halfscreen view
- (void) didMoveToWindow {
    if (super.playInstantly) {
        [self playInstant];
    }
}

- (void) display {
    [super display];
    
    CGRect frame = [self arrangeAdInFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    raidview = [[SKMRAIDView alloc] initWithFrame:frame
                                     withHtmlData:ad.adHTML
                                      withBaseURL:[NSURL URLWithString:@""]
                                supportedFeatures:@[]
                                         delegate:self
                                  serviceDelegate:nil
                               rootViewController:nil];
    
    [self addSubview:raidview];
    [self createPadlockButtonWithParent:raidview];
}

#pragma mark MKRAID View delegate

- (void) mraidViewAdReady:(SKMRAIDView *)mraidView {
    [SASender postEventViewableImpression:ad];
    
    if ([super.delegate respondsToSelector:@selector(adWasShown:)]) {
        [super.delegate adWasShown:ad.placementId];
    }
}

- (void) mraidViewAdFailed:(SKMRAIDView *)mraidView {
    [SASender postEventAdFailedToView:ad];
    
    if ([super.delegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.delegate adFailedToShow:ad.placementId];
    }
}

- (void) mraidViewNavigate:(SKMRAIDView *)mraidView withURL:(NSURL *)url {
    [self clickOnAd];
}

@end
