//
//  DCTMessageBarNavigationItem.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 15.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarNavigationItem.h"

static void *DCTMessageBarNavigationItemContext = &DCTMessageBarNavigationItemContext;

extern const struct DCTMessageBarNavigationItemAttributes {
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *titleView;
	__unsafe_unretained NSString *prompt;
	__unsafe_unretained NSString *rightBarButtonItem;
	__unsafe_unretained NSString *rightBarButtonItems;
	__unsafe_unretained NSString *leftBarButtonItem;
	__unsafe_unretained NSString *leftBarButtonItems;
	__unsafe_unretained NSString *backBarButtonItem;
	__unsafe_unretained NSString *hidesBackButton;
} DCTMessageBarNavigationItemAttributes;

const struct DCTMessageBarNavigationItemAttributes DCTMessageBarNavigationItemAttributes = {
	.title = @"title",
	.titleView = @"titleView",
	.prompt = @"prompt",
	.rightBarButtonItem = @"rightBarButtonItem",
	.rightBarButtonItems = @"rightBarButtonItems",
	.leftBarButtonItem = @"leftBarButtonItem",
	.leftBarButtonItems = @"leftBarButtonItems",
	.backBarButtonItem = @"backBarButtonItem",
	.hidesBackButton = @"hidesBackButton"
};

@implementation DCTMessageBarNavigationItem

- (void)dealloc {
	self.childNavigationItem = nil;
}

- (instancetype)initWithChildNavigationItem:(UINavigationItem *)childNavigationItem {
	self = [super initWithTitle:childNavigationItem.title];
	if (!self) return nil;
	self.childNavigationItem = childNavigationItem;
	return self;
}

- (void)setChildNavigationItem:(UINavigationItem *)childNavigationItem {

	for (NSString *keyPath in [self keyPathsToObserve]) {
		[_childNavigationItem removeObserver:self forKeyPath:keyPath context:DCTMessageBarNavigationItemContext];
	}

	_childNavigationItem = childNavigationItem;
	self.title = childNavigationItem.title;
	self.titleView = childNavigationItem.titleView;
	self.prompt = childNavigationItem.prompt;
	self.rightBarButtonItem = childNavigationItem.rightBarButtonItem;
	self.rightBarButtonItems = childNavigationItem.rightBarButtonItems;
	self.leftBarButtonItem = childNavigationItem.leftBarButtonItem;
	self.leftBarButtonItems = childNavigationItem.leftBarButtonItems;
	self.backBarButtonItem = childNavigationItem.backBarButtonItem;
	self.hidesBackButton = childNavigationItem.hidesBackButton;

	for (NSString *keyPath in [self keyPathsToObserve]) {
		[_childNavigationItem addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:DCTMessageBarNavigationItemContext];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {

	if (context != DCTMessageBarNavigationItemContext) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}

	id value = [self.childNavigationItem valueForKeyPath:keyPath];
	NSLog(@"%@:%@ %@ %@", self, NSStringFromSelector(_cmd), keyPath, value);
	[self setValue:value forKeyPath:keyPath];
}

- (NSArray *)keyPathsToObserve {
	return @[
		DCTMessageBarNavigationItemAttributes.title,
		DCTMessageBarNavigationItemAttributes.titleView,
		DCTMessageBarNavigationItemAttributes.prompt,
		DCTMessageBarNavigationItemAttributes.rightBarButtonItem,
		DCTMessageBarNavigationItemAttributes.rightBarButtonItems,
		DCTMessageBarNavigationItemAttributes.leftBarButtonItem,
		DCTMessageBarNavigationItemAttributes.leftBarButtonItems,
		DCTMessageBarNavigationItemAttributes.backBarButtonItem,
		DCTMessageBarNavigationItemAttributes.hidesBackButton
	];
}

@end
