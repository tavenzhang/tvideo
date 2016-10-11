//
//  GiftInfoModel.m
//  giftsenddemo
//
//  Created by lwj on 16/8/1.
//  Copyright © 2016年 WenJin Li. All rights reserved.
//

#import "GiftInfoModel.h"

@implementation GiftInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _send_user_id = 0;
        _senderNickString = @"";
        _giftNameString = @"";
        _giftCounts = 0;
        _gift_uid = 0;
        _giftThumbnailPath = @"";
        _selfIconStr = @"";
    }
    return self;
}
@end
