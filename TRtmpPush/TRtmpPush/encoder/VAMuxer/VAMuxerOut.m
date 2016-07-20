//
// Created by taven on 16/6/17.
// Copyright (c) 2016 suntongmian@163.com. All rights reserved.
//

#import "VAMuxerOut.h"
#import "libavformat/avformat.h"
#import "libavcodec/avcodec.h"
#import "libavformat/avformat.h"

@implementation MuxerVo {

}
- (instancetype)initWithAvPacket:(AVPacket)avPacket isVideo:(BOOL)isVideo {
    self = [super init];
    if (self) {
        AVPacket dst;
        av_copy_packet(&dst, &avPacket);
        self.avPacket = dst;
        //printf("encodeVAMuxer=%d----- Packet. size:%5d\t  pts:%lld ----dts=%llld\n--buf=%d",1,self.avPacket.size, self.avPacket.pts,self.avPacket.dts,self.avPacket.buf);
        self.isVideo = isVideo;
    }

    return self;
}

+ (instancetype)voWithAvPacket:(AVPacket)avPacket isVideo:(BOOL)isVideo {
    return [[self alloc] initWithAvPacket:avPacket isVideo:isVideo];
}

@end

@implementation VAMuxerOut {
    AVFormatContext *ofmt_ctx;

    int frameIndex;
    int videoindex_v;
    int videoindex_out;
    int audioindex_a;
    int audioindex_out;
    int buffBlockSize;
    int frame_index;
    int64_t cur_pts_v;
    int64_t cur_pts_a;
    NSLock *theLock;
    NSLock *theLockArray;
    NSMutableArray *packeList;
    BOOL isSending;
    AVBitStreamFilterContext* aacbsfc ;
}

+ (VAMuxerOut *)instance {
    static VAMuxerOut *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)dealloc {
    NSLog(@"will Destroy");
}

/***
 * 复制视频频流以及编码
 */
- (int)copyAndInitVcodec:(AVFormatContext *)octx inCtf:(AVFormatContext *)ictx {
    int ret;

    for (int i = 0; i < ictx->nb_streams; i++) {
        //Create output AVStream according to input AVStream
        if (ictx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            AVStream *in_stream = ictx->streams[i];
            AVStream *out_stream = avformat_new_stream(octx, in_stream->codec->codec);
            out_stream->time_base = in_stream->time_base;
            videoindex_v = i;
            if (!out_stream) {
                printf("Failed allocating output stream\n");
                ret = AVERROR_UNKNOWN;
                //end();
            }
            videoindex_out = out_stream->index;
            //Copy the settings of AVCodecContext
            if (avcodec_copy_context(out_stream->codec, in_stream->codec) < 0) {
                printf("Failed to copy context from input to output stream codec context\n");
                // goto end;
            }
            out_stream->codec->codec_tag = 0;
            if (octx->oformat->flags & AVFMT_GLOBALHEADER)
                out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
            break;
        
        }
    }
    return ret;
}

/**
 * 复制音频流以及编码
 */
- (int)copyAndInitAudioCodec:(AVFormatContext *)octx inCtf:(AVFormatContext *)ictx {
    int ret;
    for (int i = 0; i < ictx->nb_streams; i++) {
        //Create output AVStream according to input AVStream
        if (ictx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
            AVStream *in_stream = ictx->streams[i];
            AVStream *out_stream = avformat_new_stream(octx, in_stream->codec->codec);
            out_stream->time_base = in_stream->time_base;
            audioindex_a = i;
            if (!out_stream) {
                printf("Failed allocating output stream\n");
                ret = AVERROR_UNKNOWN;
                //  goto end;
            }
            audioindex_out = out_stream->index;
            //Copy the settings of AVCodecContext
            if (avcodec_copy_context(out_stream->codec, in_stream->codec) < 0) {
                printf("Failed to copy context from input to output stream codec context\n");
                // goto end;
            }
            out_stream->codec->codec_tag = 0;
            if (octx->oformat->flags & AVFMT_GLOBALHEADER)
                out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;

            break;
        }
    }
    return ret;
}

