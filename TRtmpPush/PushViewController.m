//
// Created by 张新华 on 16/6/17.
// Copyright (c) 2016 suntongmian@163.com. All rights reserved.
//

#import "PushViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "X264Manager.h"
#import "EncoderAAC.h"
#import "VAMuxerOut.h"
#import "EncodeFDK_AAC.h"


@interface PushViewController() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@end

@implementation PushViewController {
    AVCaptureSession *videoSession;
    AVCaptureDevice *captureVideoDevice;
    AVCaptureDeviceInput *captureDeviceInput;
    AVCaptureVideoDataOutput *captureVideoDataOutput;
    //audiOutput
    AVCaptureAudioDataOutput *captureAudioDataOutput;
    AVCaptureConnection *audioCaptureConnection;

    AVCaptureConnection *videoCaptureConnection;

    AVCaptureVideoPreviewLayer *previewLayer;

    UIButton *recordVideoButton;

    X264Manager *manager264;
    EncoderAAC *encoderAAC;
    VAMuxerOut *vaMuxerOut;
    EncodeFDK_AAC *encodeFDK_AAC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

#pragma mark -- AVCaptureSession init
    videoSession = [[AVCaptureSession alloc] init];
//    videoSession.sessionPreset = AVCaptureSessionPresetHigh;
    videoSession.sessionPreset = AVCaptureSessionPresetMedium;
    NSArray *deviceList = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceList) {
        if ([device position] == AVCaptureDevicePositionFront) {
                captureVideoDevice = device;
        }
        else {
          //  captureVideoDevice = device;
        }

    }
    NSLog(@"device position==%ld", (long) [captureVideoDevice position]);

    NSError *error = nil;
    captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureVideoDevice error:&error];
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    //add audio and video device
    if ([videoSession canAddInput:audioInput]) {
        [videoSession addInput:audioInput];
    }
    if ([videoSession canAddInput:captureDeviceInput])
        [videoSession addInput:captureDeviceInput];
    else
        NSLog(@"Error: %@", error);

    dispatch_queue_t queue = dispatch_queue_create("myEncoderH264Queue", NULL);

    captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [captureVideoDataOutput setSampleBufferDelegate:self queue:queue];
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange],
            kCVPixelBufferPixelFormatTypeKey,
                    nil]; // X264_CSP_NV12
    captureVideoDataOutput.videoSettings = settings;
    captureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([videoSession canAddOutput:captureVideoDataOutput]) {
        [videoSession addOutput:captureVideoDataOutput];
    }
    
    
    // 保存Connection，用于在SampleBufferDelegate中判断数据来源（是Video/Audio？）
    videoCaptureConnection = [captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    [videoCaptureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [self->captureVideoDevice lockForConfiguration:&error];
     self->captureVideoDevice.activeVideoMinFrameDuration = CMTimeMake(1.0, 24);
     self->captureVideoDevice.activeVideoMaxFrameDuration = CMTimeMake(1.0, 25);
    //[videoCaptureConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    [self->captureVideoDevice unlockForConfiguration];

    dispatch_queue_t queueAudion = dispatch_queue_create("queueAudion", NULL);
    captureAudioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    //[captureAudioDataOutput audioSettings:pAudioSettings];
    [captureAudioDataOutput setSampleBufferDelegate:self queue:queueAudion];
    if ([videoSession canAddOutput:captureAudioDataOutput]) {
        [videoSession addOutput:captureAudioDataOutput];
    }
    audioCaptureConnection = [captureAudioDataOutput connectionWithMediaType:AVMediaTypeAudio];
   


#pragma mark -- AVCaptureVideoPreviewLayer init
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:videoSession];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResize; // 设置预览时的视频缩放方式
    [[previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait]; // 设置视频的朝向
    [self.view.layer addSublayer:previewLayer];

#pragma mark -- Button init
    recordVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordVideoButton.frame = CGRectMake(45, self.view.frame.size.height - 60 - 15, 60, 60);
    recordVideoButton.center = CGPointMake(self.view.frame.size.width / 2, recordVideoButton.frame.origin.y + recordVideoButton.frame.size.height / 2);

    CGFloat lineWidth = recordVideoButton.frame.size.width * 0.12f;
    recordVideoButton.layer.cornerRadius = recordVideoButton.frame.size.width / 2;
    recordVideoButton.layer.borderColor = [UIColor greenColor].CGColor;
    recordVideoButton.layer.borderWidth = lineWidth;

    [recordVideoButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [recordVideoButton setTitle:@"录制" forState:UIControlStateNormal];

    recordVideoButton.selected = NO;
    [recordVideoButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [recordVideoButton setTitle:@"停止" forState:UIControlStateSelected];

    [recordVideoButton addTarget:self action:@selector(recordVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordVideoButton];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(orientationChanged)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];

}

// 当前系统时间
- (NSString *)nowTime2String {
    NSString *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}



- (void)recordVideo:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {

        NSLog(@"recordVideo....");

#pragma mark -- manager X264
        manager264 = [[X264Manager alloc] init];
        [manager264 setX264Resource];
     //  encoderAAC = [[EncoderAAC alloc] init];
        encodeFDK_AAC=[[EncodeFDK_AAC alloc]init];
        vaMuxerOut = [VAMuxerOut instance];
        [vaMuxerOut setOutputHeader:"rtmp://192.168.31.216/live/taven" vfmt:[manager264 pFormatCtx] afmt:[encodeFDK_AAC pFormatCtx]];
        [videoSession startRunning];
    } else {
        NSLog(@"stopRecord!!!");
        [videoSession stopRunning];
        [manager264 freeX264Resource];
        [vaMuxerOut writeTrailer];
        manager264 = nil;
    }
}


#pragma mark --
#pragma mark --  AVCaptureVideo(Audio)DataOutputSampleBufferDelegate method

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    // 这里的sampleBuffer就是采集到的数据了，但它是Video还是Audio的数据，得根据connection来判断
    if (connection == videoCaptureConnection) {
  //      NSLog(@"startEncode --video");
//        NSLog(@"在这里获得video sampleBuffer，做进一步处理（编码H.264）");
    //  [manager264 encoderToH264:sampleBuffer];
    }
    else if (connection == audioCaptureConnection) {
        // Audio
       // NSLog(@"startEncode --audion 这里获得audio sampleBuffer，做进一步处理（编码AAC）");
        [encodeFDK_AAC encodeAAC:sampleBuffer];
    }

}

#pragma mark --
#pragma mark -- 锁定屏幕为竖屏
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [previewLayer removeFromSuperlayer];
    previewLayer = nil;
    videoSession = nil;
    manager264 = nil;
}

@end
