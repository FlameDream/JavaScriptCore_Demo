//
//  JSExportViewController.h
//  JavaScriptDemo
//
//  Created by Jack Wang on 2018/9/5.
//  Copyright © 2018 Jack Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSUserOC<JSExport>
-(void)JSExportTest;
-(NSString *)jsExportTest1:(NSString *)test;
@end

@interface JSExportViewController : UIViewController

@end
