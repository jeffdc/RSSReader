//
//  LabelParser.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"

@interface LabelParser : BaseParser {
	BOOL isId;
	NSMutableString* term;
}

@property BOOL isId;
@property(nonatomic, retain) NSMutableString* term;

@end
