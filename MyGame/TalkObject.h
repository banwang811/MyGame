//
//  TalkObject.h
//  FirstGame
//
//  Created by yfzx on 13-10-23.
//
//

#import <Foundation/Foundation.h>

@interface TalkObject : NSObject{

    NSString *speak1; // 说话人1
    NSString *speak1FrameName; // 说话人1图片所在plist位置
    NSString *speak1PngName;   // 说话人1图片名称
    
    NSString *speak2; // 说话人2
    NSString *speak2FrameName; // 说话人2图片所在plist位置
    NSString *speak2PngName;   // 说话人2图片名称
    
    NSArray *talkMsgArray; // 说话内容数组 1说话开始
    
}

@property(nonatomic,retain) NSString *speak1; // 说话人1
@property(nonatomic,retain) NSString *speak1FrameName; // 说话人1图片所在plist位置
@property(nonatomic,retain) NSString *speak1PngName;   // 说话人1图片名称

@property(nonatomic,retain) NSString *speak2; // 说话人2
@property(nonatomic,retain) NSString *speak2FrameName; // 说话人2图片所在plist位置
@property(nonatomic,retain) NSString *speak2PngName;   // 说话人2图片名称

@property(nonatomic,retain) NSArray *talkMsgArray; // 说话内容数组

@end
