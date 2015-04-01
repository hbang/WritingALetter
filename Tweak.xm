#import "HBWLAgentWindow.h"
#import "HBWLAgentView.h"
#import <Cephei/HBPreferences.h>

HBWLAgentWindow *agentWindow;

NSString *agentName;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	%orig;

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"ws.hbang.writingaletter"];
	[preferences registerObject:&agentName default:@"Clippit" forKey:@"AgentName"];

	agentWindow = [[HBWLAgentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	agentWindow.hidden = NO;

	[agentWindow.agentView loadAgentName:agentName animated:YES];

	[[NSNotificationCenter defaultCenter] addObserverForName:HBPreferencesDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if (notification.object == preferences) {
			[agentWindow.agentView loadAgentName:agentName animated:YES];
		}
	}];
}

%end

%hook _UIModalItemsPresentingViewController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	[agentWindow.agentView playAnimation:@"GetAttention"];
}

%end
