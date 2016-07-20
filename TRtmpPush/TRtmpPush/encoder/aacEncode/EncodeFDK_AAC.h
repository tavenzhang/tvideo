//
//  EncodeFDK_AAC.h
//  FFmpeg_X264_Codec
//
//  Created by 张新华 on 16/6/21.
//  Copyright © 2016年 suntongmian@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "libavcodec/avcodec.h"
#import "libavformat/avformat.h"
#import "VAMuxerOut.h"

@interface EncodeFDK_AAC : NSObject
/*
 * 设置aac para
 * 0: 成功； －1: 失败
 */
@property AVFormatContext*                    pFormatCtx;

-(int)setAACResource;

-(int)encodeAAC:(CMSampleBufferRef)sampleBuffer;

@end
