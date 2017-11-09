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

typedef int(^TestBlock)(int a);

@interface ViewController ()

// 非容器 可变变量
@property(copy,nonatomic)NSMutableString*aCopyMStr;
@property(strong,nonatomic)NSMutableString*strongMStr;
@property (retain,nonatomic)NSMutableString *retainMStr;
@property(weak,nonatomic)NSMutableString*weakMStr;
@property(assign,nonatomic)NSMutableString*assignMStr;   // 我们用assign 修饰对象

//  retain and strong  copy  暂时没测试出 区别crash retain 苹果会报错
@property (strong,nonatomic)TestBlock strongTestBlock;
@property (retain,nonatomic)TestBlock retainTestBlock;
@property (copy,nonatomic)TestBlock copyTestBlock;
@property (assign,nonatomic)TestBlock assignTestBlock;


// 有容器对象
@property(copy,nonatomic)NSMutableArray*aCopyMArr;
@property(strong,nonatomic)NSMutableArray*strongMArr;
@property(weak,nonatomic)NSMutableArray*weakMArr;

// 非容器不可变变量
@property(copy,nonatomic)NSString*aCopyStr;
@property(strong,nonatomic)NSString*strongStr;
@property(weak,nonatomic)NSString*weakStr;
@property(assign,nonatomic)NSString*assignStr;




@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self memoryTest];
//    [self testOne];
//    [self compareAssignAndWeak];
    
//    [self comapreStrongAndRetainAndCopy];
//    [self  retainBlockAlone];
//    [self assignBlockAlone];
//    [self testRetainBlockAgain];
    
//    [self  arrTest];
//    [self nsstringTest];
    [self weakStringTestTwo];
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
    可以发现在输出assignMStr时会出现奔溃的情况。原因是发送了野指针的情况。assign同weak，指向C并且计数不+1，但当C地址引用计数为0时，assign不会对C地址进行B数据的抹除操作 也就是设置为 nil，只是进行值释放。这就导致野指针存在，即当这块地址还没写上其他值前，能输出正常值，但一旦重新写上数据，该指针随时可能没有值，造成奔溃。
 
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

#pragma mark ---- 测试 Block assign strong retain weak  然并卵
/*
 在处理用strong声明的Block属性引发的问题时偶然发现的。在诸多教程中都会讲到：声明属性时用strong或者retain效果是一样的（貌似更多开发者更倾向于用strong）。不过在声明Block时，使用strong和retain会有截然不同的效果。strong会等于copy，而retain竟然等于assign！
 
 当然定义Block还是应该用copy（还有其他需要注意的地方，可以参考这篇文章：iOS: ARC和非ARC下使用Block属性的问题），因为非ARC下不copy的Block会在栈中，ARC中的Block都会在堆上的。
 */

- (void)comapreStrongAndRetainAndCopy
{
    // 前面已经比较过  strong 和 assign 的区别
    TestBlock mBlock = ^(int a){
        return a+3;
    };
    
    self.retainTestBlock = mBlock;
    self.strongTestBlock = mBlock;
    self.copyTestBlock = mBlock;
    
    self.retainTestBlock(4);
    self.strongTestBlock(4);
    self.copyTestBlock(4);
    
    // mBlock 的改变并没有引起 copyBlock的改变 还是  7 也没有引起retain 和 strong 的改变
    // 这点和 指针类还是有点差别
    mBlock = ^(int a){
        return  a+5;
    };
    
//    self.retainTestBlock = mBlock;
//    self.strongTestBlock = mBlock;
//    self.copyTestBlock = mBlock;
    
    int a = self.retainTestBlock(4);
    int b = self.strongTestBlock(4);
    int m = self.copyTestBlock(4);
    NSLog(@"a %d b:%d",a,b);
    
    mBlock = nil;
    int retainBlock = self.retainTestBlock(4);
    int strongBlock = self.strongTestBlock(4);
    int copyBlock = self.copyTestBlock(4);
    NSLog(@"retain :%d strong :%d copy :%d",retainBlock,strongBlock,copyBlock);
    int retainBlockKey = [self.retainTestBlock valueForKey:retainCountKey];
    int strongBlockKey = [self.strongTestBlock valueForKey:retainCountKey];
    int copyBlockKey = [self.copyTestBlock valueForKey:retainCountKey];
    
}

