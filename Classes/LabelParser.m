//
//  LabelParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "LabelParser.h"
#import "FeedItem.h"

@implementation LabelParser

@synthesize isId, term;

-(void) dealloc {
	[super dealloc];
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate {
	return [super initWithDelegate:theDelegate url:[NSURL URLWithString:@"http://www.google.com/reader/api/0/tag/list"]];
}

#pragma mark -
#pragma mark Parser methods
-(void)parserDidStartDocument:(NSXMLParser *)parser {
	self.isId = NO;
	self.term = [[NSMutableString alloc] init];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
		qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if (![self isHtml:elementName aParser:parser]) {
		if ([elementName isEqualToString:@"string"]) {
			NSString* attrib = [attributeDict objectForKey:@"name"];
			self.isId = [attrib isEqualToString:@"id"];
		}
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (isId) {
		[term appendString:string];	
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (isId) {
		NSArray* things = [term componentsSeparatedByString:@"/"];
		if ([things count] == 4 && [[things objectAtIndex:[things count] - 2] isEqualToString:@"label"]) {
			// found a label
			NSString* label = [things objectAtIndex:[things count] - 1];

			FeedItem* item = [[FeedItem alloc] initWithTitle:label forIsLabel:YES];
			[parsedData setValue:item forKey:label];
			[item release];
			
			NSLog(@"LABEL = '%@'", label);
		}
		self.isId = NO;
		[term setString:@""];
	}	
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.delegate parsingComplete:[NSDictionary dictionaryWithDictionary:parsedData] parser:self];
	[term release];
	term = nil; ///??????????
}

@end
