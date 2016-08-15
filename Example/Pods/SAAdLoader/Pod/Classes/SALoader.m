//
//  SALoader.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header
#import "SALoader.h"

// import other headers
#import "SAParser.h"
#import "SAHTMLParser.h"
#import "SAVASTParser.h"

// import model headers
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

// import SA main Singleton
#import "SASession.h"
#import "SANetwork.h"

// import Aux class
#import "SAUtils.h"

@interface SALoader ()
@end

@implementation SALoader

- (void) loadAdForPlacementId:(NSInteger)placementId {
    
    // First thing to do is format the AA URL to get an ad, based on specs
    NSString *endpoint = [NSString stringWithFormat:@"%@/ad/%ld", [[SASession getInstance] getBaseUrl], (long)placementId];
    
    NSString *lang = @"none";
    NSArray *languages = [NSLocale preferredLanguages];
    if ([languages count] > 0) {
        lang = [[languages firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];;
    }
    
    NSString *userAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"UA1 %@", userAgent);
    NSLog(@"UA2 %@", [SAUtils getUserAgent]);
    
    // form the query
    NSDictionary *query = @{@"test": @([[SASession getInstance] isTestEnabled]),
                            @"sdkVersion":[[SASession getInstance] getVersion],
                            @"rnd":@([SAUtils getCachebuster]),
                            @"ct":@([SAUtils getNetworkConnectivity]),
                            @"bundle":[[NSBundle mainBundle] bundleIdentifier],
                            @"name":[SAUtils encodeURI:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]],
                            @"dauid":@([[SASession getInstance] getDauId]),
                            @"lang": lang,
                            @"device": ([SAUtils getSystemSize] == size_mobile ? @"mobile" : @"tablet")
                            };
    
    // form the header
    NSDictionary *header = @{@"Content-Type":@"application/json",
                             @"User-Agent":[SAUtils getUserAgent]};
    
    SANetwork *network = [[SANetwork alloc] init];
    [network sendGET:endpoint
           withQuery:query
           andHeader:header
        withResponse:^(NSInteger status, NSString *payload, BOOL success) {
               if (!success) {
                   if (_delegate != NULL && [_delegate respondsToSelector:@selector(didFailToLoadAdForPlacementId:)]) {
                       [_delegate didFailToLoadAdForPlacementId:placementId];
                   }
               } else {
                   // create parser & extra
                   SAParser *parser = [[SAParser alloc] init];
                   __block SAAd *parsedAd = [parser parseInitialAdFromNetwork:payload withPlacementId:placementId];
                   
                   if (!parsedAd) {
                       if (_delegate != NULL && [_delegate respondsToSelector:@selector(didFailToLoadAdForPlacementId:)]){
                           [_delegate didFailToLoadAdForPlacementId:placementId];
                       }
                   }
                   // and get extra data
                   else {
                       
                       parsedAd.creative.details.data = [[SAData alloc] init];
                       SACreativeFormat type = parsedAd.creative.creativeFormat;
                       
                       switch (type) {
                               // parse video
                           case video: {
                               SAVASTParser *vastParser = [[SAVASTParser alloc] init];
                               [vastParser parseVASTURL:parsedAd.creative.details.vast done:^(SAVASTAd *ad) {
                                   
                                   if (ad) {
                                       parsedAd.creative.details.data.vastAd = ad;
                                       if (_delegate != NULL && [_delegate respondsToSelector:@selector(didLoadAd:)]) {
                                           [_delegate didLoadAd:parsedAd];
                                       }
                                   } else {
                                       [_delegate didFailToLoadAdForPlacementId:parsedAd.placementId];
                                   }
                               }];
                               break;
                           }
                               // parse HTML data
                           case image:
                           case rich:
                           case tag:
                           case invalid: {
                               parsedAd.creative.details.data.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:parsedAd];
                               if (_delegate != NULL && [_delegate respondsToSelector:@selector(didLoadAd:)]) {
                                   [_delegate didLoadAd:parsedAd];
                               }
                               break;
                           }
                       }
                   }
               }
           }];
}

@end
