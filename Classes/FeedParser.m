//
//  FeedParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/9/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "FeedParser.h"

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

-(void) dealloc {
	[super dealloc];
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type {
	NSURL* theUrl = [NSURL URLWithString:FEEDTOURL[type]];
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

}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
		qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if (![self isHtml:elementName aParser:parser]) {
		//TODO
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.delegate parsingComplete:[NSDictionary dictionaryWithDictionary:parsedData] parser:self];
}

@end
