#import "HBWLFrame.h"
#import "HBWLAgent.h"

static NSString *const kHBWLFrameDurationKey = @"duration";
static NSString *const kHBWLFrameImagesKey = @"images";
static NSString *const kHBWLFrameSoundKey = @"sound";

@implementation HBWLFrame

- (instancetype)initWithDictionary:(NSDictionary *)dictionary agent:(HBWLAgent *)agent {
	self = [self init];

	if (self) {
		_duration = ((NSNumber *)dictionary[kHBWLFrameDurationKey]).doubleValue / 1000;
		_image = [[agent imageForFrameAtPosition:CGPointMake(((NSNumber *)dictionary[kHBWLFrameImagesKey][0][0]).floatValue, ((NSNumber *)dictionary[kHBWLFrameImagesKey][0][1]).floatValue)] retain];
		_sound = [dictionary[kHBWLFrameSoundKey] copy];
	}

	return self;
}

- (void)dealloc {
	[_image release];
	[_sound release];

	[super dealloc];
}

@end
