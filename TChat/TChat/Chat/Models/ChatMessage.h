//
//  ChatMessage.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

//#import "JKDBModel.h"

typedef enum : NSUInteger {
    MessageTypeText,
    MessageTypeAudio,
    MessageTypePicture,
    MessageTypeVideo,
} MessageType;

@interface ChatMessage : NSObject

@property (nonatomic, copy)     NSString        *content;
@property (nonatomic, assign)   MessageType     messageType;
@property (nonatomic, assign)   BOOL            isSender;
@property (nonatomic, copy)   NSString        *sendName;
@end


@interface FaceData : NSObject
@property (nonatomic, copy)     NSString        *faceName;
@property (nonatomic, copy)     NSString        *faceIco;

- (instancetype)initWithFaceName:(NSString *)faceName faceIco:(NSString *)faceIco;

+ (instancetype)voWithFaceName:(NSString *)faceName faceIco:(NSString *)faceIco;

+(NSMutableArray*)faceDataList;
@end
