//
//  ZJFCreateItemCollectionViewController.m
//  ChownhoundDaren
//
//  Created by 飞 on 15/3/17.
//  Copyright (c) 2015年 Fly tech. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

#import "ZJFCreateItemCollectionViewController.h"
#import "ZJFCreateOfHeaderCollectionReusableView.h"
#import "ZJFCreateOfFooterCollectionReusableView.h"
#import "ZJFCreateOfPhotoCollectionViewCell.h"
#import "ZJFCreateOfSpecialCollectionViewCell.h"
#import "ZJFCurrentLocation.h"
#import "ZJFLoginViewController.h"
#import "AppDelegate.h"
#import "ZJFCurrentUser.h"
#import "ZJFSNearlyItemStore.h"

@interface ZJFCreateItemCollectionViewController ()
{
    NSMutableDictionary *dictionary;  //存放header 和 footer 的引用
    CLLocationManager *locationManager;
    NSMutableArray *capturedImages;
 //   UIImagePickerController *imagePickerController;
}

@end

@implementation ZJFCreateItemCollectionViewController

int const numberOFMaxPictures = 5;

- (void)viewDidLoad{
    [super viewDidLoad];
    dictionary = [[NSMutableDictionary alloc] init];
    capturedImages = [[NSMutableArray alloc] init];
    
    if (self.loginViewController) {  //检测之前是否登录过
        //检测到登录取消了，返回到首页
        if (self.loginViewController.isCancelLogin) {
            self.loginViewController = nil; //释放资源
            self.tabBarController.selectedIndex = 0;
        }
    } else{
        [self testLogin];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)testLogin{
    
//    [AVUser logOut];
    AVUser *user = [AVUser currentUser];
    
    if (!user) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未登录" message:@"点击确定登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmLogin = [UIAlertAction actionWithTitle:@"登录"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^void(UIAlertAction *action){
                                                                 @try {
                            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            ZJFLoginViewController *loginController = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
                                                                     self.loginViewController = loginController;
                                                                     
                            [self presentViewController:loginController animated:YES completion:nil];
                            }
                                                                 @catch (NSException *exception) {
                                                                     NSLog(@"%@\n",exception);
                                                                     NSLog(@"222\n");
                                                                 }

                                                             }];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^void(UIAlertAction *action){
            self.tabBarController.selectedIndex = 0;
        }];
        
        [alert addAction:cancelButton];
        [alert addAction:confirmLogin];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [capturedImages count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row] == ([capturedImages count])) {
        ZJFCreateOfSpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfSpecialCell" forIndexPath:indexPath];
        
        return cell;
        
    } else {
        ZJFCreateOfPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfPhoto" forIndexPath:indexPath];
        UIImage *imageWithKey = [capturedImages objectAtIndex:[indexPath row]];
        
        [cell.imageView initWithImage:imageWithKey];
        
        return cell;
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//执行两次
    
   
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZJFCreateOfHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CreateOfHeader" forIndexPath:indexPath];
        
        [dictionary setObject:header forKey:@"header"];
        return header;
    } else {
        ZJFCreateOfFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CreateOfFooter" forIndexPath:indexPath];
        
        [dictionary setObject:footer forKey:@"footer"];
        return footer;
    }
    
    
}


- (void)deleteImage:(UIImage *)image{
    
    int row = [capturedImages indexOfObject:image];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
   
   [capturedImages removeObject:image];
    
    
    @try
    {

        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
    @catch (NSException *except)
    {
        NSLog(@"  %@", except.description);
    }
    
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [capturedImages count]) {
        [self showAlertSheet];
    }
}

