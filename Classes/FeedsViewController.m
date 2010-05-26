//
//  FeedsViewController.m
//  RSSReader
//
//  Created by Jeff Clark on 5/8/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedParser.h"

@interface FeedsViewController ()
-(void)getXml;
@end

@implementation FeedsViewController

@synthesize tableData;

-(void) dealloc {
	[tableData release];
	[super dealloc];
}

-(void) getXml {
	FeedParser* fp = [[FeedParser alloc] initWithDelegate:self forFeedType:ByLabel forString:self.title];
	[fp parse];
	[fp release];
	
}

#pragma mark Parser delegate methods
-(void) parsingComplete:(NSDictionary*) data parser:(BaseParser*)theParser {
	self.tableData = data;
}

#pragma mark Authentication delegate
-(void)authencationComplete {
	[self getXml];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	// get the feeds for the given label, the label is the title
	if (authenticated) {
		[self getXml];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString* item = [[tableData allKeys] objectAtIndex:indexPath.row];
	cell.textLabel.text = item;

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end
