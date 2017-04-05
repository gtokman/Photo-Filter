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

#pragma mark - Actions

- (IBAction)changeFilterAction:(UIButton *)sender {
}

- (IBAction)saveAction:(UIButton *)sender {
}

- (IBAction)intensitySliderChanged:(UISlider *)sender {
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
    }
}

@end
