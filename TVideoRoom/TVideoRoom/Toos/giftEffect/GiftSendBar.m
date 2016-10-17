//
//  GiftSendBar.m
//  iShow
//
//  Created by lwj on 16/3/14.
//
//

#import "GiftSendBar.h"
#import "UIImageView+WebCache.h"

@interface GiftSendBar(){
   
}
@property (nonatomic, assign) int oldgiftCount;
@property (nonatomic, strong)NSString*giftNumStr;
@property (nonatomic, strong)NSString*quntyty;
@property (nonatomic, strong)NSString*giftname;
@end
@implementation GiftSendBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _countAdd = 0;
        self.backgroundColor = [UIColor clearColor];
       
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, (75-35)/2, 170, 35)];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = (float)35/2;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+17.5, 0, 90, 17.5)];
        _nameLabel.textColor = [UIColor colorWithRed:0xff/255.0f green:0xfb/255.0f blue:0x71/255.0f alpha:1];
        _nameLabel.text = @"";
        
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
        [_bgView addSubview:_nameLabel];
        
        _sendgitNumlabel = [[UILabel alloc]initWithFrame:CGRectMake(20+17.5, 17.5, 90, 17.5)];
        _sendgitNumlabel.textColor = [UIColor whiteColor];
        _sendgitNumlabel.text = @"送了玫瑰";
        _sendgitNumlabel.font = [UIFont boldSystemFontOfSize:12];
        _sendgitNumlabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_sendgitNumlabel];
        [self addSubview:_bgView];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (75-35)/2, 35, 35)];
        
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 17.5;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 0.5;
        [self addSubview:_iconImageView];
        
        
        
        _giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 75, 75)];
        _giftImageView.backgroundColor = [UIColor clearColor];
       
        [self addSubview:_giftImageView];
       
  
        _giftNumlabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 75)];
        NSMutableAttributedString*mutableString = [[NSMutableAttributedString alloc]initWithString:@" X99"];
        [mutableString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0,mutableString.length)];
        [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0,mutableString.length)];
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowBlurRadius = 5;
        shadow.shadowOffset = CGSizeMake(1, 3);
        shadow.shadowColor = [UIColor grayColor];
        [mutableString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0,mutableString.length)];
        [_giftNumlabel setAttributedText:mutableString];
        [self addSubview:_giftNumlabel];
    
    }
    return self;
}
-(void)setSendGiftBarUsername:(NSString*)userName giftnumString:(NSString*)giftNumStr withgiftname:(NSString*)giftname withgiftpath:(NSString*)thumbnailPath{
    NSString*string = [NSString stringWithFormat:@" x%@",giftNumStr];
    _giftNumStr = giftNumStr;
    _gifBig = [_giftNumStr intValue];
    _oldgiftCount = (int)_gifBig;
    _countAdd = 0;
    _giftname = giftname;
    NSMutableAttributedString*mutableString = [[NSMutableAttributedString alloc]initWithString:string];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0,mutableString.length)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0,mutableString.length)];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowOffset = CGSizeMake(1, 3);
    shadow.shadowColor = [UIColor grayColor];
    [mutableString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0,mutableString.length)];
    [_giftNumlabel setAttributedText:mutableString];
    _nameLabel.text = userName;
    _sendgitNumlabel.text = [NSString stringWithFormat:@"送了%lld个%@",_countAdd,_giftname];
    //NSString *thumString = [thumbnailPath lastPathComponent];//拿到该地址的最后一个组件（不去掉后缀名的）
   // _giftImageView.image = [UIImage imageNamed:thumbnailPath];
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:thumbnailPath] placeholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(giftNumLableTransAnimation) userInfo:nil repeats:YES];
    [_timer fire];
    if (_gifBig >= 11){
         _countAdd = _gifBig-3;
    }
}
-(void)giftNumLableTransAnimation{
    
    if (_countAdd <_gifBig) {
        _countAdd++;
    }else{
        [self removeSelfDeadLine];
    }
    
    NSString*string = [NSString stringWithFormat:@" x%lld",_countAdd];
    NSMutableAttributedString*mutableString = [[NSMutableAttributedString alloc]initWithString:string];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0,mutableString.length)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0,mutableString.length)];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowOffset = CGSizeMake(1, 3);
    shadow.shadowColor = [UIColor grayColor];
    [mutableString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0,mutableString.length)];
    [_giftNumlabel setAttributedText:mutableString];
    _sendgitNumlabel.text = [NSString stringWithFormat:@"送了 %@",_giftname];
   // _sendgitNumlabel.textColor = [UIColor purpleColor];
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            _giftNumlabel.transform = CGAffineTransformMakeScale(4, 4);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            _giftNumlabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _giftNumlabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
           [self performSelector:@selector(removeSelfDeadLine) withObject:nil afterDelay:1.3];
        }];
    }];
  
}
-(void)removeSelfDeadLine{
    if (_gifBig <= _countAdd) {
        if (_oldgiftCount >= _gifBig) {
            _timer.fireDate = [NSDate distantFuture];
             [self performSelector:@selector(removeOther) withObject:nil afterDelay:1.3];
        }else{
            _oldgiftCount  = _gifBig;
        }
    }
}

-(void)removeOther{
    if (_oldgiftCount >= _gifBig){
        [self removese];
    }else{
        _oldgiftCount  = _gifBig;
        _timer.fireDate = [NSDate distantPast];
    }
    
}
-(void)setImageViewimagefromStr:(NSString*)str{
    
    //[_iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
    	//backImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: r_home_videoImgPlaceholder));
    _iconImageView.image = [UIImage imageNamed:str];
}

-(void)removese{
    if (self) {
        [self stopTimer];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removegistSendbar" object:nil userInfo:@{@"gifensendbar":self}];
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.3];
    }
}
-(void)removeSelf{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-10, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished) {
           [self removeFromSuperview];
    }];
 
}
-(void)stopTimer{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}
@end
