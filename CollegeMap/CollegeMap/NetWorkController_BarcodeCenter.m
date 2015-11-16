//
//  NetWorkController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/4.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "NetWorkController_BarcodeCenter.h"
#import "Ono.h"
#import "AFNetworking.h"

@interface NetWorkController_BarcodeCenter ()
@property (strong, nonatomic) ONOXMLDocument *document;
@end

@implementation NetWorkController_BarcodeCenter

- (void)dealloc
{
    NSLog(@"network dealloc");
}

- (void)searchBarcode:(NSString *)barcode
{
    id htmlURL = [self getURLFromBarcode:barcode];
    
    [self loadContentOfURLString:htmlURL];
}

- (NSURL *)getURLFromBarcode:(NSString *)barcode
{
    NSString *urlString = @"http://search.anccnet.com/searchResult2.aspx?keyword=[barcode]";
    NSString *tempString = [urlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL *URL = [NSURL URLWithString:tempString];
    
    return URL;
}

- (void)loadContentOfURLString:(NSURL *)url
{
    [self getDataWithURL:url];
}

- (void)getDataWithURL:(NSURL *)url
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"ASP.NET_SessionId=kw1wvp32wlyipof4ejkpup45" forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"http://www.anccnet.com/" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setValue:@"search.anccnet.com" forHTTPHeaderField:@"Host"];
    
    __weak NetWorkController_BarcodeCenter *weakself = self;
    
    [manager GET:[url absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        [weakself performSelectorOnMainThread:@selector(giveMeDocumentWithData:) withObject:responseObject waitUntilDone:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 %@",error);
    }];
}

- (void)giveMeDocumentWithData: (NSData *)data
{
    NSError *error;
    
    ONOXMLDocument *document =
    [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    self.document = document;
    
    NSDictionary *dic = [self giveMeDicOfItem];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SEARCH_BARCODE_DONE object:self userInfo:dic];
}

- (NSDictionary *)giveMeDicOfItem
{
    NSString *brandXpath = @"//*[@id=\"results\"]/li/div/dl[1]/dd[1]";
    NSString *titleXpath = @"//*[@id=\"results\"]/li/div/dl[2]/dd[2]";
    NSString *factoryXpath = @"//*[@id=\"repList_ctl00_firmLink\"]";
    NSString *specXpath = @"//*[@id=\"results\"]/li/div/dl[2]/dd[3]";
    NSString *descXpath = @"//*[@id=\"results\"]/li/div/dl[2]/dd[4]";
    NSString *imageURLXpath = @"//*[@id=\"repList_ctl00_productimg\"]";
    NSString *imageURLAttribute = @"src";
    
    NSString *brand = [self searchElementValueWithXpath:brandXpath andDocument:self.document];
    NSString *title = [self searchElementValueWithXpath:titleXpath andDocument:self.document];
    NSString *factory = [self searchElementValueWithXpath:factoryXpath andDocument:self.document];
    NSString *spec = [self searchElementValueWithXpath:specXpath andDocument:self.document];
    NSString *desc = [self searchElementValueWithXpath:descXpath andDocument:self.document];
    NSString *imageURLtemp = [self searchStringWithXpath:imageURLXpath andDocument:self.document andAttribute:imageURLAttribute];
    NSString *imageURL = [@"http://search.anccnet.com" stringByAppendingString:imageURLtemp];
    NSURL    *imageURLR = [NSURL URLWithString:imageURL];
    
    if (title.length == 0) {
        title = @"未搜索到该物品";
    }
    
    NSDictionary *dic = @{
                          ITEM_INFO_BRAND : brand,
                          ITEM_INFO_TITLE : title,
                          ITEM_INFO_FACTORY : factory,
                          ITEM_INFO_SPEC : spec,
                          ITEM_INFO_DESC : desc,
                          ITEM_INFO_IMAGEURL : imageURLR,
                          };
    return dic;
}

#pragma mark - document API

- (NSString *)searchStringWithXpath: (NSString *)XPath andDocument: (ONOXMLDocument *)document andAttribute: (NSString *)attribute
{
    __block NSString *tempString = [[NSString alloc]init];
    [document enumerateElementsWithXPath:XPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        tempString = (NSString *)[element valueForAttribute:attribute];
    }];
    
    return tempString;
}

- (NSString *)searchElementValueWithXpath: (NSString *)XPath andDocument: (ONOXMLDocument *)document
{
    __block NSString *tempString = [[NSString alloc]init];
    [document enumerateElementsWithXPath:XPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        tempString = [element stringValue];
    }];
    
    return tempString;
}

@end
