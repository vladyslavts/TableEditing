//
//  Student
//  TableEditing
//
//  Created by Vlad on 23.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "Student.h"

@interface Student ()

@end

@implementation Student


static NSString *firstNames[] = {
    
    @"Jack",     @"Ethan",   @"William",     @"Helen",   @"Alice",      @"Anna",
    @"Joshua",   @"Michael", @"Anya",        @"Dasha",   @"Richard",    @"Matthew",
    @"Caroline", @"Daisy",   @"Jacob",       @"Juliet",  @"Christine",  @"Augustine",
    @"Mark",     @"Anne",    @"Jessica",     @"Marian",  @"Sophie",     @"Leslie",
    @"Thomas",   @"Peter",   @"Donald",      @"Naomi",   @"Augustine",  @"Margaret",
    @"Abigail",  @"Kenneth", @"Mary",        @"Lisa"

};

static NSString *lastNames[] = {
    
    @"Young",     @"Fleming",   @"Chapman",     @"Fletcher",    @"Short",     @"York",
    @"Warren",    @"O’Brien",   @"Banks",       @"Cox",         @"Perkins",   @"Atkins",
    @"Grant",     @"Carpenter", @"Robbins",     @"Gibson",      @"Horton",    @"Booker",
    @"Holt",      @"Doyle",     @"Jacobs",      @"Miller",      @"Moore",     @"Flowers",
    @"Harrison",  @"Higgins",   @"Curtis",      @"Carson",      @"Jordan",    @"Bailey",
    @"McCarthy",  @"Hill",      @"Montgomery",  @"Shelton"
    
};

static NSInteger namesCount = 32;


+ (Student *)randomStudent {
    
    Student *student = [Student new];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    student.age = arc4random() % 7 + 18;
    student.imgName = @"avatar.png";
    
    return student;
}

@end
