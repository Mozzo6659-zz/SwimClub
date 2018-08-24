//
//  timeFunctions.h
//  SwimClub
//
//  Created by Mick Mossman on 12/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeFunctions : NSObject {


}
-(int)adjustOnekSecondsForDistance:(int)distance onekseconds:(int)timeinseconds;
-(NSString*)convertSecondsToTime: (int) timeinseconds;
-(int)convertTimeToSeconds: (NSString*) thetimeClock;
-(int)findTimeDiffinSeconds: (NSDate*) startDate;
-(NSString*)validateMinutesSeconds: (int) howmany;
-(BOOL)isValidDate: (int)theday themonth:(int)mnth theyear:(int)yr;

@end

