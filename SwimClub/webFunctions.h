//
//  webFunctions.h
//  SwimClub
//
//  Created by Mick Mossman on 17/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataClass.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"

@interface webFunctions : NSObject {
    
}
//@property(strong,nonatomic) NSMutableArray *eventsuploadedList;
@property (strong,nonatomic) NSMutableDictionary *responseData;
@property (weak,nonatomic) NSString *errordesc;

/*
-(void)addNewMember:(SwimClubMembers*)newmember;

-(void)updateMember:(SwimClubMembers*)member;

-(void)addEvent:(SwimClubEvents*)event;

-(void)updateEvent:(SwimClubEvents*)event;
*/
-(void)resetVars;
-(void)getEvents;
-(void)sendRequest:(NSString*)envelopeText thecommand:(NSString*)cmd completion:(void (^)(NSString *, NSError *))completionBlock;

-(NSString*)filertSOAPJSONstring:(NSString*)strTosearch srchstring:(NSString*)cmdname;

-(NSString*)getStartEnvelope;
-(NSString*)getEndEnvelope;
@end
