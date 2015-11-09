//
//  Image_vc.m
//  
//
//  Created by Fabian Jenne on 25.10.15.
//
//

#import "Image_vc.h"
#import "Singleton.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface Image_vc ()

@end

@implementation Image_vc

@synthesize scrollView ,contentView, selectImage, emptyViewLabel, emptyView0, imageView1, imageView2, imageView3, segueIDString, newMedia, imageSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([segueIDString isEqualToString:@"OverviewToImage"]) {
        self.nextButton.enabled   = NO;
        self.nextButton.tintColor = [UIColor clearColor];
    }
    
    // TODO: move to tapped View
}

- (void)viewDidAppear:(BOOL)animated {

    int imageWidth  = 225;
    int imageHeight = 225;
    int frameDeltaX = 25;
    
    UIColor *selectedBoarderColor = [UIColor colorWithRed:(254/255.0) green:(221/255.0) blue:(11/255.0) alpha:1];
    
    self.scrollView.frame       = CGRectMake(0, 0, self.view.frame.size.width, 304);
    CGRect scvFrame             = self.scrollView.frame;
    int contentWidth            = (scvFrame.size.width + 3*imageWidth + 3*frameDeltaX);
    self.scrollView.contentSize = CGSizeMake(contentWidth, scvFrame.size.height);
    
    // photo uploadView
    CGRect frame0   = CGRectMake((scvFrame.size.width/2 - imageWidth/2), 20, imageWidth, imageHeight);
    UIView *imv0    = [[UIView alloc]initWithFrame:frame0];
    self.emptyView0 = imv0;
    
    UILabel *imv0label      = [[UILabel alloc]initWithFrame:CGRectMake(20, (imv0.frame.size.height/2 - 10), (imv0.frame.size.width - 40), 20)];
    imv0label.font          = [UIFont fontWithName:@"GillSans" size:16.0];
    imv0label.textColor     = [UIColor lightGrayColor];
    imv0label.textAlignment = NSTextAlignmentCenter;
    self.emptyViewLabel     = imv0label;

    CGRect buttonFrame       = CGRectMake(frame0.size.width - 50, frame0.size.height - 50, 35, 35);
    UIButton *addImgBt       = [[UIButton alloc]initWithFrame:buttonFrame];
    [addImgBt setBackgroundImage:[UIImage imageNamed:@"cameraYellow"] forState:UIControlStateNormal];
    addImgBt.alpha           = 0.95;
    [addImgBt addTarget:self action:@selector(addImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.emptyView0 addSubview:addImgBt];
    if (self.imageSelected) {
        self.emptyViewLabel.text = @"";
        self.emptyView0.layer.borderColor = selectedBoarderColor.CGColor;
        self.emptyView0.layer.borderWidth = 0.8;
        UIImageView *imv  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.emptyView0.frame.size.width, self.emptyView0.frame.size.height)];
        imv.image         = self.selectImage;
        imv.contentMode   = UIViewContentModeScaleAspectFill;
        imv.clipsToBounds = YES;
        [self.emptyView0 addSubview:imv];
    } else {
        self.emptyViewLabel.text = @"Upload a cover photo";
        self.emptyView0.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.emptyView0.layer.borderWidth = 0.8;
        [self.emptyView0 addSubview:self.emptyViewLabel];
    }
    
    CGRect frame1      = CGRectOffset(frame0, (frame0.size.width + frameDeltaX), 0);
    UIImageView *imv1  = [[UIImageView alloc]initWithFrame:frame1];
    imv1.image         = [UIImage imageNamed:@"penne.jpg"];
    imv1.contentMode   = UIViewContentModeScaleAspectFill;
    imv1.clipsToBounds = YES;
    self.imageView1    = imv1;
    
    CGRect frame2      = CGRectOffset(frame1, (frame0.size.width + frameDeltaX), 0);
    UIImageView *imv2  = [[UIImageView alloc]initWithFrame:frame2];
    imv2.image         = [UIImage imageNamed:@"penne.jpg"];
    imv2.contentMode   = UIViewContentModeScaleAspectFill;
    imv2.clipsToBounds = YES;
    self.imageView2    = imv2;
    
    CGRect frame3      = CGRectOffset(frame2, (frame0.size.width + frameDeltaX), 0);
    UIImageView *imv3  = [[UIImageView alloc]initWithFrame:frame3];
    imv3.image         = [UIImage imageNamed:@"CookHead"];
    imv3.contentMode   = UIViewContentModeScaleAspectFill;
    imv3.clipsToBounds = YES;
    self.imageView3    = imv3;
    
    self.emptyView0.userInteractionEnabled = YES;
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    
    [self.contentView addSubview:self.emptyView0];
    [self.contentView addSubview:self.imageView1];
    [self.contentView addSubview:self.imageView2];
    [self.contentView addSubview:self.imageView3];
    
    // gesture for adding images
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] init];
    [singleTap0 addTarget:self action:@selector(addImagePressed:)];
    [singleTap0 setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] init];
    [singleTap1 addTarget:self action:@selector(imageTapped:)];
    [singleTap1 setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] init];
    [singleTap2 addTarget:self action:@selector(imageTapped:)];
    [singleTap2 setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] init];
    [singleTap3 addTarget:self action:@selector(imageTapped:)];
    [singleTap3 setNumberOfTapsRequired:1];
    
    [self.emptyView0 addGestureRecognizer:singleTap0];
    [self.imageView1 addGestureRecognizer:singleTap1];
    [self.imageView2 addGestureRecognizer:singleTap2];
    [self.imageView3 addGestureRecognizer:singleTap3];
}

