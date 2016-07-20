//
//  EncoderAAC.m
//  FFmpeg_X264_Codec
//
//  Created by 张新华 on 16/6/17.
//  Copyright © 2016年 suntongmian@163.com. All rights reserved.
//

#import "EncoderAAC.h"
#import "libavcodec/avcodec.h"
#import "libavformat/avformat.h"
#import "libswscale/swscale.h"
#import "libavutil/frame.h"
#import "libavutil/opt.h"
#import "libswresample/swresample.h"
#import "VAMuxerOut.h"

@implementation EncoderAAC{
    AVFrame *frame;
    AVPacket   pkt;
    AVFormatContext *pFormatCtx;
    int  frameIndex;
    AVFormatContext *ofmt_ctx;
    AVOutputFormat *oformat;
    AVCodecContext *codec_ctx;
    AVCodec         *codec;
    AVStream        *audioStream;
    size_t buffersize;
}

@synthesize pFormatCtx=pFormatCtx;
- (instancetype)init {
    self = [super init];
    if (self) {
       [self setAACResource];
    }

    return self;
}

- (int)setAACResource {
    av_register_all();
    // audio
    pFormatCtx = avformat_alloc_context();
    //Guess Format
    //AVOutputFormat *outFormat = av_guess_format(NULL, "AAC", NULL);
    //int ret = avformat_alloc_output_context2(&pFormatCtx, NULL, "AAC", NULL);
    //pFormatCtx->oformat=outFormat;
    codec = avcodec_find_encoder(AV_CODEC_ID_AAC);
    //audio & video
    audioStream = avformat_new_stream(pFormatCtx, codec);
    codec_ctx = audioStream->codec;
    codec_ctx->codec_id = AV_CODEC_ID_AAC;
    codec_ctx->codec_type = AVMEDIA_TYPE_AUDIO;
    codec_ctx->sample_fmt = AV_SAMPLE_FMT_FLT;
    codec_ctx->sample_rate = 44100;
    codec_ctx->frame_size=2400;
    codec_ctx->channel_layout = AV_CH_LAYOUT_MONO;
    codec_ctx->channels = av_get_channel_layout_nb_channels(codec_ctx->channel_layout);
//    codec_ctx->bit_rate = 64000;
    codec_ctx->codec = codec;
    buffersize = av_samples_get_buffer_size(NULL, codec_ctx->channels, codec_ctx->frame_size, codec_ctx->sample_fmt, 1);
    audioStream->time_base.num = 1;
    audioStream->time_base.den = 1000;
    av_new_packet(&pkt, buffersize);
    if (pFormatCtx->oformat->flags & AVFMT_GLOBALHEADER)
        codec_ctx->flags |= CODEC_FLAG_GLOBAL_HEADER;
  
    int resAcod = avcodec_open2(codec_ctx, codec,NULL);
    if (resAcod < 0) {
        
        printf("Failed to open encoder! ==%d\n",resAcod);
    }
    return 0;
}
/* AVFrame表示一祯原始的音频数据，因为编码的时候需要一个AVFrame,，
      在这里创建一个AVFrame,用来填充录音回调传过来的inputBuffer.里面是数据格式为PCM
      调用FFMPEG的编码函数 avcodec_encode_audio2（）后，将PCM-->AAC
      编码压缩为AAC格式，并保存在AVPacket中。
      再调用 av_interleaved_write_frame
      我们将它写入到指定的推流地址上,FFMPEG将发包集成在它内部实现里
    */
