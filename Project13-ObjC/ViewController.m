//
//  ViewController.m
//  Project13-ObjC
//
//  Created by g tokman on 4/5/17.
//  Copyright © 2017 garytokman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.context = [CIContext new];
    self.currentFilter = [CIFilter filterWithName:@"CISepiaTone"];
}

#pragma mark - Helper

- (void)applyProcessing {
    [self.currentFilter setValue:[NSNumber numberWithFloat:self.intensitySlider.value] forKey:kCIInputIntensityKey];
    CIImage *image = [self.currentFilter outputImage];
    struct CGImage *cgImageRef = [self.context createCGImage:image fromRect:[image extent]];
    
    if (cgImageRef) {
        self.imageView.image = [[UIImage alloc]initWithCGImage:cgImageRef];
    }
}

#pragma mark - Actions

- (IBAction)changeFilterAction:(UIButton *)sender {
}

- (IBAction)saveAction:(UIButton *)sender {
}

- (IBAction)intensitySliderChanged:(UISlider *)sender {
    [self applyProcessing];
}

- (IBAction)importImageAction:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (image) {
        self.currentImage = image;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        CIImage *beginImage = [[CIImage alloc]initWithImage:image];
        [self.currentFilter setValue:beginImage forKey:kCIInputImageKey];
        [self applyProcessing];
    }
}

@end
