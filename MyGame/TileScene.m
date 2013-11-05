//
//  TileScene.m
//  MyGame
//
//  Created by yfzx on 13-10-31.
//
//

#import "TileScene.h"
#import "Hero.h"
#import "TalkObject.h"
#import "TalkScene.h"
#import "BattleScene.h"
#import "LotteryScene.h"
#import "BattleResult.h"
#import "Debuff.h"

typedef enum {
    talk_no = 0,
    talk_npc1 = 1,
    talk_npc2 = 2,
    talk_boss = 3,
} talk_happen;

typedef enum {
    lev_tag = 1800,
    mission_tag = 1801,
    detail_tag = 1802,
} bar_tag;

talk_happen talk_hp = talk_no;

int jd = 1;

CGPoint pttt;

@implementation TileScene

@synthesize hero;
@synthesize tileMap;
@synthesize heroHP;

-(void)dealloc{
    if (tileMap) {
        [tileMap release];
    }
    if (hero) {
        [hero release];
    }
    if (heroHP) {
        [heroHP release];
    }
    [super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TileScene *layer = [TileScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)onEnter{
    [super onEnter];
    if (1) {
        NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
        NSData *data = [arr objectForKey:@"battleResult"];
        if (data) {
            BattleResult *br = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            CCLOG(@"返回的战斗结果: %@",br.result);
            CCSprite *show = [CCSprite spriteWithFile:@"showResult.jpg"];
            show.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
            show.scaleX = 0.1f;
            CCLabelTTF *ttf = [CCLabelTTF labelWithString:br.result fontName:@"STHeitiK-Light" fontSize:20];
            ttf.position = show.position;
            ttf.scaleX = 0.1f;
            [self addChild:ttf z:401 tag:999];
            [self addChild:show z:400 tag:998];
            
            CCScaleTo *to = [CCScaleTo actionWithDuration:0.5 scaleX:0.8 scaleY:1];
            CCScaleTo *to2 = [CCScaleTo actionWithDuration:0.5 scale:1];
            
            [show runAction:to];
            [ttf runAction:to2];
            
            [arr removeObjectForKey:@"battleResult"];
            jd++; // 进度++
        }
        
    }
    switch (talk_hp) {
        case talk_npc1:
        {
            talk_hp = talk_no;
            [self battle:@"0"];
        }
            break;
        case talk_npc2:
        {
            talk_hp = talk_no;
            [self battle:@"1"];
        }
            break;
        case talk_boss:
        {
            talk_hp = talk_no;
            [self battle:@"3"];
        }
            break;
            
        default:{
            talk_hp = talk_no;
        }
            break;
    }
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
        [self createBg];
        [self createMap];
        [self createHero];
        [self createNpc];
        [self createNpc2];
        [self createBoss];
        [self createMenus];
        [self createCCJoyStick];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

//设置镜头
-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

-(void)createBg{
    CCSprite *bb = [CCSprite spriteWithFile:@"barbg.png"];
    bb.anchorPoint = ccp(0, 1);
    bb.position = ccp(0, screenSize.height + 2);
    bb.scaleY = 0.76f;
    bb.scaleX = 0.54f;
    [self addChild:bb];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"HudLayerSpriteFrame.plist"];
    CCSprite *header = [CCSprite spriteWithSpriteFrameName:@"Boss7Icon.png"];
    
    CCMenuItemSprite *itemSprite = [CCMenuItemSprite itemFromNormalSprite:header selectedSprite:nil target:self selector:@selector(showDetail)];
    CCMenu *menu = [CCMenu menuWithItems:itemSprite, nil];
    menu.position = ccp(24.0f, screenSize.height - 24.0f);
    [self addChild:menu];
    
    // 血条底图
    CCSprite *hpBar = [CCSprite spriteWithSpriteFrameName:@"LifeBarBackground.png"];
    hpBar.color = ccRED;
    hpBar.position = ccp(menu.position.x + 84.0f,menu.position.y);
    [self addChild:hpBar];
    // 血条
    self.heroHP=[CCProgressTimer progressWithFile:@"heroHpbar.png"];
    heroHP.position = ccp(hpBar.position.x - 5, hpBar.position.y + 5);
    heroHP.percentage = 99; //当前进度
    heroHP.type=kCCProgressTimerTypeHorizontalBarLR;//进度条的显示样式
    heroHP.percentage += 1;
    [self addChild:heroHP];
//    pttt = heroHP.position;
    
    CCLabelTTF *ttf = [CCLabelTTF labelWithString:@"Lv_1" fontName:@"STHeitiK-Light" fontSize:12];
    ttf.anchorPoint = ccp(0, 0.5);
    ttf.position = ccp(menu.boundingBox.size.width + 2,menu.position.y - 18);
    [self addChild:ttf z:1 tag:lev_tag];
}

-(void)showDetail{
    // 显示玩家信息,暂时写个死的。。后续待完善
    [self removeChild:[self getChildByTag:detail_tag] cleanup:YES];
    CCSprite *detail = [CCSprite spriteWithFile:@"detail.png"];
    detail.anchorPoint = ccp(0, 1);
    detail.position = ccp(0, screenSize.height - 60);
    [self addChild:detail z:1 tag:detail_tag];
    
}

-(void)createMap{
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map_1.tmx"];
    [self addChild:self.tileMap z:-1];
    
    CCLOG(@"====================  %f,%f",self.tileMap.position.x,self.tileMap.position.y);
}

-(void)createMenus{
    CCSprite *lottery = [CCSprite spriteWithFile:@"lotteryItem.png"];
    CCMenuItemSprite *lotteryItem = [CCMenuItemSprite itemFromNormalSprite:lottery selectedSprite:nil target:self selector:@selector(lotteryClick)];
    lotteryItem.scale = 0.5f;
    CCMenu *lotteryMenu = [CCMenu menuWithItems:lotteryItem, nil];
    lotteryMenu.position = ccp(230.0f, screenSize.height - 30.0f);
    
    Debuff *de = [Debuff deBuff:other_1];
    de.position = ccp(lotteryMenu.position.x - 2, lotteryMenu.position.y);
    de.flipX = YES;
    [de runAction:de.debuffAnimate];
    [self addChild:de z:201];
    [self addChild:lotteryMenu z:200];
    
    CCSprite *cls = [CCSprite spriteWithFile:@"close.png"];
    CCMenuItemSprite *itt = [CCMenuItemSprite itemFromNormalSprite:cls selectedSprite:nil target:self selector:@selector(back)];
    CCMenu *mm = [CCMenu menuWithItems:itt, nil];
    mm.position = ccp(screenSize.width - 20 , screenSize.height * 0.9);
    [self addChild:mm z: 5];
}

-(void)back{
    [[CCDirector sharedDirector] popScene];
}

-(void)lotteryClick{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[LotteryScene scene]]];
}

