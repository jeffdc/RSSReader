//
//  FeedParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/9/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "FeedParser.h"
#import "ParserDelegate.h"

static NSString* FEEDTOURL[] = {
	@"http://www.google.com/reader/atom/user/-/state/com.google/starred",
	@"http://www.google.com/reader/atom/user/-/state/com.google/reading-list",
	@"http://www.google.com/reader/atom/user/-/state/com.google/reading-list?xt=user/-/state/com.google/read",
	@"http://www.google.com/reader/atom/user/-/state/com.google/read",
	@"http://www.google.com/reader/atom/user/-/state/com.google/kept-unread",
	@"http://www.google.com/reader/atom/user/-/state/com.google/broadcast",
	@"http://www.google.com/reader/atom/user/-/label/%@",
	@"http://www.google.com/reader/atom/feed/%@"
};

@implementation FeedParser

@synthesize currentEntry, entries, site, feedItem, linkAttributeDict, feedType;

- (void) dealloc {
	[currentEntryTitle release];
	[currentEntryAuthor release];
	[currentEntryHTML release];
	[currentEntryUpdatedDate release];
	[currentEntry release];
	[site release];
	[entries release];
	[feedItem release];
	[super dealloc];
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type {
	self.feedType = type;
	NSURL* theUrl = [NSURL URLWithString:FEEDTOURL[type]];
	currentEntryTitle = [[NSMutableString alloc] init];
	currentEntryAuthor = [[NSMutableString alloc] init];
	currentEntryHTML = [[NSMutableString alloc] init];
	currentEntryUpdatedDate = [[NSMutableString alloc] init];
	self.currentEntry = [[Entry alloc] init];
	return [super initWithDelegate:theDelegate url:theUrl];
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type forString:(NSString*)string {
	NSString* urlString = [NSString stringWithFormat:FEEDTOURL[type], string];
	NSURL* theUrl = [NSURL URLWithString:urlString];
	return [super initWithDelegate:theDelegate url:theUrl];
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
		qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if (![self isHtml:elementName aParser:parser]) {
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
		if ([elementName isEqualToString:@"updated"] && isEntry) {
			foundEntryUpdatedDate = YES;
		}
		if ([elementName isEqualToString:@"summary"] && isEntry) {
			foundEntryHTML = YES;
		}
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

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
				qualifiedName:(NSString *)qName {
	
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
	if (!entries) {
		self.entries = [[NSMutableArray alloc]init];
	}
	if ([elementName isEqualToString:@"entry"]) {
		[entries addObject:currentEntry];
		isEntry = NO;
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	self.site = [[Site alloc]initWithName:@"starred" 
						URL:[NSURL URLWithString:@"http://www.google.com/reader/atom/user/-/state/com.google/starred"] 
						siteEntries:entries];
	self.feedItem = [[FeedItem alloc] initWithTitle:@"starredFeedItem" forIsLabel:NO];
	[feedItem.sites addObject:site];
	[self.delegate parsingComplete:[NSDictionary dictionaryWithObject:feedItem forKey:@"starred"] parser:self];
}

@end
