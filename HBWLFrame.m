#import "HBWLFrame.h"
#import "HBWLAgent.h"
#import "HBWLBranch.h"

static NSString *const kHBWLFrameDurationKey = @"duration";
static NSString *const kHBWLFrameImagesKey = @"images";
static NSString *const kHBWLFrameSoundKey = @"sound";
static NSString *const kHBWLFrameExitBranchKey = @"exitBranch";
static NSString *const kHBWLFrameBranchingKey = @"branching";
static NSString *const kHBWLFrameBranchesKey = @"branches";

@implementation HBWLFrame

- (instancetype)initWithDictionary:(NSDictionary *)dictionary agent:(HBWLAgent *)agent {
	self = [self init];

	if (self) {
		_duration = ((NSNumber *)dictionary[kHBWLFrameDurationKey]).doubleValue / 1000;
		_image = [[agent imageForFrameAtPosition:CGPointMake(((NSNumber *)dictionary[kHBWLFrameImagesKey][0][0]).floatValue, ((NSNumber *)dictionary[kHBWLFrameImagesKey][0][1]).floatValue)] retain];
		_sound = [dictionary[kHBWLFrameSoundKey] copy];

		NSNumber *exitBranch = dictionary[kHBWLFrameExitBranchKey];
		_exitBranch = exitBranch ? exitBranch.unsignedIntegerValue : 0;

		if (dictionary[kHBWLFrameBranchingKey] && dictionary[kHBWLFrameBranchingKey][kHBWLFrameBranchesKey]) {
			NSMutableArray *branching = [NSMutableArray array];

			for (NSDictionary *branch in dictionary[kHBWLFrameBranchingKey][kHBWLFrameBranchesKey]) {
				[branching addObject:[[HBWLBranch alloc] initWithDictionary:branch]];
			}

			_branching = [branching copy];
		}
	}

	return self;
}

- (void)dealloc {
	[_image release];
	[_sound release];
	[_branching release];

	[super dealloc];
}

@end
