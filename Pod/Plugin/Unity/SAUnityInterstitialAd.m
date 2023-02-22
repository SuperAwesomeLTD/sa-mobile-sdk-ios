/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAUnityCallback.h"
#import <SuperAwesome/SuperAwesome-Swift.h>
#import "SAUnityCallback.h"

/**
 * Native method called from Unity.
 * Method that adds a callback to the SAInterstitialAd static method class
 */
void SuperAwesomeUnitySAInterstitialAdCreate () {
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case SAEventAdLoaded: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adLoaded"); break;
            case SAEventAdEmpty: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adEmpty"); break;
            case SAEventAdFailedToLoad: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adFailedToLoad"); break;
            case SAEventAdAlreadyLoaded: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adAlreadyLoaded"); break;
            case SAEventAdShown: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adShown"); break;
            case SAEventAdFailedToShow: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adFailedToShow"); break;
            case SAEventAdClicked: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adClicked"); break;
            case SAEventAdEnded: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adEnded"); break;
            case SAEventAdClosed: unitySendAdCallback(@"SAInterstitialAd", placementId, @"adClosed"); break;
        }
    }];
}

/**
 * Native method called from Unity.
 * Load an interstitial ad
 *
 * @param placementId   the placement id to try to load an ad for
 * @param configuration production = 0 / staging = 1
 * @param test          true / false
 * @param encodedOptions a json encoded dictionary of options to send with requests
 */
void SuperAwesomeUnitySAInterstitialAdLoad (int placementId, int configuration, bool test, const char *encodedOptions) {

    [SAInterstitialAd setTestMode:test];

    if(encodedOptions) {

        NSString *options = [NSString stringWithUTF8String:encodedOptions];
        NSData *jsonData = [options dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *optionsData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

        if (error || [options length] == 0) {
            // Fallback to loading without options
            [SAInterstitialAd load: placementId];
        } else {
            [SAInterstitialAd load: placementId options: optionsData];
        }

    } else {
        [SAInterstitialAd load: placementId];
    }
}

/**
 * Native method called from Unity.
 * Check to see if there's an ad available
 *
 * @return true / false
 */
bool SuperAwesomeUnitySAInterstitialAdHasAdAvailable(int placementId) {
    return [SAInterstitialAd hasAdAvailable: placementId];
}

/**
 * Native method called from Unity.
 * Play an interstitial ad
 *
 * @param isParentalGateEnabled true / false
 * @param isBumperPageEnabled   true / false
 * @param orientation           ANY = 0 / PORTRAIT = 1 / LANDSCAPE = 2
 */
void SuperAwesomeUnitySAInterstitialAdPlay (int placementId, bool isParentalGateEnabled, bool isBumperPageEnabled, int orientation) {
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAInterstitialAd setParentalGate:isParentalGateEnabled];
    [SAInterstitialAd setBumperPage:isBumperPageEnabled];
    [SAInterstitialAd setOrientation:[OrientationHelper from: orientation]];
    [SAInterstitialAd play: placementId fromVC: root];
}

/**
 * Native method called from Unity.
 * Apply Settings
 */
void SuperAwesomeUnitySAInterstitialAdApplySettings (bool isParentalGateEnabled, bool isBumperPageEnabled,
                                                     int orientation, bool isTestingEnabled) {
    [SAInterstitialAd setParentalGate:isParentalGateEnabled];
    [SAInterstitialAd setBumperPage:isBumperPageEnabled];
    [SAInterstitialAd setOrientation:[OrientationHelper from: orientation]];
    [SAInterstitialAd setTestMode:isTestingEnabled];
}
