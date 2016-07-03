//
//  ProjectDAO.h
//  fmdb
//
//  Created by Apple on 16/3/26.
//
//

#import "DAO.h"

@interface ProjectDAO : DAO
// 添加首页最新的三条project
+ (BOOL)addNewestProejcts:(NSArray *)projects;
// 添加首页projects 10条
+ (BOOL)addHomeProejcts:(NSArray *)projects;
// 添加微众筹projects 10条
+ (BOOL)addWeiPublicFundProejcts:(NSArray *)projects;

// 首页最新的三条project
+ (NSArray *)projectsAllNewest;
// 首页首页projects 10条
+ (NSArray *)projectsAllHome;
// 首页微众筹projects 10条
+ (NSArray *)projectsAllWeiPublicFund;
@end
