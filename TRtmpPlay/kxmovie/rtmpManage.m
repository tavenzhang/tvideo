//
//  RtmpShare.m
//  kxmovie
//
//  Created by  on 16/6/24.
//
//

#import "rtmpManage.h"
#import "rtmpUtil.h"
@implementation RtmpManager {
    BOOL isCreatFile;
    BOOL isForeBeaker;
    FILE *fp;
    double pingKey;
}
@synthesize rtmp=rtmp;

static RtmpManager *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSMutableDictionary *)getParam {
    return self->dicPara;
}
- (void)stopStream {
    [self cleanSockt];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initRtmp {
    
    if (rtmp == NULL) {
        rtmp = RTMP_Alloc();
        RTMP_Init(_instance->rtmp);
        rtmp->Link.timeout = 10; //单位秒
        bLiveStream = YES;
        isCreatFile = false;
        isForeBeaker = false;
        pingKey = -1.0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopStream)
                                                     name:@"closeRtmp"
                                                   object:NULL];
    } else {
        [self cleanSockt];
        [self initRtmp];
    }
}

- (void)cleanSockt {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (rtmp != NULL) {
        isForeBeaker = true;
        @try {
            RTMP_Close(rtmp);
            RTMP_Free(rtmp);
        } @catch (NSException *exception) {
            NSLog(@"cleanSockt NSException==%@", [exception description]);
        } @finally {
            isCreatFile = false;
            if (fp != NULL) {
                fclose(fp);
            }
            countbufsize = 0;
            rtmp = NULL;
            fp = NULL;
        }
    }
}

- (int)sendNetPing:(double)key {
    if (pingKey != key) {
        pingKey = key;
    }
    int res = SendCallPing(rtmp, key);
    
    return res;
}

- (void)rePlay {
    RTMP_SendCreateStream(rtmp);
}

- (int)startStream {
    bufsize = 1024 * 1024 * 10;
    
    char *buf = (char *)malloc(bufsize);
    memset(buf, 0, bufsize);
    while ((nRead = RTMP_Read(rtmp, buf, bufsize))) {
        // sleep(1);
        fwrite(buf, 1, nRead, fp);
        countbufsize += nRead;
        
        if (countbufsize > 100 * 10 * 1024) {
            ftruncate(fp, 100 * 1024);
            countbufsize = 100 * 1024;
        }
        if (!isCreatFile && countbufsize > 60 * 1024) {
            //缓冲大于60kb才播放
            RtmpManager *rtmpM = [RtmpManager shareInstance];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"readyedRtmp"
             object:NULL
             userInfo:[rtmpM getParam]];
            isCreatFile = true;
        }
        
        if (isForeBeaker) {
            isForeBeaker = false;
            break;
        }
    };
    
    free(buf);
    return 1;
}

- (int)connectServer:(NSString *)path
             paraDic:(NSMutableDictionary *)dic
               valid:(BOOL)valid {
    dicPara = dic;
    NSString *local = [dic objectForKey:@"path"];
    
    if (!RTMP_SetupURL(rtmp, [path cStringUsingEncoding:NSUTF8StringEncoding])) {
        RTMP_Log(RTMP_LOGERROR, "SetupURL Err\n");
        [self cleanSockt];
        return 0;
    }
    
    if (bLiveStream) {
        rtmp->Link.lFlags |= RTMP_LF_LIVE;
    }
    
    RTMP_SetBufferMS(rtmp, 20 * 1000);
    if (!RTMP_Connect(rtmp, NULL)) {
        RTMP_Log(RTMP_LOGERROR, "Connect Err\n");
        [self cleanSockt];
        return -1;
    }
    fp = fopen([local cStringUsingEncoding:NSUTF8StringEncoding],
               [@"wb" cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (valid) {
        [self sendNetPing:pingKey];
    }
    if (!RTMP_ConnectStream(rtmp, 0)) {
        
        RTMP_Log(RTMP_LOGERROR, "ConnectStream Err\n");
        [self cleanSockt];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startStream];
    });
    return 1;
}

@end

