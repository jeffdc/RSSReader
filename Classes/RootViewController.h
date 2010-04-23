//
//  RootViewController.h
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BaseGoogleViewController.h"

@interface RootViewController : BaseGoogleViewController {
	UIToolbar* toolbar;
	NSMutableData *mainXMLData;
	NSMutableArray *feedTitles;
	NSMutableString *currentTitle;
	bool foundTitle;
}

-(void)startParsingXML;

@property (nonatomic, retain) NSMutableArray *feedTitles;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSMutableData *mainXMLData;
@property bool foundTitle;
@end
