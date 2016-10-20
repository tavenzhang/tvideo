//
//  Rtmp.m
//  kxmovie
//
//  Created by  on 16/6/6.
//
//

#import "rtmpUtil.h"
#import "rtmpManage.h"
#import "librtmp/rtmp.h"
static int KEY = 413256489;

int encryptKey(int plainText) { return plainText ^ KEY; }

int decryptKey(int cipherText) { return cipherText ^ KEY; }

#define SAVC(x) static const AVal av_##x = AVC(#x)

SAVC(code);
SAVC(level);
SAVC(netping);
SAVC(play);

int mySendPlay(RTMP *r) {
  RTMPPacket packet;
  char pbuf[1024], *pend = pbuf + sizeof(pbuf);
  char *enc;

  packet.m_nChannel = 0x08; /* we make 8 our stream channel */
  packet.m_headerType = RTMP_PACKET_SIZE_LARGE;
  packet.m_packetType = RTMP_PACKET_TYPE_INVOKE;
  packet.m_nTimeStamp = 0;
  packet.m_nInfoField2 = r->m_stream_id; /*0x01000000; */
  packet.m_hasAbsTimestamp = 0;
  packet.m_body = pbuf + RTMP_MAX_HEADER_SIZE;

  enc = packet.m_body;
  enc = AMF_EncodeString(enc, pend, &av_play);
  enc = AMF_EncodeNumber(enc, pend, ++r->m_numInvokes);
  *enc++ = AMF_NULL;

  RTMP_Log(RTMP_LOGDEBUG, "%s, seekTime=%d, stopTime=%d, sending play: %s",
           __FUNCTION__, r->Link.seekTime, r->Link.stopTime,
           r->Link.playpath.av_val);
  enc = AMF_EncodeString(enc, pend, &r->Link.playpath);
  if (!enc)
    return FALSE;

  /* Optional parameters start and len.
   *
   * start: -2, -1, 0, positive number
   *  -2: looks for a live stream, then a recorded stream,
   *      if not found any open a live stream
   *  -1: plays a live stream
   * >=0: plays a recorded streams from 'start' milliseconds
   */
  if (r->Link.lFlags & RTMP_LF_LIVE)
    enc = AMF_EncodeNumber(enc, pend, -1000.0);
  else {
    if (r->Link.seekTime > 0.0)
      enc =
          AMF_EncodeNumber(enc, pend, r->Link.seekTime); /* resume from here */
    else
      enc = AMF_EncodeNumber(enc, pend, 0.0);
    /*-2000.0);*/ /* recorded as default, -2000.0 is not reliable since
                     that freezes the player if the stream is not found */
  }
  if (!enc)
    return FALSE;

  /* len: -1, 0, positive number
   *  -1: plays live or recorded stream to the end (default)
   *   0: plays a frame 'start' ms away from the beginning
   *  >0: plays a live or recoded stream for 'len' milliseconds
   */
  /*enc += EncodeNumber(enc, -1.0); */ /* len */
  if (r->Link.stopTime) {
    enc = AMF_EncodeNumber(enc, pend, r->Link.stopTime - r->Link.seekTime);
    if (!enc)
      return FALSE;
  }

  packet.m_nBodySize = enc - packet.m_body;

  return RTMP_SendPacket(r, &packet, TRUE);
}

char *printAMFProps(AMFObject *obj) {
  NSString *pstr = @"";
  if (obj != NULL) {

    NSString *temp;
    NSString *name = @"";
    for (int n = 0; n < obj->o_num; n++) {
      AMFObjectProperty *pro = &obj->o_props[n];
      switch (pro->p_type) {
      case AMF_NUMBER:
        temp = [NSString
            stringWithFormat:@"pro== %d: value:%f\n", n, pro->p_vu.p_number];
        break;
      case AMF_STRING:
        temp = [NSString stringWithFormat:@"pro==%d: value:%s\n", n,
                                          pro->p_vu.p_aval.av_val];
        if (n == 0) {
          name = [NSString stringWithFormat:@"%s", pro->p_vu.p_aval.av_val];
        }
        break;
      case AMF_OBJECT:
        temp = [NSString
            stringWithFormat:@"pro==%d: type=AMF_OBJECT value:\n{\n%s}\n", n,
                             printAMFProps(&pro->p_vu.p_object)];
        break;
      default:
        temp = [NSString stringWithFormat:@"pro%d: value: amftype()%s\n", n,
                                          pro->p_name.av_val];
        break;
      }
      pstr = [pstr stringByAppendingString:temp];
    }
    NSLog(@"AMFObject----------%@ \n%@", name, pstr);
  }
  return (char *)[pstr cStringUsingEncoding:NSUTF8StringEncoding];
}