//设置新窗口，选择图片
- (void)showAlertSheet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"nithing"
                                                                   message:@"选择照片上传方式"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *chooseFromAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler: ^void(UIAlertAction *action){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.delegate = self;
                                                                      
        imagePickerController = imagePickerController;
        [[self.tabBarController tabBar] setHidden:YES];
                                                                      
        [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                      
                                                                  }];

    
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler: ^void(UIAlertAction *action){
         UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
         imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
         imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
         imagePickerController.delegate = self;
                                                                 
         imagePickerController = imagePickerController;
                                                                 [[self.tabBarController tabBar] setHidden:YES];
                                                                 
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                                        
         [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                 
                                                             }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:chooseFromAlbumAction];
    [alert addAction:chooseFromCamera];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    [capturedImages addObject:image];
        
    //[[ZJFImageStore shareStore] setImage:image forKey:uniqueImageName];
        
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self.tabBarController tabBar] setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
        
}

- (NSArray *)array{
    return capturedImages;
}

- (ZJFCreateOfHeaderCollectionReusableView *)getHeaderView{
    return [dictionary objectForKey:@"header"];
}

- (ZJFCreateOfFooterCollectionReusableView *)getFooterView{
    return [dictionary objectForKey:@"footer"];
}

- (IBAction)createCancel:(id)sender {
    [self tabBarController].selectedIndex = 0;
}

