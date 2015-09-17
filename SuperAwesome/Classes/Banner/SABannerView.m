//
//  SABanner.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 11/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SABannerView.h"
#import "UIView+FindUIViewController.h"
#import "SuperAwesome.h"
#import "SKLogger.h"
#import "SAPadlockView.h"

@interface SABannerView ()

@property (nonatomic,strong) SKMRAIDView *bannerView;
@property (nonatomic,strong) SAParentalGate *gate;
@property (nonatomic,strong) SAAdResponse *adResponse;
@property (nonatomic,strong) NSURL *adURL;

- (void)commonInit;
- (NSArray *)supportedBannerSizes;
- (BOOL)isSupportedSize:(CGSize)aSize;
- (void)fetchAd;
- (void)renderAd;
- (void)sendImpressionEvent;

@end

@implementation SABannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

//#if TARGET_INTERFACE_BUILDER
//- (void)prepareForInterfaceBuilder
//{
//    if([self isSupportedSize:self.bounds.size]){
//        NSBundle *bundle = [NSBundle bundleForClass:self.class];
//        NSString *fileName = [bundle pathForResource:[NSString stringWithFormat:@"AdDemo%@x%@", @(self.bounds.size.width), @(self.bounds.size.height)] ofType:@"jpg"];
//        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [imageView sizeToFit];
//        [self addSubview:imageView];
//    }else{
//        UIColor *saColor = [UIColor colorWithRed:0.8 green:0.17 blue:0.09 alpha:1];
//        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
//        [label setText:@"Invalid size!\nCheck the documentation for the list of supported banner sizes."];
//        [label setTextColor:[UIColor whiteColor]];
//        [label setBackgroundColor:saColor];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setNumberOfLines:0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self addSubview:label];
//    }
//}
//#endif

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if(self.window == nil){
        return;
    }
    
    [self fetchAd];
}

- (void)removeFromSuperview
{
    [self.bannerView removeFromSuperview];
    
    [super removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Methods

- (void)commonInit
{
    
}

- (void)setVisible:(BOOL)visible
{
    _visible = visible;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
}

- (NSArray *)supportedBannerSizes
{
    return @[[NSValue valueWithCGSize:CGSizeMake(320, 50)],
             [NSValue valueWithCGSize:CGSizeMake(300, 50)],
             [NSValue valueWithCGSize:CGSizeMake(300, 250)],
             [NSValue valueWithCGSize:CGSizeMake(728, 90)],
             [NSValue valueWithCGSize:CGSizeMake(768, 1024)],
             [NSValue valueWithCGSize:CGSizeMake(320, 480)]];
}

- (BOOL)isSupportedSize:(CGSize)aSize
{
    NSArray *sizes = [self supportedBannerSizes];
    for(NSValue *size in sizes){
        if(CGSizeEqualToSize([size CGSizeValue], aSize)){
            return YES;
        }
    }
    return NO;
}

- (void)fetchAd
{
    SAAdManager *adLoader = [[SuperAwesome sharedManager] adManager];
    SAAdRequest *adRequest = [[SAAdRequest alloc] initWithPlacementId:self.placementID];
    [adLoader loadAd:adRequest completion:^(SAAdResponse *response, NSError *error) {
        
        if(error != nil || response == nil){
            [SKLogger error:@"SABannerView" withMessage:@"Failed to fetch ad"];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFailShowingAd:)]){
                [self.delegate didFailShowingAd:self];
            }
            return;
        }
        
        // go forward
        self.adResponse = response;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFetchNextAd:)]){
            [self.delegate didFetchNextAd:self];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self renderAd];
        });
        
    }];
}

- (void)renderAd
{
    NSString *html = [self.adResponse.creative toHTML];
    self.bannerView = [[SKMRAIDView alloc] initWithFrame:self.bounds withHtmlData:html withBaseURL:[NSURL URLWithString:@"http://superawesome.tv"] supportedFeatures:@[] delegate:self serviceDelegate:nil rootViewController:[self firstAvailableUIViewController]];
    self.bannerView.backgroundColor = self.backgroundColor;
    [self addSubview:self.bannerView];
    
    // show padlock only for not-is fallback
    if (!_adResponse.isFallback) {
        [self setupPadlockButton:_bannerView];
    }
}

- (void)sendImpressionEvent
{
    SAEventRequest *eventRequest = [[SAEventRequest alloc] initWithAdResponse:self.adResponse type:@"impression"];
    SAAdManager *adLoader = [[SuperAwesome sharedManager] adManager];
    [adLoader sendEvent:eventRequest completion:^(SAEventResponse *response, NSError *error) {
        
    }];
}

#pragma mark - SKMRAIDViewDelegate

- (void)mraidViewAdReady:(SKMRAIDView *)mraidView
{    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendImpressionEvent];
    });
}
- (void)mraidViewAdFailed:(SKMRAIDView *)mraidView
{
    [SKLogger error:@"SABannerView" withMessage:@"Failed to render ad"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailShowingAd:)]){
        [self.delegate didFailShowingAd:self];
    }
}
- (void)mraidViewWillExpand:(SKMRAIDView *)mraidView
{
    
}
- (void)mraidViewNavigate:(SKMRAIDView *)mraidView withURL:(NSURL *)url
{
    if([self isParentalGateEnabled]){
        if(self.gate == nil){
            self.gate = [[SAParentalGate alloc] init];
            self.gate.delegate = self;
        }
        [self.gate show];
        self.adURL = url;
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(willLeaveApplicationForAd:)]){
            [self.delegate willLeaveApplicationForAd:self];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
}

// This callback is to ask permission to resize an ad.
- (BOOL)mraidViewShouldResize:(SKMRAIDView *)mraidView toPosition:(CGRect)position allowOffscreen:(BOOL)allowOffscreen
{
    return YES;
}


#pragma mark SAParentalGateDelegate

- (void)didGetThroughParentalGate:(SAParentalGate *)parentalGate
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(willLeaveApplicationForAd:)]){
        [self.delegate willLeaveApplicationForAd:self];
    }
    [[UIApplication sharedApplication] openURL:self.adURL];
}

- (void) didCancelParentalGate:(SAParentalGate *)parentalGate {
    NSLog(@"Cancel");
}

@end
