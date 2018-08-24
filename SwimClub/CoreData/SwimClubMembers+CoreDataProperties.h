//
//  SwimClubMembers+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 3/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubMembers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubMembers (CoreDataProperties)

+ (NSFetchRequest<SwimClubMembers *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t datachanged;
@property (nullable, nonatomic, copy) NSDate *dateofbirth;
@property (nullable, nonatomic, copy) NSString *emailaddress;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nonatomic) int32_t memberid;
@property (nullable, nonatomic, copy) NSString *membername;
@property (nonatomic) int16_t onekseconds;
@property (nonatomic) int16_t swimclubid;
@property (nonatomic) int32_t webid;
@property (nonatomic) int16_t selectedforevent;
@property (nullable, nonatomic, retain) SwimClubAgeGroups *agegroup;
@property (nullable, nonatomic, retain) SwimClubEventResults *eventresults;
@property (nullable, nonatomic, retain) SwimClubGroups *membergroup;

@end

NS_ASSUME_NONNULL_END
