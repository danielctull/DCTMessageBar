//
//  IntrinsicTextView.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarTextView.h"
#import "DCTMessageBar.h"

@interface DCTMessageBarTextView () <UITextViewDelegate>
@property (nonatomic) UIView *debug;
@end

@implementation DCTMessageBarTextView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {

	NSInteger oldPreferredMaxLayoutWidth = _preferredMaxLayoutWidth + 0.5f;
	NSInteger newPreferredMaxLayoutWidth = preferredMaxLayoutWidth + 0.5f;
	if (oldPreferredMaxLayoutWidth == newPreferredMaxLayoutWidth) {
		return;
	}

	_preferredMaxLayoutWidth = preferredMaxLayoutWidth;
	[self invalidateIntrinsicContentSize];
}

- (void)setText:(NSString *)text {
	[super setText:text];
	[self invalidateIntrinsicContentSize];
}


- (CGSize)intrinsicContentSize {
	CGSize max = CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX);
	return [self sizeThatFits:max];
}

- (UIView *)debug {

	if (!DCTMessageBarDebug) {
		return nil;
	}

	if (!_debug) {
		_debug = [UIView new];
		_debug.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.8f];
		[self addSubview:self.debug];
	}

	return _debug;
}

- (CGRect)visibleRect {
	UIEdgeInsets insets = UIEdgeInsetsMake(self.contentInset.top + self.textContainerInset.top,
										   self.contentInset.left + self.textContainerInset.left,
										   self.contentInset.bottom + self.textContainerInset.bottom,
										   self.contentInset.right + self.textContainerInset.right);
	CGRect visibleRect = UIEdgeInsetsInsetRect(self.bounds, insets);
	return visibleRect;
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {

	self.delegate = self;

	if (CGRectContainsRect(self.visibleRect, rect)) {
		return;
	}

	UITextPosition *position = self.selectedTextRange.end;
	CGRect caretRect = [self caretRectForPosition:position];

	[super scrollRectToVisible:caretRect animated:NO];
}

//- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
//
//	self.delegate = self;
//
//	NSInteger contentHeight = self.contentSize.height + 0.5f;
//	NSInteger frameHeight = self.frame.size.height + 0.5f;
//
//	if (contentHeight == frameHeight) {
//
//		contentOffset.y = 0.0f;
//
//	} else {
//
//		UITextPosition *position = self.selectedTextRange.end;
//		CGRect rect = [self caretRectForPosition:position];
//		rect.size.height += self.textContainerInset.bottom;
//		
//		CGFloat caretBottom = CGRectGetMaxY(rect);
//		CGFloat height = CGRectGetHeight(self.bounds);
//		NSLog(@"%@ %@", @(caretBottom), @(height));
//
//		contentOffset.y = floorf(caretBottom - height);
//	}
//
//	NSLog(@"setContentOffset: %f", contentOffset.y);
//	[super setContentOffset:contentOffset animated:NO];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"did scroll contentOffset: %f", self.contentOffset.y);
}

@end
