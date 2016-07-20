//
//  X264Manager.m
//  FFmpeg_X264_Codec
//
//  Created by sunminmin on 15/9/7.
//  Copyright (c) 2015年 suntongmian@163.com. All rights reserved.
//

#import "X264Manager.h"
#import "VAMuxerOut.h"
#import "time.h"

#ifdef __cplusplus
extern "C" {
#endif

#include "libavfilter/avfilter.h"
#include "libavutil/imgutils.h"

#ifdef __cplusplus
};
#endif




static  int64_t start_time=0;

@implementation X264Manager
{

    AVOutputFormat                      *fmtOut;
    AVStream                            *outVideo_stream;
    AVCodecContext                      *pCodecCtx;
    AVCodec                             *pCodec;
    AVPacket                             pkt;
    uint8_t                             *picture_buf;
    AVFrame                             *pFrame;
    int                                  picture_size;
    int                                  y_size;
    int                                  frameIndex;
    char                                *aviobuffer;
    int                                  encoder_h264_frame_width; // 编码的图像宽度
    int                                  encoder_h264_frame_height; // 编码的图像高度
    int64_t pts_time;
    int64_t now_time;

}


- (instancetype)initWithPFormatCtx{
    self = [super init];
    if (self) {
        [self setX264Resource];
    }
    return self;
}


/*
 *  设置X264
 */
- (int)setX264Resource
{
    frameIndex = 0;
    // AVCaptureSessionPresetMedium
    encoder_h264_frame_width = 360;
    encoder_h264_frame_height = 480;
    // AVCaptureSessionPresetHigh
  //    encoder_h264_frame_width = 1920;
  //    encoder_h264_frame_height = 1080;
    av_register_all(); // 注册FFmpeg所有编解码器
    avformat_network_init();
    _pFormatCtx = avformat_alloc_context();
  
    //Guess Format
    fmtOut = av_guess_format(NULL, ".h264", NULL);
    //Init AVIOContext
    _pFormatCtx->oformat = fmtOut;
    // Method2.
    outVideo_stream = avformat_new_stream(_pFormatCtx, 0);

    outVideo_stream->time_base.num = 1;
    outVideo_stream->time_base.den = 1000;
    //指定为自定义到
    if (_pFormatCtx->oformat->flags|CODEC_FLAG_GLOBAL_HEADER){
        outVideo_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
    }
    // Param that must set
    pCodecCtx =  outVideo_stream->codec;
   // pCodecCtx->codec_id = fmtOut->video_codec;
    pCodecCtx->codec_id = AV_CODEC_ID_H264;
    pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    pCodecCtx->pix_fmt = AV_PIX_FMT_YUV420P;
    pCodecCtx->width = encoder_h264_frame_width;
    pCodecCtx->height = encoder_h264_frame_height;
    pCodecCtx->time_base.num = 1;
    pCodecCtx->time_base.den = 24;
    pCodecCtx->bit_rate = 400000;
    pCodecCtx->gop_size = 250;
    // H264
    // pCodecCtx->me_range = 16;
    // pCodecCtx->max_qdiff = 4;
    pCodecCtx->qcompress = 0.6;
    pCodecCtx->qmin = 10;
    pCodecCtx->qmax = 51;
    // Optional Param
    pCodecCtx->max_b_frames=1;
    // Set Option
    AVDictionary *param = 0;
    // H.264
    if(pCodecCtx->codec_id == AV_CODEC_ID_H264) {
        av_dict_set(&param, "preset", "fast", 0);
        av_dict_set(&param, "tune", "zerolatency", 0);
        av_dict_set(&param, "profile", "main", 0);
        av_dict_set(&param, "rotate", "90", 0);
    }
    // int ret2= av_dict_set(&outVideo_stream->metadata, "rotate", "90", 0);
    // Show some Information
   // av_dump_format(_pFormatCtx, 0, "h264V", 1);
    pCodec = avcodec_find_encoder(pCodecCtx->codec_id);
    if (!pCodec) {
        
        printf("Can not find encoder! \n");
        return -1;
    }
    int resAcod = avcodec_open2(pCodecCtx, pCodec,&param);
    if (resAcod < 0) {
        
        printf("Failed to open encoder! ==%d\n",resAcod);
        return -1;
    }
    pFrame = av_frame_alloc();
    picture_size = av_image_get_buffer_size(pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height,0);
    picture_buf = (uint8_t *)av_malloc(picture_size);
    avpicture_fill((AVPicture *)pFrame, picture_buf, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
    //Write File Header
   // avformat_write_header(_pFormatCtx, NULL);
   
    y_size = pCodecCtx->width * pCodecCtx->height;
    pts_time =now_time = 0;
    return 0;
}



/*
 * 将CMSampleBufferRef格式的数据编码成h264并写入文件
 */
- (void)encoderToH264:(CMSampleBufferRef)sampleBuffer
{
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
     //   UInt8 *bufferbasePtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
        UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
      //  size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
       // size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
        size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,1);
       // size_t bytesrow2 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,2);
        UInt8 *yuv420_data = (UInt8 *)malloc(width * height *3/2); // buffer to store YUV with layout YYYYYYYYUUVV
        /* convert NV12 data to YUV420p*/
        UInt8 *pY = bufferPtr ;
        UInt8 *pUV = bufferPtr1;
        UInt8 *pU = yuv420_data + width*height;
        UInt8 *pV = pU + width*height/4;
        for(int i =0;i<height;i++)
        {
            memcpy(yuv420_data+i*width,pY+i*bytesrow0,width);
        }
        for(int j = 0;j<height/2;j++)
        {
            for(int i =0;i<width/2;i++)
            {
                *(pU++) = pUV[i<<1];
                *(pV++) = pUV[(i<<1) + 1];
            }
            pUV+=bytesrow1;
        }
        // add code to push yuv420_data to video encoder here
        picture_buf = yuv420_data;
        pFrame->data[0] = picture_buf;              // Y
        pFrame->data[1] = picture_buf+ y_size;      // U
        pFrame->data[2] = picture_buf+ y_size*5/4;  // V
        av_new_packet(&pkt, picture_size);
        av_init_packet(&pkt);
        pkt.data = NULL;    // packet data will be allocated by the encoder
        pkt.size = 0;
        pkt.pts = AV_NOPTS_VALUE;
        pkt.dts = AV_NOPTS_VALUE;
        // PTS
        pFrame->pts  = pCodecCtx->frame_number;
        int got_picture = 0;
        pFrame->width = encoder_h264_frame_width;
        pFrame->height = encoder_h264_frame_height;
        pFrame->format = AV_PIX_FMT_YUV420P;
        
        int ret = avcodec_encode_video2(pCodecCtx, &pkt, pFrame, &got_picture);
        if(ret < 0) {
            printf("Failed to encode! \n");
        }

        if (got_picture==1) {
            //printf("Succ encode frame: %5d\tsize:%5d\n", frameIndex, pkt.size,pkt.pts,pkt.dts,pkt.duration);
            //frameIndex++;
            pkt.stream_index = outVideo_stream->index;
            if (pkt.pts != AV_NOPTS_VALUE )
            {
                pkt.pts = av_rescale_q(pkt.pts,pCodecCtx->time_base, outVideo_stream->time_base);
            }
            if(pkt.dts !=AV_NOPTS_VALUE )
            {
                pkt.dts = av_rescale_q(pkt.dts,pCodecCtx->time_base, outVideo_stream->time_base);
            }
            pkt.duration = av_rescale_q(pkt.duration, pCodecCtx->time_base, outVideo_stream->time_base);
           [[VAMuxerOut instance] encodeVAMuxer:&pkt isVideo:YES];
            av_free_packet(&pkt);
        }
       // av_frame_free(&pFrame);
        free(yuv420_data);
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}


