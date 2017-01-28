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
    NSInteger gropsCount = arc4random() % 5 + 5;
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
    group.name = [NSString stringWithFormat:@"Group #%d", [self.groups count] + 1];
    
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
    return [gr.students count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    Group *gr = [self.groups objectAtIndex:indexPath.section];
    Student *std = [gr.students objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", std.firstName, std.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)std.age];
    cell.imageView.image = [UIImage imageNamed:std.imgName];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groups objectAtIndex:section] name];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Group *sourceGroup = [self.groups objectAtIndex:indexPath.section];
    Student *selectedStudent = [sourceGroup.students objectAtIndex:indexPath.row];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tempArray removeObject:selectedStudent];
        sourceGroup.students = tempArray;
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    Group *sourceGroup = [self.groups objectAtIndex:fromIndexPath.section];
    Student *selectedStudent = [sourceGroup.students objectAtIndex:fromIndexPath.row];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (fromIndexPath.section == toIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        sourceGroup.students = tempArray;
    
    } else {
        
        Group *destinationGroup = [self.groups objectAtIndex:toIndexPath.section];

        [tempArray removeObject:selectedStudent];
        sourceGroup.students = tempArray;
        
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:selectedStudent atIndex:toIndexPath.row];
        destinationGroup.students = tempArray;
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}
 */

@end
