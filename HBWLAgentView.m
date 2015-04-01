#import "HBWLAgentView.h"
#import "HBWLAgent.h"
#import "HBWLFrame.h"

static NSString *const kHBWLAgentsLocation = @"file:///Library/WritingALetter/Agents";

@implementation HBWLAgentView {
	HBWLAgent *_agent;
	BOOL _isAnimating;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playRandomAnimation)];
		gestureRecognizer.numberOfTapsRequired = 2;
		[self addGestureRecognizer:gestureRecognizer];

		[self loadAgentName:@"Clippit"];
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
#ifdef WritingALetterTest_PrefixHeader_pch
	NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"bundle" subdirectory:@"agents"]];
#else
	NSBundle *bundle = [NSBundle bundleWithURL:[NSURL URLWithString:[[kHBWLAgentsLocation stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"bundle"]]];
#endif

	HBWLAgent *agent = [[HBWLAgent alloc] initWithBundle:bundle];

	if (agent) {
		self.agent = agent;
	} else {
		NSLog(@"WritingALetter: agent %@ not found", name);
	}
}

#pragma mark - Animation

- (void)playAnimation:(NSString *)animation {
	[self playAnimation:animation completion:nil];
}

- (void)playAnimation:(NSString *)animation completion:(void(^)())completion {
	NSArray *frames = _agent.animations[animation];

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

	// TODO: completion block
}

- (void)playRandomAnimation {
	NSString *animation;

	do {
		animation = _agent.animations.allKeys[arc4random_uniform(_agent.animations.allKeys.count)];
	} while (![animation hasPrefix:@"Idle"]);

	[self playAnimation:animation];
}

- (void)_playSoundFired:(NSTimer *)timer {
	[_agent playSound:timer.userInfo];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
	_isAnimating = NO;
}

#pragma mark - Memory management

- (void)dealloc {
	[_agent release];
	[super dealloc];
}

@end