- (void)retainBlockAlone
{
    // 前面已经比较过  strong 和 assign 的区别
    TestBlock mBlock = ^(int a){
        return a+3;
    };
    
    self.retainTestBlock = mBlock;
    int a = self.retainTestBlock(4);
    
    mBlock = ^(int a){
        return  a+5;
    };
    
//    self.retainTestBlock = mBlock;
    int b = self.retainTestBlock(4);
    
    mBlock = nil;
    int c = self.retainTestBlock(4);   // 无论 mBlock 如何改变都没有改变 retainBlock
    
}

- (void)assignBlockAlone
{
    // 前面已经比较过  strong 和 assign 的区别
    TestBlock mBlock = ^(int a){
        return a+3;
    };
    
    self.assignTestBlock = mBlock;
    int a = self.assignTestBlock(4);
    
    mBlock = ^(int a){
        return  a+5;
    };
    
    self.assignTestBlock = mBlock;
    int b = self.assignTestBlock(4);
    
    mBlock = nil;
    int c = self.assignTestBlock(4);
}

/*
   一直到这里也没有 发现 assign 和 retain 的区别
 */
- (void)testRetainBlockAgain
{
    self.retainTestBlock =  ^(int a){
        return a+3;
    };
    int a = self.retainTestBlock(4);
    
    self.retainTestBlock = ^(int a){
        return  a+5;
    };
    int b = self.retainTestBlock(4);
    
//    self.retainTestBlock = nil;
//    int c = self.retainTestBlock(4);   // 无论 mBlock 如何改变都没有改变 retainBlock
}


#pragma mark ----   NSMutableArray 容器可变变量
/*
 上面代码有点多，所做的操作是mArrOrigin（value1,value2）赋值给copy,strong,weak修饰的aCopyMArr,strongMArr,weakMArr。通过给原数组增加元素，修改原数组元素值，然后输出mArrOrigin的引用计数，和数组地址，查看变化。
 发现其中数组本身指向的内存地址除了aCopyMArr重新开辟了一块地址，strongMArr,weakMArr和mArrOrigin指针指向的地址是一样的。也就是说
 
 容器可变变量中容器本身和非容器可变变量是一样的，copy深拷贝，strongMArr,weakMArr和assign都是浅拷贝
 
 另外我们发现被拷贝对象mArrOrigin中的数据引用计数居然不是1而是3。也就是说容器内的数据拷贝都是进行了浅拷贝。同时当我们修改数组中的一个数据时strongMArr,weakMArr，aCopyMArr中的数据都改变了，说明
 
 容器可变变量中的数据在拷贝的时候都是浅拷贝
 */
- (void)arrTest
{
    NSMutableArray*mArrOrigin = [[NSMutableArray alloc]init];
    NSMutableString*mstr1 = [[NSMutableString alloc]initWithString:@"value1"];
    NSMutableString*mstr2 = [[NSMutableString alloc]initWithString:@"value2"];
    NSMutableString*mstr3 = [[NSMutableString alloc]initWithString:@"value3"];
    
    [mArrOrigin addObject:mstr1];
    [mArrOrigin addObject:mstr2];
    
    //将mArrOrigin拷贝给aCopyMArr，strongMArr，weakMArr
    self.aCopyMArr= mArrOrigin;
    self.strongMArr= mArrOrigin;
    self.weakMArr= mArrOrigin;
    
    NSLog(@"mArrOrigin输出:%p,%@\\n", mArrOrigin,mArrOrigin);
    NSLog(@"aCopyMArr输出:%p,%@\\n",_aCopyMArr,_aCopyMArr);
    NSLog(@"strongMArr输出:%p,%@\\n",_strongMArr,_strongMArr);
    NSLog(@"weakMArr输出:%p,%@\\n",_weakMArr,_weakMArr);
    NSLog(@"weakMArr输出:%p,%@\\n",_weakMArr[0],_weakMArr[0]);
    NSLog(@"mArrOrigin中的数据引用计数%@", [mArrOrigin valueForKey:@"retainCount"]);
    NSLog(@"%p %p %p %p",&mArrOrigin,mArrOrigin,mArrOrigin[0],mArrOrigin[1]);
    // 说明 weak 并没有增加引用计数
    
    //给原数组添加一个元素
    [mArrOrigin addObject:mstr3];
    
    NSLog(@"mArrOrigin输出:%p,%@\\n", mArrOrigin,mArrOrigin);
    NSLog(@"aCopyMArr输出:%p,%@\\n",_aCopyMArr,_aCopyMArr);
    NSLog(@"strongMArr输出:%p,%@\\n",_strongMArr,_strongMArr);
    NSLog(@"weakMArr输出:%p,%@\\n",_weakMArr,_weakMArr);
    NSLog(@"mArrOrigin中的数据引用计数%@", [mArrOrigin valueForKey:@"retainCount"]);
    
    //修改原数组中的元素，看是否有随之变化 copy也发生了改变
    [mstr1 appendFormat:@"aaa"];
    
    NSLog(@"mArrOrigin输出:%p,%@\\n", mArrOrigin,mArrOrigin);
    NSLog(@"aCopyMArr输出:%p,%@\\n",_aCopyMArr,_aCopyMArr);
    NSLog(@"strongMArr输出:%p,%@\\n",_strongMArr,_strongMArr);
    NSLog(@"weakMArr输出:%p,%@\\n",_weakMArr,_weakMArr);
    
    #pragma mark ---- !!! 注意发现  改变 mstr1
    // _aCopyMArr 的第一个元素也发生了 也就是 copy 了array 但是没有对每个元素
    // 每个元素copy 一遍放新的数组里面去 注意是并没有 这么做。
}


