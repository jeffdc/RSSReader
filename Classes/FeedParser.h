//
//  FeedParser.h
//  RSSReader
//
//  Created by Jeff Clark on 5/9/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"
#import "Site.h"
#import "FeedItem.h"
#import "Entry.h"

typedef enum {
	Starred,
	All,
	Unread,
	Read,
	KeptUnread,
	Public,
	ByLabel,
	BySite
} FeedType;

@interface FeedParser : BaseParser {
	Entry* currentEntry;
	Site* starred;
	FeedItem* starredFeedItem;
	NSMutableArray* starredEntries;
	
	BOOL isEntry;
	BOOL inEntrySource;
	BOOL foundEntryTitle;
	BOOL foundSiteTitle;
	BOOL foundEntryAuthor;
	BOOL foundEntryURL;
	BOOL foundEntryHTML;
	BOOL foundEntryUpdatedDate;
	
	NSDictionary* linkAttributeDict;
	NSMutableString* currentEntryTitle;
	NSMutableString* currentSiteTitle;
	NSMutableString* currentEntryAuthor;
	NSMutableString* currentEntryHTML;
	NSMutableString* currentEntryUpdatedDate;
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type;
-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type forString:(NSString*)string;

@end
