//
//  NetworkManager.m
//  CGVAPP
//
//  Created by Nguyen Van Thanh on 12/7/15.
//  Copyright © 2015 DangDingCan. All rights reserved.
//

#import "NetworkManager.h"
#define BASE_URL @"https://www.mp3.zing.vn"
#import "TFHpple.h"
#import "PhimObj.h"
#import "SMXMLDocument.h"

@interface NetworkManager()
@end

@implementation NetworkManager
+(instancetype)shareManager {
    static NetworkManager*shareManager = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        shareManager = [self new];
    });
    return shareManager;
}
-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}
// Test trang CGV.vn
-(void)GetFilmFromLink:(NSString *)url OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod{
    
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();
    }
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='category-products']/ul/li";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];
    for (TFHppleElement * element in nodes) { // bắt đầu duyệt trong class "category ...
        
        TFHppleElement * element1 = [element firstChildWithClassName:@"product-poster"];  // Lấy thẻ div co class là product-poster
        TFHppleElement * element2 = [element1 firstChildWithTagName:@"a"];
        
        
        NSString *linkDetail = [element2 objectForKey:@"href"];
        
        TFHppleElement *element3 = [element2 firstChildWithTagName:@"img"];
        
        NSString *linkimage = [element3 objectForKey:@"src"];
        
        TFHppleElement * element4 = [element firstChildWithClassName:@"product-info"]; //tạo node chứa thẻ prdoduct info
        TFHppleElement *element20 = [element4 firstChildWithClassName:@"product-name"];
        TFHppleElement *element21 = [element20 firstChildWithTagName:@"a"];
        
        NSString *name = [element21 objectForKey:@"title"];
        TFHppleElement *element5 = [element4 firstChildWithClassName:@"movie-actress"]; // lấy thẻ movie
        TFHppleElement *element6 = [element5 firstChildWithClassName:@"std"]; // lấy thẻ có class std
        
        NSString *filmDuration = element6.content; // --> thời lượng film là content của element6
        
        TFHppleElement *element7 = [element4 firstChildWithClassName:@"movie-genre"]; // lấy thẻ movie-genere
        TFHppleElement *element8 = [element7 firstChildWithClassName:@"std"];
        
        NSString *filmType = element8.content ;
        NSString *trimmedString = [filmType stringByTrimmingCharactersInSet:
                                   [NSCharacterSet newlineCharacterSet]];
        trimmedString = [trimmedString stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
        filmType = trimmedString;
        TFHppleElement *element9 = [element4 firstChildWithClassName:@"movie-release"];
        TFHppleElement *element10 = [element9 firstChildWithClassName:@"std"];
        NSString *filmDateRealease = element10.content;
        
        PhimObj *phim = [[PhimObj alloc] initWithName:name
                                             catelogy:filmType
                                             duration:filmDuration
                                                 date:filmDateRealease
                                           linkDetail:linkDetail
                                             imageUrl:linkimage ];
        
        [allItems addObject:phim];
    }
    completedMethod(allItems);
}
// Lấy thông tin cho FrontView

-(void)GetMusicFromLink:(NSString *)urlmusic OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod
{
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlmusic]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='zcontent']/div/div/div/div";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];
    for (TFHppleElement * element in nodes) { // bắt đầu duyệt các phần tử trong class "zcontent"
        
        TFHppleElement * element1 = [element firstChildWithTagName:@"a"]; //Element 1 là thẻ a đầu tiên
        NSString *linkDetail = [element1 objectForKey:@"href"]; // Done link chi tiết
        
        TFHppleElement *element2 = [element1 firstChildWithTagName:@"img"];
        NSString *linkImage = [element2 objectForKey:@"src"];
        
        // Xong việc với thẻ tag "a" chứa 2 link trên, ta chuyển sang thẻ khác chứa các thông tin còn lại,
        TFHppleElement *element3 = [element firstChildWithClassName:@"description"];
        TFHppleElement *element4 = [element3 firstChildWithClassName:@"title-item ellipsis"];
        
        TFHppleElement *element5 = [element4 firstChildWithTagName:@"a"];
        NSString *tenbaihat = element5.content;
        // --> done !!
        
        TFHppleElement *element6 = [element3 firstChildWithClassName:@"inblock ellipsis"];
        TFHppleElement *element7 = [element6 firstChildWithClassName:@"title-sd-item"];
        TFHppleElement *element8 = [element7 firstChildWithTagName:@"a"];
        NSString *tencasi = element8.content;
        
        
        PhimObj *song =[[PhimObj alloc] initWithName:tenbaihat
                                            catelogy:tencasi
                                            duration:nil
                                                date:nil
                                          linkDetail:linkDetail
                                            imageUrl:linkImage];
        [allItems addObject:song];
        
    }
    completedMethod(allItems);
    
}

// Lấy playlist cho detailScreen từ linkdetail của FrontView
-(void)GetPlaylistFromLink:(NSString *)linkParent OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod {
    
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkParent]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='box-scroll ']/ul/li/div/h3";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];
    
    for (TFHppleElement *element in nodes) {
        TFHppleElement * element1 = [element firstChildWithTagName:@"a"];
        
        NSString *linkDetail = [element1 objectForKey:@"href"];
        NSString *songname = element1.content;
        
        PhimObj *playlist =[[PhimObj alloc] initWithName:songname
                                                catelogy:nil
                                                duration:nil
                                                    date:nil
                                              linkDetail:linkDetail
                                                imageUrl:nil];
        [allItems addObject:playlist];
    }
    completedMethod(allItems);
    
}

// Lấy link Xml từ trang bài hát đơn (linkDetail)

-(void)GetXmlFromDetailLink:(NSString *)urlmp3 OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod {
    NSError * error;
    
    NSString * html = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlmp3] encoding: NSUTF8StringEncoding error:&error];
    NSRange indexFirst = [html rangeOfString:@"data-xml="];
    NSString *pathTemp = @"http://mp3.zing.vn/xml/song-xml/LGJHTZHslQQsLGFtZFcybnkm";  // template link, để đo độ dài chuỗi cần cắt.
    long int count = [pathTemp length];
    NSString *link = [html substringWithRange:NSMakeRange(indexFirst.location + 10, count )]; // Cắt từ toạ độ data-xml + 10 ký tự nữa. Độ dài là số ký tự của pathTemp
  
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    [allItems addObject:link];
    completedMethod(allItems);
}
-(void)GetMp3FromXml:(NSString *)urlXml OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod {
    
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlXml]
                                          options:NSDataReadingUncached
                                            error:&error];
    
    
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    
    
    
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error) {
        NSLog(@"Error while parsing the document: %@", error);
        return;
    }

    SMXMLElement *items = [document childNamed:@"item"];
    NSString *source = [items valueWithPath:@"source"];
    NSString *title = [items valueWithPath:@"title"];
    
    PhimObj *song =[[PhimObj alloc] initWithName:source
                                        catelogy:title
                                        duration:nil
                                            date:nil
                                      linkDetail:nil
                                        imageUrl:nil];

    
    
    [allItems addObject:song];
    completedMethod (allItems);
}

@end
