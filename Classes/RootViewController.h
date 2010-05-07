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
	NSMutableData* mainXMLData;
	NSDictionary* labels;
	NSDictionary* starred;
	NSDictionary* feeds;
	bool foundTitle;
	
	@private 
	bool isEntry;
	bool isLabel;
	int parserCount;
	NSMutableDictionary* tableData;
}

@property (nonatomic, retain) NSDictionary *labels;
@property (nonatomic, retain) NSDictionary *starred;
@property (nonatomic, retain) NSDictionary *feeds;
@property (nonatomic, retain) NSMutableData *mainXMLData;
@property (nonatomic, retain) NSMutableDictionary* tableData;
@property bool foundTitle;
@property bool isEntry;
@property bool isLabel;
@end
