#import <UIKit/_UIBackdropEffectView.h>
#import <UIKit/_UIBackdropView.h>
#import <UIKit/_UIBackdropViewSettingsAdaptiveLight.h>
#import <UIKit/_UIModalItemAlertBackgroundView.h>
#import <UIKit/_UIModalItemAlertContentView.h>
#import <UIKit/_UIModalItemTableViewCell.h>
#import <UIKit/UIImage+Private.h>

/*
NSBundle *bundle;

static const char *kHBWLTriangleBackdropViewIdentifier;
static const char *kHBWLAssistantViewIdentifier;

#pragma mark - Force vertical layout

%hook _UIModalItem

- (BOOL)forceVerticalLayout {
	return YES;
}

%end

#pragma mark - Speech bubble and assistant

%hook _UIModalItemAlertBackgroundView

- (id)initWithFrame:(CGRect)frame {
	self = %orig;

	if (self) {
		_UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(self, "_effectView");

		_UIBackdropViewSettingsAdaptiveLight *settings = [[[%c(_UIBackdropViewSettingsAdaptiveLight) alloc] initWithDefaultValues] autorelease];
		settings.colorTint = [UIColor colorWithRed:1 green:1 blue:0.5f alpha:1];
		[backdropView transitionToSettings:settings];

		_UIBackdropViewSettingsAdaptiveLight *settings2 = [[[%c(_UIBackdropViewSettingsAdaptiveLight) alloc] initWithDefaultValues] autorelease];
		settings2.colorTint = [UIColor colorWithRed:1 green:1 blue:0.5f alpha:1];
		[backdropView transitionToSettings:settings2];

		_UIBackdropView *triangleBackdropView = [[%c(_UIBackdropView) alloc] initWithFrame:CGRectMake(0, 0, 16.f, 24.f) autosizesToFitSuperview:NO settings:settings2];

		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint:CGPointZero];
		[bezierPath addLineToPoint:CGPointMake(triangleBackdropView.frame.size.width, triangleBackdropView.frame.size.height)];
		[bezierPath addLineToPoint:CGPointMake(triangleBackdropView.frame.size.width, 0)];
		[bezierPath closePath];
		[[UIColor blackColor] setFill];
		[bezierPath fill];

		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		shapeLayer.frame = triangleBackdropView.bounds;
		shapeLayer.path = bezierPath.CGPath;

		triangleBackdropView.backdropEffectView.layer.mask = shapeLayer;
		[self addSubview:triangleBackdropView];

		objc_setAssociatedObject(self, &kHBWLTriangleBackdropViewIdentifier, triangleBackdropView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

		UIImageView *assistantView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clippit" inBundle:bundle]];
		[self addSubview:assistantView];

		objc_setAssociatedObject(self, &kHBWLAssistantViewIdentifier, assistantView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return self;
}

- (void)layoutSubviews {
	%orig;

	UIView *triangleBackdropView = objc_getAssociatedObject(self, &kHBWLTriangleBackdropViewIdentifier);
	CGRect triangleFrame = triangleBackdropView.frame;
	triangleFrame.origin.x = self.frame.size.width / 3;
	triangleFrame.origin.y = self.frame.size.height;
	triangleBackdropView.frame = triangleFrame;

	UIView *assistantView = objc_getAssociatedObject(self, &kHBWLAssistantViewIdentifier);
	CGRect assistantFrame = assistantView.frame;
	assistantFrame.origin.x = triangleFrame.origin.x + 10.f;
	assistantFrame.origin.y = self.frame.size.height + 10.f;
	assistantView.frame = assistantFrame;
}

- (void)dealloc {
	[objc_getAssociatedObject(self, &kHBWLTriangleBackdropViewIdentifier) release];
	[objc_getAssociatedObject(self, &kHBWLAssistantViewIdentifier) release];

	%orig;
}

%end

#pragma mark - Left alignment

%hook _UIModalItemAlertContentView

- (void)_prepareViewIfNeeded {
	BOOL alertViewIsSetup = MSHookIvar<BOOL>(self, "_alertViewIsSetup");
	%orig;

	if (alertViewIsSetup) {
		return;
	}

	self.titleLabel.textAlignment = NSTextAlignmentLeft;
	self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
	self.messageLabel.textAlignment = NSTextAlignmentLeft;

	UIView *tableViewTopSeparator = MSHookIvar<UIView *>(self, "_tableViewTopSeparator");
	tableViewTopSeparator.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = %orig;
	cell.selectedBackgroundView.backgroundColor = [cell.selectedBackgroundView.backgroundColor colorWithAlphaComponent:0.5f];
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	%orig;
	cell.textLabel.textAlignment = NSTextAlignmentLeft;
}

%end

#pragma mark - Disable separators

%hook _UIModalItemTableViewCell

- (void)setShowFullWidthSeparator:(BOOL)showFullWidthSeparator {
	%orig(NO);
}

%end
*/

#import "HBWLAgentView.h"
#import <UIKit/UIWindow+Private.h>

UIWindow *agentWindow;
HBWLAgentView *agentView;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	%orig;

	agentWindow = [[UIWindow alloc] init];
	agentWindow.windowLevel = UIWindowLevelAlert - 1.f;
	agentWindow.userInteractionEnabled = NO;
	agentWindow.hidden = NO;

	agentView = [[HBWLAgentView alloc] initWithFrame:CGRectMake(196.f, 464.f, 0, 0)];
	agentView.userInteractionEnabled = NO;
	[agentWindow addSubview:agentView];
}

%end

%hook SBLockScreenViewController

- (void)_handleDisplayTurnedOn {
	%orig;
	[agentView playAnimation:@"Greeting"];
}

%end

%hook _UIModalItemsPresentingViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	[agentView playAnimation:@"GetAttention"];
}

%end

#pragma mark - Constructor

%ctor {

}
