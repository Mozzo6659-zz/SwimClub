//
//  SwimClubGroups+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 8/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubGroups+CoreDataProperties.h"

@implementation SwimClubGroups (CoreDataProperties)

+ (NSFetchRequest<SwimClubGroups *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Groups"];
}

@dynamic groupid;
@dynamic groupname;
@dynamic startseconds;
@dynamic endseconds;
@dynamic members;

@end
