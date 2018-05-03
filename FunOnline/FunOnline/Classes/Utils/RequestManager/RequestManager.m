//
//  HttpRequestManager.m
//  OnlyBrother_ Seller
//
//  Created by 马康旭 on 16/10/26.
//  Copyright © 2016年 谭捷. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"

@interface RequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) NSURLSession * session;

@end

@implementation RequestManager

- (instancetype)init{
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
        
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置请求超时
        _sessionManager.requestSerializer.timeoutInterval = 6;
        //向AFN添加一些隐私权策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy = securityPolicy;
        //接收参数类型
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    }
    return self;
}


/**
 *  单例
 */
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static RequestManager *httpRequest = nil;
    dispatch_once(&onceToken, ^{
        httpRequest = [[RequestManager alloc] init];
    });
    return httpRequest;
}

-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure{
    
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure{
    
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(Progress)downloadProgress success:(Success)success failure:(Failure)failure{
    
    WeakSelf;
    
    return [_sessionManager GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf requestTask:task responseObj:responseObject success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(Progress)uploadProgress success:(Success)success failure:(Failure)failure{
    
    WeakSelf;
    
    return [_sessionManager POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf requestTask:task responseObj:responseObject success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}


- (void)requestTask:(NSURLSessionDataTask * _Nullable)task responseObj:(id  _Nullable)responseObject success:(Success)success {
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        id jsonObject = [self JSONObjectWithData:responseObject];
        
        if ([jsonObject isKindOfClass:[NSNull class]]) {
            success(nil);
            return;
        }
        
        //不是字典直接返回
        if (![jsonObject isKindOfClass:[NSDictionary class]]) {
            
            success(jsonObject);
            return;
        }
        
        success(jsonObject);
    }
    else {
        
        success(responseObject); //返回请求数据
    }
}


- (void)startGET:(NSString *)URLString parameters:(id)parameters progress:(Progress)progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    // 请求的url特殊字符处理
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    // 创建请求对象 并：设置缓存策略为每次都从网络加载 超时时间10s
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    // request.HTTPBody = [@"type=focus-c" dataUsingEncoding:NSUTF8StringEncoding];
    NSProgress *pgs = [[NSProgress alloc] init];

    // 创建任务
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        double totalLength = data.length;
        double percent = response.expectedContentLength / totalLength;
        
        pgs.totalUnitCount = totalLength;
        pgs.completedUnitCount = percent;
        !progress?:progress(pgs);
        
        id object = nil;
        if (data && [data isKindOfClass:[NSData class]]) {
            object = [data mj_JSONObject];
            !success?:success(object);
        }
        if ([data isKindOfClass:[NSNull class]]) {
            object = nil;
            !success?:success(object);
            return;
        }
        
        if (error) { //如果请求失败
            !failure?:failure(error);
        }
    }];
    
    // 发送请求，执行task
    [dataTask resume];
}


- (id)JSONObjectWithData:(NSData *)data {
    id responseObj = nil;
    NSError *error = nil;
    
    responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        // NSInteger statusCode = [[responseObj valueForKey:@"code"] integerValue];
    }else {
        
        return error;
    }
    return responseObj;
}

@end
