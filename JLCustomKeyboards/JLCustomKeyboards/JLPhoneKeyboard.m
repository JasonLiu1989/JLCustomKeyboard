//
//  JLPhoneKeyboard.m
//  JLCustomKeyboards
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "JLPhoneKeyboard.h"

enum {
    JLNumberPhoneViewImageLeft = 0,
    JLNumberPhoneViewImageInner,
    JLNumberPhoneViewImageRight,
    JLNumberPhoneViewImageMax
};

@interface JLPhoneKeyboard()
{
    NSArray *_randomLowercaseArray;
    NSArray *_randomCapitalArray;
    NSMutableArray *_encryptionMutableArray;
}
@property (nonatomic, strong) IBOutletCollection(UIButton) NSMutableArray *characterKeys;

@property (nonatomic, assign, getter=isShifted) BOOL shifted;

@property (strong, nonatomic) UIButton *shiftButton;
@property (strong, nonatomic) UIButton *returnButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *spaceButton;

@end

@implementation JLPhoneKeyboard
@synthesize textView = _textView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)init
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = (CGFloat)270/320;
    
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * scale)];
    if (self)
    {
        self.characterKeys = [[NSMutableArray alloc] init];
        _randomLowercaseArray = [self getABCRandomOrderArray];
        _randomCapitalArray = [self capitalArray:_randomLowercaseArray];
        _encryptionMutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < _randomLowercaseArray.count; i++)
        {
            UIButton *button = [[UIButton alloc] init];
            UILabel *label = [[UILabel alloc] init];
            if (i < 10)
            {
                CGPoint point = CGPointMake(screenWidth*2/320 + i * (screenWidth/10), 12 *screenWidth/320);
                [button setFrame:CGRectMake(point.x, point.y, screenWidth*28/320, screenWidth*39/320)];
                
            }
            else if (i < 20)
            {
                CGPoint point = CGPointMake(screenWidth*2/320 + (i-10) * (screenWidth/10), 66 * screenWidth/320);
                [button setFrame:CGRectMake(point.x, point.y, screenWidth*28/320, screenWidth*39/320)];
                
            }
            else if (i < 29)
            {
                CGPoint point = CGPointMake(screenWidth*18/320 + (i-20) * (screenWidth/10), 120 * screenWidth/320);
                [button setFrame:CGRectMake(point.x, point.y, screenWidth*28/320, screenWidth*39/320)];
                
            }
            else
            {
                CGPoint point = CGPointMake(screenWidth*18/320 + (i-29) * (screenWidth/10), 174 * screenWidth/320);
                [button setFrame:CGRectMake(point.x, point.y, screenWidth*28/320, screenWidth*39/320)];
                
            }
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [label setFrame:button.frame];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 6.0;
            label.layer.borderWidth = 1.0;
            label.layer.borderColor = [[UIColor whiteColor] CGColor];
            [label setBackgroundColor:[UIColor whiteColor]];
            button.userInteractionEnabled = NO;
            [self.characterKeys addObject:button];
            [self addSubview:label];
            [self addSubview:button];
        }
        [self loadCharactersWithArray:_randomLowercaseArray];
        
        _shiftButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth*2/320, 228 * screenWidth/320, screenWidth*74/320, screenWidth*39/320)];
        [_shiftButton addTarget:self action:@selector(shiftPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_shiftButton setTitle:@"Shift" forState:UIControlStateNormal];
        [_shiftButton setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [_shiftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _shiftButton.layer.masksToBounds = YES;
        _shiftButton.layer.cornerRadius = 6.0;
        _shiftButton.layer.borderWidth = 1.0;
        _shiftButton.layer.borderColor = [[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0] CGColor];
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth*18/320 + 7 * (screenWidth/10), 174 * screenWidth/320, screenWidth*60/320, screenWidth*39/320)];
        [_deleteButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.cornerRadius = 6.0;
        _deleteButton.layer.borderWidth = 1.0;
        _deleteButton.layer.borderColor = [[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0] CGColor];
        UILongPressGestureRecognizer *deleteGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAll:)];
        [_deleteButton addGestureRecognizer:deleteGesture];
        _spaceButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth*82/320, 228 * screenWidth/320, screenWidth*155/320, screenWidth*39/320)];
        [_spaceButton addTarget:self action:@selector(spacePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_spaceButton setTitle:@"Space" forState:UIControlStateNormal];
        [_spaceButton setBackgroundColor:[UIColor whiteColor]];
        [_spaceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spaceButton.layer.masksToBounds = YES;
        _spaceButton.layer.cornerRadius = 6.0;
        _spaceButton.layer.borderWidth = 1.0;
        _spaceButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        _returnButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth*243/320, 228 * screenWidth/320, screenWidth*75/320, screenWidth*39/320)];
        [_returnButton addTarget:self action:@selector(returnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_returnButton setTitle:@"Return" forState:UIControlStateNormal];
        [_returnButton setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [_returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _returnButton.layer.masksToBounds = YES;
        _returnButton.layer.cornerRadius = 6.0;
        _returnButton.layer.borderWidth = 1.0;
        _returnButton.layer.borderColor = [[UIColor colorWithRed:179.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0] CGColor];
        
        [self addSubview:_shiftButton];
        [self addSubview:_deleteButton];
        [self addSubview:_spaceButton];
        [self addSubview:_returnButton];
        self.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:212.0/255.0 blue:217.0/255.0 alpha:1.0];
        
    }
    
    return self;
}

