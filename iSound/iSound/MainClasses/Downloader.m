
//  Created by  Jumax.R on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import "Downloader.h"
#import "Custom.h"

@implementation Downloader


+ (id)downloader {
    
    return [[self alloc] init];
}

- (UIImage *)loadingWithURL:(NSString *)url
                      index:(int)idx
                   delegate:(id <DownloaderDelegate>)delegate
                    cacheTo:(CachePath)cachePath {
    
    self.url = url;
    self.idx = idx;
    self.cachePath = cachePath;
    self.delegate  = delegate;
    
    if ([url isEqualToString:@""] ||
        [url isEqual:[NSNull null]] ||
        [url isEqualToString:@"(null)"] ||
         url == nil)
    {
        if ([self.delegate respondsToSelector:@selector(downloaderNoSuchFileInThisUrl:)])
        {
            [self.delegate downloaderNoSuchFileInThisUrl:url];
        }
        NSLog(@"This image can not be loaded, Because the URL is empty.");
        return nil;
    }

    NSString *path = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    switch (cachePath)
    {
        case Document:
            path = [[Custom getDocumentDir] stringByAppendingPathComponent:path];
            break;
        case Temp:
            path = [[Custom getTempDir] stringByAppendingPathComponent:path];
            break;
        case None:
            break;
    }
    
    NSData   *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:data];
    
    if (image)
    {
        self.image = image;
        if ([delegate respondsToSelector:@selector(downloaderLoadingFromLocalDidFinish:)])
        {
            [delegate downloaderLoadingFromLocalDidFinish:self];
        }
        return image;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];

    receiveData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];
    if ([self.delegate respondsToSelector:@selector(downloaderWillStart:)])
    {
        [self.delegate downloaderWillStart:self];
    }
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    dataLength = [response expectedContentLength];
    receiveData.length = 0;
    if ([self.delegate respondsToSelector:@selector(downloaderDidStart:)])
    {
        [self.delegate downloaderDidStart:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	[receiveData appendData:data];
    if ([self.delegate respondsToSelector:@selector(downloaderProgress:)])
    {
        [self.delegate downloaderProgress:(float)[receiveData length] / (float)dataLength];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.image = [[UIImage alloc] initWithData:receiveData];

    if ([self.delegate respondsToSelector:@selector(downloaderDidFinish:object:)] && _image)
    {
        NSString *path = [_url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        switch (_cachePath)
        {
            case Document:
                [receiveData writeToFile:[[Custom getDocumentDir] stringByAppendingPathComponent:path]
                              atomically:YES];
                break;
            case Temp:
                [receiveData writeToFile:[[Custom getTempDir] stringByAppendingPathComponent:path]
                              atomically:YES];
                break;
            case None:
                break;
        }
        [self.delegate downloaderDidFinish:self object:_image];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    
    if ([self.delegate respondsToSelector:@selector(downloaderDidFailWithError:)])
    {
        [self.delegate downloaderDidFailWithError:error];
    }
}

+ (BOOL)cleanCache {
    
//    NSString *extension = @"m4r";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error;
    NSString *filename;
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
        return NO;
    }
    
    NSEnumerator *e = [contents objectEnumerator];
    
    while ((filename = [e nextObject]))
    {
//        if ([[filename pathExtension] isEqualToString:extension]) {
        
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
            return NO;
        }
//        }
    }
    return YES;
}

@end
