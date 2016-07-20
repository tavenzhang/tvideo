//
//  Rtmp.h
//  kxmovie
//
//  Created by 张新华 on 16/6/6.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "librtmp/rtmp.h"
#import "librtmp/amf.h"
#import "librtmp/log.h"

extern char* lastRtmpPath;


int mySendPlay(RTMP *r);

char *printAMFProps(AMFObject *obj);

void RTMP_handleReg();

int SendCallPing(RTMP *r, double key);


@interface rtmpHelp : NSObject{
    NSLock* myPlock;
}

@property NSLock *plock;

-(int)RTMP_TestConnect:(NSString*)path;

+ (rtmpHelp *)instance;


@end