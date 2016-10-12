//
//  ChatViewController.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SendMessageBlock)(NSString*);

@class YYFaceScrollView;

@interface ChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIView             *bottomView;
@property (weak, nonatomic) IBOutlet UITextField        *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faceViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnFace;
/** 表情视图 */
@property (nonatomic, strong) YYFaceScrollView          *faceView;

@property (nonatomic, strong) NSMutableArray    *messages;

@property (nonatomic, copy)     SendMessageBlock           sendBlock;

-(void)receiveMessage:(ChatMessage*)msg;

-(void)adjust:(CGFloat)w  h:(CGFloat)height;
- (void)cancelFocus;
@end
