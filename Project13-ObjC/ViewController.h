//
//  ViewController.h
//  Project13-ObjC
//
//  Created by g tokman on 4/5/17.
//  Copyright © 2017 garytokman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property CIContext *context;
@property CIFilter *currentFilter;
@property UIImage *currentImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

- (IBAction)changeFilterAction:(UIButton *)sender;
- (IBAction)saveAction:(UIButton *)sender;
- (IBAction)intensitySliderChanged:(UISlider *)sender;
- (IBAction)importImageAction:(UIBarButtonItem *)sender;

@end

