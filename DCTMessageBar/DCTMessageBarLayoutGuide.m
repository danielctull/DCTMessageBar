
#import "DCTMessageBarLayoutGuide.h"

@implementation DCTMessageBarLayoutGuide
@synthesize length = _length;
@synthesize topAnchor = _topAnchor;
@synthesize bottomAnchor = _bottomAnchor;
@synthesize heightAnchor = _heightAnchor;

- (instancetype)initWithLength:(CGFloat)length {
	self = [super init];
	if (!self) return nil;
	_length = length;
	return self;
}

@end
