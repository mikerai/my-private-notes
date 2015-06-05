//
//  RecipeBookViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 26/7/13.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginVC.h"

@interface RecipeBookViewController : PFQueryTableViewController

-(IBAction)logOut:(id)sender;

@end
