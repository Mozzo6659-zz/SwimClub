//
//  CommonFunctions.h
//  SwimClub
//
//  Created by Mick Mossman on 16/7/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject {
    
}

-(NSString*)getFullPhotoPath: (NSString*) photoname;
-(NSString*)makePhotoName: (int) memberid;

@end
