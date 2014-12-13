//
//  DropDownSubTitle.m
//  tuan
//
//  Created by zerd on 14-12-12.
//  Copyright (c) 2014年 zerd. All rights reserved.
//

#import "DropDownSubTitle.h"
#import "Common.h"
#import "UIImage+ZD.h"

#define kDuration 0.6

#define kTitleWidth 100
#define kTitleHeight 44

@implementation DropDownSubTitle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.image = [UIImage resizedImage:@"bg_subfilter_other.png"];
        self.clipsToBounds = YES;           //不显示超出自身控件范围的子控件
    }
    return self;
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    //显示按钮
    if (self.subviews.count < _titles.count) {
        for (NSUInteger i = self.subviews.count; i < _titles.count; i++) {
            //创建少的按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
    }else if (self.subviews.count > _titles.count){
        for (NSUInteger i = _titles.count; i < self.subviews.count; i++) {
            //隐藏多余的按钮
            UIButton *btn = self.subviews[i];
            btn.hidden = YES;
        }
    }
    
    //设置按钮文字
    for (int i = 0; i < _titles.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.hidden = NO;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
    }
    
    [self layoutSubviews];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    //调整子控件位置
    
    //算出当前屏幕能放几列按钮
    NSUInteger columns = self.frame.size.width / kTitleWidth;
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.hidden = NO;
        //设置位置
        CGFloat x = (i % columns) * kTitleWidth;    //求余数 得到当前的列数 * 宽度
        CGFloat y = (i / columns) * kTitleHeight;   //求除数 得到当前的行数 * 高度
        btn.frame = CGRectMake(x, y, kTitleWidth, kTitleHeight);
    }
 
    //设置自身高度
    [UIView animateWithDuration:1.0 animations:^{
        NSUInteger row = (_titles.count + columns - 1) / columns;
        CGRect frame = self.frame;
        frame.size.height = row * kTitleHeight; 
        self.frame = frame;
    }];
}

//通过动画显示出来
- (void)showWithAnimation{
    
    [self layoutSubviews];
    
    self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    self.alpha = 0;
    [UIView animateWithDuration:kDuration animations:^{
        //1.scrollview 从上方出现
        self.transform = CGAffineTransformIdentity;
        //2.cover alpha 0 -> 0.4
        self.alpha = 1;
    }];
}
//通过动画隐藏出来
- (void)hideWithAnimation{
    [UIView animateWithDuration:kDuration animations:^{
        //1.scrollview 从上方出现
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
        //2.cover alpha 0 -> 0.4
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];

}

@end
