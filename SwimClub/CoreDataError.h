//
//  CoreDataError.h
//  LetsGoShopping
//
//  Created by Mick Mossman on 7/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CoreDataError : NSObject
-(void)showError: (NSError*) err;
@end
