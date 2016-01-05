//
//  NSObject+Chanel.h
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/18/15.
//
//

#import <Foundation/Foundation.h>

@interface Chanel :NSObject
@property (nonatomic, strong) NSString * chude;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * linkChanel;

-(id) initWithName :(NSString *) name
              image: (NSString*)image
         linkchanel:(NSString*) chanel;





@end