-(void)createHero{
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"location"];
    NSAssert(objects != nil, @"objects group not found");
    NSMutableDictionary *start = [objects objectNamed:@"location3"];
    NSAssert(start != nil, @"start not found");
    
    int x = [[start valueForKey:@"x"] intValue];
    int y = [[start valueForKey:@"y"] intValue];
    
    CCLOG(@"*************** %d,%d",x,y);
    
    self.hero = [Hero Hero:HERO_1];
    self.hero.position = ccp(x, y);
    [self addChild:self.hero];
//    [self.hero heroWithBloodProcess];
    self.hero.scale = 0.6f;
    [self.hero HeroExcuteStand];
}

-(void)battle:(NSString *)x{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    [arr setObject:x forKey:@"battle"];
    CCScene *c = [BattleScene scene];
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:c]];
}

-(void)createNpc{
    Hero *npc = [Hero Hero:HERO_2];
    [npc HeroExcuteStand];
    npc.flipX = YES;
    npc.scale = 0.6f;
    // 这里font为空，主要是因为NPC的素材大小是256x256的,在添加成menu时坐标显示不好调
    CCMenuItemFont *npcItem = [CCMenuItemFont itemFromString:@" " target:self selector:@selector(npcSpeak:)];
    [npcItem setFontSize:75];
    npcItem.scale = 0.6f;
    CCMenu *menu = [CCMenu menuWithItems:npcItem, nil];
    
    // 描述
    CCLabelTTF *head = [CCLabelTTF labelWithString:@"李莫愁" fontName:@"Marker Felt" fontSize:12];
    head.color = ccBLUE;
    
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"location"];
    NSAssert(objects != nil, @"objects group not found");
    NSMutableDictionary *start = [objects objectNamed:@"npc1"];
    NSAssert(start != nil, @"start not found");
    
    int x = [[start valueForKey:@"x"] intValue];
    int y = [[start valueForKey:@"y"] intValue];
    
    menu.position = ccp(x, y);
    npc.position = ccp(x, y);
    head.position = ccp(x, y - 25);
    
    [self addChild:menu];
    [self addChild:npc];
    [self addChild:head];
    
}

