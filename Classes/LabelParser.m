//
//  LabelParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "LabelParser.h"


@implementation LabelParser

-(void) init:(id) {
	self.url = [NSURL URLWithString:@"http://www.google.com/reader/api/0/tag/list"];
}

#pragma mark -
#pragma mark Parser methods
-(void)parserDidStartDocument:(NSXMLParser *)parser {
	isEntry = NO;
	isLabel = NO;
	foundTitle = NO;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
		qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	// see if we are actually authenticated to Google, if not then we will be getting HTML, not XML back from the call
	if ([elementName isEqualToString:@"html"]) {
		[parser abortParsing];
		self.authenticated = NO;
		[self authenticate];
		return;
	}
	
	if ([elementName isEqualToString:@"entry"]) {
		isEntry = YES;
	}
	
	if ([elementName isEqualToString:@"category"] && isEntry) {
		NSString* term = [attributeDict objectForKey:@"term"];
		NSArray* things = [term componentsSeparatedByString:@"/"];
		if ([things count] == 4 && [[things objectAtIndex:[things count] - 2] isEqualToString:@"label"]) {
			// found a label
			NSString* label = [things objectAtIndex:[things count] - 1];
			FeedItem* item = [[FeedItem alloc] initWithTitle:label isLabel:YES];
			[feedTitles setValue:item forKey:label];
			isLabel = YES;
		}
	}
	
	if ([elementName isEqualToString:@"title"] && isEntry && !isLabel) {
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
		FeedItem* item = [[FeedItem alloc] initWithTitle:currentTitle isLabel:NO];
		[feedTitles setValue:item forKey:currentTitle];
		foundTitle = NO;
	}
	
	if ([elementName isEqualToString:@"entry"]) {
		isEntry = NO;
		isLabel = NO;
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.delegate parsingComplete:[NSDictionary dictionaryWithDictionary:mainXMLData]];
}

@end
