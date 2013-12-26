
#import "JROrderlyDictionary.h"

@interface JROrderlyDictionary (private)

- (void)removeKey:(NSString *)key;

@end

@implementation JROrderlyDictionary

+ (id)dictionary {

	return [[JROrderlyDictionary alloc] init];
}

- (id)init {

	if (self = [super init])
	{
		objects = [[NSMutableDictionary	alloc] init];
		allKeys = [[NSMutableArray		alloc] init];
	}
	return self;
}

- (id)valueForKey:(NSString *)key {

	return [objects valueForKey:key];
}

- (id)objectForKey:(id)key {

	return [objects objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
	
	[objects setObject:object forKey:key];
	[self	 removeKey:key];
	[allKeys addObject:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {

	[objects setValue:value forKey:key];
	[self	 removeKey:key];
	[allKeys addObject:key];
}

- (void)removeObjectForKey:(id)akey {

	[self	 removeKey:akey];
	[objects removeObjectForKey:akey];
}

- (void)removeAllObjects {
	
	[objects removeAllObjects];
	[allKeys removeAllObjects];
}

- (NSArray *)allKeys {

	return [NSArray arrayWithArray:allKeys];
}

- (void)removeKey:(NSString *)key {

	for (NSString *fKey in allKeys)
	{
		if ([fKey isKindOfClass:[NSString class]] && [fKey isEqualToString:key])
		{
			[allKeys removeObject:fKey];
		}
	}
}

@end