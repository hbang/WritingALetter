#import "HBWLBranch.h"

static NSString *const kHBWLBranchWeightKey = @"weight";
static NSString *const kHBWLBranchFrameIndexKey = @"frameIndex";

@implementation HBWLBranch

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [self init];

	if (self) {
		_weight = ((NSNumber *)dictionary[kHBWLBranchWeightKey]).unsignedIntegerValue;
		_frameIndex = ((NSNumber *)dictionary[kHBWLBranchFrameIndexKey]).unsignedIntegerValue;
	}

	return self;
}

@end
