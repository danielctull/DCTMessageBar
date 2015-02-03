
#import "DCTMessageBarLayoutGuide.h"

@implementation DCTMessageBarLayoutGuide
@synthesize length = _length;

- (instancetype)initWithLength:(CGFloat)length {
	self = [super init];
	if (!self) return nil;
	_length = length;
	return self;
}

@end
