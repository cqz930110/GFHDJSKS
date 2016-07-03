//
//  MessageScrollView.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/12/7.
//  Copyright © 2015年 Niuduz. All rights reserved.
//


@interface HomeMessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) NSString *message;
@end

@implementation HomeMessageView
- (void)setMessage:(NSString *)message
{
    _contentLabel.text = message;
}
@end

#import "MessageScrollView.h"
#import "HWWeakTimer.h"
#define UISCREENWIDTH  self.frame.size.width//广告的宽度
#define UISCREENHEIGHT  self.frame.size.height//广告的高度

static CGFloat const chageImageTime = 1.5;
static NSUInteger currentMessage = 0;//记录中间图片的下标,开始总是为0

@interface MessageScrollView ()
{
    HomeMessageView * _upMessageView;
    HomeMessageView * _downMessageView;
    NSArray * _messages;
}
@end

@implementation MessageScrollView
- (instancetype)initWithFrame:(CGRect)frame withMessages:(NSArray *)messages
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bounces = NO;
        self.userInteractionEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentOffset = CGPointMake(0, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH, UISCREENHEIGHT*2);
        self.delegate = self;
        // 初始化 view
        _upMessageView =  [[[NSBundle mainBundle] loadNibNamed:@"HomeMessageView" owner:nil options:nil] lastObject];
        _upMessageView.frame = CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT);
        
        _downMessageView =  [[[NSBundle mainBundle] loadNibNamed:@"HomeMessageView" owner:nil options:nil] lastObject];
        _downMessageView.frame = CGRectMake(0, UISCREENHEIGHT, UISCREENWIDTH, UISCREENHEIGHT);
        
        [self addSubview:_upMessageView];
        [self addSubview:_downMessageView];
        self.messages = messages;
        _moveTime = [HWWeakTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setMessages:(NSArray *)messages
{
    _messages = messages;
    _upMessageView.message = _messages[0];
    _downMessageView.message = _messages[1];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    [self setContentOffset:CGPointMake(0, UISCREENHEIGHT) animated:YES];
    if(self.contentOffset.y == UISCREENHEIGHT)
    {
        currentMessage = currentMessage+1 >= _messages.count?0:currentMessage+1;
        _upMessageView.message = _messages[currentMessage];
        
        NSInteger downMessage = currentMessage+1 == _messages.count?0:currentMessage+1;
        _downMessageView.message = _messages[downMessage];
    }
    self.contentOffset = CGPointMake(0, 0);
}

- (void)dealloc
{
    _moveTime = nil;
}

@end
