//
//  SwimClubMembers+CoreDataClass.m
//  SwimClub
//
//  Created by Mick Mossman on 3/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubMembers+CoreDataClass.h"

@implementation SwimClubMembers
-(int16_t)age {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:self.dateofbirth
                                                 toDate:[NSDate date]
                                                options:0];
    
    return (int) components.year;
    }
@end