-(void)createNpc2{
    Enemy *npc = [Enemy enemyWithType:ENEMY_ALXMEN];
    [npc EnemyExcuteStand];
    [npc removeBlood];
    npc.flipX = YES;
    npc.scale = 0.6f;
    // 这里font为空，主要是因为NPC的素材大小是256x256的,在添加成menu时坐标显示不好调
    CCMenuItemFont *npcItem = [CCMenuItemFont itemFromString:@" " target:self selector:@selector(npc2Speak:)];
    [npcItem setFontSize:75];
    npcItem.scale = 0.6f;
    CCMenu *menu = [CCMenu menuWithItems:npcItem, nil];
    
    // 描述
    CCLabelTTF *head = [CCLabelTTF labelWithString:@"流氓" fontName:@"Marker Felt" fontSize:12];
    head.color = ccBLUE;
    
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"location"];
    NSAssert(objects != nil, @"objects group not found");
    NSMutableDictionary *start = [objects objectNamed:@"npc2"];
    NSAssert(start != nil, @"start not found");
    
    int x = [[start valueForKey:@"x"] intValue];
    int y = [[start valueForKey:@"y"] intValue];
    
    menu.position = ccp(x, y);
    npc.position = ccp(x, y);
    head.position = ccp(x, y - 25);
    
    [self addChild:menu];
    [self addChild:npc];
    [self addChild:head];
}

-(void)createBoss{
    Enemy *npc = [Enemy enemyWithType:ENEMY_BOSS1];
    [npc EnemyExcuteStand];
    [npc removeBlood];
    npc.flipX = NO;
    npc.scale = 0.6f;
    // 这里font为空，主要是因为NPC的素材大小是256x256的,在添加成menu时坐标显示不好调
    CCMenuItemFont *npcItem = [CCMenuItemFont itemFromString:@" " target:self selector:@selector(npc3Speak:)];
    [npcItem setFontSize:75];
    npcItem.scale = 0.6f;
    CCMenu *menu = [CCMenu menuWithItems:npcItem, nil];
    
    // 描述
    CCLabelTTF *head = [CCLabelTTF labelWithString:@"雷霆王" fontName:@"Marker Felt" fontSize:12];
    head.color = ccBLUE;
    
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"location"];
    NSAssert(objects != nil, @"objects group not found");
    NSMutableDictionary *start = [objects objectNamed:@"boss"];
    NSAssert(start != nil, @"start not found");
    
    int x = [[start valueForKey:@"x"] intValue];
    int y = [[start valueForKey:@"y"] intValue];
    
    menu.position = ccp(x, y);
    npc.position = ccp(x, y);
    head.position = ccp(x, y - 25);
    
    [self addChild:menu];
    [self addChild:npc];
    [self addChild:head];
}

-(BOOL)talkDistanceCheck:(CGPoint)pt{
    float dist = [self distanceFromPointX:self.hero.position distanceToPointY:pt];
    CCLOG(@"%f",dist);
    if (dist < 40) {
        return YES;
    }
    return NO;
}

-(void)showTitle:(NSString *)msg{
    CCLabelTTF *ha = [CCLabelTTF labelWithString:msg fontName:@"Marker Felt" fontSize:20];
    ha.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:ha];
    CCFadeOut *f = [CCFadeOut actionWithDuration:1];
    [ha runAction:f];
}

