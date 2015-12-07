//
//  SAFormatter.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

// import header
#import "SAHTMLParser.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import juciy aux functions
#import "SAAux.h"

// import SA class
#import "SuperAwesome.h"

@implementation SAHTMLParser

+ (NSString*) formatCreativeDataIntoAdHTML:(SAAd*)ad {
    
    switch (ad.creative.format) {
        case image:{
            return [self formatCreativeIntoImageHTML:ad];
            break;
        }
        case video:{
            return nil;
            break;
        }
        case rich:{
            return [self formatCreativeIntoRichMediaHTML:ad];
            break;
        }
        case tag:{
            return [self formatCreativeIntoTagHTML:ad];
            break;
        }
        default:{
            return nil;
            break;
        }
    }
}

+ (NSString*) formatCreativeIntoImageHTML:(SAAd*)ad {
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayImage" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"imageURL" withString:ad.creative.details.image];
    return htmlString;
}

+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*)ad {
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayRichMedia" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *richMediaString = [[NSMutableString alloc] init];
    [richMediaString appendString:ad.creative.details.url];
    
    NSDictionary *richMediaDict = @{
        @"placement":[NSNumber numberWithInteger:ad.placementId],
        @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
        @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
        @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
        @"rnd":[NSNumber numberWithInteger:[SAAux getCachebuster]]
    };
    [richMediaString appendString:@"?"];
    [richMediaString appendString:[SAAux formGetQueryFromDict:richMediaDict]];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"richMediaURL" withString:richMediaString];
    
    // return HTML string
    return htmlString;
}

+ (NSString*) formatCreativeIntoTagHTML:(SAAd*)ad {
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayTag" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    
    // correct some tag issues
    NSString *tagString = ad.creative.details.tag;
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click]" withString:[NSString stringWithFormat:@"%@&redir=",ad.creative.trackingURL]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click_enc]" withString:[SAAux encodeURI:ad.creative.trackingURL]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[keywords]" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[timestamp]" withString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"tagdata" withString:tagString];
    return htmlString;
}

@end
