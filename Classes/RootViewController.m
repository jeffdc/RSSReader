//
//  RootViewController.m
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "AuthenticationViewController.h"

@implementation RootViewController

@synthesize feedTitles, currentTitle, sidCookie, authController, mainXMLData, foundTitle;

-(void)getXML {
	NSURL *getXMLURL = [NSURL URLWithString:@"http://www.google.com/reader/atom/"];
	NSURLRequest *getXMLRequest = [[NSURLRequest alloc]initWithURL:getXMLURL]; //use an NSMutableRequest so it can be reused?
	NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:getXMLRequest delegate:self];
	[getXMLRequest release];
	[conn release]; //nil out also?
}

#pragma mark -
#pragma mark Connection methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mainXMLData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
		[self startParsingXML];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		if (statusCode >= 400)
		{
			NSLog(@"Received HTTP status code %i", statusCode);
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];		
			[connection cancel];

		    //TODO: handle errors more appropriately
		} else {
			self.mainXMLData = [[NSMutableData alloc] init];
		}
		
	}
}


-(void)startParsingXML {
	NSXMLParser *mainXMLDataParser = [[NSXMLParser alloc] initWithData:mainXMLData];
	mainXMLDataParser.delegate = self;
	[mainXMLDataParser parse];
	[mainXMLDataParser release];
}

#pragma mark -
#pragma mark Parser methods


-(void)parserDidStartDocument:(NSXMLParser *)parser {
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"title"]) {
		foundTitle = YES;
		currentTitle = [[[NSMutableString alloc] init] autorelease];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (foundTitle) {
		[currentTitle appendString:string];	
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (foundTitle) {
		[feedTitles addObject:currentTitle];
		foundTitle = NO;
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"%@", feedTitles);
}

#pragma mark AuthenticationViewController delegate
- (void) authenticationComplete:(AuthenticationViewController*) avc SIDCookie:(NSHTTPCookie*) cookie {
	[avc dismissModalViewControllerAnimated:YES];
	self.sidCookie = cookie;
	NSLog(@"SID = '%@'", avc.sid);
	[self getXML];
}

#pragma mark ViewController methods

- (void) viewDidLoad {
	NSLog(@"viewDidLoad");
	[super viewDidLoad];
	
	//check for username and password "on disk"
	//TODO
	
	feedTitles = [[NSMutableArray alloc] init]; //maybe specify capacity
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear");

    if (!authController.authenticated) {
		AuthenticationViewController *avc = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationView" bundle:nil];
		avc.delegate = self;
		[self.navigationController presentModalViewController:avc animated:YES];
	}
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [[self.feedTitles objectAtIndex:indexPath.row] valueForKey:@"title"];
	
    return cell;
}



/*
// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[currentTitle dealloc];
	[feedTitles dealloc];
    [super dealloc];
}


@end

