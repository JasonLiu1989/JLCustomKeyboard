//
//  JLPhoneKeyboard.h
//  JLCustomKeyboards
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kFont [UIFont fontWithName:@"GurmukhiMN" size:20]
#define kChar @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"z", @"x", @"c", @"v", @"b", @"n", @"m" ]
#define kNumber @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"]
#define EncryptionCharacter [[NSDictionary alloc] initWithObjects:@[@"AA",@"AB",@"AC",@"AD",@"AE",@"AF",@"BA",@"BB",@"BC",@"BD",@"BE",@"BF",@"CA",@"CB",@"CC",@"CD",@"CE",@"CF",@"DA",@"DB",@"DC",@"DD",@"DE",@"DF",@"EA",@"EB",@"EC",@"ED",@"EE",@"EF",@"FA",@"FB",@"FC",@"FD",@"FE",@"FF",@"A0",@"A1",@"A2",@"A3",@"A4",@"A5",@"A6",@"A7",@"A8",@"A9",@"B0",@"B1",@"B2",@"B3",@"B4",@"B5",@"B6",@"B7",@"B8",@"B9",@"C0",@"C1",@"C2",@"C3",@"C4",@"C5"] forKeys:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]]

@class JLPhoneKeyboard;

@protocol JLPhoneKeyboardDelegate <NSObject>

- (void)encryptionArray:(NSArray *)array keyboard:(JLPhoneKeyboard *)keyboard;

@end

@interface JLPhoneKeyboard : UIView<UIInputViewAudioFeedback>

@property (strong) id<UITextInput> textView;

@property (nonatomic,assign) id<JLPhoneKeyboardDelegate> delegate;

@end
