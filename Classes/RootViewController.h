//
//  RootViewController.h
//  RSSReader
//  Displays a table of all the root items in the user's Google Reader feed.
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BaseGoogleViewController.h"
#import "FeedsViewController.h"
#import "EntriesViewController.h"

@interface RootViewController : BaseGoogleViewController {
	NSMutableData* mainXMLData;
	NSDictionary* labels;
	NSDictionary* starred;
	NSMutableDictionary* feeds;
	BOOL foundTitle;
	FeedsViewController* feedsVC;
	EntriesViewController* entriesVC;
	
	@private 
	BOOL isEntry;
	BOOL isLabel;
	int parserCount;
	NSMutableDictionary* tableData;
}

@property (nonatomic, retain) NSDictionary *labels;
@property (nonatomic, retain) NSDictionary *starred;
@property (nonatomic, retain) NSMutableDictionary *feeds;
@property (nonatomic, retain) NSMutableData *mainXMLData;
@property (nonatomic, retain) NSMutableDictionary* tableData;
@property (nonatomic, retain) IBOutlet FeedsViewController *feedsVC;
@property (nonatomic, retain) IBOutlet EntriesViewController *entriesVC;
@property BOOL foundTitle;
@property BOOL isEntry;
@property BOOL isLabel;
@end
