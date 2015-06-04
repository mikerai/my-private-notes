//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Simon on 10/8/13.
//
//

#import "NewRecipeViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface NewRecipeViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientsTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;

@end

@implementation NewRecipeViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) addBlurEffect {
    // Add blur view
    CGRect bounds = self.navigationController.navigationBar.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar addSubview:visualEffectView];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar sendSubviewToBack:visualEffectView];
    
    // Here you can add visual effects to any UIView control.
    // Replace custom view with navigation bar in above code to add effects to custom view.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameTextField.delegate = self;
    _prepTimeTextField.delegate = self;
    _ingredientsTextField.delegate = self;
    
    self.addButton.layer.borderWidth = 1.0f;
    self.takeButton.layer.borderWidth = 1.0f;
    
    self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.takeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.addButton.layer.cornerRadius = 0.0f;
    self.takeButton.layer.cornerRadius = 0.0f;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = _recipeImageView.bounds;
    [_recipeImageView addSubview:visualEffectView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showPhotoLibary];
    }
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    //[self.navigationController presentModalViewController: mediaUI animated: YES];
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Create PFObject with recipe information
    PFObject *recipe = [PFObject objectWithClassName:@"Recipe"];
    [recipe setObject:_nameTextField.text forKey:@"name"];
    [recipe setObject:_prepTimeTextField.text forKey:@"prepTime"];
    
    NSArray *ingredients = [_ingredientsTextField.text componentsSeparatedByString: @","];
    [recipe setObject:ingredients forKey:@"ingredients"];
    
    // Recipe image
    NSData *imageData = UIImageJPEGRepresentation(_recipeImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _nameTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [recipe setObject:imageFile forKey:@"imageFile"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];

    // Upload recipe to Parse
    [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the recipe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setRecipeImageView:nil];
    [self setNameTextField:nil];
    [self setPrepTimeTextField:nil];
    [self setIngredientsTextField:nil];
    [super viewDidUnload];
}


- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {

    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.recipeImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
