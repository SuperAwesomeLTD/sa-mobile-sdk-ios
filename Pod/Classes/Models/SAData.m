//
//  SAData.m
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

#import "SAData.h"

@implementation SAData

- (NSString*) print {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"\n\t\t Ad Data:"];
    [result appendFormat:@"\n\t\t\t HTML: %@", _adHTML];
    [result appendFormat:@"\n\t\t\t ImagePath: %@", _imagePath];
    [result appendFormat:@"\n\t\t\t vastAds: %ld", (long)[_vastAds count]];
    return result;
}

@end
