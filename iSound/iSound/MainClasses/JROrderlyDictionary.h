
@interface JROrderlyDictionary : NSObject {

	@private
	NSMutableDictionary	*objects;
	NSMutableArray		*allKeys;
}

+ (id)dictionary;
- (id)init;
- (id)valueForKey:(NSString *)key;
- (id)objectForKey:(id)key;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(id)akey;
- (void)removeAllObjects;
- (NSArray *)allKeys;

@end