-(void)setTextView:(id<UITextInput>)textView
{
    
    if ([textView isKindOfClass:[UITextView class]])
        [(UITextView *)textView setInputView:self];
    else if ([textView isKindOfClass:[UITextField class]])
        [(UITextField *)textView setInputView:self];
    
    _textView = textView;
}

-(id<UITextInput>)textView
{
    return _textView;
}

-(void)loadCharactersWithArray:(NSArray *)a
{
    int i = 0;
    for (UIButton *b in self.characterKeys)
    {
        [b setTitle:[a objectAtIndex:i] forState:UIControlStateNormal];
        [b.titleLabel setFont:kFont];
        i++;
    }
}

- (BOOL) enableInputClicksWhenVisible
{
    return YES;
}

#pragma mark - Keyboard Button Actions

- (void)characterPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *character = [NSString stringWithString:button.titleLabel.text];
    
    
    [self.textView insertText:character];
    
    if ([(UITextField *)self.textView text].length == 1)
    {
        _encryptionMutableArray = [[NSMutableArray alloc] init];
    }
    UITextRange *cursorRange = [(UITextField *)self.textView selectedTextRange];
    UITextPosition *beginning = [(UITextField *)self.textView beginningOfDocument];
    const NSInteger location = [(UITextField *)self.textView offsetFromPosition:beginning toPosition:cursorRange.start];
    [_encryptionMutableArray insertObject:[EncryptionCharacter objectForKey:character] atIndex:location - 1];
    if ([self.delegate respondsToSelector:@selector(encryptionArray:keyboard:)])
    {
        [self.delegate encryptionArray:_encryptionMutableArray keyboard:self];
    }
    if (location == [(UITextField *)self.textView text].length)
    {
        [self performSelector:@selector(changeText) withObject:nil afterDelay:1.5];
    }
    
    if (self.isShifted)
        [self unShift];
    
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void)shiftPressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    if (!self.isShifted)
    {
        [self loadCharactersWithArray:_randomCapitalArray];
        self.shifted = YES;
    }
    else
    {
        [self loadCharactersWithArray:_randomLowercaseArray];
        self.shifted = NO;
    }
}

