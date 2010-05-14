//
//  StarredParser.m
//  RSSReader
//
//  Created by Neal on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StarredParser.h"

@implementation StarredParser

-(id) init {
	self.url = [NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/starred"];
	return self;
}

#pragma mark -
#pragma mark Parser methods
-(void)parserDidStartDocument:(NSXMLParser *)parser {
	isEntry = NO;
	inEntrySource = NO;
	foundEntryTitle = NO;
	foundSiteTitle = NO;
	foundEntryAuthor = NO;
	foundEntryURL = NO;
	foundEntryHTML = NO;
	// Do we need to nil out the all of the character holder objects so they get cleared?
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"entry"]) {
		isEntry = YES;
	}
	if ([elementName isEqualToString:@"source"] && isEntry) {
		inEntrySource = YES; 
	}
	if ([elementName isEqualToString:@"title"] && isEntry && !inEntrySource) {
		foundEntryTitle = YES;
	} 
	if ([elementName isEqualToString:@"title"] && inEntrySource) {
		foundSiteTitle = YES; 	
	}
	if ([elementName isEqualToString:@"name"] && isEntry) {
		foundEntryAuthor = YES;
	}
	if ([elementName isEqualToString:@"link"] && isEntry) {
		foundEntryURL = YES;
		linkAttributeDict = [NSDictionary dictionaryWithDictionary:attributeDict];
	}
	if ([elementName isEqualToString:@"updated"]) {
		foundEntryUpdatedDate = YES;
	}
	if ([elementName isEqualToString:@"summary"] && isEntry) {
		foundEntryHTML = YES;
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (foundEntryTitle) {
		[currentEntryTitle appendString:string];	
	}
	if (foundSiteTitle) {
		[currentSiteTitle appendString:string];
	}
	if (foundEntryAuthor) {
		[currentEntryAuthor appendString:string];
	}
	if (foundEntryHTML) {
		[currentEntryHTML appendString:string];
	}
	if (foundEntryUpdatedDate) {
		[currentEntryUpdatedDate appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if (!currentEntry) { // Create the Entry object if it's null.
		currentEntry = [[Entry alloc]init];
	}
	if (foundEntryTitle) {
		currentEntry.title = currentEntryTitle;
		foundEntryTitle = NO;
		currentEntryTitle = nil;
	}
	if (foundSiteTitle) {
		currentEntry.siteName = currentSiteTitle;
		foundSiteTitle = NO;
		currentSiteTitle = nil;
	}
	if (foundEntryAuthor) {
		currentEntry.author = currentEntryAuthor;
		foundEntryAuthor = NO;
		currentEntryAuthor = nil;
	}
	if (foundEntryURL) {
		currentEntry.url = [NSURL URLWithString:[linkAttributeDict objectForKey:@"href"]]; // Does the key need to be cast to a string?
																						   // String has to conform to RFC 2396...
	}
	if (foundEntryHTML) {
		currentEntry.html = currentEntryHTML; // Unsure as to how we'll display the HTML on a UIWebView.
											  // NSData doesn't seem to be what we need to use, so it's a NSString for now.
		foundEntryHTML = NO;
		currentEntryHTML = nil;
	}
	if (foundEntryUpdatedDate) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss z"]; // Can I set the format to something different than what Google Reader uses?
													// See this site for formatting: http://unicode.org/reports/tr35/#Date_Format_Patterns
		NSDate *updatedDate = [df dateFromString: currentEntryUpdatedDate];
		currentEntry.date = updatedDate;
		foundEntryUpdatedDate = NO;
		[df release];
		updatedDate = nil;
		currentEntryUpdatedDate = nil;
	}
	if ([elementName isEqualToString:@"source"]) {
		inEntrySource = NO;
	}
	if (!starredEntries) {
		starredEntries = [[NSMutableArray alloc]init];
	}
	if ([elementName isEqualToString:@"entry"]) {
		[starredEntries addObject:currentEntry];
		currentEntry = nil; // Will this cause it to create a new Entry object for each entry? 
							//How do I safely nil this out so it's ready for the next entry?
		isEntry = NO;
	}
}
		 
-(void)parserDidEndDocument:(NSXMLParser *)parser {
	starred = [[Site alloc]initWithName:@"starred" URL:[NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/starred"] siteEntries:starredEntries];
	starredFeedItem = [[FeedItem alloc]initWithTitle:@"starredFeedItem" isLabel:NO];
	[starredFeedItem.sites addObject:starred];
	// Everything is packed into the StarredFeedItem at this point. Do what ever else is necessary (add it into a dictionary, etc.).
	
	//[self.delegate parsingComplete:[NSDictionary dictionaryWithDictionary:mainXMLData]];
	// Not needed anymore
}

- (void) dealloc {
	[super dealloc];
}

@end
