//
//  ViewController.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 01/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SALoginViewController.h"

@interface ViewController : UIViewController <SALoginViewControllerDelegate>

- (IBAction)openLogin:(id)sender;

@end
