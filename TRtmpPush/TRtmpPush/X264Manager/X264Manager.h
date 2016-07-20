//
//  X264Manager.h
//  FFmpeg_X264_Codec
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "libavformat/avformat.h"



@interface X264Manager : NSObject

- (instancetype)initWithPFormatCtx;

@property AVFormatContext                    *pFormatCtx;
/*
 * 设置X264
 * 0: 成功； －1: 失败
 */
- (int)setX264Resource;

/*
 * 将CMSampleBufferRef格式的数据编码成h264并写入文件
 */
- (void)encoderToH264:(CMSampleBufferRef)sampleBuffer;

/*
 * 释放资源
 */
- (void)freeX264Resource;


@end
