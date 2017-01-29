//
//  TableViewController.m
//  TableEditing
//
//  Created by Vlad on 23.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "TableViewController.h"
#import "Student.h"
#import "Group.h"

@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *groups;

@end


@implementation TableViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    self.groups = [NSMutableArray array];
    int gropsCount = arc4random() % 5 + 5;
    
    for (int i = gropsCount; i >= 1; i--) {
        
        Group *group = [Group new];
        group.name = [NSString stringWithFormat:@"Group #%d", i];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 1; j < arc4random() % 5 + 5; j++) {
            [array addObject:[Student randomStudent]];
        }
        
        group.students = array;
        [self.groups addObject:group];
        
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action

- (void)addSection:(UIBarButtonItem *)sender {
    
    Group *group = [Group new];
    group.name = [NSString stringWithFormat:@"Group #%u", [self.groups count] + 1];
    
    group.students = @[[Student randomStudent],
                       [Student randomStudent]];
   
    [self.groups insertObject:group atIndex:0];
    
    [self.tableView beginUpdates];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}

- (void)editAction:(UIBarButtonItem *)sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editAction:)];
    self.navigationItem.leftBarButtonItem = editButton;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group *gr = [self.groups objectAtIndex:section];
    return [gr.students count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        static NSString *addStudentIdentifier = @"addStudent";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Press to add Student";
        return cell;
        
    } else {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    Group *gr = [self.groups objectAtIndex:indexPath.section];
    Student *std = [gr.students objectAtIndex:indexPath.row -1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", std.firstName, std.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)std.age];
    cell.imageView.image = [UIImage imageNamed:std.imgName];
    
    return cell;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groups objectAtIndex:section] name];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Group *sourceGroup = [self.groups objectAtIndex:indexPath.section];
    Student *selectedStudent = [sourceGroup.students objectAtIndex:indexPath.row - 1];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tempArray removeObject:selectedStudent];
        sourceGroup.students = tempArray;
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    Group *sourceGroup = [self.groups objectAtIndex:fromIndexPath.section];
    Student *selectedStudent = [sourceGroup.students objectAtIndex:fromIndexPath.row - 1];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (fromIndexPath.section == toIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:fromIndexPath.row - 1 withObjectAtIndex:toIndexPath.row - 1];
        sourceGroup.students = tempArray;
    
    } else {
        
        Group *destinationGroup = [self.groups objectAtIndex:toIndexPath.section];

        [tempArray removeObject:selectedStudent];
        sourceGroup.students = tempArray;
        
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:selectedStudent atIndex:toIndexPath.row - 1];
        destinationGroup.students = tempArray;
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}

#pragma mark - UITableViewDelegate


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return indexPath;
    } else {
    return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        Group *sourceGroup = [self.groups objectAtIndex:indexPath.section];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
        
        int newIndex = 0;

        [tempArray insertObject:[Student randomStudent] atIndex:newIndex];
        sourceGroup.students = tempArray;
        
        [tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.tableView.allowsSelectionDuringEditing = YES;
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



@end
