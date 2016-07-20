//
//  YYFaceView.m
//
//
//  Created by Joker on 14-1-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "YYFaceView.h"
#import "ChatMessage.h"
//#import "TChat-pch.h"

#define item_width 30
#define item_height 30
#define item_h_dim 20
#define item_v_dim 5

@implementation YYFaceView{
    NSMutableArray *faceList;
    int  maxCellCount;
    int   maxRow;
    float startPostionX;
    float startPostionY;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * 行 row:3
 * 列 colum:7
 * 表情尺寸 30*30 pixels
 */
-(void)initData
{
    maxRow = 3;
    maxCellCount = kWidth/(item_width+item_h_dim);
    startPostionX = (kWidth - maxCellCount*(item_width+item_h_dim)+item_h_dim)/2;
    startPostionY = 10;
    items = [[NSMutableArray alloc] init];
    faceList = [[NSMutableArray alloc] init];
    faceList = [FaceData faceDataList];
    NSMutableArray *items2D = nil;
    for (int i=0; i<faceList.count; i++) {
        NSDictionary *item = [faceList objectAtIndex:i];
        if (i % 21 == 0) {
            items2D = [NSMutableArray arrayWithCapacity:21];
            [items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    self.pageNumber = items.count;
    //设置尺寸
    self.frame = CGRectMake(0, 0, items.count *[UIScreen mainScreen].bounds.size.width, 3 * item_height+20);
   // self.width = items.count *[UIScreen mainScreen].bounds.size.width;
   // self.height = 3 * item_height+20;
    
    //放大镜
    magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage bundleImageName:@"emoticon_keyboard_magnifier"];
    magnifierView.hidden = YES;
    magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:magnifierView];
    
    UIImageView *faceItem = [[UIImageView alloc] initWithFrame:CGRectMake((64-30)/2, 15, item_width, item_width)];
    faceItem.tag = 2013;
    faceItem.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:faceItem];
}

/*
 *
 items = [
 ["表情1",“表情2”,“表情3”,......“表情28”],
 ["表情1",“表情2”,“表情3”,......“表情28”],
 ["表情1",“表情2”,“表情3”,......“表情28”]
 ];
 */
- (void)drawRect:(CGRect)rect
{
    //定义列和行
    int row = 0, colum = 0;
    
    for (int i = 0; i<items.count; i++) {
        NSArray *item2D = [items objectAtIndex:i];
        for (int j=0; j<item2D.count; j++) {
            FaceData *item = [item2D objectAtIndex:j];
            NSString *imageName = [item faceIco];
            UIImage *image = [UIImage bundleImageName:imageName];
            
            CGRect frame = CGRectMake(colum * (item_width +item_h_dim), row *(item_height + item_v_dim), item_width, item_height);
            //考虑页数，需要加上前几页的宽度
            float x = (i*kWidth) + frame.origin.x;
            frame.origin.x  = x+startPostionX;
            frame.origin.y +=startPostionY;
            [image drawInRect:frame];
            
            //更新列与行
            colum++;
            if (colum % maxCellCount == 0) {
                row ++;
                colum = 0;
            }
            if (row == maxRow) {
                row = 0;
            }
        }
    }
}

- (void)touchFace:(CGPoint)point
{
    //页数
    int page = point.x / kWidth;
    float x = point.x - (page *kWidth) -startPostionX;
    float y = point.y - startPostionY;
    
    //计算列与行
    int colum = x / (item_width+item_h_dim);
    int row = y /(item_height+item_v_dim);
    
    if (colum > maxCellCount) {
        colum = maxCellCount;
    }
    if (colum < 0) {
        colum = 0;
    }
    //索引从0开始
    if (row > (maxRow-1)) {
        row =  (maxRow-1);
        
    }
    
    if (row < 0) {
        row = 0;
    }
    
    //计算选中表情的索引
    int index = colum + (row * maxCellCount);
    NSArray *item2D = [items objectAtIndex:page];
    if (index >= item2D.count) {
        self.selectedFaceName=@"";
        return;
    }
    FaceData *item = [item2D objectAtIndex:index];
    NSString *faceName = [item faceName];
    if (![self.selectedFaceName isEqualToString:faceName]) {
        //给放大镜添加上表情
        NSString *imageName = [item faceIco];
        UIImage *image = [UIImage bundleImageName:imageName];
        
        UIImageView *faceItem = (UIImageView *)[magnifierView viewWithTag:2013];
        faceItem.image = image;
        
        magnifierView.left = (page * kWidth) + colum *(item_width+item_h_dim);
        magnifierView.bottom = row *item_height + 30;
        
        self.selectedFaceName = faceName;
    }
    
}

#pragma mark - touch事件
//touch 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
     [self touchFace:point];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
}

//touch 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    printf("touch moving-----------------");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
   [self touchFace:point];
}

//touch 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
    if (self.block != nil) {
        _block(_selectedFaceName);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

@end
