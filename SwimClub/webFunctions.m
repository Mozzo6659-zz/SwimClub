//
//  webFunctions.m
//  SwimClub
//
//  Created by Mick Mossman on 17/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "webFunctions.h"

@implementation webFunctions
//@synthesize eventsuploadedList;
@synthesize responseData; //gonna return this
@synthesize errordesc;

-(void)getEvents {
    
    [self resetVars];
    NSString *envelopeText = [self getStartEnvelope];
    NSString *thecommand = @"GetEventsToDownloadJSON";
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\" />\n"];
    envelopeText = [envelopeText stringByAppendingString:@"</soap12:Body>\n"];
    envelopeText = [envelopeText stringByAppendingString:@"</soap12:Envelope>"];
    
    [self sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        if (error) {
            //errordesc = [error localizedDescription];
        } else {
             NSString *cmdResult = [thecommand stringByAppendingString:@"Result"];
            NSString *sJSON = [self filertSOAPJSONstring:str srchstring:cmdResult];
            
            //NSLog(@"%@",sJSON);
            NSData *dJSON = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            responseData = [NSJSONSerialization JSONObjectWithData:dJSON options:kNilOptions error:&err];
            // NSLog(@"err=%@",err.description);
            //NSLog(@"count=%lu",[responseData count]);
            
            //both of these work
            
             for (id item in responseData) {
                 NSLog(@"%@",[item valueForKey:@"eventid"]);
             }
        }
    }];
    
}

-(void)resetVars {
    errordesc = nil;
    responseData = [[NSMutableDictionary alloc] init];
    
}
/*
-(void)addNewMember:(SwimClubMembers*)newmember {
    
    NSString *sdateofbirth = @"1900-01-01";
    NSString *envelopeText = [self getStartEnvelope];
    NSString *thecommand = @"AddmemberJSON";
    
    if (newmember.dateofbirth != nil) {
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"YYYY-MM-dd"];
        sdateofbirth = [f2 stringFromDate:newmember.dateofbirth];
    }
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\">\n"];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scmemberid>%d</scmemberid>\n",newmember.webid];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scname>%@</scname>\n",newmember.membername];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scgender>%@</scgender>\n",newmember.gender];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scswimclubid>%d</scswimclubid>\n",newmember.swimclubid];
    envelopeText = [envelopeText stringByAppendingFormat:@"<sconekseconds>%d</sconekseconds>\n",newmember.onekseconds];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scdateofbirth>%@</scdateofbirth>\n",sdateofbirth];
    envelopeText = [envelopeText stringByAppendingFormat:@"<scemailaddress>%@</scemailaddress>\n",newmember.emailaddress];
    envelopeText = [envelopeText stringByAppendingFormat:@"</%@>\n",thecommand];
    envelopeText = [envelopeText stringByAppendingString:[self getEndEnvelope]];
    
    [self sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        } else {
            NSLog(@"%@",str);
        }
    }];
    
}

-(void)updateMember:(SwimClubMembers*)member{
    [self resetVars];
}

-(void)addEvent:(SwimClubEvents*)event{
    [self resetVars];
}

-(void)updateEvent:(SwimClubEvents*)event{
    [self resetVars];
}
*/
#pragma web cnnections


-(NSString*)getStartEnvelope {
   
    NSString *envelopeText = @"<soap12:Envelope ";
    envelopeText = [envelopeText stringByAppendingString:@"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "];
    envelopeText = [envelopeText stringByAppendingString:@"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"];
    envelopeText = [envelopeText stringByAppendingString:@"<soap12:Body>\n"];
    envelopeText = [envelopeText stringByAppendingString:@"<"];
    
    return envelopeText;
}

//I DONT THINK ILL USE THIS LEAVE HERE ANYWAYS. ITS NOT RECOMMENDED TO BLOCK THE MAIN THREAD
/*
-(void)sendSynchronousRequest:(NSString*)envelopeText thecommand:(NSString*) cmd {
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [self getURL];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    
    NSString *cmdfull = @"https://hammerheadsoftware.com.au/";
    cmdfull = [cmdfull stringByAppendingFormat:@"%@",cmd];
    [request addValue:cmdfull forHTTPHeaderField:@"SOAPAction"];
    
    
    //NSLog(@"cmd=%@",cmdfull);
    //[request setValue:@"www.hammerheadsoftware.com.au" forHTTPHeaderField:@"Host"];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%lu",[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    
    
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *thetask = [session dataTaskWithRequest:request];
    
    
}
*/

