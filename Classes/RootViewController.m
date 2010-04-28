//
//  RootViewController.m
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "AuthenticationViewController.h"

@interface RootViewController ()
-(void)getXML;
-(void)startParsingXML;
@end

@implementation RootViewController

@synthesize feedTitles, currentTitle, mainXMLData, foundTitle;

- (void)dealloc {
	[currentTitle dealloc];
	[feedTitles dealloc];
    [super dealloc];
}

-(void)getXML {	
	NSURL *url = [NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/reading-list"];
	// make sure the proper cookie is set
	if (![[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]) {
		NSLog(@"No google cookie set!");
	}

	NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url]; //use an NSMutableRequest so it can be reused?
	
	NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	[request release];
	[conn release]; //nil out also?
}

-(void)startParsingXML {
	NSXMLParser *mainXMLDataParser = [[NSXMLParser alloc] initWithData:mainXMLData];
	mainXMLDataParser.delegate = self;
	[mainXMLDataParser parse];
	[mainXMLDataParser release];
}

#pragma mark ViewController methods
- (void) viewDidLoad {
	[super viewDidLoad];
	
	feedTitles = [[NSMutableArray alloc] init]; //maybe specify capacity
}

-(void)postViewAppeared {
	[self getXML];
}

#pragma mark -
#pragma mark Parser methods
-(void)parserDidStartDocument:(NSXMLParser *)parser {
	
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
			qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	NSLog(@"Element Name = '%@'", elementName);
	// see if we are actually authenticated to Google, if not then we will be getting HTML, not XML back from the call
	if ([elementName isEqualToString:@"html"]) {
		[parser abortParsing];
		self.authenticated = NO;
		[self authenticate];
	} else if ([elementName isEqualToString:@"title"]) {
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
	// refresh the table
	[self.tableView reloadData];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedTitles count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [self.feedTitles objectAtIndex:indexPath.row];
	
    return cell;
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
	NSString *s = [[NSString alloc] initWithData:mainXMLData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", s);
	[s release];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
@end