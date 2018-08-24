//
//  SwimClubEvents+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 27/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubEvents+CoreDataProperties.h"

@implementation SwimClubEvents (CoreDataProperties)

+ (NSFetchRequest<SwimClubEvents *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Events"];
}

@dynamic datachanged;
@dynamic distancemtrs;
@dynamic downloadeddate;
@dynamic eventdate;
@dynamic eventid;
@dynamic eventname;
@dynamic isfinished;
@dynamic location;
@dynamic uploadeddate;
@dynamic webid;
@dynamic eventResults;

@end
