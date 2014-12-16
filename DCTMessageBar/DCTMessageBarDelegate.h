//
//  DCTMessageBarDelegate.h
//  DCTMessageBar
//
//  Created by Daniel Tull on 28/09/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import Foundation;
@class DCTMessageBar;

@protocol DCTMessageBarDelegate <NSObject>

- (BOOL)messageBarShouldBecomeActive:(DCTMessageBar *)messageBar;
- (void)messageBarNeedsHeightUpdate:(DCTMessageBar *)messageBar;
- (void)messageBarSendButtonTapped:(DCTMessageBar *)messageBar;
- (void)messageBar:(DCTMessageBar *)messageBar didChangeText:(NSString *)text;

@end
