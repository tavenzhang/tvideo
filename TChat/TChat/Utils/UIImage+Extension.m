//
//  UIImage+Extension.m
//  TextUtil
//
//  Created by zx_04 on 15/8/20.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    
    // 加载原有图片
    UIImage *norImage = [UIImage bundleImageName:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = norImage.size.width * 0.5;
    CGFloat top = norImage.size.height * 0.5;
    CGFloat bottom = norImage.size.height-top;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(top, w, bottom, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}


+(UIImage*)bundleImageName:(NSString *)imageName{
       NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Chat.bundle"];
       NSBundle*  nsBund=[NSBundle bundleWithPath:bundlePath];
       UIImage *img = [UIImage imageNamed:imageName inBundle:nsBund compatibleWithTraitCollection:nil];
    return img;
}


@end


