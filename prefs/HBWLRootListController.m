#import "HBWLRootListController.h"

@implementation HBWLRootListController

#pragma mark - Constants

+ (NSString *)hb_shareText {
	return @"Check out WritingALetter by HASHBANG Productions!";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"https://cydia.hbang.ws/depiction/ws.hbang.writingaletter/"];
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithRed:83.f / 255.f green:215.f / 255.f blue:106.f / 255.f alpha:1];
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

@end
