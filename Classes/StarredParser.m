//
//  StarredParser.m
//  RSSReader
//
//  Created by Neal on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StarredParser.h"
#import "ParserDelegate.h";

@implementation StarredParser

@synthesize currentEntry, starredEntries, starred, starredFeedItem, linkAttributeDict;

- (void) dealloc {
	[currentEntry release];
	[starred release];
	[starredEntries release];
	[starredFeedItem release];
	[super dealloc];
}

-(id) init {
	self.url = [NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/starred"];
	currentEntryTitle = [[NSMutableString alloc] init];
	currentEntryAuthor = [[NSMutableString alloc] init];
	currentEntryHTML = [[NSMutableString alloc] init];
	currentEntryUpdatedDate = [[NSMutableString alloc] init];
	currentEntry = [[NSMutableString alloc] init];
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
		self.linkAttributeDict = [NSDictionary dictionaryWithDictionary:attributeDict];
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
		self.currentEntry = [[Entry alloc]init];
		//JC needs to be retained otherwise it will end up deleted and the program will crash
	}
	if (foundEntryTitle) {
		currentEntry.title = currentEntryTitle;
		foundEntryTitle = NO;
		[currentEntryTitle setString:@""];
	}
	if (foundSiteTitle) {
		currentEntry.siteName = currentSiteTitle;
		foundSiteTitle = NO;
		[currentSiteTitle setString:@""];
	}
	if (foundEntryAuthor) {
		currentEntry.author = currentEntryAuthor;
		foundEntryAuthor = NO;
		[currentEntryAuthor setString:@""];
	}
	if (foundEntryURL) {
		currentEntry.url = [NSURL URLWithString:[linkAttributeDict objectForKey:@"href"]];
		foundEntryURL = NO;
		[linkAttributeDict release];
	}
	if (foundEntryHTML) {
		currentEntry.html = currentEntryHTML;
		foundEntryHTML = NO;
		[currentEntryHTML setString:@""];
	}
	if (foundEntryUpdatedDate) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss z"]; 
		NSDate *updatedDate = [df dateFromString: currentEntryUpdatedDate];
		currentEntry.date = updatedDate;
		foundEntryUpdatedDate = NO;
		[df release];
		[currentEntryUpdatedDate setString:@""];
	}
	if ([elementName isEqualToString:@"source"]) {
		inEntrySource = NO;
	}
	if (!starredEntries) {
		self.starredEntries = [[NSMutableArray alloc]init];
	}
	if ([elementName isEqualToString:@"entry"]) {
		[starredEntries addObject:currentEntry];
		isEntry = NO;
	}
}
		 
-(void)parserDidEndDocument:(NSXMLParser *)parser {
	self.starred = [[Site alloc]initWithName:@"starred" URL:[NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/starred"] siteEntries:starredEntries];
	self.starredFeedItem = [[FeedItem alloc] initWithTitle:@"starredFeedItem" forIsLabel:NO];
	[starredFeedItem.sites addObject:starred];
	[self.delegate parsingComplete:[NSDictionary dictionaryWithObject:starredFeedItem forKey:@"starred"] parser:self];
}

@end
