//
//  RtmpShare.h
//  kxmovie
//
//  Created by 张新华 on 16/6/24.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "librtmp/rtmp.h"
#import "librtmp/amf.h"
#import "librtmp/log.h"

@interface RtmpManager:NSObject
{
    BOOL bLiveStream;
    int bufsize;
    long countbufsize;
    int nRead;
    NSMutableDictionary* dicPara;
}

@property RTMP* rtmp;
- (void)rePlay;
-(int)sendNetPing:(double)key;
+(instancetype) shareInstance ;
-(void)initRtmp;
-(void)cleanSockt;
-(int)connectServer:(NSString *)path paraDic:(NSMutableDictionary *)dic valid:(BOOL)valid;
-(NSMutableDictionary*) getParam;
@end
