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

@synthesize ga, timer, msg, usernameField, passwordField, sid, authenticated, sidCookie;

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
		NSLog(@"SID = '%@'", self.ga.SID);
		
		cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:self.ga.SID , NSHTTPCookieName, @".google.com", 
							NSHTTPCookieDomain, @"/", NSHTTPCookiePath, @"1600000000", NSHTTPCookieExpires, nil];
		sidCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];
		
		self.authenticated = YES;
		[self dismissModalViewControllerAnimated:YES];
	} else {
		[self.msg setText:self.ga.failureReason];
	}
	[activityIndicator stopAnimating];
	
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
