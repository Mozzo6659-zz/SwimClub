//
//  SwimClubAgeGroups+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 29/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubAgeGroups+CoreDataProperties.h"

@implementation SwimClubAgeGroups (CoreDataProperties)

+ (NSFetchRequest<SwimClubAgeGroups *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AgeGroups"];
}

@dynamic agegroupname;
@dynamic maxage;
@dynamic minage;
@dynamic agegroupid;
@dynamic members;

@end
