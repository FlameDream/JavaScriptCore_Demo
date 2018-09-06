//
//  OC_JSViewController.m
//  JavaScriptDemo
//
//  Created by Jack Wang on 2018/9/5.
//  Copyright © 2018 Jack Wang. All rights reserved.
//

#import "OC_JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface OC_JSViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)JSContext *context;
@end

@implementation OC_JSViewController

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
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"OC_JS" ofType:@"html"];
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
    
    //
/**
 注意事项：
    为什把_context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    放在DidFinishLoad里进行执行，这个是主动调用JS，需要保证JS加载成功。而JS调用OC其实和这个相反，尽量把一些方法放在Web为加载的时候去注册方法
 */
    
    
    
    // 1.创建 JavaScript执行的环境
//    在直接使用JavaScriptCore情况下，建议在WebView加载完之后再执行OC调用Web页的JS，因为在在加载过程中WebView中的JS文件还没有加载完成，OC就调用JS方法会出现方法缺少
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //异常处理 避免在加载HTML中存在JS的语法错误
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"-----web 异常==%@",exception);
    };
    
    
    [self OC_JS];

}

-(void)OC_JS{
    
    /**
     执行JS方法：注意事项
     
     注意事项OC调用JS尽量使用后面的两种方法
     第一种存在一定的弊端：如果复杂的返回值返回，无法接收
     第二种、第三种可以通过对JSValue进行转换成OC的值
     */
    
    // 方法一：
    //    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"oc_JS()"];
//    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"oc_js_ParametersAndReturn('%@')",@"Jack"]];
//    NSLog(@"------:%@",result);
    
    //方法二：
    
    [self.context evaluateScript:@"oc_js_NOParameters()"];
   
    
    
    // 方法三：
//    JSValue *fun = self.context[@"oc_js_ParametersAndReturn"];
//    JSValue *result2 = [fun callWithArguments:@[@"Jack"]];
//    NSLog(@"-----%@",result2);
//
    
    
  
    
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //加载失败
    
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
