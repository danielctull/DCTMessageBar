
#import "DCTMessageBarKeyboardObserver.h"

@implementation DCTMessageBarKeyboardObserver

// Start observing as soon as the app is launched.
+ (void)load {
	[self sharedKeyboardObserver];
}

+ (instancetype)sharedKeyboardObserver {
	static DCTMessageBarKeyboardObserver *sharedKeyboardObserver;
	static dispatch_once_t sharedKeyboardObserverToken;
	dispatch_once(&sharedKeyboardObserverToken, ^{
		sharedKeyboardObserver = [self new];
	});
	return sharedKeyboardObserver;
}

- (instancetype)init {
	self = [super init];
	if (!self) return nil;

	_keyboardFrame = CGRectNull;

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self
						   selector:@selector(keyboardWillChangeFrameNotification:)
							   name:UIKeyboardWillChangeFrameNotification
							 object:nil];

	return self;
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
	NSDictionary *userInfo = notification.userInfo;
	NSValue *frameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
	self.keyboardFrame = [frameValue CGRectValue];
}

@end