/*
 * 释放资源
 */
- (void)freeX264Resource
{
    //Flush Encoder
    int ret = flush_encoder(_pFormatCtx,0);
    if (ret < 0) {
        
        printf("Flushing encoder failed\n");
    }
    
    //Write file trailer
    av_write_trailer(_pFormatCtx);
    //Clean
    if (outVideo_stream){
        avcodec_close(outVideo_stream->codec);
        av_free(pFrame);
    }
    avio_close(_pFormatCtx->pb);
    av_free(aviobuffer);
    avformat_free_context(_pFormatCtx);
}

int flush_encoder(AVFormatContext *fmt_ctx,unsigned int stream_index)
{
    int ret;
    int got_frame;
    AVPacket enc_pkt;
    if (!(fmt_ctx->streams[stream_index]->codec->codec->capabilities &
          CODEC_CAP_DELAY))
        return 0;
    
//    while (1) {
//        enc_pkt.data = NULL;
//        enc_pkt.size = 0;
//        av_init_packet(&enc_pkt);
//        ret = avcodec_encode_video2(fmt_ctx->streams[stream_index]->codec, &enc_pkt,
//                                     NULL, &got_frame);
//        av_frame_free(NULL);
//        if (ret < 0)
//            break;
//        if (!got_frame){
//            ret=0;
//            break;
//        }
//        printf("Flush Encoder: Succeed to encode 1 frame!\tsize:%5d\n",enc_pkt.size);
//        /* mux encoded frame */
//        ret = av_write_frame(fmt_ctx, &enc_pkt);
//        if (ret < 0)
//            break;
//    }

    return ret;
}

@end
