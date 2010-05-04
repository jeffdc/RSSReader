//
//  BaseGoogleViewController.h
//  RSSReader
//
//  Created by Jeff Clark on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleAuthenticate.h"
#import "AuthenticationViewController.h"
#import "PreferencesViewController.h"

@interface BaseGoogleViewController : UITableViewController<
				GoogleAuthenticateDelegate, AuthenticationViewControllerDelegate, PreferencesViewControllerDelegate> {
	UIToolbar* toolbar;
	NSString *sid;
	NSHTTPCookie *sidCookie;
	bool authenticated;
	
@private
	GoogleAuthenticate* ga;
}

-(void)authenticate;
-(void)settingsClick:(id) sender;

-(void)postViewAppeared;

@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSHTTPCookie *sidCookie;
@property bool authenticated;
@property(nonatomic, retain) GoogleAuthenticate* ga;

@end
