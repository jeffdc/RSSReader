//
//  FeedParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/9/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "FeedParser.h"


@implementation FeedParser

-(void) dealloc {
	[super dealloc];
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
