//
//  EncoderAAC.m
//  FFmpeg_X264_Codec
//
//  Created by 张新华 on 16/6/17.
//  Copyright © 2016年 suntongmian@163.com. All rights reserved.
//

#import "EncodeFDK_AAC.h"


@implementation EncodeFDK_AAC{
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
    AVBitStreamFilterContext* aacbsfc ;
    
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
    av_register_all(); // 注册FFmpeg所有编解码器
    avformat_network_init();
    // audio
    pFormatCtx = avformat_alloc_context();
    //Guess Format
    avformat_alloc_output_context2(&pFormatCtx, NULL, "flv", NULL);
    //int ret = avformat_alloc_output_context2(&pFormatCtx, NULL, "AAC", NULL);
   // pFormatCtx->oformat=outFormat;
    codec=avcodec_find_encoder_by_name("libfdk_aac");
    //codec = avcodec_find_encoder(AV_CODEC_ID_AAC);
    //audio & video
    audioStream = avformat_new_stream(pFormatCtx, codec);
    codec_ctx = audioStream->codec;
    codec_ctx->codec_id = audioStream->codec->codec_id;
    codec_ctx->codec_type = AVMEDIA_TYPE_AUDIO;
    codec_ctx->sample_fmt = AV_SAMPLE_FMT_S16;
    codec_ctx->sample_rate = 44100;
    //codec_ctx->bit_rate=128000;
    codec_ctx->channel_layout = AV_CH_LAYOUT_MONO;
    codec_ctx->channels = av_get_channel_layout_nb_channels(codec_ctx->channel_layout);
    codec_ctx->profile  =   FF_PROFILE_MPEG2_AAC_LOW;
    //codec_ctx->codec = codec;
    buffersize = av_samples_get_buffer_size(NULL, codec_ctx->channels, codec_ctx->frame_size, codec_ctx->sample_fmt, 1);
    audioStream->time_base.num = 1;
    audioStream->time_base.den = 1000;
    if (pFormatCtx->oformat->flags & AVFMT_GLOBALHEADER)
        codec_ctx->flags |= CODEC_FLAG_GLOBAL_HEADER;
   // av_new_packet(&pkt, buffersize);
    //指定为自定义到
  //  av_dump_format(pFormatCtx, 1, "AAC", 1);
    aacbsfc = av_bitstream_filter_init("aac_adtstoasc");
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
    int8_t **input = NULL;
    //int src_linesize;
    int in_samples = (int)numSamples;
    frame = av_frame_alloc();
    frame->nb_samples =(int) numSamples;
     ret = avcodec_fill_audio_frame(frame, codec_ctx->channels, codec_ctx->sample_fmt,(uint8_t *)samples, (int) in_samples * av_get_bytes_per_sample(codec_ctx->sample_fmt)*codec_ctx->channels, 0);

    //frame->nb_samples=frame->nb_samples;
    if (ret<0) {
        printf("avcodec_fill_audio_frame error !\n");
        av_frame_free(&frame);
        av_free_packet(&pkt);
        return -1;
    }
    printf("frame->nb_samples==%d",frame->nb_samples);
    codec_ctx->frame_size = frame->nb_samples ;
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
        [[VAMuxerOut instance] encodeVAMuxer:&(pkt) isVideo:NO];
    }
    //av_free(samples);
    av_frame_free(&frame);
    av_free_packet(&pkt);
    return 1;
}


@end
