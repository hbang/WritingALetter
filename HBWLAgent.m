#import "HBWLAgent.h"
#import "HBWLFrame.h"
#import "HBWLBranch.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIImage+Private.h>

static NSString *const kHBWLAgentDataOverlayCountKey = @"overlayCount";
static NSString *const kHBWLAgentDataFrameSizeKey = @"framesize";
static NSString *const kHBWLAgentDataAnimationsKey = @"animations";
static NSString *const kHBWLAgentDataFramesKey = @"frames";
static NSString *const kHBWLAgentDataUseExitBranchingKey = @"useExitBranching";

@implementation HBWLAgent {
	NSDictionary *_sounds;
	NSDictionary *_useExitBranching;
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
	self = [self init];

	if (self) {
		if (!bundle) {
			NSLog(@"WritingALetter: bundle is nil");
			return nil;
		}

		_bundle = bundle;
		_name = [bundle.infoDictionary[@"CFBundleDisplayName"] copy];
		_mapImage = [[UIImage imageNamed:@"map" inBundle:bundle] retain];

		NSError *error = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[bundle URLForResource:@"agent" withExtension:@"json"]] options:kNilOptions error:&error];

		if (error) {
			NSLog(@"WritingALetter: reading json for %@ failed: %@", _name, error);
			return nil;
		}

		_overlayCount = ((NSNumber *)json[kHBWLAgentDataOverlayCountKey]).floatValue;
		_frameSize = CGSizeMake(((NSNumber *)json[kHBWLAgentDataFrameSizeKey][0]).floatValue, ((NSNumber *)json[kHBWLAgentDataFrameSizeKey][1]).floatValue);

		NSMutableDictionary *sounds = [NSMutableDictionary dictionary];
		NSArray *bundleSounds = [_bundle URLsForResourcesWithExtension:@"caf" subdirectory:nil];

		for (NSURL *sound in bundleSounds) {
			SystemSoundID soundID;
			AudioServicesCreateSystemSoundID((CFURLRef)sound, &soundID);

			if (soundID) {
				sounds[sound.lastPathComponent.stringByDeletingPathExtension] = @(soundID);
			} else {
				NSLog(@"WritingALetter: failed to create system sound for %@", sound);
			}
		}

		_sounds = [sounds copy];

		NSDictionary *jsonAnimations = json[kHBWLAgentDataAnimationsKey];
		NSMutableDictionary *animations = [NSMutableDictionary dictionary];
		NSMutableDictionary *useExitBranching = [NSMutableDictionary dictionary];

		for (NSString *animationName in jsonAnimations.allKeys) {
			NSMutableArray *frames = [NSMutableArray array];

			for (NSDictionary *frame in jsonAnimations[animationName][kHBWLAgentDataFramesKey]) {
				[frames addObject:[[HBWLFrame alloc] initWithDictionary:frame agent:self]];
			}

			animations[animationName] = [frames copy];
			useExitBranching[animationName] = jsonAnimations[animationName][kHBWLAgentDataUseExitBranchingKey] ?: @NO;
		}

		_animations = [animations copy];
		_useExitBranching = [useExitBranching copy];
	}

	return self;
}

#pragma mark - Get frames

- (NSArray *)framesForAnimation:(NSString *)animation {
	NSArray *frames = _animations[animation];

	if (!frames) {
		return nil;
	}

	if (!((NSNumber *)_useExitBranching[animation]).boolValue) {
		return frames;
	}

	NSMutableArray *newFrames = [NSMutableArray array];
	NSUInteger i = 0;

	while (i < frames.count - 1) {
		HBWLFrame *frame = frames[i];
		BOOL gotFrame = NO;

		if (frame.exitBranch > 0) {
			[newFrames addObject:frames[frame.exitBranch]];
			gotFrame = YES;
		} else if (frame.branching) {
			NSUInteger random = arc4random_uniform(100);

			for (HBWLBranch *branch in frame.branching) {
				if (random <= branch.weight) {
					[newFrames addObject:frames[branch.frameIndex]];
					gotFrame = YES;
					break;
				}

				random -= branch.weight;
			}
		}

		if (!gotFrame) {
			[newFrames addObject:frame];
		}

		i++;
	}

	return [[newFrames copy] autorelease];
}

- (UIImage *)imageForFrameAtPosition:(CGPoint)position {
	struct CGImage *cgImage = CGImageCreateWithImageInRect(_mapImage.CGImage, (CGRect){ position, _frameSize });
	UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);
	return uiImage;
}

#pragma mark - Play sounds

- (void)playSound:(NSString *)sound {
	if (!_sounds[sound]) {
		NSLog(@"WritingALetter: no sound called %@ for %@", sound, _name);
		return;
	}

	AudioServicesPlaySystemSound(((NSNumber *)_sounds[sound]).unsignedIntValue);
}

#pragma mark - Memory management

- (void)dealloc {
	for (NSNumber *sound in _sounds) {
		AudioServicesDisposeSystemSoundID(sound.unsignedIntValue);
	}

	[_bundle release];
	[_name release];
	[_mapImage release];
	[_animations release];
	[_useExitBranching release];
	[_sounds release];

	[super dealloc];
}

@end
