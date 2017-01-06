//
//  SAUnityBannerAd.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else
#import "SuperAwesome.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#import "SAUnityCallback.h"

extern "C" {
    
    /**
     *  A dictionary that holds Unity banners
     */
    NSMutableDictionary *bannerDictionary = [@{} mutableCopy];
    
    /**
     *  Function that creates a new SABannerAd instance
     *
     *  @param unityName the name of the banner in unity
     */
    void SuperAwesomeUnitySABannerAdCreate (const char *unityName) {
        // get the key
        __block NSString *key = [NSString stringWithUTF8String:unityName];
        
        // create a new banner
        SABannerAd *banner = [[SABannerAd alloc] init];
        
        // set banner callback
        [banner setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendToUnity(key, placementId, @"adLoaded"); break;
                case adFailedToLoad: sendToUnity(key, placementId, @"adFailedToLoad"); break;
                case adShown: sendToUnity(key, placementId, @"adShown"); break;
                case adFailedToShow: sendToUnity(key, placementId, @"adFailedToShow"); break;
                case adClicked: sendToUnity(key, placementId, @"adClicked"); break;
                case adClosed: sendToUnity(key, placementId, @"adClosed"); break;
            }
        }];
        
        // save the banner
        [bannerDictionary setObject:banner forKey:key];
    }
    
    /**
     *  Function that loads an ad for a banner
     *
     *  @param unityName     the unique name of the banner in unity
     *  @param placementId   placement id to load the ad for
     *  @param configuration production = 0 / staging = 1
     *  @param test          true / false
     */
    void SuperAwesomeUnitySABannerAdLoad (const char *unityName, int placementId, int configuration, bool test) {
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            [banner setTestMode:test];
            [banner setConfiguration:getConfigurationFromInt(configuration)];
            [banner load:placementId];
            
        } else {
            // handle failure
        }
    }
    
    /**
     *  Function that checks wheter a banner has a loaded ad available or not
     *
     *  @param unityName the unique name of the banner in unity
     *
     *  @return true of false
     */
    bool SuperAwesomeUnitySABannerAdHasAdAvailable (const char *unityName) {
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            return [banner hasAdAvailable];
        }
        
        return false;
    }
    
    /**
     *  Function that plays a banner ad in unity
     *
     *  @param unityName             the unique name of the banner in unity
     *  @param isParentalGateEnabled true / false
     *  @param position              TOP = 0 / BOTTOM = 1
     *  @param size                  BANNER_320_50 = 0 / BANNER_300_50 = 1 / BANNER_728_90 = 2 / BANNER_300_250 = 3
     *  @param color                 true = transparent / false = gray
     */
    void SuperAwesomeUnitySABannerAdPlay (const char *unityName, bool isParentalGateEnabled, int position, int width, int height, bool color)
    {
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            
            // get the root vc
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            // calculate the size of the ad
            __block CGSize realSize = CGSizeMake(width, height);
            
            // get the screen size
            __block CGSize screen = [UIScreen mainScreen].bounds.size;
            
            if (realSize.width > screen.width) {
                realSize.height = (screen.width * realSize.height) / realSize.width;
                realSize.width = screen.width;
            }
            
            // calculate the position of the ad
            __block CGPoint realPos = position == 0 ?
            CGPointMake((screen.width - realSize.width) / 2.0f, 0) :
            CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
            
            // get banner
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            [banner setParentalGate:isParentalGateEnabled];
            [banner setColor:color];
            [root.view addSubview:banner];
            [banner resize:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
            
            // add a block notification
            [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:
             ^(NSNotification * note) {
                 screen = [UIScreen mainScreen].bounds.size;
                 
                 realSize = CGSizeMake(width, height);
                 
                 if (realSize.width > screen.width) {
                     realSize.height = (screen.width * realSize.height) / realSize.width;
                     realSize.width = screen.width;
                 }
                 
                 if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
                 else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
                 
                 [banner resize:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
             }];
            
            
            // finally play
            [banner play];
            
        } else {
            // handle failure
        }
    }
    
    /**
     *  Function that closes and removes a banner from view
     *
     *  @param unityName the unique name of the banner in unity
     */
    void SuperAwesomeUnitySABannerAdClose (const char *unityName) {
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            [banner close];
            [banner removeFromSuperview];
            [bannerDictionary removeObjectForKey:key];
        } else {
            // handle failure
        }
    }
}