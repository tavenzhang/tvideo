//
//  GiftSendBar.h
//  iShow
//
//  Created by lwj on 16/3/14.
//
//

#import <UIKit/UIKit.h>
@interface GiftSendBar : UIView
@property (nonatomic ,retain) UIImageView*iconImageView;
@property (nonatomic ,retain) UIView*bgView;
@property (nonatomic ,retain) UIImageView*giftImageView;
@property (nonatomic,retain) UILabel* giftNumlabel;
@property (nonatomic ,retain) UILabel*nameLabel;
@property (nonatomic ,retain) UILabel*sendgitNumlabel;
@property (nonatomic ,assign) long long gifBig;
@property (nonatomic, strong) NSTimer*timer;
@property (nonatomic ,assign)long long countAdd;
-(void)setImageViewimagefromStr:(NSString*)str;
-(void)setSendGiftBarUsername:(NSString*)userName giftnumString:(NSString*)giftNumStr withgiftname:(NSString*)giftname withgiftpath:(NSString*)thumbnailPath ;

@end