//打印日志和回调
void rtmp_invoke_type_20(RTMP *rtmp, AMFObject obj) {
  if(![[RtmpManager shareInstance] rtmp])
  {
      [[RtmpManager shareInstance]setRtmp:rtmp];
      SendCallPing(rtmp, -1);
  }
   
  AVal method;
  printAMFProps(&obj);
  AMFProp_GetString(AMF_GetProp(&obj, NULL, 0), &method);
  AMFObject obj2;
  AVal code, level;
  if (strcmp(method.av_val, "onStatus") == 0) {
    printAMFProps(&obj);
    AMFProp_GetObject(AMF_GetProp(&obj, NULL, 3), &obj2);
    AMFProp_GetString(AMF_GetProp(&obj2, &av_code, -1), &code);
    AMFProp_GetString(AMF_GetProp(&obj2, &av_level, -1), &level);
    if (!strcmp(code.av_val, "NetStream.Play.Start")) {
      NSLog(@"NetStream.Play.Start-------level: %s", level.av_val);
    }

  } else if (strcmp(method.av_val, av_netping.av_val) == 0) {
    double key = AMFProp_GetNumber(AMF_GetProp(&obj, NULL, 5));
    NSLog(@"Type_20--key========: %f", key);
    if (key > 1) {
      key = encryptKey(key);
       [[RtmpManager shareInstance] sendNetPing:key];
    } else if ((int)key == 1) {
       [[RtmpManager shareInstance] rePlay];
    }
  }
}

//发送ping包 
int SendCallPing(RTMP *r, double key) {
  RTMPPacket packet;
  char pbuf[1024], *pend = pbuf + sizeof(pbuf);
  char *enc;
  packet.m_nChannel = 0x03; /* control channel (invoke) */
  packet.m_headerType = RTMP_PACKET_SIZE_MEDIUM;
  packet.m_packetType = 0x14; /* INVOKE */
  packet.m_nTimeStamp = 0;
  packet.m_nInfoField2 = 0;
  packet.m_hasAbsTimestamp = 0;
  packet.m_body = pbuf + RTMP_MAX_HEADER_SIZE;

  enc = packet.m_body;
  //对“releaseStream”字符串进行AMF编码
  enc = AMF_EncodeString(enc, pend, &av_netping);
  //对传输ID（0）进行AMF编码？
  enc = AMF_EncodeNumber(enc, pend, ++r->m_numInvokes);
  //命令对象
  *enc++ = AMF_NULL;
  //对参数进行AMF编码
  if (key > 1) {
    enc = AMF_EncodeNumber(enc, pend, key);
  }
  if (!enc)
    return FALSE;

  packet.m_nBodySize = enc - packet.m_body;
  RTMP_Log(RTMP_LOGDEBUG, [@" SendCallPing---key=%f ---r->m_numInvokes=%d\n"
                              cStringUsingEncoding:NSUTF8StringEncoding],
           key, r->m_numInvokes);
  return RTMP_SendPacket(r, &packet, true);
}

//注册rtmp回调
void RTMP_handleReg() {
  RTMP_LogSetLevel(RTMP_LOGERROR);
  RTMP_SetInvoke_20_Callback(rtmp_invoke_type_20);
}



@implementation rtmpHelp
{

}
@synthesize plock=myPlock;
+ (rtmpHelp *)instance {
  static rtmpHelp *_instance = nil;

  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] init];
      _instance.plock = [[NSLock alloc] init];
    }
  }

  return _instance;
}


//测试rtmp 连接是否可用
-(int)RTMP_TestConnect:(NSString*)path
{
    [myPlock lock];
    RTMP* rtmp = RTMP_Alloc();
    RTMP_Init(rtmp);
    [myPlock unlock];
    rtmp->Link.timeout = 3; //单位秒
    if (!RTMP_SetupURL(rtmp, [path cStringUsingEncoding:NSUTF8StringEncoding])) {
        RTMP_Log(RTMP_LOGERROR, "test Connect SetupURL Err\n");
        RTMP_Close(rtmp);
        RTMP_Free(rtmp);
        return 0;
    }
    rtmp->Link.lFlags |= RTMP_LF_LIVE;
    if (!RTMP_Connect(rtmp, NULL)) {
        RTMP_Log(RTMP_LOGERROR, "test Connect Err\n");
        RTMP_Close(rtmp);
        RTMP_Free(rtmp);
        return -1;
    }
   
    RTMP_Log(RTMP_LOGERROR, "test Connect suessses");
    RTMP_Close(rtmp);
    RTMP_Free(rtmp);
     return 1;
}

@end
