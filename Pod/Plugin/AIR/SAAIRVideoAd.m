//
//  SAAIRVideoAd.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#include "SAAIRVideoAd.h"

#import "SAAIRCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
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

FREObject SuperAwesomeAIRSAVideoAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // native video code
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adClicked"); break;
            case adClosed:          sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adClosed"); break;
        }
    }];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAVideoAdLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsInt32(argv[1], &configuration);
    FREGetObjectAsBool(argv[2], &test);
    
    // configure & load
    [SAVideoAd setTestMode:test];
    [SAVideoAd setConfiguration: getConfigurationFromInt(configuration)];
    [SAVideoAd load:placementId];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAVideoAdHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    
    uint32_t hasAdAvailable = [SAVideoAd hasAdAvailable:placementId];
    
    FREObject boolToReturn = nil;
    FRENewObjectFromBool(hasAdAvailable, &boolToReturn);
    
    return boolToReturn;
    
}

FREObject SuperAwesomeAIRSAVideoAdPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    uint32_t isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    uint32_t shouldShowCloseButton = SA_DEFAULT_CLOSEBUTTON;
    uint32_t shouldShowSmallClickButton = SA_DEFAULT_SMALLCLICK;
    uint32_t shouldAutomaticallyCloseAtEnd = SA_DEFAULT_CLOSEATEND;
    int orientation = SA_DEFAULT_ORIENTATION;
    uint32_t isBackButtonEnabled = SA_DEFAULT_BACKBUTTON;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsBool(argv[2], &shouldShowCloseButton);
    FREGetObjectAsBool(argv[3], &shouldShowSmallClickButton);
    FREGetObjectAsBool(argv[4], &shouldAutomaticallyCloseAtEnd);
    FREGetObjectAsInt32(argv[5], &orientation);
    FREGetObjectAsBool(argv[6], &isBackButtonEnabled);
    
    [SAVideoAd setParentalGate:isParentalGateEnabled];
    [SAVideoAd setCloseButton:shouldShowCloseButton];
    [SAVideoAd setSmallClick:shouldShowSmallClickButton];
    [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
    [SAVideoAd setOrientation:getOrientationFromInt(orientation)];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAVideoAd play: placementId fromVC: root];
    
    return NULL;
}