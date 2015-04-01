@class HBWLAgent;

typedef void (^HBWLAgentAnimationPlayCompletion)();

@interface HBWLAgentView : UIView

- (void)loadAgentName:(NSString *)name;
- (void)loadAgentName:(NSString *)name animated:(BOOL)animated;

- (void)playAnimation:(NSString *)animation;
- (void)playAnimation:(NSString *)animation completion:(HBWLAgentAnimationPlayCompletion)completion;

@property (nonatomic, retain) HBWLAgent *agent;

- (void)setAgent:(HBWLAgent *)agent animated:(BOOL)animated;

@end