-(void)npcSpeak:(CCNode *)node{
    CCMenuItemFont *f = (CCMenuItemFont *)node;
    if (![self talkDistanceCheck:f.parent.position]) {
        [self showTitle:@"你离的太远了。"];
        return;
    }
    CCLOG(@"NPC 对话开始。。。");
    // 截一张当前界面的图,防止已经暂停后再次点击其他按钮
    CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    [renderTexture begin];
    [self visit];
    [renderTexture end];
    [renderTexture setPosition:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    TalkObject *obj = [[[TalkObject alloc] init] autorelease];
    obj.speak1FrameName = @"StoryLayer.plist";
    obj.speak1PngName = @"Jebat2.png";
    
    obj.speak2FrameName = @"StoryLayer.plist";
    obj.speak2PngName = @"Teja.png";
    
    NSArray *array = [NSArray arrayWithObjects:@"如今能做的都做了，剩下的就等那女魔头来了……",
                      @"问世间，情是何物……直教人生死相许……",
                      @"女魔头...",
                      @"今天陆家庄里的人，一个也别想跑掉",
                      @"二十年过去了,你终究还是不放过我们。",
                      @"哼,受死吧！", nil];
    obj.talkMsgArray = array;
    
    talk_hp = talk_npc1;
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TalkScene scene:obj andBg:renderTexture]]];
    
}

-(void)npc2Speak:(CCNode *)node{
    CCMenuItemFont *f = (CCMenuItemFont *)node;
    if (![self talkDistanceCheck:f.parent.position]) {
        [self showTitle:@"你离的太远了。"];
        return;
    }
    CCLOG(@"NPC 对话开始。。。");
    // 截一张当前界面的图,防止已经暂停后再次点击其他按钮
    CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    [renderTexture begin];
    [self visit];
    [renderTexture end];
    [renderTexture setPosition:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    TalkObject *obj = [[[TalkObject alloc] init] autorelease];
    obj.speak1FrameName = @"StoryLayer.plist";
    obj.speak1PngName = @"Jebat2.png";
    
    obj.speak2FrameName = @"StoryLayer.plist";
    obj.speak2PngName = @"Lekiu.png";
    
    if (jd >= 2) {
        NSArray *array = [NSArray arrayWithObjects:@"放开那女孩！",
                          @"！！！",
                          @"代表月亮消灭你们。",
                          @"一个傻子,一个哑巴,死一边去吧。", nil];
        obj.talkMsgArray = array;
        
        talk_hp = talk_npc2;
    } else {
        NSArray *array = [NSArray arrayWithObjects:@"放开那女孩",
                          @"你资质太低,先打败我仇妹再来",
                          @"...",nil];
        obj.talkMsgArray = array;
        
        talk_hp = talk_no;
    }
    
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TalkScene scene:obj andBg:renderTexture]]];
    
}

-(void)npc3Speak:(CCNode *)node{
    CCMenuItemFont *f = (CCMenuItemFont *)node;
    if (![self talkDistanceCheck:f.parent.position]) {
        [self showTitle:@"你离的太远了。"];
        return;
    }
    CCLOG(@"NPC 对话开始。。。");
    // 截一张当前界面的图,防止已经暂停后再次点击其他按钮
    CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    [renderTexture begin];
    [self visit];
    [renderTexture end];
    [renderTexture setPosition:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    TalkObject *obj = [[[TalkObject alloc] init] autorelease];
    obj.speak1FrameName = @"StoryLayer.plist";
    obj.speak1PngName = @"Jebat2.png";
    
    obj.speak2FrameName = @"StoryLayer.plist";
    obj.speak2PngName = @"Sultan.png";
    
    if (jd >= 3) {
        NSArray *array = [NSArray arrayWithObjects:@"你就是传说中的‘雷霆王’？",
                          @"无知的凡人",
                          @"。。。",
                          @"= =！",
                          @"接招",nil];
        obj.talkMsgArray = array;
        
        talk_hp = talk_boss;
    } else {
        NSArray *array = [NSArray arrayWithObjects:@"你就是传说中的‘雷霆王’？",
                          @"无知的凡人",
                          @"。。。",
                          @"先打败流氓再来吧。",
                          @"- -!",nil];
        obj.talkMsgArray = array;
        
        talk_hp = talk_no;
    }
    
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TalkScene scene:obj andBg:renderTexture]]];
    
}



-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    UITouch  *touch=[touches anyObject];
//    CGPoint   touchLocation = [touch locationInView:touch.view];
//    CGPoint  glLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
    
//    CCLOG(@"glLocation %f,%f",glLocation.x,glLocation.y);
//    [self ptCheck:glLocation];
}

