//
//  SwimClubMembers+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 3/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubMembers+CoreDataProperties.h"

@implementation SwimClubMembers (CoreDataProperties)

+ (NSFetchRequest<SwimClubMembers *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Members"];
}

@dynamic age;
@dynamic datachanged;
@dynamic dateofbirth;
@dynamic emailaddress;
@dynamic gender;
@dynamic memberid;
@dynamic membername;
@dynamic onekseconds;
@dynamic swimclubid;
@dynamic webid;
@dynamic selectedforevent;
@dynamic agegroup;
@dynamic eventresults;
@dynamic membergroup;

@end
