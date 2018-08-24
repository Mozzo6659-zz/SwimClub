//
//  SwimClubSysControl+CoreDataProperties.m
//  SwimClub
//
//  Created by Mick Mossman on 2/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubSysControl+CoreDataProperties.h"

@implementation SwimClubSysControl (CoreDataProperties)

+ (NSFetchRequest<SwimClubSysControl *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SysControl"];
}

@dynamic runningeventid;
@dynamic runningeventseconds;
@dynamic runningeventstopped;

@end
