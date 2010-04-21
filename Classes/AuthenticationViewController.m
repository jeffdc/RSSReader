//
//  AuthenticationViewController.m
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "RSSReaderAppDelegate.h"
#import "RootViewController.h"

@implementation AuthenticationViewController

@synthesize ga, timer, msg, usernameField, passwordField, sid, authenticated, sidCookie, delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	self.authenticated = NO;
	return self;
}

- (IBAction) login:(id)sender {
	self.ga = [[GoogleAuthenticate alloc] initWithUserName:usernameField.text password:passwordField.text];
	
	[self.msg setText:@"Authenticating..."];
	
	[activityIndicator startAnimating];
	[self.ga authenticate];
	
	// set up the timer to wait for completion of authentication 
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loginDone:) userInfo:nil repeats:YES];
}

-(void)loginDone: (NSTimer*) theTimer {
	NSLog(@"loginDone");
	
	if (!self.ga.completed) {
		NSLog(@"Still waiting...");
		return;
	}
	
	[theTimer invalidate];
	
	if (self.ga.authenticated) {
		self.sid = self.ga.SID;
		
		NSDictionary* cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										  @"SID", NSHTTPCookieName,
										  @".google.com", NSHTTPCookieDomain, 
										  @"/", NSHTTPCookiePath, 
										  @"1600000000", NSHTTPCookieExpires, 
										  self.ga.SID, NSHTTPCookieValue,
										  nil];
		
		sidCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
		if (!sidCookie) {
			NSLog(@"Failed to create cookie.");
		}

		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];
		
		self.authenticated = YES;
	} else {
		[self.msg setText:self.ga.failureReason];
	}
	[activityIndicator stopAnimating];
	[delegate authenticationComplete:self SIDCookie:sidCookie];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField	{
	[textField resignFirstResponder];
	if (textField == passwordField) {
		[self login:self];
	} else {
		[passwordField becomeFirstResponder];
	}
	
	return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
