//
//  BarcodeView.m
//  barcodetest
//
//  Created by Kent Miller on 9/23/13.
//  Copyright (c) 2013 Kent Miller. All rights reserved.
//

#import "BarcodeView.h"

@interface BarcodeView ()

@end

@implementation BarcodeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self capture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)capture
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
   
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input)
    {
        NSLog(@"Error: %@", error);
        return;
    }

    [session addInput:input];
    
    //Turn on point autofocus for middle of view
    [device lockForConfiguration:&error];
    CGPoint point = CGPointMake(0.5,0.5);
    [device setFocusPointOfInterest:point];
    [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    [device unlockForConfiguration];

    //Add the metadata output device
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];

    NSLog(@"%lu",output.availableMetadataObjectTypes.count);
    for (NSString *s in output.availableMetadataObjectTypes)
        NSLog(@"%@",s);
    
    //You should check here to see if the session supports these types, if they aren't support you'll get an exception
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode];
    output.rectOfInterest = self.livevideo.bounds;
    
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    newCaptureVideoPreviewLayer.frame = self.livevideo.bounds;
    newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.livevideo.layer insertSublayer:newCaptureVideoPreviewLayer above:self.livevideo.layer];
    
    [session startRunning];


}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadata in metadataObjects)
    {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code])
        {
            NSString *code =[(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            NSLog(@"Read EAN13 %@", code);
            self.barcode.text = code;
        }
        else if ([metadata.type isEqualToString:AVMetadataObjectTypeUPCECode])
        {
            NSString *code =[(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            NSLog(@"Read UPC-E %@", code);
            self.barcode.text = code;
        }
        else if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN8Code])
        {
            NSString *code =[(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            NSLog(@"Read EAN8 %@", code);
            self.barcode.text = code;
        }
    }
}

@end
