//
//  DTFLanguageManager.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2023/8/3.
//  Copyright © 2023 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DTFLanguageDownloadCompletionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface DTFLanguageManager : NSObject

@property (nonatomic, strong)NSString *ocrResultStr;
@property (nonatomic, strong)NSString *languageType;

+ (instancetype)sharedInstance;

- (BOOL)checkNeedPreload;
- (BOOL)checkUpdateDocWithVersion:(NSString *)version;
- (BOOL)checkUpdateFaceWithVersion:(NSString *)version;
- (void)startFaceDownload;
- (void)startDocDownload;
- (NSString *)getCurrentLanguage;
- (NSString *)getFileWithPath:(NSString *)path fileName:(NSString *)fileName;

- (void)initializeLanguageDictionary;
- (NSString *)getLocalizedStringForKey:(NSString *)key;
- (void)setBundlePath:(NSString *)bundlePath;

@end

NS_ASSUME_NONNULL_END
