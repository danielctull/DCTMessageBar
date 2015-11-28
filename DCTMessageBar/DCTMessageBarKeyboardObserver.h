
@import UIKit;

@interface DCTMessageBarKeyboardObserver : NSObject

+ (instancetype)sharedKeyboardObserver;
@property (nonatomic) CGRect keyboardFrame;

@end
