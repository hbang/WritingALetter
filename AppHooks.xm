#import <Foundation/NSDistributedNotificationCenter.h>

void sendAnimation(NSString *name) {
	[[NSDistributedNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HBWLPlayAnimationNotification object:nil userInfo:@{ kHBWLAnimationNameKey: name }]];
}

%hook UIAlertController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	sendAnimation(@"GetAttention");
}

%end

%hook UIPrinterPickerViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	sendAnimation(@"Print");
}

%end

%hook UISearchBar

- (void)becomeFirstResponder {
	%orig;
	sendAnimation(@"Searching");
}

%end

%hook UITextView

- (void)becomeFirstResponder {
	%orig;
	sendAnimation(arc4random_uniform(2) == 1 ? @"Writing" : @"CheckingSomething");
}

%end
