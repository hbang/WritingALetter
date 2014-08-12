@class HBWLAgent;

@interface HBWLFrame : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary agent:(HBWLAgent *)agent;

@property NSTimeInterval duration;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *sound;

// TOOD: branching
// @property NSUInteger exitBranch;

@end
