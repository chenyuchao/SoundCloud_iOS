
#import "Request.h"
#import "JROrderlyDictionary.h"
#import "JSON.h"

@implementation Request


+ (Request *)request {

    return [[self alloc] init];
}

+ (Request *)request:(int)rid {

    Request *request  = [[self alloc] init];
    request.requestId = rid;
    return request;
}

- (id)init
{
    if (self = [super init])
	{
	}
	return self;
}

#pragma mark 下载数据入口

- (void)startConnection:(NSString *)url args:(JROrderlyDictionary *)info {
    
    if (!info)
    {
        info = [JROrderlyDictionary dictionary];
    }
    [info setObject:@"ios_280" forKey:@"api_user"];
    [info setObject:@"ios"     forKey:@"from"];
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@", OutNetAddress, url];
    NSMutableString *args = [NSMutableString string];
    
    NSArray *sort = [[info allKeys] sortedArrayUsingSelector:@selector(compare:)];
	for (NSString *key in sort)
    {
        if ([[info valueForKey:key] isEqualToString:@""] || ![info valueForKey:key])
        {
            continue;
        }
		[args appendFormat:@"%@=%@", key, [info valueForKey:key]];
        if (key != [sort lastObject])
            [args appendString:@"&"];
    }
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@",PrivateKey, args, PrivateKey];
    [args appendString:@"&sign="];
    [args appendString:[[Custom MD5:md5Str] lowercaseString]];
    
    NSLog(@"%@?%@",aurl, args);
    
	NSData *postData = [args dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSURL *requestURL = [NSURL URLWithString:aurl];
    
	[request setURL:requestURL];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
    
    receiveData = [[NSMutableData alloc] init];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if ([self.delegate respondsToSelector:@selector(downloadWillStart:)])
    {
        [self.delegate downloadWillStart:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    currentLength = 0;
    sumLength = (NSInteger)[response expectedContentLength];
    receiveData.length = 0;
//    if ([self.delegate respondsToSelector:@selector(downloadDidStart:)])
//    {
//        [self.delegate downloadDidStart:self];
//    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    currentLength += [data length];
	[receiveData appendData:data];
//    if ([self.delegate respondsToSelector:@selector(downloadProgress:withProgress:)])
//    {
//        [self.delegate downloadProgress:self withProgress:currentLength / sumLength];
//    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    NSString *jsonString = [[NSString alloc] initWithData:receiveData
                                                 encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
	id object = [parser objectWithString:jsonString];

    if ([self.delegate respondsToSelector:@selector(downloadDidFinish:withResult:)])
    {
        [self.delegate downloadDidFinish:self withResult:object];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    
    if ([self.delegate respondsToSelector:@selector(downloadDidFail:WithError:)])
    {
        [self.delegate downloadDidFail:self WithError:error];
    }
}

@end
