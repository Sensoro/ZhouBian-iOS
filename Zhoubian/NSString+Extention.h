//
//  NSString+Contain.h
//  Sensoro Deployment Utility
//
//  Created by skyming on 3/25/15.
//  Copyright (c) 2015 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)
- (BOOL)containsSubString:(NSString *)aString;
- (NSString*) getRealPartOfQRCode;

@end
