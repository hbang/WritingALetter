@class HBWLAgent;

@interface HBWLAgentView : UIView

- (void)playAnimation:(NSString *)animation;
- (void)playAnimation:(NSString *)animation completion:(void(^)())completion;

@property (nonatomic, retain) HBWLAgent *agent;

@end
