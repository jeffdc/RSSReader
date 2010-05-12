//
//  Entry.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//


@interface Entry : NSObject {
	NSString* title;
	NSDate* date;
	NSString* author;
	NSString* html;
	NSString* siteName;
	NSURL* url;
	//NSURL* siteURL; //null if not a starred item, because the entry can use it's site.title ... needed???
}

- (id) initWithTitle:(NSString*)entryTitle entryDate:(NSDate*)entryDate entryAuthor:(NSString*)entryAuthor 
								entryHTML:(NSData*)entryHTML entrySiteName(NSString*):entrySiteName entryURL:(NSURL*)entryURL;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSData* html;
@property (nonatomic, retain) NSString* siteName;
@property (nonatomic, retain) NSURL* url;

@end
