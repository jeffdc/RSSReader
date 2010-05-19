//
//  ParserDelegate.h
//  RSSReader
//
//  Created by Jeff Clark on 5/16/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseParser.h"

@protocol ParserDelegate

-(void) parsingComplete:(NSDictionary*) data parser:(BaseParser*)theParser;

@end
