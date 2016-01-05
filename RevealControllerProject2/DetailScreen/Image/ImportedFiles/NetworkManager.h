//
//  NetworkManager.h
//  CGVAPP
//
//  Created by Nguyen Van Thanh on 12/7/15.
//  Copyright © 2015 DangDingCan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
+(instancetype)shareManager;
-(void) GetFilmFromLink:(NSString*) url OnComplete:(void(^)(NSArray *items))completedMethod fail:(void(^)())failMethod;
-(void) GetMusicFromLink: (NSString*) urlmusic OnComplete:(void(^)(NSArray *items))completedMethod fail:(void(^)())failMethod;
-(void) GetXmlFromDetailLink : (NSString*) urlmp3 OnComplete:(void(^) (NSArray *items))completedMethod fail :(void (^)())failMethod;
-(void) GetPlaylistFromLink : (NSString*) linkParent OnComplete:(void(^) (NSArray *items))completedMethod fail :(void (^)())failMethod;
-(void) GetMp3FromXml:(NSString* ) urlXml OnComplete:(void(^)(NSArray *items))completedMethod fail:(void(^)())failMethod;
@end
