//
//  ChatMessage.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "ChatMessage.h"

static NSMutableArray* faceDataList;
@implementation ChatMessage

@end


@implementation FaceData

- (instancetype)initWithFaceName:(NSString *)faceName faceIco:(NSString *)faceIco {
    self = [super init];
    if (self) {
        self.faceName = faceName;
        self.faceIco = faceIco;
    }

    return self;
}

+ (instancetype)voWithFaceName:(NSString *)faceName faceIco:(NSString *)faceIco {
    return [[self alloc] initWithFaceName:faceName faceIco:faceIco];
}

+(NSMutableArray*)faceDataList{
    if(!faceDataList){
        faceDataList = [[NSMutableArray alloc] init];
        for(int i=1;i<44;i++) {
            NSString *sname;
        
            NSString *ico;
            if (i < 10) {
                 sname= [NSString stringWithFormat:@"{/0%d}", i];
                 ico = [NSString stringWithFormat:@"0%d", i];
            }
            else if(i<44){
                ico = [NSString stringWithFormat:@"%d", i];
                sname= [NSString stringWithFormat:@"{/%d}", i];
            }
            else{
                ico = [NSString stringWithFormat:@"0%d", i];
                sname= [NSString stringWithFormat:@"{/%d}", i];
            }
            FaceData *vo = [[FaceData alloc] initWithFaceName:sname faceIco:ico];
            [faceDataList addObject:vo];
        }
    }
    return faceDataList;
}

@end