//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Simon on 10/8/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NewRecipeViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;

@end
