//
//  BaseGoogleViewController.m
//  RSSReader
//
//  Created by Jeff Clark on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseGoogleViewController.h"
#import "AuthenticationViewController.h"

static NSString *const USER_DEFAULTS_KEY = @"rssreader.nothoo.com";

@implementation BaseGoogleViewController

@synthesize sid, sidCookie, authenticated, ga;

- (void) viewDidLoad {
	self.authenticated = NO;
	self.ga = [[GoogleAuthenticate alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
   if (!self.authenticated) {
		// try to get user name and password from "disk"
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		NSArray *vals = [ud stringArrayForKey:USER_DEFAULTS_KEY];
		if (vals && [vals count] > 0) {
			[ga authenticateWithUserName: [vals objectAtIndex:0] password:[vals objectAtIndex:1]];
		} else {
			AuthenticationViewController *avc = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationView" bundle:nil];
			avc.delegate = self;
			[self.navigationController presentModalViewController:avc animated:YES];
		}
	}
	[super viewWillAppear:animated];
}

- (NSHTTPCookie*) createSidCookie {
	NSLog(@"SID = '%@'", self.sid);
	NSDictionary* cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									  @"SID", NSHTTPCookieName,
									  @".google.com", NSHTTPCookieDomain, 
									  @"/", NSHTTPCookiePath, 
									  @"1600000000", NSHTTPCookieExpires, 
									  self.sid, NSHTTPCookieValue,
									  nil];
	
	sidCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
	if (!sidCookie) {
		NSLog(@"Failed to create cookie.");
	}
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];

	return sidCookie;	
}

- (void) completeAuthentication:(NSString*)theSid {
	self.sid = theSid;
	self.sidCookie = [self createSidCookie];
	self.authenticated = YES;
}

#pragma mark AuthenticationViewController delegate
- (void) authenticationVCComplete:(AuthenticationViewController*) avc {
	[avc dismissModalViewControllerAnimated:YES];
	[self completeAuthentication:avc.sid];
	// save to "disk"
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:avc.usernameField.text, avc.passwordField.text, nil] forKey:USER_DEFAULTS_KEY];
}

#pragma mark GoogleAuthenticate delegate
- (void) authenticationComplete:(GoogleAuthenticate*) theGa {
	[self completeAuthentication:theGa.SID];
}

- (void) authenticationFailed:(GoogleAuthenticate*) theGa {
	NSLog(@"Authentication failed. %@", theGa.failureReason);
	self.authenticated = NO;
}

- (void) dealloc {
	[ga dealloc];
	[super dealloc];
}
@end
