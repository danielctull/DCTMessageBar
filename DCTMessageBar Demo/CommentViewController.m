//
//  CommentViewController.m
//  Commenting
//
//  Created by Daniel Tull on 13.09.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CommentViewController.h"
@import DCTMessageBar;

@interface CommentViewController () <DCTMessageBarControllerDelegate>
@property (nonatomic) NSMutableArray *messages;
@end

@implementation CommentViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	self.messages = [NSMutableArray new];
	self.dct_messageBarController.delegate = self;
	self.dct_messageBarController.messageBar.placeholder = @"Post message";
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	UIEdgeInsets insets = self.tableView.contentInset;
	insets.top = self.topLayoutGuide.length;
	self.tableView.contentInset = insets;

	insets = self.tableView.scrollIndicatorInsets;
	insets.top = self.topLayoutGuide.length;
	self.tableView.scrollIndicatorInsets = insets;
}

- (void)addMessage:(NSString *)messages {
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.messages.count inSection:0];
	[self.messages addObject:messages];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateMaximumHeightForSize:self.view.bounds.size];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	[self updateMaximumHeightForSize:size];
}

- (void)updateMaximumHeightForSize:(CGSize)size {
	self.dct_messageBarController.messageBar.maximumHeight = floorf(size.height / 3.0f);
}

#pragma mark - DCTMessageBarControllerDelegate

- (void)messageBarControllerSendButtonTapped:(DCTMessageBarController *)messageBarController {
	[self addMessage:messageBarController.messageBar.text];
	messageBarController.messageBar.text = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = self.messages[indexPath.row];
	return cell;
}

@end
