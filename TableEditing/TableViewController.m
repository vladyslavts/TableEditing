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
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Students";
    
    self.groups = [NSMutableArray array];
    for (int i = 1; i < arc4random() % 15 + 10; i++) {
        
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


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
