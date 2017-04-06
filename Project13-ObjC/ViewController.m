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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentImage) {
        [self.placeHolderLabel setHidden:YES];
    }
}

#pragma mark - Helper

- (void)applyProcessing {
    
    NSArray *inputKeys = [self.currentFilter inputKeys];
    if ([inputKeys containsObject:kCIInputIntensityKey]) {
        [self.currentFilter setValue:[NSNumber numberWithFloat:[self.intensitySlider value]] forKey:kCIInputIntensityKey];
    }
    if ([inputKeys containsObject:kCIInputRadiusKey]) {
        [self.currentFilter setValue:[NSNumber numberWithFloat:[self.intensitySlider value] * 200] forKey:kCIInputRadiusKey];
    }
    if ([inputKeys containsObject:kCIInputScaleKey]) {
        [self.currentFilter setValue:[NSNumber numberWithFloat:[self.intensitySlider value] * 10] forKey:kCIInputScaleKey];
    }
    if ([inputKeys containsObject:kCIInputCenterKey]) {
        [self.currentFilter setValue:[CIVector
                                      vectorWithX:self.currentImage.size.width / 2 Y:self.currentImage.size.height / 2]
                              forKey:kCIInputCenterKey];
    }
    
    CIImage *outputImage = [self.currentFilter outputImage];
    struct CGImage *newCGImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    
    if (newCGImage) {
        self.imageView.image = [[UIImage alloc]initWithCGImage:newCGImage];
    }
}

#pragma mark - Actions

- (IBAction)changeFilterAction:(UIButton *)sender {
    void(^setFilter)(UIAlertAction*) = ^(UIAlertAction* action) {
        ViewController * __weak weakSelf = self;
        if (weakSelf.currentImage) {
            weakSelf.currentFilter = [CIFilter filterWithName:action.title];
            CIImage *beginImage = [[CIImage alloc]initWithImage:weakSelf.currentImage];
            [weakSelf.currentFilter setValue:beginImage forKey:kCIInputImageKey];
            [weakSelf applyProcessing];
        }
    };
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Choose filter"
                                          message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CIBumpDistortion" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CIGaussianBlur" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CIPixellate" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CISepiaTone" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CITwirlDistortion" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CIUnsharpMask" style:UIAlertActionStyleDefault handler:setFilter]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)saveAction:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:withContextInfo:), nil);
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

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error withContextInfo: (void  * _Nullable)contextInfo {
    if (error) {
        NSLog(@"Could not save: %@", error.localizedDescription);
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Saved!"
                                              message:@"Your new masterpiece was saved to Photos!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

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
