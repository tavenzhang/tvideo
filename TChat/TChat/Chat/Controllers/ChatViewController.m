//
//  ChatViewController.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "ChatViewController.h"

#import "ChatCell.h"
#import "YYFaceScrollView.h"
#import <UIKit/UIKit.h>

@implementation ChatViewController{
    BOOL isShowFace;
    NSBundle* nsBund;
    CGFloat  viewHeight;
    CGFloat  viewWidth;
}

- (id)init
    {
        NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Chat.bundle"];
        nsBund=[NSBundle bundleWithPath:bundlePath];
    
        if ((self = [super initWithNibName:[NSString stringWithUTF8String:object_getClassName(self)] bundle:nsBund]))
        {
            //code
            isShowFace = NO;
            viewWidth=kWidth;
            viewHeight=kHeight;
        }
        return self;
    }

-(void)adjust:(CGFloat)w  h:(CGFloat)height{
    viewWidth = w;
    viewHeight = height;
}

- (void)viewDidLoad {
 
    [[self view] setAutoresizesSubviews:NO];
    // Do any additional setup after loading the view.
    _tableView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFocus)];
    [self.tableView addGestureRecognizer:tapGesture];
    self.view.height = viewHeight;
    self.view.width = viewWidth;
    _textField.delegate = self;
    //加载历史聊天记录
   // [self loadChatRecords];
       _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     _tableView.backgroundColor = VIEW_BGCOLOR;
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)loadChatRecords
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *data = [ChatMessage findAll];
//        dispatch_async(dispatch_get_main_queue(), ^{
//             _messages = [[NSMutableArray alloc] initWithArray:data];
//            [_tableView reloadData];
//        });
//    });
}
//接收 消息格式 
-(void)receiveMessage:(ChatMessage*)msg{
    if(_messages == NULL)
    {
        _messages = [[NSMutableArray alloc]init];
    }
    [_messages addObject:msg];
    [_tableView reloadData];
     [self tableViewScrollToBottom];
}

/** 取消事件的焦点 */
- (void)cancelFocus
{
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^{
    //高度退回原位
        self.view.height =viewHeight;
        _tableBottomConst.constant=48;
        _faceViewBottom.constant=0;
        self.view.top=0;
    }];
}

- (void)sendMessage:(NSString *)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        return;
    }
   
    if(_sendBlock!=NULL)
    {
       _sendBlock(text);
    }
    else{
        ChatMessage *chatMessage = [[ChatMessage alloc] init];
        chatMessage.isSender = YES;
        chatMessage.sendName =@"我";
        chatMessage.content = text;
        // [chatMessage save];
        [_messages addObject:chatMessage];
        [_tableView reloadData];
      [self tableViewScrollToBottom];
    }
      self.textField.text = nil;

}

- (void)tableViewScrollToBottom
{
    if (_messages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messages.count-1) inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)emtionClick:(id)sender {
    NSLog(@"%s--emtionClick",__func__);
    if(isShowFace)
    {
        isShowFace=NO;
        [self cancelFocus];
        return;
    }
    isShowFace=YES;
    [self.textField resignFirstResponder];
    if (_faceView == nil) {
        __block __weak ChatViewController *this = self;
        
        _faceView = [[YYFaceScrollView alloc] initWithSelectBlock:^(NSString *faceName) {
            NSString *text = this.textField.text;
            NSString *appendText = [text stringByAppendingString:faceName];
            this.textField.text = appendText;
        }];
        _faceView.backgroundColor = RGBColor(220, 220, 220, 1);
        _faceView.top = viewHeight;
        _faceView.clipsToBounds = NO;
        
        _faceView.sendBlock = ^{
            NSString* fullText = this.textField.text;
            [this sendMessage:fullText];
            [this cancelFocus];
        };
        [self.view addSubview:_faceView];
    }
    float height = _faceView.height;

    _tableBottomConst.constant=height+48;
    _faceViewBottom.constant=height;
    self.view.height = viewHeight+height;
    [UIView animateWithDuration:0.3 animations:^{
        //_faceView.top = kHeight - height;
        //调整bottomView的高度
        self.view.bottom = viewHeight+20;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage:_textField.text];
    return YES;
}

#pragma mark - Notification event
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = value.CGRectValue;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.top =  -frame.size.height;;
    } completion:^(BOOL finished) {
        [self tableViewScrollToBottom];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [ChatCell cellWithTableView:tableView];
    cell.message = [_messages objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    
    return [ChatCell heightOfCellWithMessage:message];
}

@end
