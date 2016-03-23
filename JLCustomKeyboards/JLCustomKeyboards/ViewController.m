//
//  ViewController.m
//  JLCustomKeyboards
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "JLPhoneKeyboard.h"

@interface ViewController ()<JLPhoneKeyboardDelegate>
{
    
    IBOutlet UITextField *_abcTextField;
    
    IBOutlet UITextField *_2;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JLPhoneKeyboard *customKeyBoard = [[JLPhoneKeyboard alloc] init];
    [customKeyBoard setTextView:_abcTextField];
    customKeyBoard.delegate = self;
    customKeyBoard.tag = 1;
    JLPhoneKeyboard *customKeyboard2 = [[JLPhoneKeyboard alloc] init];
    [customKeyboard2 setTextView:_2];
    customKeyboard2.delegate = self;
    customKeyboard2.tag = 2;
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gfdsgsd:(id)sender
{
    NSLog(@"%@",_2.text);
    
}

- (void)encryptionArray:(NSArray *)array keyboard:(JLPhoneKeyboard *)keyboard
{
    switch (keyboard.tag)
    {
        case 1:
            NSLog(@"1111111111111:%@",[self decryptionArray:array]);
            break;
        case 2:
            NSLog(@"2222222222222:%@",[self decryptionArray:array]);
            break;
        default:
            break;
    }
}

- (NSString *)decryptionArray:(NSArray *)array
{
    NSString *resultString = [[NSString alloc] init];
    for (int i = 0; i < array.count; i++)
    {
        NSArray *allKeys = [EncryptionCharacter allKeys];
        for (int j = 0; j < allKeys.count; j++)
        {
            if ([[EncryptionCharacter objectForKey:allKeys[j]] isEqual:array[i]])
            {
                resultString = [resultString stringByAppendingString:allKeys[j]];
                break;
            }
        }
    }
    return resultString;
}

@end