- (IBAction)sendToServe:(id)sender {
    self.tabBarController.selectedIndex = 0; //发送完后，立刻返回首页
    
    //  [[[ZJFCurrentLocation shareStore] locationManager] stopUpdatingLocation];
    
    //   CLLocation *xlocation = [ZJFCurrentLocation shareStore].location;
    //   NSLog(@"fuck1: %f\n",xlocation.coordinate.latitude);
    //   NSLog(@"fuck2: %f\n",xlocation.coordinate.longitude);
    //  NSLog(@"fuck3:%@\n",xlocation.description);
    
    CLLocation *cllocation = [ZJFCurrentLocation shareStore].location;
    
    AVObject *shareItem = [AVObject objectWithClassName:@"shareItem"];
    
    [shareItem setObject:[NSNumber numberWithDouble:cllocation.coordinate.latitude] forKey:@"latitude"];
    [shareItem setObject:[NSNumber numberWithDouble:cllocation.coordinate.longitude] forKey:@"longitude"];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *thumbnailStore = [[NSMutableDictionary alloc] init];
    
    if ([capturedImages count]) {
        for (int i=0; i<[capturedImages count]; i++) {
            NSData *data = UIImageJPEGRepresentation([capturedImages objectAtIndex:i], 0.5);
            
            //这里应当给文件添加合适的扩展名！
            NSString *uuidString = [[NSUUID UUID] UUIDString];
            AVFile *file = [AVFile fileWithName:uuidString data:data];
            [file save];
            
            [mutableArray addObject:file];
            
            //将缩略图的名称和原始图片名称保持一致，方便由缩略图名得到原始图片
            UIImage *image1 = [self getThumbnail:[capturedImages objectAtIndex:i]];
            NSData *thumbnailData = UIImageJPEGRepresentation(image1, 0.5);
            [thumbnailStore setObject:thumbnailData forKey:uuidString];
        }
        
    }
    [shareItem setObject:(NSDictionary *)thumbnailStore forKey:@"thumbnailData"];
    [shareItem setObject:(NSArray *)mutableArray forKey:@"imageStore"];
    
    NSString *descriptionOfItem = [[self getHeaderView] textViewInHeader].text;
    NSString *locationNameOfItem = [[self getFooterView] textFieldInFooter].text;
    [shareItem setObject:descriptionOfItem forKey:@"itemDescription"];
    [shareItem setObject:locationNameOfItem forKey:@"placeName"];
    
    [shareItem setObject:[AVUser currentUser].username forKey:@"username"];
    [shareItem setObject:[NSDate date] forKey:@"createDate"];
    
    //如果item的description长度小于5，则它不进行相似度查询，因为文本太短，无法确定
    if (descriptionOfItem.length < 5) {
        [shareItem setObject:[NSNumber numberWithBool:NO] forKey:@"canFoundSimiliarity"];
    } else {
        [shareItem setObject:[NSNumber numberWithBool:YES] forKey:@"canFoundSimiliarity"];
    }
    
    //处理信息中包含的文本，服务器分词、本地计算tf-idf值，然后将结果作为数组保存至shareItem，keyWord 数组中
    NSDictionary *parameter = @{@"string" : descriptionOfItem};
    [AVCloud callFunctionInBackground:@"hello" withParameters:parameter block:^(id object, NSError *error){
        if (!error) {
            NSArray *array = (NSArray *)object;  //得到从服务器返回的分词数组
            
            NSDictionary *d = [self compressArray:array];  //对分词数组进行压缩
            NSLog(@"%@\n",d);
            
            [self incrementForDictionary:d];  //修改语义词中相应词出现的次数
            
            NSArray *wordsTf = [self calculateTf_Idf:d numberOfAll:array.count];  //得到各个分词的tf-idf值
            for (NSDictionary *dic in wordsTf) {
                NSLog(@"\nkey: %@\ntf-idf: %@\n",[dic objectForKey:@"key"],[dic objectForKey:@"tf-idf"]);
            }
            
            NSLog(@"---------------\n");
            
            NSArray *sortedWordsTf = [self sortArrayByTf_idf:wordsTf];
            for (NSDictionary *dic in sortedWordsTf) {
                NSLog(@"\nkey: %@\ntf-idf: %@\n",[dic objectForKey:@"key"],[dic objectForKey:@"tf-idf"]);
            }
            
            NSLog(@"-------------\n");
            
            NSArray *keyWordsTf = [self getFirstTenElement:sortedWordsTf];
            for (NSDictionary *dic in keyWordsTf) {
                NSLog(@"\nkey: %@\ntf-idf: %@\n",[dic objectForKey:@"key"],[dic objectForKey:@"tf-idf"]);
            }
            
            NSArray *keyWords = [self getKeyWords:keyWordsTf];
            
            [shareItem setObject:keyWords forKey:@"keyWords"];  //item中关键词组成的数组，主要用于相似度时查询使用
            
            [shareItem setObject:keyWordsTf forKey:@"keyWordWithTF_IDF"];
            
            [shareItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (!error) {
                    NSLog(@"保存完成\n");
                    
                    //用户每发布一条信息，将数据库中item的总值加1，即countItem类的count属性加1
                    AVQuery *queryCount = [AVQuery queryWithClassName:@"countItem"];
                    [queryCount getFirstObjectInBackgroundWithBlock:^(AVObject *object,NSError *error){
                        if (!error) {
                            [object incrementKey:@"count"];
                        }
                        
                        [object saveInBackground];
                    }];
                    
                    //保存完成后，刷新数据,将新数据读取到本地
                    //            [[ZJFSNearlyItemStore shareStore] findSurroundObjectForRefresh];
                    
                    [capturedImages removeAllObjects];
                    [[self getHeaderView] textViewInHeader].text = nil;
                    [[self getFooterView] textFieldInFooter].text = nil;
                    
                    
                } else {
                    NSLog(@"%@\n",[error description]);
                }
            }];
            
        } else {
            NSLog(@"call function error: %@\n",[error description]);
        }
    }];
}

#pragma mark -处理从服务器返回的分词

- (NSArray *)getKeyWords:(NSArray *)array{
    //得到array中包含的关键词数组

    NSMutableArray *keyWords = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        [keyWords addObject:[dic objectForKey:@"key"]];
    }
    
    return keyWords;
}

- (NSArray *)getFirstTenElement:(NSArray *)array{
    //如果该数组长度长于10，取前10个元素
    
    NSMutableArray *firstTenArray = [NSMutableArray array];
    if(array.count > 10){
        for (int i=0; i<10; i++) {
            [firstTenArray addObject:[array objectAtIndex:i]];
        }
        
        return firstTenArray;
    } else{
        return array;
    }
}

