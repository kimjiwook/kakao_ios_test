//
//  NSObject+Associating.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "NSObject+Associating.h"

@implementation NSObject (Associating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
