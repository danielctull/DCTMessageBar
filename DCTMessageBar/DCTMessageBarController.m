//
//  DCTMessageBarController.m
//  DCTMessageBar
//
//  Created by Daniel Tull on 14.11.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTMessageBarController.h"
#import "DCTMessageBarControllerDelegate.h"
#import "DCTMessageBar.h"
#import "DCTMessageBarSetBottomLayoutGuide.h"
#import "DCTMessageBarLayoutGuide.h"

@interface DCTMessageBarController () <DCTMessageBarDelegate>
@property (nonatomic, readwrite) UIViewController *viewController;
@property (nonatomic) NSLayoutConstraint *bottomMarginConstraint;
@end

@implementation DCTMessageBarController

#pragma mark - Initialization

- (void)dealloc {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)sharedInit {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;
	[self sharedInit];
	return self;
}

- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
	self = [super initWithNibName:name bundle:bundle];
	if (!self) return nil;
	[self sharedInit];	
	return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
	self = [self initWithNibName:nil bundle:nil];
	if (!self) return nil;
	_viewController = viewController;
	return self;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	self.viewController = segue.destinationViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *view = self.viewController.view;
	if (!view.superview) {
		view.frame = self.view.bounds;
		view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self.view insertSubview:view belowSubview:self.messageBar];
	}

	if (!self.messageBar) {
		self.messageBar = [DCTMessageBar new];
		self.messageBar.delegate = self;
		self.messageBar.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:self.messageBar];

		NSLayoutConstraint *leftMarginConstraint = [NSLayoutConstraint constraintWithItem:self.view
																				attribute:NSLayoutAttributeLeading
																				relatedBy:NSLayoutRelationEqual
																				   toItem:self.messageBar
																				attribute:NSLayoutAttributeLeading
																			   multiplier:1.0f
																				 constant:0.0f];

		NSLayoutConstraint *rightMarginConstraint = [NSLayoutConstraint constraintWithItem:self.view
																				 attribute:NSLayoutAttributeTrailing
																				 relatedBy:NSLayoutRelationEqual
																					toItem:self.messageBar
																				 attribute:NSLayoutAttributeTrailing
																				multiplier:1.0f
																				  constant:0.0f];

		self.bottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.view
																   attribute:NSLayoutAttributeBottom
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.messageBar
																   attribute:NSLayoutAttributeBottom
																  multiplier:1.0f
																	constant:0.0f];

		[self.view addConstraints:@[leftMarginConstraint, rightMarginConstraint, self.bottomMarginConstraint]];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	CGFloat length = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.messageBar.frame);
	DCTMessageBarLayoutGuide *guide = [[DCTMessageBarLayoutGuide alloc] initWithLength:length];
	[self sendBottomLayoutGuideToChildViewControllers:guide];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
	CGFloat third = viewHeight / 3.0f;

	CGFloat top = self.topLayoutGuide.length;
	CGFloat bottom = self.bottomMarginConstraint.constant;

	if (top > 0) top--; // This is likely a nav bar, so just tuck under to not have a double-width border line.

	CGFloat space = viewHeight - top - bottom;
	self.messageBar.maximumHeight = MIN(third, space);
}

#pragma mark - DCTMessageBarController

- (void)updateHeight {

	CGSize currentSize = self.view.frame.size;
	CGSize targetSize = CGSizeMake(currentSize.width, 0);
	[self.messageBar systemLayoutSizeFittingSize:targetSize];

	[UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:0 animations:^{
		[self.messageBar layoutIfNeeded];

		CGFloat length = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.messageBar.frame);
		DCTMessageBarLayoutGuide *guide = [[DCTMessageBarLayoutGuide alloc] initWithLength:length];
		[self sendBottomLayoutGuideToChildViewControllers:guide];
	} completion:nil];
}

- (void)sendBottomLayoutGuideToChildViewControllers:(id<UILayoutSupport>)guide {
	for (UIViewController *viewController in self.childViewControllers) {
		if ([viewController conformsToProtocol:@protocol(DCTMessageBarSetBottomLayoutGuide)]) {
			id<DCTMessageBarSetBottomLayoutGuide> guideViewController = (id<DCTMessageBarSetBottomLayoutGuide>)viewController;
			[guideViewController setBottomLayoutGuide:guide];
		}
	}
}

#pragma mark - UIKeyboard Notifications

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {

	if (!self.messageBar.textView.isFirstResponder) {
		return;
	}

	NSDictionary *userInfo = notification.userInfo;
	CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];

	CGFloat keyboardMinY = CGRectGetMinY(keyboardEndFrame);
	CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
	CGFloat value = viewHeight - keyboardMinY;

	if (value < 0) value = 0;
	self.bottomMarginConstraint.constant = value;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[self.messageBar layoutIfNeeded];
	[UIView commitAnimations];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {

	if (!self.messageBar.textView.isFirstResponder) {
		return;
	}

	CGFloat length = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.messageBar.frame);
	DCTMessageBarLayoutGuide *guide = [[DCTMessageBarLayoutGuide alloc] initWithLength:length];
	[self sendBottomLayoutGuideToChildViewControllers:guide];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {

	if (!self.messageBar.textView.isFirstResponder) {
		return;
	}

	CGFloat length = CGRectGetHeight(self.messageBar.bounds);
	DCTMessageBarLayoutGuide *guide = [[DCTMessageBarLayoutGuide alloc] initWithLength:length];
	[self sendBottomLayoutGuideToChildViewControllers:guide];
}

#pragma mark - DCTMessageBarDelegate

- (BOOL)messageBarShouldBecomeActive:(DCTMessageBar *)messageBar {

	if ([self.delegate respondsToSelector:@selector(messageBarControllerShouldBecomeActive:)]) {
		return [self.delegate messageBarControllerShouldBecomeActive:self];
	}

	return YES;
}

- (void)messageBarNeedsHeightUpdate:(DCTMessageBar *)messageBar {
	[self updateHeight];
}

- (void)messageBar:(DCTMessageBar *)messageBar didChangeText:(NSString *)text {
	if ([self.delegate respondsToSelector:@selector(messageBarController:didChangeText:)]) {
		[self.delegate messageBarController:self didChangeText:text];
	}
}

- (void)messageBarSendButtonTapped:(DCTMessageBar *)messageBar {
	if ([self.delegate respondsToSelector:@selector(messageBarControllerSendButtonTapped:)]) {
		[self.delegate messageBarControllerSendButtonTapped:self];
	}
}

#pragma mark - UIViewController Containment

- (UIViewController *)childViewControllerForStatusBarStyle {
	return self.viewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
	return self.viewController;
}

- (BOOL)shouldAutorotate {
	return self.viewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
	return self.viewController.supportedInterfaceOrientations;
}

@end
