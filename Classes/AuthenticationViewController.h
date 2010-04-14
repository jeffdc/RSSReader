//
//  AuthenticationViewController.h
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleAuthenticate.h"

@interface AuthenticationViewController : UIViewController<UITextFieldDelegate> {

	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UILabel *msg;
	IBOutlet UIActivityIndicatorView *activityIndicator;

	NSString *sid;
	NSMutableDictionary *cookieProperties;
	NSHTTPCookie *sidCookie;
	bool authenticated;
	
	@private
	NSTimer *timer;
	GoogleAuthenticate *ga;
}

- (IBAction) login:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *msg;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSHTTPCookie *sidCookie;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) GoogleAuthenticate *ga;
@property bool authenticated;

@end