-(void)ptCheck:(CGPoint)glLocation{
    CGPoint tilePos = [self tileCoordForPosition:glLocation];
//    CCLOG(@"瓷砖坐标为 %f,%f",tilePos.x,tilePos.y);
    
    CCTMXLayer* layer = [self.tileMap layerNamed:@"things"];
    int tileId = [layer tileGIDAt:tilePos];
//    CCLOG(@"things %d",tileId);
    
    if (tileId == 0) {
        self.hero.opacity = 250;
    } else {
        self.hero.opacity = 190.0f;
    }
    
    CCTMXLayer* layer2 = [self.tileMap layerNamed:@"route"];
    int tileId2 = [layer2 tileGIDAt:tilePos];
//    CCLOG(@"route %d",tileId2);
    
    if (tileId2 == 0) {
        
        if (self.hero.heroState == HeroState_STATENONE) {
            [self.hero HeroExcuteRun];
        }
        self.hero.position = glLocation;
        [self setViewpointCenter:glLocation];
    }
}

// 坐标转换成瓷砖坐标
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
    int x = position.x / tileMap.tileSize.width;
    int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
//    CCLOG(@"tileCG x = %d,y = %d",x,y);
    return ccp(x, y);
}

#pragma - createCCJoyStick
#pragma CCJoyStick 遥杆

// 创建模拟摇杆
-(void)createCCJoyStick{
    
    //BallRadius即模拟摇杆球的半径
    //MoveAreaRadius即摇杆球可移动的范围半径
    //isFollowTouch即是否将摇杆基准位置跟随touch坐标
    //isCanVisible即是否可见
    //isAutoHide即是否自动隐藏（touchend即隐藏)
    //hasAnimation即是否显示摇杆复位动画
    CCJoyStick *ccj=[CCJoyStick initWithBallRadius:25 MoveAreaRadius:100
                                     isFollowTouch:YES isCanVisible:YES
                                        isAutoHide:YES hasAnimation:YES];
    //可选，不设置即看不见摇杆球, 透明度需要改其源码
    [ccj setBallTexture:@"analogue_handle.png"];
    //可选，不设置即看不见底座, 透明度需要改其源码
    [ccj setDockTexture:@"analogue_bg.png"];
    //可选，不设置即看不见连动杆
    //摇杆激活区域为基准坐标半径，默认为另一个方法，
    //设置屏幕矩形区域为激活区域setHitAreaWithRect
    [ccj setHitAreaWithRadius:2000];
//    ccj.position=CGPointMake(80,65);
//    pttt = ccj.position;
    ccj.scale=0.6f;
    ccj.delegate=self;
    [self addChild:ccj z:5432];
    
}

-(void)removeS{
    [self removeChild:[self getChildByTag:998] cleanup:YES];
    [self removeChild:[self getChildByTag:999] cleanup:YES];
}

// 摇杆的代理方法
// 摇杆摇动时调用该方法
- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
    [self removeS];
    // 加速暂时写死
    power = 0.5f;
    // 判断摇杆方向
    if (angle > -90 && angle < 90) {
        // 左移
        hero.flipX = NO;
    } else {
        // 右移
        hero.flipX = YES;
    }
    
    /*精灵坐标点*/
    float nextx=hero.position.x;
    float nexty=hero.position.y;
    
    /*控制主角移动速度*/
    nextx+=direction.x * (power*2);
    nexty+=direction.y * (power*2);
    
    if(nexty>=(self.tileMap.contentSize.height - 25.0f)){
        nexty=(self.tileMap.contentSize.height - 25.0f);
    }
    if(nextx>=(self.tileMap.contentSize.width - 20.0f)){
        nextx=(self.tileMap.contentSize.width - 20.0f);
    }
    // 边界最小值
    if (nexty<=25.0f)
    {
        nexty=25.0f;
    }
    if(nextx<=20.0f){
        nextx=20.0f;
    }
    
//    self.hero.position =ccp(nextx, nexty);
    [self ptCheck:ccp(nextx, nexty)];
}

// 摇动时调用
- (void) onCCJoyStickActivated:(CCNode*)sender
{
    [self removeChild:[self getChildByTag:detail_tag] cleanup:YES];
}

// 摇动释放时调用
- (void) onCCJoyStickDeactivated:(CCNode*)sender
{
    [self.hero HeroExcuteStand];
}

/**
 * 计算两点距离
 */
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@end
