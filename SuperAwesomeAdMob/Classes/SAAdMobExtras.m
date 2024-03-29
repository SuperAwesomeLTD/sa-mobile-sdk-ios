#import "SAAdMobExtras.h"

@implementation SAAdMobVideoExtra

- (id) init {
    if (self = [super init]) {
        _testEnabled = false;
        _orientation = OrientationAny;
        _parentalGateEnabled = false;
        _bumperPageEnabled = false;
        _closeButtonEnabled = false;
        _closeAtEndEnabled = true;
        _smallCLickEnabled = false;
    }
    
    return self;
}

@end

@implementation SAAdMobCustomEventExtra

@synthesize trasparentEnabled = _trasparentEnabled;
@synthesize testEnabled = _testEnabled;
@synthesize parentalGateEnabled = _parentalGateEnabled;
@synthesize bumperPageEnabled = _bumperPageEnabled;
@synthesize orientation = _orientation;

- (id) init {
    _dict = [[NSMutableDictionary alloc] init];
    
    if (self = [super init]) {
        _testEnabled = false;
        _parentalGateEnabled = false;
        _bumperPageEnabled = false;
        _orientation = OrientationAny;
        _trasparentEnabled = false;
    }
    
    return self;
}

- (id) initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    _dict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys count:cnt];
    return self;
}

- (NSUInteger)count {
    return [_dict count];
}
- (id)objectForKey:(id)aKey {
    return [_dict objectForKey:aKey];
}
- (NSEnumerator *)keyEnumerator {
    return [_dict keyEnumerator];
}

- (void) setTrasparentEnabled:(BOOL)value {
    _trasparentEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_TRANSPARENT];
}

- (void) setTestEnabled:(BOOL)value {
    _testEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_TEST];
}

- (void) setParentalGateEnabled:(BOOL)value  {
    _parentalGateEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_PARENTAL_GATE];
}

- (void) setBumperPageEnabled:(BOOL)value {
    _bumperPageEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_BUMPER_PAGE];
}

- (void) setOrientation:(Orientation)value {
    _orientation = value;
    [_dict setObject:@(value) forKey:kKEY_ORIENTATION];
}

@end

@implementation SAAdMobExtras

- (id) init {
    if (self = [super init]) {
        _testEnabled = false;
        _orientation = OrientationAny;
        _parentalGateEnabled = false;
        _bumperPageEnabled = false;
        _closeButtonEnabled = false;
        _closeAtEndEnabled = true;
        _smallCLickEnabled = false;
        _transparentEnabled = false;
    }
    
    return self;
}

@end