- (int)setOutputHeader:(char *)outPath vfmt:(AVFormatContext *)videoFmt afmt:(AVFormatContext *)audioFmt {
    int ret;
    theLock = [[NSLock alloc] init];
    packeList = [[NSMutableArray alloc] init];
    theLockArray = [[NSLock alloc] init];
    videoindex_v = audioindex_a = -1;
    cur_pts_a = cur_pts_v = 0;
    av_register_all(); // 注册FFmpeg所有编解码器
    avformat_network_init();
    //init ofmt_ctx
    ofmt_ctx = avformat_alloc_context();
    avformat_alloc_output_context2(&ofmt_ctx, NULL, "flv", outPath);
    
    //Open output URL
    if (avio_open(&ofmt_ctx->pb, outPath, AVIO_FLAG_READ_WRITE) < 0) {
        printf("Failed to open output file! \n");
        return -1;
    }

    //复制视频频
    if (videoFmt) {
        if ((ret = [self copyAndInitVcodec:ofmt_ctx inCtf:videoFmt]) < 0) {
            av_log(NULL, AV_LOG_ERROR, " get video stream fail\n");
            return ret;
        }
    }

    if (audioFmt) {
        if ((ret = [self copyAndInitAudioCodec:ofmt_ctx inCtf:audioFmt]) < 0) {
            av_log(NULL, AV_LOG_ERROR, " get audion stream fail\n");
            // return ret;
        }
    }
 
    //printf outinfo
  //  av_dump_format(ofmt_ctx, 0, "VAMuxer", 1);
    avformat_write_header(ofmt_ctx, NULL);
    //另起线程循环发包
    return 0;
}

- (void)sendVAMeassge {
    [theLock lock];
    isSending = YES;
    while (packeList.count > 0) {
        MuxerVo *vo;
        AVPacket pkt;
        vo = [packeList objectAtIndex:0];
        [packeList removeObjectAtIndex:0];
        pkt = [vo avPacket];
//        int ret = av_compare_ts(cur_pts_v, ofmt_ctx->streams[videoindex_out]->time_base, cur_pts_a, ofmt_ctx->streams[audioindex_out]->time_base);
//        //Get an AVPacket
//        if (ret <= 0) {
//            for (int i = 0; i < packeList.count; i++) {
//                if ([packeList[i] isVideo]) {
//                    vo = [packeList objectAtIndex:i];
//                    [packeList removeObjectAtIndex:i];
//                    break;
//                }
//            }
//            if(!vo)
//            {
//                continue;
//            }
//            pkt = [vo avPacket];
//            cur_pts_v = pkt.pts;
//
//        } else {
//            for (int t = 0; t < packeList.count; t++) {
//                if (![packeList[t] isVideo]) {
//                    vo = [packeList objectAtIndex:t];
//                    [packeList removeObjectAtIndex:t];
//                    break;
//                }
//            }
//            if(!vo)
//            {
//                continue;
//            }
//            pkt = [vo avPacket];
//            cur_pts_a = pkt.pts;
//        }
       pkt.stream_index = [vo isVideo] ? videoindex_out : audioindex_out;
        //Write PTS
//        AVRational time_base1=ofmt_ctx->streams[ pkt.stream_index]->time_base;
//        //Duration between 2 frames (us)
//        double fps= 1/av_q2d(ofmt_ctx->streams[pkt.stream_index]->codec->time_base);
//       
//        int64_t calc_duration=(double)AV_TIME_BASE/fps;
//        //Parameters
//        pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
//        pkt.dts=pkt.pts;
//        pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
//        frame_index++;
//         printf("fps==%f----frame_index=%d\n",fps,frame_index);
        //Write
        if (pkt.buf != NULL) {
            printf("isVideo=%d----- Write . size:%5d\t  pts:%lld ----dts=%lld    pkt.stream_index==%d\n", [vo isVideo], pkt.size, pkt.pts, pkt.dts, pkt.stream_index);
            if (av_interleaved_write_frame(ofmt_ctx, &pkt) < 0) {
                printf("Error muxing packet\n");
            }
        }
    }
    isSending = NO;
    [theLock unlock];
}

- (int)encodeVAMuxer:(AVPacket *)pkt isVideo:(BOOL)videoType {

    MuxerVo *vo = [[MuxerVo alloc] initWithAvPacket:*pkt isVideo:videoType];
    if(vo)
    {
        [packeList addObject:vo];
        if (!isSending) {
            //dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self sendVAMeassge];
          //  });
        }
    }
    return 0;
}

/**
 * //Write file traile
 */
- (void)writeTrailer {
    if (ofmt_ctx) {
        av_write_trailer(ofmt_ctx);
    }
}

- (void)end {

}
@end