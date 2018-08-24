//
//  SwimClubSysControl+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 2/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubSysControl+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubSysControl (CoreDataProperties)

+ (NSFetchRequest<SwimClubSysControl *> *)fetchRequest;

@property (nonatomic) int32_t runningeventid;
@property (nonatomic) int32_t runningeventseconds;
@property (nullable, nonatomic, copy) NSDate *runningeventstopped;

@end

NS_ASSUME_NONNULL_END
