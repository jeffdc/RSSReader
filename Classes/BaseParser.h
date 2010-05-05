//
//  BaseParser.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

@protocol ParserDelegate;

@interface BaseParser : NSObject {
	NSURL* url;
	NSMutableData *mainXMLData;
	NSMutableDictionary* parsedData;
	<id> ParserDelegate delegate;
}

-(void) parse;
-(void) startParsing;

@protocol ParserDelegate
-(void) parsingComplete:(NSDictionary*);
@end