- (void)unShift
{
    if (self.isShifted)
    {
        [self loadCharactersWithArray:_randomLowercaseArray];
    }
    if (!self.isShifted)
        self.shifted = YES;
    else
        self.shifted = NO;
}
- (void)deletePressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self.textView deleteBackward];
    
    
    UITextRange *cursorRange = [(UITextField *)self.textView selectedTextRange];
    UITextPosition *beginning = [(UITextField *)self.textView beginningOfDocument];
    const NSInteger location = [(UITextField *)self.textView offsetFromPosition:beginning toPosition:cursorRange.start];
    if (_encryptionMutableArray.count && location != 0)
    {
        [_encryptionMutableArray removeObjectAtIndex:location];
    }
    
    if ([self.delegate respondsToSelector:@selector(encryptionArray:keyboard:)])
    {
        [self.delegate encryptionArray:_encryptionMutableArray keyboard:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void)spacePressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    
    [self.textView insertText:@" "];
    
    if (self.isShifted)
        [self unShift];
    
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void)returnPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    [[UIDevice currentDevice] playInputClick];
//    [self.textView insertText:@"\n"];
//    if ([self.textView isKindOfClass:[UITextView class]])
//        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
//    else if ([self.textView isKindOfClass:[UITextField class]])
//        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void)addPopupToButton:(UIButton *)b
{
    UIImageView *keyPop;
    CGFloat scale = (CGFloat)[UIScreen mainScreen].bounds.size.width/320;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(15*scale, 10*scale, 52*scale, 60*scale)];
    
    CGRect frame;
    
    
    if (b == [self.characterKeys objectAtIndex:0] || b == [self.characterKeys objectAtIndex:10]) {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:JLNumberPhoneViewImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        frame = CGRectMake(-16*scale, -71*scale, keyPop.frame.size.width*scale, keyPop.frame.size.height*scale);
    }
    else if (b == [self.characterKeys objectAtIndex:9] || b == [self.characterKeys objectAtIndex:19]) {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:JLNumberPhoneViewImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        frame = CGRectMake(-38*scale, -71*scale, keyPop.frame.size.width*scale, keyPop.frame.size.height*scale);
    }
    else {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:JLNumberPhoneViewImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        frame = CGRectMake(-27*scale, -71*scale, keyPop.frame.size.width*scale, keyPop.frame.size.height*scale);
    }
    [keyPop setFrame:frame];
    [text setFont:[UIFont fontWithName:kFont.fontName size:44]];
    
    [text setTextAlignment:UITextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:b.titleLabel.text];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);
    keyPop.layer.shadowOpacity = 1;
    keyPop.layer.shadowRadius = 5.0;
    keyPop.clipsToBounds = NO;
    
    
    [keyPop addSubview:text];
    [b addSubview:keyPop];
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys)
    {
        if ([b subviews].count > 1)
        {
            [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
        if(CGRectContainsPoint(b.frame, location))
        {
            [self addPopupToButton:b];
            [[UIDevice currentDevice] playInputClick];
        }
    }
}

-(void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys)
    {
        if ([b subviews].count > 1)
        {
            [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
        if(CGRectContainsPoint(b.frame, location))
        {
            [self addPopupToButton:b];
        }
    }
}


-(void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    for (UIButton *b in self.characterKeys)
    {
        if ([b subviews].count > 1)
        {
            [[[b subviews] objectAtIndex:1] removeFromSuperview];
        }
        if(CGRectContainsPoint(b.frame, location))
        {
            [self characterPressed:b];
        }
    }
}

#pragma mark - Private Methods

- (NSArray *)getRandomOrderArray:(NSArray *)array
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSMutableArray *oldArr = [[NSMutableArray alloc] initWithArray:array];
    if (oldArr.count > 0)
    {
        for (int i = 0; i < array.count; i++)
        {
            NSInteger aRandomNumber = arc4random()%oldArr.count;
            NSString *string = oldArr[aRandomNumber];
            [resultArr addObject:string];
            [oldArr removeObject:string];
        }
        
    }
    return resultArr;
}

- (NSArray *)getABCRandomOrderArray
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    NSMutableArray *oldNumberArr = [[NSMutableArray alloc] initWithArray:kNumber];
    NSMutableArray *oldCharArr = [[NSMutableArray alloc] initWithArray:kChar];
    
    for (int i = 0; i < kNumber.count; i++)
    {
        NSInteger aRandomNumber = arc4random()%oldNumberArr.count;
        NSString *string = oldNumberArr[aRandomNumber];
        [resultArr addObject:string];
        [oldNumberArr removeObject:string];
    }
    
    for (int i = 0; i < kChar.count; i++)
    {
        NSInteger aRandomNumber = arc4random()%oldCharArr.count;
        NSString *string = oldCharArr[aRandomNumber];
        [resultArr addObject:string];
        [oldCharArr removeObject:string];
    }
        
    
    return resultArr;
}

