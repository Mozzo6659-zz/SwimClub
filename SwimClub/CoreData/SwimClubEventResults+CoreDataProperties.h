//
//  SwimClubEventResults+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 27/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubEventResults+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubEventResults (CoreDataProperties)

+ (NSFetchRequest<SwimClubEventResults *> *)fetchRequest;

@property (nonatomic) int16_t diffseconds;
@property (nonatomic) int32_t eventid;
@property (nonatomic) int16_t expectedseconds;
@property (nonatomic) int32_t memberid;
@property (nonatomic) int16_t resultseconds;
@property (nullable, nonatomic, retain) SwimClubEvents *event;
@property (nullable, nonatomic, retain) SwimClubMembers *member;

@end

NS_ASSUME_NONNULL_END
