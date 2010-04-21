//
//  RootViewController.h
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AuthenticationViewController.h";

@interface RootViewController : UITableViewController<AuthenticationViewControllerDelegate> {
	NSMutableData *mainXMLData;
	//	NSURLConnection *conn;
	AuthenticationViewController *authController;
	NSMutableArray *feedTitles;
	NSMutableString *currentTitle;
	NSHTTPCookie *sidCookie;
	bool foundTitle;
}

-(void)startParsingXML;

//@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableArray *feedTitles;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSHTTPCookie *sidCookie;
@property (nonatomic, retain) AuthenticationViewController *authController;
@property (nonatomic, retain) NSMutableData *mainXMLData;
@property bool foundTitle;
@end