- (NSArray *)sortArrayByTf_idf:(NSArray *)array{
    //根据每项字典中的tf值对数组进行排序
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [[obj2 objectForKey:@"tf-idf"] compare:[obj1 objectForKey:@"tf-idf"]];
        return result;
    }];
    
    return sortedArray;
}


- (NSArray *)calculateTf_Idf:(NSDictionary *)dic numberOfAll:(int)keyCounts{
    //返回一个数组，该数组包含所有的词和对应的tf-idf值
    AVQuery *queryCount = [AVQuery queryWithClassName:@"countItem"];
    AVObject *object = [queryCount getFirstObject];
    double allItemCount = [[object objectForKey:@"count"] doubleValue];
    
    NSMutableArray *keyWords = [NSMutableArray array];
    
    NSArray *keys = [dic allKeys];
    
    for (NSString *key in keys) {
        //得到该词在word_library类中的值，即在语义库中出现的次数
        AVQuery *queryWord = [AVQuery queryWithClassName:@"word_library"];
        [queryWord whereKey:@"word" equalTo:key];
        AVObject *wordObject = [queryWord getFirstObject];
        double wordCount = [[wordObject objectForKey:@"count"] doubleValue];

        
        //词频(tf) = 某个词在文章中出现的次数/该文章总词数
        double tf = [[dic objectForKey:key] doubleValue] / keyCounts;
        //idf = 语料库中文档总数 / 包含该词的文档书 + 1，然后求他的自然对数
        double idf = log((allItemCount+1)/ (wordCount+1));  //防止分母分子为零
        
        double tf_idf = tf * idf;
        
        //数组每项为一个字典，该字典有两个键，key 和 tf-idf，分别对应着word以及该word的tf-idf值
        [keyWords addObject:@{@"key": key ,@"tf-idf": [NSNumber numberWithDouble:tf_idf]}];
    }
    
    
    return keyWords;
}


- (NSDictionary *)compressArray:(NSArray *)array {
    //数组中含有重复词组，合并
    NSMutableDictionary *KeyWords = [[NSMutableDictionary alloc] init];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    
    for (NSString *word in array) {
        if ([self isContainInArray:keyArray withString:word]) {
            //字典中已经有该词为键的项
            
            double i = [[KeyWords objectForKey:word] doubleValue];
            [KeyWords removeObjectForKey:word];
            [KeyWords setObject:[NSNumber numberWithDouble:i+1] forKey:word];
        } else {
            //字典中没有包含该项，则以该词新建一个键
            
            [KeyWords setObject:[NSNumber numberWithDouble:1.0] forKey:word];
            [keyArray addObject:word];
        }
    }
    
    return KeyWords;  //返回的字典中，包含所有的分词，以及他们的出现频率
}

//根据字典中对应的词语，修改word_library类中该词的count属性值，即加1
- (void)incrementForDictionary:(NSDictionary *)dic{
    NSArray *keys = [dic allKeys];
    for (NSString *key in keys) {
        //查找是否已经包含此词语
        
        AVQuery *query = [AVQuery queryWithClassName:@"word_library"];
        [query whereKey:@"word" equalTo:key];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
            if (object == nil) {
                //类库中尚未包含该词，将该词作为新的项加入
                
                AVObject *object = [AVObject objectWithClassName:@"word_library"];
                [object setObject:key forKey:@"word"];
                [object setObject:[NSNumber numberWithInt:1] forKey:@"count"];
                [object saveInBackground];
            } else {
                [object incrementKey:@"count"];
                [object saveInBackground];
            }
        }];
    }
}

- (BOOL)isContainInArray:(NSArray *)array  withString:(NSString *)string{
    //检测string是否包含在array中
    for (NSString *key in array) {
        if ([key isEqualToString:string]) {
            return YES;
        }
    }
    
    return NO;
}


- (UIImage *)getThumbnail:(UIImage *)image{
    CGSize newSize = CGSizeMake(82, 82);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}














@end