-(int)encodeAAC:(CMSampleBufferRef)sampleBuffer {
    
    CMSampleTimingInfo timing_info;
    CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &timing_info);
    int ret;
    CMItemCount numSamples = CMSampleBufferGetNumSamples(sampleBuffer);
    NSUInteger channelIndex = 0;
    CMBlockBufferRef audioBlockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t audioBlockBufferOffset = (channelIndex * numSamples * sizeof(SInt16));
    size_t lengthAtOffset = 0;
    size_t totalLength = 0;
    SInt16 *samples = NULL;
    CMBlockBufferGetDataPointer(audioBlockBuffer, audioBlockBufferOffset, &lengthAtOffset, &totalLength, (char **)(&samples));
    const AudioStreamBasicDescription *audioDescription = CMAudioFormatDescriptionGetStreamBasicDescription(CMSampleBufferGetFormatDescription(sampleBuffer));
    SwrContext *swr = swr_alloc();
    int in_smprt = (int)audioDescription->mSampleRate;
    av_opt_set_int(swr, "in_channel_layout",  AV_CH_LAYOUT_MONO, 0);
    av_opt_set_int(swr, "out_channel_layout", codec_ctx->channel_layout,  0);
    
    av_opt_set_int(swr, "in_channel_count", audioDescription->mChannelsPerFrame,  0);
    av_opt_set_int(swr, "out_channel_count", 1,  0);
    
    av_opt_set_int(swr, "in_sample_rate",     audioDescription->mSampleRate,0);
    av_opt_set_int(swr, "out_sample_rate",    codec_ctx->sample_rate,0);
    
    av_opt_set_sample_fmt(swr, "in_sample_fmt",  AV_SAMPLE_FMT_S16, 0);
    av_opt_set_sample_fmt(swr, "out_sample_fmt", codec_ctx->sample_fmt,  0);
    swr_init(swr);
    uint8_t **input = NULL;
    int src_linesize;
    int in_samples = (int)numSamples;
    ret = av_samples_alloc_array_and_samples(&input, &src_linesize, audioDescription->mChannelsPerFrame, in_samples, AV_SAMPLE_FMT_S16P, 0);
    uint8_t *temp=*input;
    *input=(uint8_t*)samples;

    uint8_t *output=NULL;
    int out_samples = av_rescale_rnd(swr_get_delay(swr, in_smprt) +in_samples, codec_ctx->sample_rate, in_smprt, AV_ROUND_UP);
    av_samples_alloc(&output, NULL, codec_ctx->channels, out_samples, codec_ctx->sample_fmt, 0);
    in_samples = (int)numSamples;
    out_samples = swr_convert(swr, &output, out_samples, (const uint8_t **)input, in_samples);
    printf("out_samples==%d\n",out_samples);
    frame = av_frame_alloc();
    frame->nb_samples =(int) out_samples;
    
   // codec_ctx->frame_size=    frame->nb_samples;
    ret = avcodec_fill_audio_frame(frame, codec_ctx->channels, codec_ctx->sample_fmt,(uint8_t *)output, (int) out_samples * av_get_bytes_per_sample(codec_ctx->sample_fmt)*
            codec_ctx->channels, 1);
    
    if (ret<0) {
        printf("avcodec_fill_audio_frame error !\n");
        av_frame_free(&frame);
        av_free_packet(&pkt);
        return -1;
    }
//    frame->nb_samples = codec_ctx->frame_size;
    frame->channel_layout = codec_ctx->channel_layout;
    frame->sample_rate = codec_ctx->sample_rate;
    frame->channels = codec_ctx->channels;
    frame->pts = frame->nb_samples*frameIndex;
    
    av_init_packet(&pkt);
    int gotFrame = 0;
    pkt.data = NULL;    // packet data will be allocated by the encoder
    pkt.size = 0;
    pkt.pts = AV_NOPTS_VALUE;
    pkt.dts = AV_NOPTS_VALUE;

    ret = avcodec_encode_audio2(codec_ctx, &pkt, frame, &gotFrame);
    
    frameIndex++;
    if (ret < 0) {
        printf("encoder error! \n");
        av_frame_free(&frame);
        av_free_packet(&pkt);
        //   pthread_mutex_unlock(&encoder->mutex);
        return -1;
    }
    if (gotFrame == 1) {
        pkt.stream_index = audioStream->index;
        if (pkt.pts != AV_NOPTS_VALUE )
        {
            pkt.pts = av_rescale_q(pkt.pts,codec_ctx->time_base, audioStream->time_base);
        }
        if(pkt.dts !=AV_NOPTS_VALUE )
        {
            pkt.dts = av_rescale_q(pkt.dts,codec_ctx->time_base, audioStream->time_base);
        }

      //  pkt.pts = codec_ctx->frame_number;
        //printf("Succ -- audion encode frame: \tsize:%5d\n ,pkt.pts=%d,dts=%d,duration=%d,", pkt.size,pkt.pts,pkt.dts,pkt.duration);
      //  ret = av_interleaved_write_frame(pFormatCtx, &pkt);
        //AVPacket dst;
        //av_copy_packet(&dst, &pkt);
        [[VAMuxerOut instance] encodeVAMuxer:&(pkt) isVideo:NO];
    }
    //if (input)
    //    av_freep(&input[0]);
  
  
//    if(input)
//    {
//        av_free(*input);
//    }
      //
    av_free(temp);
    av_free(input);
    av_freep(&output);
    av_frame_free(&frame);
    av_free_packet(&pkt);
    av_free(swr);
//    if (output)
//        av_freep(&output[0]);

   // av_free(&input);

    //av_free(audioBlockBuffer);
    
    //    pthread_mutex_unlock(&encoder->mutex);
    return 1;

}


@end
