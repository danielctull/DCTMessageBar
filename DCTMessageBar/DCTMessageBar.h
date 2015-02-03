//
//  CommentBar.h
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
#import "DCTMessageBarDelegate.h"
#import "DCTMessageBarController.h"
#import "DCTMessageBarControllerDelegate.h"
#import "UIViewController+DCTMessageBarController.h"
#import "DCTMessageBarNavigationItem.h"
#import "DCTMessageBarSetBottomLayoutGuide.h"

extern const BOOL DCTMessageBarDebug;
extern const CGFloat DCTMessageBarNoMaximumHeight;

//! Project version number and string for DCTMessageBar.
FOUNDATION_EXPORT double DCTMessageBarVersionNumber;
FOUNDATION_EXPORT const unsigned char DCTMessageBarVersionString[];

@interface DCTMessageBar : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, weak) IBOutlet id<DCTMessageBarDelegate> delegate;

@property (nonatomic, readonly) UITextView *textView;

@property (nonatomic) CGFloat maximumHeight;

@property (nonatomic) BOOL enabled;

@end
