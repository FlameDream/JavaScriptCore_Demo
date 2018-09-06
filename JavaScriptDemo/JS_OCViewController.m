//
//  JS_OCViewController.m
//  JavaScriptDemo
//
//  Created by Jack Wang on 2018/9/5.
//  Copyright © 2018 Jack Wang. All rights reserved.
//

#import "JS_OCViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JS_OCViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)JSContext *context;
@end

@implementation JS_OCViewController

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
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"JS_OC" ofType:@"html"];
    NSURL *locationURL = [NSURL URLWithString:urlStr];
    
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:locationURL];
    // 4.加载网页
    [webView loadRequest:request];
    
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.delegate = self;
    
    [self initDocumentContext];
}

-(void)initDocumentContext{
    
    /**
     注意事项：
     为什把_context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     放在初始化WebView之后，并且初始化OC的方法。
     
     JS调用OC，OC是一个被动被调用的过程。为保证Web端的JS加载成功。尽量把一些方法放在Web加载的时候去注册方法进去，当Web加载完成可以顺利的调用OC的方法
     */
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //3.1 JS调用OC方法 使用block方法调用
    __weak typeof(self) weakSelf = self;
    //a.无参数 无返回值
    self.context[@"js_oc_NOParameters"] = ^(){
        NSLog(@"无参数 无返回值");
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf test1];
        }
        
    };
    //b.无参数 有返回值
    self.context[@"js_oc_NOParameters_return"] = ^(){
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf test2];
        }
        return @"展示 ==》无参数 有返回值的HTML上的Alert";
    };
    //c.有参数 无返回值
    self.context[@"js_oc_haveParameters"] = ^(NSString *title){
        NSLog(@"有参数 无返回值");
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf test3:title];
        }
    };
    
    //d.有参数 又返回值
    self.context[@"js_oc_haveParameters_return"] = ^(NSString *title){
        NSLog(@"有参数 无返回值");
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf test4:title];
        }
        return [NSString stringWithFormat:@"有参数 有返回值:%@",title];
    };
}



#pragma mark --JS 调用 OC

//a.无参数 无返回值
-(void)test1{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"OC方法弹出框==>JS调用OC=>无参数-无返回值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:action];
        [self presentViewController:vc animated:true completion:nil];
    });
}

//b.无参数 有返回值
-(void)test2{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"OC方法弹出框==>JS调用OC=>无参数-有返回值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:action];
        [self presentViewController:vc animated:true completion:nil];
    });
}

//c.有参数 无返回值
-(void)test3:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"OC方法弹出框==>JS调用OC=>有参数-无返回值:参数：%@",title] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:action];
        [self presentViewController:vc animated:true completion:nil];
        
    });
}

//d.有参数 又返回值
-(void)test4:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"OC方法弹出框==>JS调用OC=>有参数-有返回值:参数：%@",title] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:action];
        [self presentViewController:vc animated:true completion:nil];
    });
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
    
    //异常处理 避免在加载HTML中存在JS的语法错误
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"-----web 异常==%@",exception);
    };
    
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
