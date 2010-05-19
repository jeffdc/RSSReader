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
	NSMutableData *mainXmlData;
	NSMutableDictionary* parsedData;
	id<ParserDelegate> delegate;
}

-(void) parse;
-(void) startParsing;
-(id) initWithDelegate:(id<ParserDelegate>) theDelegate url:(NSURL*)theUrl;
-(BOOL) isHtml:(NSString*)elementName aParser:(NSXMLParser*)parser;

@property(assign) id<ParserDelegate> delegate;
@property(nonatomic, retain) NSURL* url;
@property(nonatomic, retain) NSMutableData* mainXmlData;
@property(nonatomic, retain) NSMutableDictionary* parsedData;

@end

