//
//  StarredParser.h
//  RSSReader
//
//  Created by Neal on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseParser.h"
#import "Site.h" // Should these be in .m? --JC - not needed since .m includes this file.
#import "FeedItem.h"
#import "Entry.h"

@interface StarredParser : BaseParser {
	
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

@property (nonatomic, retain) NSDictionary* linkAttributeDict;
@property (nonatomic, retain) Entry* currentEntry;
@property (nonatomic, retain) Site* starred;
@property (nonatomic, retain) FeedItem* starredFeedItem;
@property (nonatomic, retain) NSMutableArray* starredEntries;

@end
