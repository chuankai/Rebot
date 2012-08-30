//
//  IPenController.m
//  iNpen
//
//  Created by Lin Chuankai on 8/24/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import "IPenController.h"
#import "TCPServer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>

static IPenController *sharedController = nil;

@implementation IPenController
{
    NSMutableDictionary *waveForms;
    CMMotionManager *motionManager;
    NSTimer *controllerTimer;
    TCPServer *server;
}


- (id)init
{
    if (!sharedController) {
        if (self = [super init]) {
            waveForms = [[NSMutableDictionary alloc] initWithCapacity:0];
            if (![self loadWaveForms]) {
                sharedController = self;
            }
            server = [[TCPServer alloc] init];
        }
    }
    
    return sharedController;
}

+ (id)sharedController
{
    if (!sharedController) {
        sharedController = [[IPenController alloc] init];
    }
        
    return sharedController;
}

- (BOOL)loadWaveForms
{
    NSArray *waveFiles = [NSArray arrayWithObjects:@"4ms_SQR_L", @"4ms_SQR_R", @"6ms_SQR_L", @"6ms_SQR_R", nil];
    
    for (NSString *file in waveFiles) {
        SystemSoundID soundID;

        NSURL *url = [[NSBundle mainBundle] URLForResource:file withExtension:@"wav"];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID)) {
            return YES;
        } else {
            [waveForms setObject:[NSNumber numberWithUnsignedInt:soundID] forKey:file];
            NSLog(@"%@ -> %lu", file, soundID);
        }
    }

    return NO;
}

- (void)initMotionMeter
{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 0.01; //second
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
}

- (void)controller:(NSTimer *)timer
{
    NSLog(@"Pitch: %f", motionManager.deviceMotion.attitude.pitch);
    NSLog(@"Angular speed: %f", motionManager.deviceMotion.rotationRate.x);
//    AudioServicesPlayAlertSound([[waveForms objectForKey:@"4ms_SQR_R"] unsignedIntValue]);
}

- (void)start
{
    NSLog(@"Start iPen Controller");
    
    [self initMotionMeter];
    
//    controllerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(controller:) userInfo:nil repeats:YES];
    [server startWithPort:33354 UsingBlock:^(NSInputStream *stream){
        uint8_t buf[1];
        NSInteger len;
        len = [(NSInputStream *)stream read:buf maxLength:1];
        if (len) {
            NSLog(@"Input: %c", buf[0]);
            
            switch (buf[0]) {
                case 'F':
                    AudioServicesPlayAlertSound([[waveForms objectForKey:@"6ms_SQR_R"] unsignedIntValue]);
                    break;

                case 'R':
                    AudioServicesPlayAlertSound([[waveForms objectForKey:@"8ms_SQR_R"] unsignedIntValue]);                    
                    break;

                case 'S':
                    AudioServicesPlayAlertSound([[waveForms objectForKey:@"4ms_SQR_R"] unsignedIntValue]);
                    break;

                default:
                    break;
            }
        }
        
    }];
}

- (void)stop
{
    NSLog(@"Stop iPen Controller");
    
//    [controllerTimer invalidate];
    [server stop];
}

@end
