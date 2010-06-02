//
//  Site.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

@interface Feed : NSObject {
	NSString* title;
	NSURL* url;
	NSMutableArray* entries;
	NSMutableArray* labels;
}

- (id) initWithTitle:(NSString*)name URL:(NSURL*)URL;
- (BOOL) addEntry:(Entry*)entry;
- (BOOL) addLabel:(NSString*)label;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSURL* url;
@property (nonatomic, copy) NSMutableArray* entries;
@property (nonatomic, copy) NSMutableArray* labels;

@end

