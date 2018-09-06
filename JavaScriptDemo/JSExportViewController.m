//
//  JSExportViewController.m
//  JavaScriptDemo
//
//  Created by Jack Wang on 2018/9/5.
//  Copyright © 2018 Jack Wang. All rights reserved.
//

#import "JSExportViewController.h"

@interface JSExportViewController ()<UIWebViewDelegate,JSUserOC>

@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)JSContext *context;

@end

@implementation JSExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUIWebViewTest];
}
- (void)createUIWebViewTest {
    // 1.创建webview
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    // 2.2 创建一个本地URL
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"JSExport" ofType:@"html"];
    NSURL *locationURL = [NSURL URLWithString:urlStr];
    
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:locationURL];
    // 4.加载网页
    [webView loadRequest:request];
    
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.delegate = self;
}

#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    // 如果Web视图 开始加载内容，则为true; 否则，是的。
    // 可以设置避免加载其他的页面内容
    
    return true;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    // Web 开始加载
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 加载完成
    // 执行OC调用JS方法
    [self initDocumentContext];
}


-(void)initDocumentContext{
    
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    /**
     使用JSExport过程中：定义OC的页面使用“native”来代表OC当前页面,一般情况下都习惯使用native，但是我们可以和Web前端约定使用其他的内容代替，但是不能使用Web前段的一些关键字：“location”等
     
     
     我这个例子使用“tttt”
     */
    _context[@"tttt"] = self;
    
    
    //异常处理 避免在加载HTML中存在JS的语法错误
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"-----web 异常==%@",exception);
    };
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //加载失败
    
}



#pragma mark JSExport Define Function

-(void)JSExportTest{
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"JS调用：JSExport协议定义的OC方法" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:true completion:nil];
}

-(NSString *)jsExportTest1:(NSString *)test{
    NSLog(@"输出Input：%@",test);
    return [NSString stringWithFormat:@"JSExport---:%@",test];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
