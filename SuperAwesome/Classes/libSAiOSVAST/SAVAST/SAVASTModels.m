//
//  SAVAST Model Space
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

#import "SAVASTModels.h"

////////////////////////////////////////////////////////////////////////////////
// SAGenericVAST

@implementation SAGenericVAST

- (void) print {
    // do nothing
}

@end

////////////////////////////////////////////////////////////////////////////////
// SAAd

@implementation SAVASTAd

- (void) print {
    if (_type == 0) NSLog(@"\tType: InLine Ad(%@)", __id);
    if (_type == 1) NSLog(@"\tType: Wrapper Ad(%@)", __id);
    NSLog(@"\tSequence: %@", _sequence);
    NSLog(@"\tImpressions[%ld]", (long)_Impressions.count);
    NSLog(@"\tErrors[%ld]", (long)_Errors.count);
    NSLog(@"\tCreatives[%ld]", (long)_Creatives.count);
    for (SAVASTCreative *c in _Creatives) {
        [c print];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
// SAAd

@implementation SAImpression
@end

////////////////////////////////////////////////////////////////////////////////
// SACreative
//  SALinearCreative
//  SANonLinearCreative
//  SACompanionAdsCreative

@implementation SAVASTCreative
@end

@implementation SALinearCreative

- (void) print {
    if (super.type == Linear) NSLog(@"\t\tType: Linear Creative(%@)", __id);
    if (super.type == NonLinear) NSLog(@"\t\tType: NonLinear Creative(%@)", __id);
    if (super.type == CompanionAds) NSLog(@"\t\tType: CompanionAds Creative(%@)", __id);
    NSLog(@"\t\tSequence: %@", _sequence);
    NSLog(@"\t\tDuration: %@", _Duration);
    NSLog(@"\t\tplayable: %@", _playableMediaURL);
    if (_ClickThrough) NSLog(@"\t\tClickThrough: OK %@", _ClickThrough);
    else NSLog(@"\t\tClickThrough: NOK");
    NSLog(@"\t\tClickTracking[%ld]", (long)_ClickTracking.count);
    NSLog(@"\t\tCustomClicks[%ld]", (long)_CustomClicks.count);
    NSLog(@"\t\tTracking[%ld]", (long)_TrackingEvents.count);
    NSLog(@"\t\tMediaFiles[%ld]", (long)_MediaFiles.count);
}

@end

@implementation SANonLinearCreative

- (void) print {
    NSLog(@"\t\tNonLinear Creative not implemented");
}

@end

@implementation SACompanionAdsCreative

- (void) print {
    NSLog(@"\t\tCompanionAds Creative not implemented");
}

@end

////////////////////////////////////////////////////////////////////////////////
// SAMediaFile

@implementation SAMediaFile

- (void) print {
    NSLog(@"\t\tMediaFile [%@x%@] %@", _width, _height, _URL);
}

@end

////////////////////////////////////////////////////////////////////////////////
// SATracking

@implementation SATracking

- (void) print {
    NSLog(@"\t\tTracking [%@] %@", _event, _URL);
}

@end