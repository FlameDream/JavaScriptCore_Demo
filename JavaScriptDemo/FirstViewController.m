//
//  FirstViewController.m
//  JavaScriptDemo
//
//  Created by Jack Wang on 2018/9/1.
//  Copyright © 2018 Jack Wang. All rights reserved.
//

#import "FirstViewController.h"

#import "JSExportViewController.h"
#import "JS_OCViewController.h"
#import "OC_JSViewController.h"


#import <WebKit/WKWebView.h>
@interface FirstViewController ()<UINavigationControllerDelegate>

@property(nonatomic, copy)NSArray *classType;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _classType = @[@"使用JSExport协议-JS调用OC",@"使用JS调用OC方法",@"使用OC调用JS方法"];
    
    for (int i = 0; i < _classType.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100 + 100 * i, self.view.frame.size.width - 100, 50)];
        [btn setTitle:_classType[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:23 / 255.0 blue:17 / 255.0 alpha:1];
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 + i;
        [self.view addSubview:btn];
    }
//    [self createUIWebViewTest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"JS和OC交互";
    
    
}

-(void)clickBtn:(UIButton *)send{
    if (send.tag == 10) {
        JSExportViewController *vc = [[JSExportViewController alloc] init];
        vc.title = _classType[send.tag - 10];
        [self.navigationController pushViewController:vc animated:true];
        
    }else if (send.tag == 11){
        JS_OCViewController *vc = [[JS_OCViewController alloc] init];
        vc.title = _classType[send.tag - 10];
        [self.navigationController pushViewController:vc animated:true];
    }else{
        OC_JSViewController *vc = [[OC_JSViewController alloc] init];
        vc.title = _classType[send.tag - 10];
        [self.navigationController pushViewController:vc animated:true];
        
    }
}
@end
