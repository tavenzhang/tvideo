//
// Created by 张新华 on 16/6/17.
// Copyright (c) 2016 suntongmian@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libavcodec/avcodec.h"
#import "libavformat/avformat.h"
#import "libavutil/mathematics.h"

@interface MuxerVo:NSObject

@property AVPacket avPacket;
@property BOOL isVideo;

- (instancetype)initWithAvPacket:(AVPacket )avPacket isVideo:(BOOL)isVideo;

+ (instancetype)voWithAvPacket:(AVPacket )avPacket isVideo:(BOOL)isVideo;
@end


@interface VAMuxerOut : NSObject
{

}
+ (VAMuxerOut *)instance;

/*
 * 设置输出格式
 * 0: 成功； －1: 失败
 */
-(int)setOutputHeader:(char *)outPath vfmt:(AVFormatContext*)videoFmt afmt:(AVFormatContext*)audioFmt;
-(int)encodeVAMuxer:(AVPacket *)avpk isVideo:(BOOL)videoType;
-(void)writeTrailer;
@end
