//
//  DCTMessageBarControllerDelegate.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@class DCTMessageBarController;

@protocol DCTMessageBarControllerDelegate <NSObject>

@optional
- (BOOL)messageBarControllerShouldBecomeActive:(DCTMessageBarController *)messageBarController;
- (void)messageBarControllerSendButtonTapped:(DCTMessageBarController *)messageBarController;
- (void)messageBarController:(DCTMessageBarController *)messageBarController didChangeText:(NSString *)text;

@end
