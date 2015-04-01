#import "HBWLAgentWindow.h"
#import "HBWLAgentView.h"
#import <Cephei/HBPreferences.h>
#import <SpringBoard/SBApplication.h>

HBWLAgentWindow *agentWindow;

NSString *agentName;

void sendAnimation(NSString *name) {
	[agentWindow.agentView playAnimation:name];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	%orig;

	/*
	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"ws.hbang.writingaletter"];
	[preferences registerObject:&agentName default:@"Clippit" forKey:@"AgentName"];
	*/

	agentWindow = [[HBWLAgentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	agentWindow.hidden = NO;
	[agentWindow.agentView loadAgentName:@"Clippit" animated:YES];

	CGRect agentFrame = agentWindow.agentView.frame;
	agentFrame.origin.x = agentWindow.frame.size.width - agentWindow.agentView.frame.size.width - 40.f;
	agentFrame.origin.y = agentWindow.frame.size.height - agentWindow.agentView.frame.size.height - 40.f;
	agentWindow.agentView.frame = agentFrame;

	/*
	[agentWindow.agentView loadAgentName:agentName animated:YES];

	[[NSNotificationCenter defaultCenter] addObserverForName:HBPreferencesDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if (notification.object == preferences) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[agentWindow.agentView loadAgentName:agentName animated:YES];
			});
		}
	}];
	*/
}

%end

%hook SBApplication

- (BOOL)icon:(id)icon launchFromLocation:(NSInteger)location {
	BOOL result = %orig;

	if ([@[ @"com.apple.mobilenotes", @"com.apple.reminders", @"com.atebits.Tweetie2", @"com.tapbots.Tweetbot", @"com.tapbots.TweetbotPad", @"com.tapbots.Tweetbot3", @"com.tinyspeck.chatlyio", @"com.facebook.Messenger", @"com.iconfactory.Blackbird", @"com.kik.chat", @"com.apple.iBooks", @"com.apple.MobileSMS" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(arc4random_uniform(2) == 1 ? @"Writing" : @"CheckingSomething");
	} else if ([@[ @"com.apple.mobilemail", @"com.orchestra.v2", @"com.google.inbox", @"com.google.Gmail", @"com.microsoft.Office.Outlook", @"com.microsoft.exchange.iphone" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"SendMail");
	} else if ([@[ @"com.googlecode.mobileterminal.Terminal", @"ws.hbang.Terminal", @"com.panic.Prompt", @"com.panic.Prompt2", @"com.saurik.Cydia", @"com.apple.Preferences", @"crash-reporter" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"GetTechy");
	} else if ([@[ @"com.apple.mobilesafari", @"com.google.chrome.ios", @"com.google.GoogleMobile", @"com.facebook.Facebook", @"com.reddit.alienblue" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"Searching");
	} else if ([@[ @"com.exile90.icleanerpro", @"org.altervista.exilecom.icleaner" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"EmptyTrash");
	} else if ([@[ @"com.burbn.instagram", @"ws.hbang.vlc-ios", @"com.apple.mobileslideshow", @"com.apple.camera", @"com.toyopagroup.picaboo", @"com.vine.iphone" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"GetArtsy");
	} else if ([@[ @"eu.heinelt.ifile", @"com.google.Drive", @"com.getdropbox.Dropbox", @"com.microsoft.skydrive", @"com.panic.iOS.Transmit" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"Save");
	} else if ([@[ @"com.apple.VoiceMemos", @"com.skype.skype", @"fm.overcast.overcast", @"com.sonos.SonosController", @"com.apple.Music" ] containsObject:self.bundleIdentifier]) {
		sendAnimation(@"Alert");
	}

	return result;
}

%end

%hook SBSearchField

- (void)becomeFirstResponder {
	%orig;
	sendAnimation(@"Searching");
}

%end

%hook SBBulletinBannerController

- (void)observer:(id)observer addBulletin:(id)bulletin forFeed:(uint64_t)feed {
	%orig;
	sendAnimation(@"GetAttention");
}

%end
