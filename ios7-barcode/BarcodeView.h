//
//  BarcodeView.h
//  barcodetest
//
//  Created by Kent Miller on 9/23/13.
//  Copyright (c) 2013 Kent Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BarcodeView : UIViewController <AVCaptureMetadataOutputObjectsDelegate>


@property (strong, nonatomic) IBOutlet UILabel *barcode;
@property (strong, nonatomic) IBOutlet UIView *livevideo;

@end