- (NSArray *)capitalArray:(NSArray *)array
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSMutableArray *oldArr = [[NSMutableArray alloc] initWithArray:array];
    if (oldArr.count > 0)
    {
        for (int i = 0; i < oldArr.count; i++)
        {
            
            NSString *string = oldArr[i];
            [resultArr addObject:[string capitalizedString]];
            
        }
        
    }
    return resultArr;
}

- (void)changeText
{
    NSMutableString *abc = [[NSMutableString alloc] init];
    UITextField *textField = (UITextField *)self.textView;
    for (int i = 0; i < textField.text.length; i++)
    {
        [abc appendString:@"a"];
    }
    UITextRange *range = [self.textView textRangeFromPosition:[self.textView beginningOfDocument] toPosition:[self.textView endOfDocument]];
    
    [self.textView replaceRange:range withText:[NSString stringWithFormat:@"%@",abc]];
}

#pragma mark - Gesture

- (void)deleteAll:(UILongPressGestureRecognizer *)recognizer
{
    NSString *text = [(UITextField *)self.textView text];
    for (int i = 0; i < text.length; i++)
    {
        [self deletePressed:nil];
    }
}

#pragma mark - UI Utilities

+ (UIImage *) imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#define _UPPER_WIDTH   (52.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (32.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (61.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2)
#define _PAN_LOWER_HEIGHT    (32.0 * [[UIScreen mainScreen] scale])

#define _PAN_UL_WIDTH        ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT    (11.0 * [[UIScreen mainScreen] scale])

#define _PAN_CURVE_SIZE      (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X     (15 * [[UIScreen mainScreen] scale])
#define _PADDING_Y     (10 * [[UIScreen mainScreen] scale])
#define _WIDTH   (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT   (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)


#define _OFFSET_X    -25 * [[UIScreen mainScreen] scale])
#define _OFFSET_Y    59 * [[UIScreen mainScreen] scale])


- (CGImageRef)createKeytopImageWithKind:(int)kind
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPDER_WIDTH;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
    
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind) {
        case JLNumberPhoneViewImageLeft:
            p.x -= _PAN_UL_WIDTH*2;
            break;
            
        case JLNumberPhoneViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case JLNumberPhoneViewImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0*M_PI/2.0,
                 1.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_WIDTH;
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0*M_PI/2.0,
                 2.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    
    switch (kind) {
        case JLNumberPhoneViewImageLeft:
            break;
            
        case JLNumberPhoneViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case JLNumberPhoneViewImageRight:
            p.x -= _PAN_UL_WIDTH*2;
            break;
    }
    
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    //----
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake(_WIDTH,
                                           _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    //----
    
    // draw gradient
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
//        CGFloat components[] = {
//            0.95f, 1.0f,
//            0.85f, 1.0f,
//            0.675f, 1.0f,
//            0.8f, 1.0f};
    CGFloat components[] = {
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f};
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 2);
    
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    
    CGGradientRef gradientRef =
    CGGradientCreateWithColorComponents(colorSpaceRef, components, NULL, count);
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startPoint,
                                endPoint,
                                kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    CFRelease(path);
    
    return imageRef;
}

@end
