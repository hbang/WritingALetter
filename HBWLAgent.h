@interface HBWLAgent : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle;

- (UIImage *)imageForFrameAtPosition:(CGPoint)frame;
- (void)playSound:(NSString *)sound;

@property (nonatomic, retain, readonly) NSBundle *bundle;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) UIImage *mapImage;

@property (readonly) NSUInteger overlayCount;
@property (readonly) CGSize frameSize;
@property (nonatomic, retain, readonly) NSDictionary *animations;
@property (nonatomic, retain, readonly) NSDictionary *useExitBranching;

@end
