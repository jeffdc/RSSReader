//
//  RootViewController.h
//  RSSReader
//  Displays a table of all the root items in the user's Google Reader feed.
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BaseGoogleViewController.h"

@interface RootViewController : BaseGoogleViewController {
	NSMutableData *mainXMLData;
	NSMutableArray *feedTitles;
	NSMutableString *currentTitle;
	bool foundTitle;
}

@property (nonatomic, retain) NSMutableArray *feedTitles;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSMutableData *mainXMLData;
@property bool foundTitle;
@end
