//
//  ViewController.m
//  CustomizeNumPad
//
//  Created by jiayi zhou on 10/31/13.
//  Copyright (c) 2013 jiayi zhou. All rights reserved.
//

#import "ViewController.h"
#import "CustomNumPadPopoverController.h"

@interface ViewController ()<UITextFieldDelegate,UIPopoverControllerDelegate,UIWebViewDelegate,numPadPopoverDelegate>

@property (nonatomic,strong) IBOutlet UITextField *textField1;
@property (nonatomic,strong) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) UITextField *focusTextField;

@property (nonatomic,strong) UIPopoverController *numPadPopover;

@end

@implementation ViewController
@synthesize numPadPopover=_numPadPopover;
@synthesize webView=_webView;
@synthesize focusTextField;
NSString *currentInputId;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib./Users/jiayizhou/Dropbox/facebook.html
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"keypadBasic" withExtension:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    
    self.textField1.delegate=self;
    self.textField2.delegate=self;
//    NSURL *url =[NSURL URLWithString:@"https://www.facebook.com/"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
//    [self.view addSubview:_webView];

}

-(void)numPadPopoverControll:(CustomNumPadPopoverController *)viewController sendString:(NSString *)key{
    NSLog(@"Function test--->sendDataToMainController %@",focusTextField);
    NSString *numberKey = key;
    NSLog(@"%@",numberKey);
    
    if (numberKey) {
        if ([numberKey length]==1 && isnumber([numberKey characterAtIndex:0])) {
            self.focusTextField.text = [self.focusTextField.text stringByAppendingString:numberKey];
            NSString *jsCode = [NSString stringWithFormat:@"$(%@).val($(%@).val()+%@);",currentInputId,currentInputId,numberKey];
            [_webView stringByEvaluatingJavaScriptFromString:jsCode];
        }
        else if ([numberKey isEqual:@"+"]){
            NSLog(@"The opration is %@",numberKey);
            NSString *jsCode = [NSString stringWithFormat:@"$(%@).val(parseInt($(%@).val())+1);",currentInputId,currentInputId];
            [_webView stringByEvaluatingJavaScriptFromString:jsCode];
            
            if ([self.focusTextField.text integerValue]) {
                self.focusTextField.text=[NSString stringWithFormat:@"%d",[self.focusTextField.text integerValue]+1];
            }
        }
        else if ([numberKey isEqual:@"-"]){
            NSLog(@"The opration is %@",numberKey);
            NSString *jsCode = [NSString stringWithFormat:@"$(%@).val(parseInt($(%@).val())-1);",currentInputId,currentInputId];
            [_webView stringByEvaluatingJavaScriptFromString:jsCode];
            if ([self.focusTextField.text integerValue]) {
                self.focusTextField.text=[NSString stringWithFormat:@"%d",[self.focusTextField.text integerValue]-1];

            }
        }
        else if ([numberKey isEqual:@"c"]){
            NSLog(@"The opration is %@",numberKey);
            self.focusTextField.text = nil;
            NSString *jsCode = [NSString stringWithFormat:@"$(%@).val('')",currentInputId];
            [_webView stringByEvaluatingJavaScriptFromString:jsCode];
            
        }
        else if ([numberKey isEqual:@"."]){
            NSLog(@"The opration is %@",numberKey);
            self.focusTextField.text = [self.focusTextField.text stringByAppendingString:numberKey];
            NSString *jsCode = [NSString stringWithFormat:@"$(%@).val($(%@).val()+'.');",currentInputId,currentInputId];
            [_webView stringByEvaluatingJavaScriptFromString:jsCode];
            
        }
        else if ([numberKey isEqual:@"Return"]){
            NSLog(@"The opration is %@",numberKey);
            [self.numPadPopover dismissPopoverAnimated:YES];
        }
    }
}



-(BOOL)disablesAutomaticKeyboardDismissal{
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.webView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.focusTextField=textField;
     NSLog(@"Function test--->textFieldShouldBeginEditing");
    NSLog(@"Function test--->textFieldDidBeginEditing");
    if (_numPadPopover==nil) {
        CustomNumPadPopoverController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomNumPadPopover"];
        content.delegate=self;
        _numPadPopover = [[UIPopoverController alloc] initWithContentViewController:content];
    }
    [self.numPadPopover presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _numPadPopover.delegate=self;
//    CustomNumPadPopoverController *numpadView=[[CustomNumPadPopoverController alloc] init];
//    numpadView.delegate=self;
    return NO;
}
- (void)showNumPadPopover:(CGPoint )point{
    NSLog(@"Function test--->showNumPadPopover %f,%f",point.x,point.y);
    if (_numPadPopover==nil) {
        CustomNumPadPopoverController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomNumPadPopover"];
        content.delegate=self;
        _numPadPopover = [[UIPopoverController alloc] initWithContentViewController:content];
    }
    [self.numPadPopover presentPopoverFromRect:CGRectMake(point.y,point.x,0, 0) inView:_webView permittedArrowDirections:UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown animated:YES];
    _numPadPopover.delegate=self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *URL = [request URL];
    NSLog(@"%@",[URL scheme]);
    if ([[URL scheme] isEqualToString:@"ejsnumpad"]) {
        NSLog(@"Works here -------->%@ ",URL);
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        for (NSString *param in [[URL query] componentsSeparatedByString:@"&"]) {
            NSArray *paramPair = [param componentsSeparatedByString:@"="];
            [params setObject:[paramPair objectAtIndex:1] forKey:[paramPair objectAtIndex:0]];
        }
        NSString *locationX = params[@"x"];
        NSString *locationY = params[@"y"];
        currentInputId = params[@"id"];
        NSLog(@"%@",currentInputId);
        CGPoint point = CGPointMake([locationY floatValue], [locationX floatValue]);
        [self showNumPadPopover:point];
    }
    return YES;
}

@end
