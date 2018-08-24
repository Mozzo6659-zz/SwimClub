//
//  CommonFunctions.m
//  SwimClub
//
//  Created by Mick Mossman on 16/7/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions

-(NSString*)makePhotoName:(int)memberid {
    //NSLog(@"memberid=%d",memberid);
    
    NSString *photoname = [NSString stringWithFormat:@"%d",memberid];
    
    photoname = [photoname stringByAppendingString:@".jpg"];
    
    return photoname;
}

-(NSString*)getFullPhotoPath: (NSString*)photoname {
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *fullpathandfile  = [stringPath stringByAppendingPathComponent:photoname];
    //fullpathandfile = [fullpathandfile stringByAppendingString:photoname];
    
    return fullpathandfile;
}
@end


