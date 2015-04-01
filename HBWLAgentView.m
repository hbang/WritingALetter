#import "HBWLAgentView.h"
#import "HBWLAgent.h"
#import "HBWLFrame.h"
#import <Foundation/NSDistributedNotificationCenter.h>

@implementation HBWLAgentView {
	HBWLAgent *_agent;
	NSTimer *_idleTimer;

	BOOL _isAnimating;
	HBWLAgentAnimationPlayCompletion _completion;
}

- (instancetype)init {
	self = [super init];

	if (self) {
		self.alpha = 0.75f;

		UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerFired:)] autorelease];
		[self addGestureRecognizer:panGestureRecognizer];

		UITapGestureRecognizer *tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playRandomAnimation)] autorelease];
		tapGestureRecognizer.numberOfTapsRequired = 2;
		[self addGestureRecognizer:tapGestureRecognizer];

		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAnimationNotification:) name:HBWLPlayAnimationNotification object:nil];
	}

	return self;
}

#pragma mark - Set agent

- (HBWLAgent *)agent {
	return _agent;
}

- (void)setAgent:(HBWLAgent *)agent {
	[self setAgent:agent animated:NO];
}

- (void)setAgent:(HBWLAgent *)agent animated:(BOOL)animated {
	void (^completion)() = ^{
		_agent = agent;

		CGRect frame = self.frame;
		frame.size = _agent.frameSize;
		self.frame = frame;

		if (animated) {
			[self playAnimation:@"Greeting"];
		}
	};

	if (_agent && animated) {
		[self playAnimation:@"GoodBye" completion:completion];
	} else {
		completion();
	}
}

- (void)loadAgentName:(NSString *)name {
	[self loadAgentName:name animated:NO];
}

- (void)loadAgentName:(NSString *)name animated:(BOOL)animated {
#ifdef WritingALetterTest_PrefixHeader_pch
	NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"bundle" subdirectory:@"agents"]];
#else
	NSBundle *bundle = [NSBundle bundleWithURL:[[[NSURL URLWithString:kHBWLAgentsLocation] URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"bundle"]];
#endif

	HBWLAgent *agent = [[HBWLAgent alloc] initWithBundle:bundle];

	if (agent) {
		[self setAgent:agent animated:animated];
	} else {
		NSLog(@"WritingALetter: agent %@ not found", name);
	}
}

#pragma mark - Animation

- (void)playAnimation:(NSString *)animation {
	[self playAnimation:animation completion:nil];
}

- (void)playAnimation:(NSString *)animation completion:(HBWLAgentAnimationPlayCompletion)completion {
	NSArray *frames = [_agent framesForAnimation:animation];

	if (!frames) {
		NSLog(@"WritingALetter: no animation %@ for %@", animation, _agent.name);

		if (completion) {
			completion();
		}

		return;
	}

	NSTimeInterval totalDuration = 0;
	NSTimeInterval durationSoFar = 0;
	NSMutableArray *values = [NSMutableArray array];
	NSMutableArray *keyTimes = [NSMutableArray array];

	for (HBWLFrame *frame in frames) {
		totalDuration += frame.duration;
	}

	for (HBWLFrame *frame in frames) {
		[values addObject:(id)frame.image.CGImage];
		[keyTimes addObject:@(durationSoFar / totalDuration)];

		if (frame.sound) {
			[NSTimer scheduledTimerWithTimeInterval:durationSoFar target:self selector:@selector(_playSoundFired:) userInfo:frame.sound repeats:NO];
		}

		durationSoFar += frame.duration;
	}

	[values addObject:(id)((HBWLFrame *)_agent.animations[@"RestPose"][0]).image.CGImage];
	[keyTimes addObject:@1];

	CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	keyframeAnimation.delegate = self;
	keyframeAnimation.values = values;
	keyframeAnimation.keyTimes = keyTimes;
	keyframeAnimation.duration = totalDuration;
	keyframeAnimation.calculationMode = kCAAnimationDiscrete;
	keyframeAnimation.fillMode = kCAFillModeBoth;
	keyframeAnimation.removedOnCompletion = NO;
	[self.layer addAnimation:keyframeAnimation forKey:nil];

	if (![animation hasPrefix:@"Idle"]) {
		_isAnimating = YES;
	}

	if (completion) {
		_completion = [completion copy];
	}
}

- (void)playRandomAnimation {
	NSString *animation;

	do {
		animation = _agent.animations.allKeys[arc4random_uniform(_agent.animations.allKeys.count)];
	} while ([animation hasPrefix:@"Idle"]);

	[self playAnimation:animation];
}

- (void)_playSoundFired:(NSTimer *)timer {
	[_agent playSound:timer.userInfo];
}

#pragma mark - Idle timer

- (void)_resetIdleTimer {
	if (_isAnimating) {
		return;
	}

	if (_idleTimer) {
		[_idleTimer invalidate];
		[_idleTimer release];
	}

	_idleTimer = [[NSTimer scheduledTimerWithTimeInterval:10 + arc4random_uniform(30) target:self selector:@selector(_idleTimerFired) userInfo:nil repeats:NO] retain];
}

- (void)_idleTimerFired {
	if (_isAnimating) {
		return;
	}

	NSString *animation;

	do {
		animation = _agent.animations.allKeys[arc4random_uniform(_agent.animations.allKeys.count)];
	} while (![animation hasPrefix:@"Idle"]);

	[self playAnimation:animation];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
	_isAnimating = NO;

	if (_completion) {
		_completion();
		[_completion release];
	}

	[self _resetIdleTimer];
}

#pragma mark - Gesture recogniser

- (void)panGestureRecognizerFired:(UIPanGestureRecognizer *)gestureRecognizer {
	switch (gestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:
		{
			[UIView animateWithDuration:0.2 animations:^{
				self.alpha = 1;
				self.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
			}];
			break;
		}

		case UIGestureRecognizerStateChanged:
		{
			self.center = [gestureRecognizer locationInView:self.superview];
			break;
		}

		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		{
			[UIView animateWithDuration:0.2 animations:^{
				self.alpha = 0.75f;
				self.transform = CGAffineTransformMakeScale(1, 1);
			}];
			break;
		}

		default:
			break;
	}
}

#pragma mark - Notification

- (void)receivedAnimationNotification:(NSNotification *)notification {
	[self playAnimation:notification.userInfo[kHBWLAnimationNameKey]];
}

#pragma mark - Memory management

- (void)dealloc {
	[_agent release];
	[_idleTimer release];

	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

@end
