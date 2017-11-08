//
//  ViewController.m
//  iOSInterview
//
//  Created by meitianhui2 on 2017/11/7.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    主要演示 assing strong copy retain weak 的区别
    参照的简书是 http://www.jianshu.com/p/a29a0bdd5da8
 */

#import "ViewController.h"

static NSString *retainCountKey = @"retainCount";


@interface ViewController ()

//
@property(copy,nonatomic)NSMutableString*aCopyMStr;
@property(strong,nonatomic)NSMutableString*strongMStr;
@property (retain,nonatomic)NSMutableString *retainMStr;
@property(weak,nonatomic)NSMutableString*weakMStr;
@property(assign,nonatomic)NSMutableString*assignMStr;   // 我们用assign 修饰对象

// 有容器对象
@property(copy,nonatomic)NSMutableArray*aCopyMArr;
@property(strong,nonatomic)NSMutableArray*strongMArr;
@property(weak,nonatomic)NSMutableArray*weakMArr;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self memoryTest];
//    [self testOne];
    [self compareAssignAndWeak];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----  NSMutableString 测试

/**
 内存和引用计数的 测试
 此处tempMStr就是A，值地址就是C，“strValue”就是B，而引用计数这个概念是针对C的，赋值给其他变量或者指针设置为nil，如tempStr = nil，都会使得引用计数有所增减。当内存区域引用计数为0时就会将数据抹除。而我们使用copy,strong,retain,weak,assign区别就在：
 
 1.是否开辟新的内存
 2.是否对地址C有引用计数增加
 
 需要注意的是property修饰符是在被赋值时起作用
 */
- (void)memoryTest
{
    NSMutableString *tempMStr = [[NSMutableString alloc] initWithString:@"strValue"];
    NSLog(@"tempMStr值地址:%p，tempMStr值%@,tempMStr值引用计数%@\\n", tempMStr,tempMStr,[tempMStr valueForKey:retainCountKey]);
    //输出tempMStr值地址:0x7a05f650，tempMStr值strValue,tempMStr值引用计数1
}


/**
 注意 引用计数的
 */
- (void)testOne
{
    //
    NSMutableString *mstrOrigin = [[NSMutableString alloc] initWithString:@"mstrOriginValue"];
    // 有意思的 是retainCount  是一个对象类型
    NSLog(@"mstrOrigin 开始的引用计数%@",[mstrOrigin valueForKey:@"retainCount"]);
    self.aCopyMStr = mstrOrigin;
    self.strongMStr = mstrOrigin;
    self.retainMStr = mstrOrigin;
    self.weakMStr = mstrOrigin;
    self.assignMStr = mstrOrigin;
    //
    NSLog(@"mstrOrigin输出:%p,%@\\n", mstrOrigin,mstrOrigin);
    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
    NSLog(@"retainMStr输出:%p,%@\\n",_retainMStr,_retainMStr);
    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
    NSLog(@"assignMStr输出:%p,%@\\n",_assignMStr,_assignMStr);
    NSLog(@"mstrOrigin 新的引用计数%@",[mstrOrigin valueForKey:@"retainCount"]);
    NSLog(@"aCopyMStr 的引用计数是:%@",[_aCopyMStr valueForKey:@"retainCount"]);
    /*
      mstrOrigin 开始的引用计数1
      mstrOrigin输出:0x60400004cab0,mstrOriginValue\n
      aCopyMStr输出:0x600000447c20,mstrOriginValue\n
      strongMStr输出:0x60400004cab0,mstrOriginValue\n
      retainMStr输出:0x60400004cab0,mstrOriginValue\n
      weakMStr输出:0x60400004cab0,mstrOriginValue\n
      assignMStr输出:0x60400004cab0,mstrOriginValue\n
      mstrOrigin 新的引用计数3
      aCopyMStr 的引用计数是:1
     */
    /*
     从上面可以看出copy 并没有改变引用计数，ratain ,Strong 使得引用计数分别 +1
     */
    NSLog(@"-------------  修改原值后 ----------------");
    [mstrOrigin appendString:@"+appendValue"];
    NSLog(@"mstrOrigin输出:%p,%@\\n", mstrOrigin,mstrOrigin);
    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);  // 没有改变
    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
    NSLog(@"retainMStr输出:%p,%@\\n",_retainMStr,_retainMStr);
    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
    NSLog(@"assignMStr输出:%p,%@\\n",_assignMStr,_assignMStr);
    
    NSLog(@"----------------- 设置成nil   --------------------");
    mstrOrigin = nil;
    NSLog(@"mstrOrigin输出:%p,%@\\n", mstrOrigin,mstrOrigin);
    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
    NSLog(@"retainMStr输出:%p,%@\\n",_retainMStr,_retainMStr);
    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
    NSLog(@"assignMStr输出:%p,%@\\n",_assignMStr,_assignMStr);
    NSLog(@"mstrOrigin 新的引用计数%@",[mstrOrigin valueForKey:@"retainCount"]);
    NSLog(@"strongMStr 新的引用计数%@",[_strongMStr valueForKey:@"retainCount"]);
    NSLog(@"aCopyMStr 的引用计数是:%@",[_aCopyMStr valueForKey:@"retainCount"]);
    NSLog(@"assignMStr 的引用计数是:%@",[_assignMStr valueForKey:@"retainCount"]);
    
    // strong retain 等影响了weak assign 的对比
}


/**
    这是一个 闪退的方法  assign
    可以发现在输出assignMStr时会偶尔出现奔溃的情况。原因是发送了野指针的情况。assign同weak，指向C并且计数不+1，但当C地址引用计数为0时，assign不会对C地址进行B数据的抹除操作 也就是设置为 nil，只是进行值释放。这就导致野指针存在，即当这块地址还没写上其他值前，能输出正常值，但一旦重新写上数据，该指针随时可能没有值，造成奔溃。
 
 */
- (void)compareAssignAndWeak
{
    NSMutableString *mstrOrigin = [[NSMutableString alloc] initWithString:@"mstrOriginValue"];
    self.assignMStr = mstrOrigin;
    self.weakMStr = mstrOrigin;
    
    mstrOrigin = [[NSMutableString alloc]initWithString:@"mstrOriginChange3"];
    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
    NSLog(@"assignMStr输出:%p,%@\\n",self.assignMStr,self.assignMStr);
}

#pragma mark ----   NSMutableArray 容器可变变量
- (void)arrTest
{
    
}
























































































@end
