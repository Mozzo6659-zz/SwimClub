//
//  SwimClubEventResults+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 27/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubEventResults+CoreDataProperties.h"

@implementation SwimClubEventResults (CoreDataProperties)

+ (NSFetchRequest<SwimClubEventResults *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventResults"];
}

@dynamic diffseconds;
@dynamic eventid;
@dynamic expectedseconds;
@dynamic memberid;
@dynamic resultseconds;
@dynamic event;
@dynamic member;

@end
