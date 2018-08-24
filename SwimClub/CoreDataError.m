//
//  CoreDataError.m
//  LetsGoShopping
//
//  Created by Mick Mossman on 7/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataError.h"

@implementation CoreDataError 
    
-(void)showError:(NSError *)err {
    /*
    UIAlertView *noLists =
    [[UIAlertView alloc] initWithTitle:@"Data Error" 
                               message: @"Oops an error occurred. Please restart the app."
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [noLists show];
    */
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:@"Data Error"
                                 message:@"Oops an error occurred. Please restart the app."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    
    [alert addAction:okButton];
    
    /*[self presentViewController:alert animated:YES completion:nil];*/
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
        viewController = viewController.presentedViewController;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:alert.view
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1
                                      constant:viewController.view.frame.size.height*2.0f];
    
    [alert.view addConstraint:constraint];
    [viewController presentViewController:alert animated:YES completion:^{}];

}


@end
