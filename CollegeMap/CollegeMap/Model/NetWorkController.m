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

@property (nonatomic, strong) ONOXMLDocument *titleDocument;
@property (nonatomic, strong) ONOXMLDocument *imageAndHDDocument;
@property (nonatomic, strong) ONOXMLDocument *valueDocument;

@end

@implementation NetWorkController

#pragma mark -

- (NSDictionary *)searchBarcode:(NSString *)barcode
{
    _isHD = [[NSUserDefaults standardUserDefaults] boolForKey:HD_SETTING_KEY];
    [self getURLFromBarcode:barcode];
    
    NSDictionary *dic = [self loadContentOfURLString];
    
    return dic;
}

- (void)getURLFromBarcode:(NSString *)barcode
{
    NSString *titleHtmlString = BAIDU_TITLE_HTTP;
    NSString *titleString = [titleHtmlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL *titleURL = [NSURL URLWithString:titleString];
    _titleDocument = [self giveMeDocumentWithURL:titleURL];
    
    NSString *imageHtmlString = BAIDU_IMAGE_HTTP;
    NSString *imageString = [imageHtmlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL *imageURL = [NSURL URLWithString:imageString];
    
    if (_isHD) {
        NSString *xpath1 = @"//*[@id=\"1\"]/h3/a";
        NSString *attribute1 = @"href";
        NSString *tempString = [self searchStringWithXpath:xpath1 andDocument:_titleDocument andAttribute:attribute1];
        NSURL    *tempURL = [NSURL URLWithString:tempString];
        _imageAndHDDocument = [self giveMeDocumentWithURL:tempURL];
    } else {
        _imageAndHDDocument = [self giveMeDocumentWithURL:imageURL];
    }
    
    NSString *valueHtmlString = BAIDU_VALUE_M;
    NSString *valueString = [valueHtmlString stringByReplacingOccurrencesOfString:@"[barcode]" withString:barcode];
    NSURL    *valueURL = [NSURL URLWithString:valueString];
    ONOXMLDocument *tempDocument = [self giveMeDocumentWithURL:valueURL];
    
    NSString *xpathValue = @"/html/body/div/div[3]/div[1]/a";
    NSString *attributeValue = @"href";
    NSString *valueURLtempString = [self searchStringWithXpath:xpathValue andDocument:tempDocument andAttribute:attributeValue];
    valueURLtempString = [valueURLtempString stringByReplacingOccurrencesOfString:@"./" withString:BAIDU_VALUE_REPLACE];
    _valueDocument = [self giveMeDocumentWithURL:[NSURL URLWithString:valueURLtempString]];
    
}

- (NSDictionary *)loadContentOfURLString
{
    NSDictionary *dic = @{
                          ZAZResultTitle : [self giveMeTitle],
                          ZAZResultImage : [self giveMeImage],
                          ZAZResultValue : [self giveMeValue],
                          };
    return dic;
}

#pragma mark -

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

- (NSString *)giveMeTitle
{
    if (_isHD) {
        NSString *xpath2 = @"//*[@id=\"productTitle\"]";
        NSString *title = [self searchElementValueWithXpath:xpath2 andDocument:_imageAndHDDocument];
        
        if (title.length == 0) {
            title = @"未搜索到该条形码";
        }
        
        return title;
    } else {
        NSString *XPathTitle = @"//h3[@class='t']/a";
        
        NSString *title = [self searchElementValueWithXpath:XPathTitle andDocument:_titleDocument];
        
        if (title.length == 0) {
            title = @"未搜索到该条形码";
        }
        
        return title;
    }
}

- (NSURL *)giveMeImage
{
    if (_isHD) {
        NSString *xpath2 = @"//*[@id=\"landingImage\"]";
        NSString *attribute2 = @"data-a-dynamic-image";
        NSString *imageString = [self searchStringWithXpath:xpath2 andDocument:_imageAndHDDocument andAttribute:attribute2];
        NSURL    *imageURL = [self tempString2URL:imageString];
        
        if ([imageURL.absoluteString isEqualToString:@"none"]) {
            xpath2 = @"//*[@id=\"imgBlkFront\"]";
            imageString = [self searchStringWithXpath:xpath2 andDocument:_imageAndHDDocument andAttribute:attribute2];
            imageURL = [self tempString2URL:imageString];
        }
        
        return imageURL;
    } else {
        NSString *XPathImage = @"/html/body/div[2]/a[1]/img";
        NSString *imageString = [self searchStringWithXpath:XPathImage andDocument:_imageAndHDDocument andAttribute:@"src"];
        NSURL *imageURL = [NSURL URLWithString:imageString];
        
        return imageURL;
    }
}

- (NSString *)giveMeValue
{
    NSString *xpath = @"/html/body/div[1]/div[4]/a";
    NSString *value = [self searchElementValueWithXpath:xpath andDocument:_valueDocument];
    if (value == nil) {
        value = @"0";
    }
    
    return value;
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

- (NSURL *)tempString2URL: (NSString *)tempString
{
    NSArray *aArray = [tempString componentsSeparatedByString:@"\""];
    
    if (aArray.count > 1) {
        NSURL *result = [NSURL URLWithString:[aArray objectAtIndex:1]];
        return result;
    } else {
        NSURL *result = [NSURL URLWithString:@"none"];
        return result;
    }
}

@end