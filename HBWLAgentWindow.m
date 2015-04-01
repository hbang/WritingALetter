#import "HBWLAgentWindow.h"
#import "HBWLAgentView.h"
#import <UIKit/UIWindow+Private.h>

@implementation HBWLAgentWindow

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		self.windowLevel = 2000.f;

		if ([self respondsToSelector:@selector(_setSecure:)]) {
			self._secure = YES;
		}

		_agentView = [[HBWLAgentView alloc] init];
		[self addSubview:_agentView];
	}

	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *view = [super hitTest:point withEvent:event];
	return view == self ? nil : view;
}

#pragma mark - Memory management

- (void)dealloc {
	[_agentView release];

	[super dealloc];
}

@end
