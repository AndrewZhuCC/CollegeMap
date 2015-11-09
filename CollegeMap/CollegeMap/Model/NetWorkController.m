//
//  NetWorkController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/4.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "NetWorkController.h"
#import "Ono.h"

@interface NetWorkController ()
{
    BOOL  _isHD;
}
@end

@implementation NetWorkController

/**
 *  通过NSString格式的条形码，输出一个dic
 *
 *  @param barcode NSString格式的条形码
 *
 *  @return 包含商品title和image的字典
 */
- (NSDictionary *)searchBarcode:(NSString *)barcode
{
    _isHD = [[NSUserDefaults standardUserDefaults] boolForKey:HD_SETTING_KEY];
    id htmlURL = [self getURLFromBarcode:barcode];
    
    NSDictionary *dic = [self loadContentOfURLString:htmlURL];
    
    return dic;
}

/**
 *  利用百度在特定站内搜索的功能得到一个URL
 *
 *  @param barcode 条形码
 *
 *  @return 百度搜索的URL
 */
- (NSArray *)getURLFromBarcode:(NSString *)barcode
{
    NSString *titleHtmlString = @"http://www.baidu.com/s?wd=[barcode]%20site%3Aamazon.cn";
    /**
     *  https版本的百度搜索
     */
    //    NSString *HtmlString = @"https://www.baidu.com/s?ie=utf-8&wd=[barcode]%20site%3Aamazon.cn";
    NSString *titleString = [titleHtmlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL *titleURL = [NSURL URLWithString:titleString];
    /**
     *  电脑端百度图片搜索和手机端百度图片搜索
     */
    //    NSString *imageHtmlString = @"http://image.baidu.com/search/index?tn=baiduimage&word=[barcode]%20site%3Aamazon.cn";
    NSString *imageHtmlString = @"http://image.baidu.com/search/wisemidresult?word=[barcode]+site%3Aamazon.cn&tn=wisemidresult";
    NSString *imageString = [imageHtmlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL *imageURL = [NSURL URLWithString:imageString];
    
    NSArray *result = @[titleURL, imageURL];
    return result;
}

- (NSDictionary *)loadContentOfURLString:(NSArray *)htmlURL
{
    NSURL *titleURL = [htmlURL objectAtIndex:0];
    NSURL *imageURL = _isHD ? [htmlURL objectAtIndex:0] : [htmlURL objectAtIndex:1];
    
    NSDictionary *dic = @{
                          ZAZResultTitle : [self giveMeTitle:titleURL],
                          ZAZResultImage : [self giveMeImage:imageURL],
                          };
    return dic;
}

- (ONOXMLDocument *)giveMeDocumentWithURL: (NSURL *)htmlURL
{
    
    
    NSData *htmlURLData = [NSData dataWithContentsOfURL:htmlURL];
    NSError *error;
    
    ONOXMLDocument *document =
    [ONOXMLDocument HTMLDocumentWithData:htmlURLData error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return document;
}

- (NSString *)giveMeTitle:(NSURL *)titleURL
{
    if (_isHD) {
        NSString *xpath1 = @"//*[@id=\"1\"]/h3/a";
        NSString *attribute1 = @"href";
        NSString *tempString = [self searchStringWithXpath:xpath1 andhtmlURL:titleURL andAttribute:attribute1];
        NSURL    *tempURL = [NSURL URLWithString:tempString];
        
        NSString *xpath2 = @"//*[@id=\"landingImage\"]";
        NSString *attribute2 = @"alt";
        NSString *title = [self searchStringWithXpath:xpath2 andhtmlURL:tempURL andAttribute:attribute2];
        
        if (title.length == 0) {
            title = @"未搜索到该条形码";
        }
        
        return title;
    } else {
        ONOXMLDocument *document = [self giveMeDocumentWithURL:titleURL];
        
        __block NSString *title = [[NSString alloc]init];
        
        NSString *XPathTitle = @"//h3[@class='t']/a";
        
        [document enumerateElementsWithXPath:XPathTitle usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            title = [element stringValue];
        }];
        if (title.length == 0) {
            title = @"未搜索到该条形码";
        }
        
        return title;
    }
}

- (NSURL *)giveMeImage:(NSURL *)htmlURL
{
    if (_isHD) {
        NSString *xpath1 = @"//*[@id=\"1\"]/h3/a";
        NSString *attribute1 = @"href";
        NSString *tempString = [self searchStringWithXpath:xpath1 andhtmlURL:htmlURL andAttribute:attribute1];
        NSURL    *tempURL = [NSURL URLWithString:tempString];
        
        NSString *xpath2 = @"//*[@id=\"landingImage\"]";
        NSString *attribute2 = @"data-a-dynamic-image";
        NSString *imageString = [self searchStringWithXpath:xpath2 andhtmlURL:tempURL andAttribute:attribute2];
        NSURL    *imageURL = [self tempString2URL:imageString];
        
        return imageURL;
    } else {
        ONOXMLDocument *document = [self giveMeDocumentWithURL:htmlURL];
        
        __block NSString *imageString = [[NSString alloc]init];
        
        NSString *XPathImage = @"/html/body/div[2]/a[1]/img";
        
        [document enumerateElementsWithXPath:XPathImage usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            imageString = (NSString *)[element valueForAttribute:@"src"];
        }];
        
        NSURL *imageURL = [NSURL URLWithString:imageString];
        
        return imageURL;
    }
}

- (NSString *)searchStringWithXpath: (NSString *)XPath andhtmlURL: (NSURL *)htmlURL andAttribute: (NSString *)attribute
{
    ONOXMLDocument *document = [self giveMeDocumentWithURL:htmlURL];
    
    __block NSString *tempString = [[NSString alloc]init];
    [document enumerateElementsWithXPath:XPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        tempString = (NSString *)[element valueForAttribute:attribute];
    }];
    
    return tempString;
}

- (NSURL *)tempString2URL: (NSString *)tempString
{
    NSArray *aArray = [tempString componentsSeparatedByString:@"\""];
    
    if ([aArray objectAtIndex:1]) {
        NSURL *result = [NSURL URLWithString:[aArray objectAtIndex:1]];
        return result;
    } else {
        NSURL *result = [NSURL URLWithString:@""];
        return result;
    }
}

@end