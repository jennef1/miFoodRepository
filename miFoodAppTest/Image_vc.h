//
//  Image_vc.h
//  
//
//  Created by Fabian Jenne on 25.10.15.
//
//

#import <UIKit/UIKit.h>

@interface Image_vc : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UIView   *emptyView0;
@property (strong, nonatomic) UILabel  *emptyViewLabel;
@property (strong, nonatomic) UIButton *selectImageButton;
@property (strong, nonatomic) UIImage  *selectImage;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UIImageView *imageView3;

@property BOOL newMedia;
@property BOOL imageSelected;

- (void)addImagePressed:(id)sender;
- (void)useCameraForImage;
- (void)usePhotoLibraryForImage;
- (void)imageTapped:(UITapGestureRecognizer *)gestureRecognizer;


// navigation
@property (nonatomic, strong) NSString *segueIDString;

- (IBAction)backPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end
