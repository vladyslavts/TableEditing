//
//  Student
//  TableEditing
//
//  Created by Vlad on 23.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) NSInteger age;
@property (strong, nonatomic) NSString *imgName;

+ (Student *)randomStudent;

@end