-(void)sendRequest:(NSString*)envelopeText thecommand:(NSString*)cmd completion:(void (^)(NSString *, NSError *))completionBlock {
    //NSLog(@"%@",envelopeText);
    [self resetVars];
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [self getURL];
   
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    //[request addValue:@"text/xml" forHTTPHeaderField:@"Conteny-Type"]; //not surte about these
    //[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    
    
    
    [request setValue:@"www.hammerheadsoftware.com.au" forHTTPHeaderField:@"Host"];
    [request setValue:@"application/soap+xml" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Accept"];
    //[request addValue:@"text/xml" forHTTPHeaderField:@"Conteny-Type"] this ony for soap notsoap soap12;
    [request setValue:[NSString stringWithFormat:@"%lu",[envelope length]] forHTTPHeaderField:@"Content-Length"];
    //Soap action required fo doing a select GetEvetsToDownloadJSON
    //doenst seem to be required for AddMemberJSON
    NSString *cmdfull = @"https://hammerheadsoftware.com.au/";
    cmdfull = [cmdfull stringByAppendingFormat:@"%@",cmd];
    //NSLog(@"SOAPAction=%@",cmdfull);
    [request addValue:cmdfull forHTTPHeaderField:@"SOAPAction"];
    //NSLog(@"%@",envelopeText);
    [request setHTTPBody:envelope];
    
    //NSLog(@"content length %lu",[envelope length]);
    
  
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //NSLog(@"%@",request.HTTPBody);
    //NSLog(@"%@",request.mainDocumentURL);
    //NSURLSessionDataTask *mytesk = [session dataTaskWithRequest:request co];
    
    NSURLSessionDataTask *thetask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        //NSLog(@"response=%@",response.description);
        
        //NSLog(@"error=%@",error.description);
        //NSLog(@"datalth=%lu",[data length]);
        //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        void (^runAfterCompletion)(void) = ^void (void) {
            if (error) {
                completionBlock (nil, error);
            } else {
                NSString *dataText = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                completionBlock(dataText, error);
            }
        };
        
        //Dispatch the queue
        dispatch_async(dispatch_get_main_queue(), runAfterCompletion);
        
    }];
    [thetask resume];

}

-(NSString*)getEndEnvelope {
    

    NSString* envelopeText =@"</soap12:Body>\n";
    envelopeText = [envelopeText stringByAppendingString:@"</soap12:Envelope>"];
    
    //NSLog(@"SOAP :%@",envelopeText);
    return envelopeText;
    
}
-(NSString*)getURL {
    return  @"https:/www.hammerheadsoftware.com.au/swimclubws/swimclubservice.asmx";

}
-(NSString*)filertSOAPJSONstring:(NSString*)strTosearch srchstring:(NSString*)cmdname {
    //This will return the entire JSON string from within the SOAP wrapper
    //dont pass the < characters in cmdname
    
    //NSString *newsrch = [strTosearch stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *startBlock = @"<";
    NSString *endBlock = @"</";
    NSString *retresult = [[NSString alloc] init];
    startBlock = [startBlock stringByAppendingString:cmdname];
    startBlock = [startBlock stringByAppendingString:@">"];
    endBlock = [endBlock stringByAppendingString:cmdname];
    endBlock = [endBlock stringByAppendingString:@">"];
    NSRange startrange = [strTosearch rangeOfString:startBlock];
    NSRange endrange = [strTosearch rangeOfString:endBlock];
    
    int startIndex = (int) startrange.location + (int) startrange.length;
    int endindex = (int) endrange.location - startIndex;
    
    retresult = [strTosearch substringWithRange:NSMakeRange(startIndex,endindex)];
    //NSLog(@"result=%@",retresult);
    return retresult;
}
@end



