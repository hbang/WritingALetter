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

		CGRect agentFrame = _agentView.frame;
		agentFrame.origin.x = self.frame.size.width - _agentView.frame.size.width - 40.f;
		agentFrame.origin.y = self.frame.size.height - _agentView.frame.size.height - 40.f;
		_agentView.frame = agentFrame;

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