#pragma mark - ImagePickerController Function

- (void)addImagePressed:(id)sender {
    
    [self.scrollView setContentOffset: CGPointMake(0,0) animated:YES];
    
    UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Upload a photo" message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *useCamera  = [UIAlertAction
                                    actionWithTitle:@"use camera" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [self useCameraForImage];
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
    
    UIAlertAction *chosePhoto = [UIAlertAction
                                    actionWithTitle:@"choose photo" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [self usePhotoLibraryForImage];
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
    
    UIAlertAction* cancel    = [UIAlertAction
                                    actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
    [alert addAction:useCamera];
    [alert addAction:chosePhoto];
    [alert addAction:cancel];
    
//    alert.view.tintColor = [UIColor orangeColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)useCameraForImage {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"
                                                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate      = self;
        picker.allowsEditing = YES;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        self.newMedia        = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)usePhotoLibraryForImage {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate      = self;
    picker.allowsEditing = YES;
    picker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    self.newMedia        = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image     = info[UIImagePickerControllerOriginalImage];
        self.selectImage   = image;
        self.imageSelected = YES;
        if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    Singleton *mySingleton       = [Singleton sharedSingleton];
    mySingleton.singl_coverImage = self.selectImage;
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image"
                              delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TapGestureRecognizer

- (void)imageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    self.emptyView0.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView1.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView2.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView3.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIColor *selectedBoarderColor        = [UIColor colorWithRed:(254/255.0) green:(221/255.0) blue:(11/255.0) alpha:1];
    UIImageView *theTappedImageView      = (UIImageView *)gestureRecognizer.view;
    theTappedImageView.layer.borderColor = selectedBoarderColor.CGColor;
    theTappedImageView.layer.borderWidth = 0.9;
    
    [self.scrollView setContentOffset:
     CGPointMake((theTappedImageView.frame.origin.x - self.view.frame.size.width/2 + theTappedImageView.frame.size.width/2), 0) animated:YES];
    
    Singleton *mySingleton       = [Singleton sharedSingleton];
    mySingleton.singl_coverImage = theTappedImageView.image;
}


- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextPressed:(id)sender {
    
    // TODO: create animation
    
    // animation before Overvie
    CGRect animFrame = CGRectMake(self.view.bounds.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIView *animationView         = [[UIView alloc]initWithFrame:animFrame];
    UIColor *backgrColor          = [UIColor colorWithRed:(246/255.0) green:(250/255.0) blue:(255/255.0) alpha:1];
    animationView.backgroundColor = backgrColor;
    
    UILabel *mainLabel      = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 140, 250, 50)];
    mainLabel.font          = [UIFont fontWithName:@"GillSans" size:30.0];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.text          = @"You're almost there";
    
    UILabel *subLabel       = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 190, 250, 50)];
    UIColor *textColor      = [UIColor colorWithRed:(254/255.0) green:(221/255.0) blue:(11/255.0) alpha:1];
    subLabel.font           = [UIFont fontWithName:@"GillSans Bold" size:28.0];
    subLabel.textColor      = textColor;
    subLabel.textAlignment  = NSTextAlignmentCenter;
    subLabel.text           = @"Only 3 steps to go";
    
    UIImageView *logo  = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 250, 88, 76)];
    logo.image         = [UIImage imageNamed:@"LogoWOtext"];
    
    float moveInMain   = (animationView.frame.size.width/2 + 125);
    float moveInSub    = (animationView.frame.size.width/2 + 125);
    float moveInLogo   = (animationView.frame.size.width/2 + 44);

    [animationView addSubview:mainLabel];
    [animationView addSubview:subLabel];
    [animationView addSubview:logo];
    [self.view addSubview:animationView];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         animationView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
                     }completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             mainLabel.transform = CGAffineTransformMakeTranslation(-moveInMain, 0);
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.2 animations:^{
                                 subLabel.transform = CGAffineTransformMakeTranslation(-moveInSub, 0);
                             } completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.2 animations:^{
                                     logo.transform = CGAffineTransformMakeTranslation(-moveInLogo, 0);
                                 } completion:^(BOOL finished) {
                                     
                                     [self performSegueWithIdentifier:@"ImageToOverview" sender:self];
                                 }];
                             }];
                         }];
                     }];

}
@end
