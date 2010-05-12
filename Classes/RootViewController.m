//
//  RootViewController.m
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "AuthenticationViewController.h"
#import "FeedItem.h"
#import "LabelParser.h"
#import "FeedsViewController.h"
#import "EntriesViewController.h"

static int const TOTAL_PARSERS = 1;

@interface RootViewController ()
-(void)getXML;
-(void)populateTableData;
@end

@implementation RootViewController

@synthesize labels, starred, feeds, tableData, mainXMLData, foundTitle, isEntry, isLabel, feedsVC, entriesVC;

- (void)dealloc {
	[labels release];
	[starred release];
	[feeds release];
	[tableData release];
    [super dealloc];
}

-(void)getXML {
	LabelParser* lp = [[LabelParser alloc] initWithDelegate:self];
	[lp parse];
	[lp release];
}

-(void)populateTableData {
	self.tableData = [[NSMutableDictionary alloc] initWithCapacity:[starred count] + [labels count] + [feeds count]];
	[tableData addEntriesFromDictionary:starred];
	[tableData addEntriesFromDictionary:labels];
	[tableData addEntriesFromDictionary:feeds];	
}

#pragma mark Parser delegate methods
-(void) parsingComplete:(NSDictionary*) data parser:(BaseParser*)theParser {
	// This method needs work. 
	// The conditional checks based on kindOfClass is hideous and looks like noob OO
	// The check for parserCount seems very kludgey
	@synchronized(self) {
		++parserCount;
	}
	if ([theParser isKindOfClass:[LabelParser class]]) {
			self.labels = [NSMutableDictionary dictionaryWithDictionary:data];
	}
//	if ([theParser isKindOfClass:[StarredParser class]]) {
//		self.starred = [NSMutableDictionary dictionaryWithDictionary:data];
//	}
//	if ([theParser isKindOfClass:[FeedsParser class]]) {
//		self.feeds = [NSMutableDictionary dictionaryWithDictionary:data];
//	}
	if (parserCount == TOTAL_PARSERS) {
		parserCount = 0;
		[self populateTableData];
		[self.tableView reloadData];
	}
}


#pragma mark ViewController methods
- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Reader Feeder";
	
	if (authenticated) {
		[self getXML];
	}
}

-(void)authencationComplete {
	[self getXML];
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	//	NSLog(@"Keys = '%@'", [self.feedTitles allKeys]);
	NSString* item = [[tableData allKeys] objectAtIndex:indexPath.row];
	cell.textLabel.text = item;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FeedItem* item = [tableData objectForKey:[[tableData allKeys] objectAtIndex:indexPath.row]];
	if (item.isLabel) {
		feedsVC.tableData = tableData;
		feedsVC.title = item.title;
		[[self navigationController] pushViewController:feedsVC animated:YES];
	} else {
		entriesVC.data = tableData;
		[[self navigationController] pushViewController:entriesVC animated:YES];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
@end