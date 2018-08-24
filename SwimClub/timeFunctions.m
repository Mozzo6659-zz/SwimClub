//
//  timeFunctions.m
//  SwimClub
//
//  Created by Mick Mossman on 12/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//


#import "timeFunctions.h"

@interface timeFunctions ()

@end
@implementation timeFunctions

-(int)adjustOnekSecondsForDistance:(int)distance onekseconds:(int) timeinseconds {
    /*Adjusts the one k time to the distance for the event*/
    float divBy = distance / 1000.00;
    //NSLog(@"divby=%f",divBy);
    
    return timeinseconds * divBy;
    
}

-(NSString*)convertSecondsToTime:(int) timeinseconds {
    int hrs = timeinseconds / 3600;
    
    int seconds = timeinseconds  % 60;
    int minutes = (timeinseconds / 60) % 60;
    int hours = hrs;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}
-(NSString*)validateMinutesSeconds:(int) howmany {
    NSString *errmsg;
    
        if (howmany > 59 || howmany < 0) {
            errmsg = @"Invalid time format";
        }
        
    
    return errmsg;
}
-(int)findTimeDiffinSeconds:(NSDate *)startDate {
    NSDate *toDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&startDate
                 interval:NULL forDate:startDate];
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&toDate
                 interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitSecond
                                               fromDate:startDate toDate:toDate options:0];
    
    
    return (int) [difference second];
}
-(int)convertTimeToSeconds:(NSString*) thetimeClock {
    NSArray *thetime = [thetimeClock componentsSeparatedByString: @":"];
    
    int theSeconds = ([thetime[0] intValue] * 3600) + ([thetime[1] intValue] * 60) + [thetime[2] intValue];
    return theSeconds;
}

-(BOOL)isValidDate: (int)theday themonth:(int)mnth theyear:(int)yr {
    BOOL isOk = NO;
    NSString *dttocheck = [NSString stringWithFormat:@"%02d/%02d/%04d",theday,mnth,yr];
   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];// here set format which you want...
    NSDate *date = [dateFormat dateFromString:dttocheck];
    if (date!=nil) {
        isOk=YES;
    }
    
    return isOk;
}
@end
