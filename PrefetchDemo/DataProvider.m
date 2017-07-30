//
//  DataProvider.m
//  PrefetchDemo
//
//  Created by wangchao9 on 2017/7/29.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import "DataProvider.h"
#import "Dispatch.h"

@interface NSString (MoviePosterCellViewModel)<MoviePosterCellViewModel>

@end
@implementation NSString (MoviePosterCellViewModel)
- (NSString*)poster {return self;}
- (NSString*)reuseIdentifier {return @"MoviePosterCell";}
@end

@interface DataProvider ()
@property (nonatomic, strong) NSArray<NSString*> *urls;
@end
@implementation DataProvider
+ (instancetype)shared {
    Class exceptClass = [DataProvider class];

    if ([[[self class] superclass] isSubclassOfClass:exceptClass]) {
        @throw [NSException exceptionWithName:@"call singleton from unexcept class"
                                       reason:@"不要在子类上调用该单例方法"
                                     userInfo:@{@"except class":NSStringFromClass(exceptClass)
                                                , @"actual class":NSStringFromClass([self class])}];
    }

    static dispatch_once_t onceToken;
    static DataProvider   *instance;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.urls = @[
            @"http://i0.letvimg.com/lc05_search/201707/20/11/36/tmp_2098508908599465234.jpg",
            @"http://i3.letvimg.com/lc03_iscms/201707/28/13/19/caccec1f637f4dccab252bab24e78401.jpg",
            @"http://i2.letvimg.com/lc05_iscms/201707/27/12/02/57c7ebd0f0f143569e2db373c4b154ee.jpg",
            @"http://i1.letvimg.com/lc06_iscms/201707/26/12/05/6e4c478ef3a141b1ade7d7dd1319d270.jpg",
            @"http://i0.letvimg.com/lc03_iscms/201707/26/12/14/056283f1d9c442448b9277c5b3c37dfe.jpg",
            @"http://i0.letvimg.com/lc07_search/201707/20/11/37/tmp_6332602570808194353.jpg",
            @"http://i3.letvimg.com/lc06_iscms/201707/28/10/33/f92e931b0bf34fc1a08ee5bc731a6922.jpg",
            @"http://i2.letvimg.com/lc05_iscms/201707/28/10/53/994b206844594042b83095088bdced2d.jpg",
            @"http://i1.letvimg.com/lc07_iscms/201707/28/11/39/f227570cc6c7418b83b9687cf3f7e6c7.jpg",
            @"http://i1.letvimg.com/lc07_iscms/201707/28/10/32/4b8f64509c9f45a792a993e2ef922a3d.jpg",
            @"http://i2.letvimg.com/lc07_iscms/201707/28/10/32/7e762520639b4c16a1a0084866075cfc.jpg",
            @"http://i3.letvimg.com/lc03_iscms/201707/28/14/58/9c357117d15643988230f4989b47ea42.jpg",
            @"http://i0.letvimg.com/lc07_iscms/201707/28/12/33/5b10a923314742bb9d7a22c08f06648a.jpg",
            @"http://i3.letvimg.com/lc07_iscms/201707/28/10/32/eed615efb7c0451eaf66872af73ad39c.jpg",
            @"http://i0.letvimg.com/lc04_iscms/201707/28/10/33/4d2aae8549cd4ce49ab93255fa0b4cb6.jpg",
            @"http://i3.letvimg.com/lc04_iscms/201707/27/10/56/b0850a2a66794f8fa224ab442b2e394b.jpg",
            @"http://i1.letvimg.com/vrs/201404/22/e240f13f-c8e3-4c0f-ae15-4327e283ef92.jpg",
            @"http://i2.letvimg.com/vrs/201301/23/9839c00de00642bb945ba7ae409f5eef.jpg",
            @"http://i1.letvimg.com/vrs/201308/08/f0b3cb74b54441beb880513c1f8cf626.jpg",
            @"http://i0.letvimg.com/lc05_search/201706/21/16/45/tmp_9180374216135845493.jpg",
            @"http://i3.letvimg.com/lc07_search/201706/16/17/25/tmp_1082354181464859166.jpg",
            @"http://i2.letvimg.com/lc04_search/201706/14/15/08/tmp_8140752147880310640.jpg",
            @"http://i0.letvimg.com/lc03_search/201706/09/14/15/tmp_3701519404324521044.jpg",
            @"http://i1.letvimg.com/lc05_search/201706/07/12/38/tmp_8139339268361278612.jpg",
            @"http://i0.letvimg.com/lc07_search/201705/31/18/58/tmp_3313778379813661795.jpg",
            @"http://i1.letvimg.com/lc07_search/201705/24/16/58/tmp_149974576664116687.jpg",
            @"http://i0.letvimg.com/lc05_search/201705/22/17/03/tmp_1399471359250337037.jpg",
            @"http://i0.letvimg.com/lc04_search/201705/18/17/34/tmp_655131608112995626.jpg",
            @"http://i1.letvimg.com/lc06_search/201705/11/18/43/tmp_2742877563267322567.jpg",
            @"http://i0.letvimg.com/lc05_search/201705/10/17/14/tmp_7588180975767541169.jpg",
            @"http://i3.letvimg.com/lc06_search/201705/05/16/27/tmp_2159166666448650691.jpg",
            @"http://i3.letvimg.com/lc06_search/201705/03/17/38/tmp_2905185139722802613.jpg",
            @"http://i3.letvimg.com/lc05_search/201704/28/16/07/tmp_4659679982052852572.jpg",
            @"http://i3.letvimg.com/lc07_search/201704/26/17/37/tmp_1842931186289838496.jpg",
            @"http://i0.letvimg.com/lc06_search/201704/21/16/14/tmp_7698741322536779700.jpg",
            @"http://i0.letvimg.com/lc05_search/201704/19/17/42/tmp_1237441786100698454.jpg",
            @"http://i3.letvimg.com/lc05_search/201704/14/10/48/tmp_6096390474513514775.jpg",
            @"http://i0.letvimg.com/lc02_search/201704/12/16/28/tmp_2737478911466346657.jpg",
            @"http://i2.letvimg.com/lc02_search/201704/07/16/21/tmp_5873964322935685417.jpg",
            @"http://i0.letvimg.com/lc04_search/201703/29/17/43/tmp_1996275093477223144.jpg",
            @"http://i3.letvimg.com/lc07_search/201703/24/17/41/tmp_1404184385910030930.jpg",
            @"http://i2.letvimg.com/lc02_search/201703/22/16/21/tmp_7636805744185301835.jpg",
            @"http://i1.letvimg.com/lc06_search/201703/17/17/32/tmp_2964302617264334457.jpg",
            @"http://i1.letvimg.com/lc04_search/201703/15/17/35/tmp_6119986135526935025.jpg",
            @"http://i2.letvimg.com/lc06_search/201703/10/17/44/tmp_7178912255168177785.jpg",
            @"http://i0.letvimg.com/lc04_search/201703/07/18/26/tmp_7503890883550020705.jpg",
            @"http://i3.letvimg.com/lc04_search/201703/03/17/29/tmp_672948758499857948.jpg",
            @"http://i2.letvimg.com/lc02_search/201701/23/18/34/tmp_5102175526903104631.jpg",
            @"http://i2.letvimg.com/lc05_search/201701/23/16/03/tmp_4956416967948561251.jpg",
            @"http://i1.letvimg.com/lc05_search/201701/20/16/58/tmp_4731965286155397110.jpg",
            @"http://i3.letvimg.com/lc06_search/201701/17/17/33/tmp_487068090713284796.jpg",
            @"http://i3.letvimg.com/lc07_search/201701/13/17/00/tmp_5478565715637625792.jpg",
            @"http://i2.letvimg.com/lc05_search/201701/11/17/08/tmp_1560168642136369592.jpg",
            @"http://i3.letvimg.com/lc05_search/201701/06/16/33/tmp_3903521160422288910.jpg",
            @"http://i0.letvimg.com/lc05_search/201701/03/17/00/tmp_7945564350189810452.jpg",
            @"http://i3.letvimg.com/lc02_search/201612/30/15/30/tmp_377215290561970116.jpg",
            @"http://i3.letvimg.com/lc05_search/201612/27/16/13/tmp_6914365550916481546.jpg",
            @"http://i1.letvimg.com/lc04_search/201612/23/19/10/tmp_7122400427075333897.jpg",
            @"http://i0.letvimg.com/lc04_search/201612/20/12/39/tmp_7294710013527575128.jpg",
            @"http://i2.letvimg.com/lc06_search/201612/14/11/23/tmp_4561891180161234237.jpg",
            @"http://i1.letvimg.com/lc04_search/201612/09/11/37/tmp_7346457437877209614.png",
            @"http://i3.letvimg.com/lc07_search/201612/06/17/43/tmp_6160604054142403911.jpg",
            @"http://i0.letvimg.com/lc05_search/201612/01/18/29/tmp_3200081092394521671.jpg",
            @"http://i2.letvimg.com/lc07_search/201611/29/16/57/tmp_5432131366089921907.jpg",
            @"http://i0.letvimg.com/lc02_search/201611/25/18/00/tmp_7266384411482775172.jpg",
            @"http://i2.letvimg.com/lc06_search/201611/22/17/51/tmp_5859282833662606236.jpg",
            @"http://i0.letvimg.com/lc03_search/201611/18/18/25/tmp_3488977151963475162.jpg",
            @"http://i1.letvimg.com/lc02_search/201611/15/14/13/tmp_518538886675065973.png",
            @"http://i3.letvimg.com/lc06_search/201611/04/17/30/tmp_87216731249722625.png",
            @"http://i2.letvimg.com/lc07_search/201611/02/11/27/tmp_5595824494622437379.jpg",
            @"http://i1.letvimg.com/lc07_search/201610/28/19/05/tmp_2882925250334489497.jpg",
            @"http://i2.letvimg.com/lc07_search/201610/27/11/33/tmp_504011712028411493.jpg",
            @"http://i2.letvimg.com/lc03_search/201610/24/18/20/tmp_8256645685509043154.jpg",
            @"http://i1.letvimg.com/lc07_search/201610/14/10/57/tmp_6555956933182094788.png",
            @"http://i0.letvimg.com/lc04_search/201609/30/18/49/tmp_4987685100206157656.jpg",
            @"http://i3.letvimg.com/lc07_search/201609/30/18/35/tmp_8204496750057923127.jpg",
            @"http://i2.letvimg.com/lc06_search/201609/30/18/26/tmp_877595098714260721.jpg",
            @"http://i0.letvimg.com/lc06_search/201609/30/17/59/tmp_808421681783623377.jpg",
            @"http://i3.letvimg.com/lc06_search/201609/30/17/49/tmp_1691659735453418210.jpg",
            @"http://i2.letvimg.com/lc06_search/201609/30/17/39/tmp_1304420374772166672.jpg",
            @"http://i3.letvimg.com/lc05_search/201609/30/17/27/tmp_308690969479040291.jpg",
            @"http://i3.letvimg.com/lc05_search/201609/30/17/17/tmp_1640694798669308335.jpg",
            @"http://i0.letvimg.com/lc07_search/201609/30/16/47/tmp_3516838959643151914.jpg",
            @"http://i1.letvimg.com/lc02_search/201609/30/11/32/tmp_6869534347179218238.jpg",
            @"http://i3.letvimg.com/lc02_search/201609/21/18/36/tmp_8555698390758033518.jpg",
            @"http://i3.letvimg.com/lc06_search/201609/14/17/21/tmp_9185500744386778783.jpg",
            @"http://i1.letvimg.com/lc05_search/201609/13/18/56/tmp_924837140357040191.png",
            @"http://i0.letvimg.com/lc04_search/201609/09/15/50/tmp_4807740885690918466.jpg",
            @"http://i0.letvimg.com/lc06_search/201609/05/18/09/tmp_6962995469834028811.jpg",
            @"http://i1.letvimg.com/lc05_search/201608/31/18/36/tmp_6368129593383721973.png",
            @"http://i1.letvimg.com/lc04_search/201608/29/13/58/tmp_3215598137863475892.png",
            @"http://i2.letvimg.com/lc06_search/201608/26/17/54/tmp_7833968042265881587.jpg",
            @"http://i3.letvimg.com/lc04_search/201608/26/17/50/tmp_6765571768771782471.jpg",
            @"http://i2.letvimg.com/lc05_search/201608/26/17/45/tmp_2890729863392197270.jpg",
            @"http://i1.letvimg.com/lc04_search/201608/26/17/41/tmp_657900211674180475.jpg",
            @"http://i2.letvimg.com/lc06_search/201608/26/17/29/tmp_3173229363259769107.jpg",
            @"http://i2.letvimg.com/lc07_search/201608/26/17/23/tmp_3662044026939258315.jpg",
            @"http://i1.letvimg.com/lc07_search/201608/26/17/01/tmp_5184442691214334663.jpg",
            @"http://i0.letvimg.com/lc06_search/201608/26/16/51/tmp_7091594992029661318.jpg",
            @"http://i3.letvimg.com/lc06_search/201608/26/16/13/tmp_273218260928333094.jpg",
            @"http://i3.letvimg.com/lc05_search/201608/26/16/07/tmp_8503145987501992560.jpg",
            @"http://i0.letvimg.com/lc05_search/201608/26/15/58/tmp_4443593465330355487.jpg",
            @"http://i0.letvimg.com/lc04_search/201608/26/15/51/tmp_1503257126048353517.jpg"
        ];
    });

    return instance;
}

const NSUInteger PageSize = 20;
- (void)loadData:(NSUInteger)pageIndex completion:(void (^)(MoviePosterCellViewModelArray*urls))completion {
    NSTimeInterval   delayInSeconds = arc4random_uniform(20) + 1;
    delayInSeconds /= 10.0;
    dispatch_queue_t qeueu = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), qeueu, ^{
        [Dispatch ui:^{
            NSUInteger pageSize = MIN(PageSize, self.urls.count - pageIndex * PageSize);
            NSArray *movies = [self.urls subarrayWithRange:NSMakeRange(pageIndex * PageSize, pageSize)];
            completion(movies);
        }];
    });
}

- (BOOL)hasMoreData:(NSUInteger)pageIndex {
    return (pageIndex * PageSize + PageSize) < self.urls.count;
}
@end
