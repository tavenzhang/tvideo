//
//  GiftInfoModel.h
//  giftsenddemo
//
//  Created by lwj on 16/8/1.
//  Copyright © 2016年 WenJin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftInfoModel : NSObject
@property (nonatomic, assign)unsigned int send_user_id;//发送者uid
@property (nonatomic, retain) NSString *senderNickString;//发送者名字
@property (nonatomic, retain) NSString *giftNameString;//礼物名
@property (nonatomic, assign) unsigned int giftCounts;//礼物数量
@property (nonatomic, assign) unsigned int gift_uid;//礼物uid
@property (nonatomic ,strong) NSString* giftThumbnailPath;//礼物图片地址
@property (nonatomic, strong) NSString* selfIconStr;//用户头像地址
@end
