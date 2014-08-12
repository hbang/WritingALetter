#import "HBWLRootListController.h"

@implementation HBWLRootListController

#pragma mark - Constants

+ (NSString *)hb_shareText {
	return @"Check out WritingALetter by HASHBANG Productions!";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"https://cydia.saurik.com/package/ws.hbang.writingaletter"];
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithRed:83.f / 255.f green:215.f / 255.f blue:106.f / 255.f alpha:1];
}

#pragma mark - PSListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

@end
