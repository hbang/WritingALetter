//
//  ViewController.m
//  WritingALetterTest
//
//  Created by Adam D on 12/08/2014.
//  Copyright (c) 2014 HASHBANG Productions. All rights reserved.
//

#import "ViewController.h"
#import "HBWLAgentView.h"
#import "HBWLAgent.h"

@implementation ViewController {
	HBWLAgentView *_agentView;
}
            
- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_agentView = [[HBWLAgentView alloc] initWithFrame:CGRectMake(100, 200, 0, 0)];
	[self.view addSubview:_agentView];
	
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, 300, 44)];
	textField.placeholder = @"Run animation name";
	textField.delegate = self;
	textField.tag = 0;
	[self.view addSubview:textField];
	
	UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 118, 300, 44)];
	textField2.placeholder = @"Run sound id";
	textField2.delegate = self;
	textField2.tag = 1;
	[self.view addSubview:textField2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	switch (textField.tag) {
		case 0:
			[_agentView playAnimation:textField.text];
			break;
		
		case 1:
			[_agentView.agent playSound:textField.text];
			break;
	}
	
	return YES;
}

@end