#pragma mark ---- NSString 测试

/**
 其实笔者 认为 weakString 是不宜 和 strong 一起的
 */
- (void)nsstringTest
{
    NSLog(@"\\n\\n\\n\\n------------------不可变量实验------------------------");
    
    NSString*strOrigin = [[NSString alloc]initWithUTF8String:"strOrigin0123456"];
    self.aCopyStr= strOrigin;
    self.strongStr= strOrigin;
    self.weakStr= strOrigin;
    
    NSLog(@"strOrigin输出:%p,%@\\n", strOrigin,strOrigin);
    NSLog(@"aCopyStr输出:%p,%@\\n",_aCopyStr,_aCopyStr);
    NSLog(@"strongStr输出:%p,%@\\n",_strongStr,_strongStr);
    NSLog(@"weakStr输出:%p,%@\\n",_weakStr,_weakStr);
    NSLog(@"------------------修改原值后------------------------");
    
    strOrigin =@"aaa";
    NSLog(@"strOrigin输出:%p,%@\\n", strOrigin,strOrigin);
    NSLog(@"aCopyStr输出:%p,%@\\n",_aCopyStr,_aCopyStr);
    NSLog(@"strongStr输出:%p,%@\\n",_strongStr,_strongStr);
    NSLog(@"weakStr输出:%p,%@\\n",_weakStr,_weakStr);
    NSLog(@"------------------结论------------------------");
    
    NSLog(@"strOrigin值值为改变，但strOrigin和aCopyStr指针地址和指向都已经改变，说明不可变类型值不可被修改，重新初始化");
    
    self.aCopyStr=nil;
    self.strongStr=nil;
    NSLog(@"strOrigin输出:%p,%@\\n", strOrigin,strOrigin);
    NSLog(@"aCopyStr输出:%p,%@\\n",_aCopyStr,_aCopyStr);
    NSLog(@"strongStr输出:%p,%@\\n",_strongStr,_strongStr);
    NSLog(@"weakStr输出:%p,%@\\n",_weakStr,_weakStr);
    
    NSLog(@"------------------结论------------------------");
    
    NSLog(@"当只有weakStr拥有C时，值依旧会被释放，同非容器可变变量");
}


/**
 这个 weak 测试告诉我们  strong 和 copy strOrigin 影响了weak 这个属性的值
 对比 和 上面那个方法的测试 weakStr 的输出。
 还有一个 strOrigin 被赋予新的值后  前面一块区域实际是被系统回收了 weak 的对象设置成了 null 值
 这样 没有野指针
 */
- (void)weakStringTestTwo
{
    NSString*strOrigin = [[NSString alloc]initWithUTF8String:"HelloDeLong"];
    self.weakStr = strOrigin;
    NSLog(@"weakStr输出:%p,%@\\n",_weakStr,_weakStr);
    strOrigin =@"aaa";
    
 
    NSLog(@"weakStr输出:%p,%@\\n",_weakStr,_weakStr);
    
    /*
      weakStr输出:0x6000002252a0,HelloDeLong\n
      weakStr输出:0x0,(null)\n
     */

}























































































@end
