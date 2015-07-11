//
//  IMSequenceEditorTableViewController.m
//  Impressionism
//
//  Created by Brad on 6/30/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMSequenceEditorTableViewController.h"
#import "IMPaintingAttributes.h"
#import "IMPaintingsAttributesTableViewController.h"
#import "IMAppDelegate.h"
#import "IMRootViewController.h"


@interface IMSequenceEditorTableViewController () <UIActionSheetDelegate> {
  NSString *_fileName;
  IMSequence *_sequence;
}
@end

@implementation IMSequenceEditorTableViewController


-(id) initWithSequence:(IMSequence *)sequence {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    _sequence = sequence;
    self.title = [_sequence name];
  }
  return self;
}




- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sequence steps].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

  cell.tag = indexPath.row;
  UIStepper *stepper = [[UIStepper alloc] init];
  [stepper addTarget:self action:@selector(stepperValueDidChange:) forControlEvents:UIControlEventValueChanged];
  stepper.tag = indexPath.row;
  stepper.center = CGPointMake(320-100, 22);
  [stepper sizeToFit];
  [cell.contentView addSubview:stepper];

  NSString *title = [[_sequence steps] objectAtIndex:indexPath.row][@"brush"];
  cell.textLabel.text = title;
  NSUInteger duration = [[[_sequence steps] objectAtIndex:indexPath.row] [@"duration"] integerValue];
  stepper.value = duration;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Seconds", duration];

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}


-(void) stepperValueDidChange:(UIStepper *)stepper {
  NSMutableDictionary *step = [[_sequence steps][stepper.tag] mutableCopy];

  step[@"duration"] = [NSNumber numberWithInt:stepper.value];

  [[_sequence steps] removeObjectAtIndex:stepper.tag];
  [[_sequence steps] insertObject:step atIndex:stepper.tag];
  [self.tableView reloadData];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      [[_sequence steps] removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
  id object = [[_sequence steps] objectAtIndex:fromIndexPath.row];
  [[_sequence steps] removeObjectAtIndex:fromIndexPath.row];
  [[_sequence steps] insertObject:object atIndex:toIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)saveJSON {
  [_sequence save];
    [[[UIAlertView alloc] initWithTitle:@"Saved" message:@"The sequence is saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *fileName = [_sequence steps][indexPath.row][@"brush"];
  NSString *json = [IMPaintingAttributes JSONStringFromAttributeFileWithName:fileName];
  IMPaintingsAttributesTableViewController *vc = [[IMPaintingsAttributesTableViewController alloc] initWithJSON:json];
  vc.fileName = fileName;
  vc.title = @"Step";
  [self.navigationController pushViewController:vc animated:YES];
}

-(void) menuButtonPressed {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Add Brush Step",@"Save To Disk",@"Close",nil];
  actionSheet.tag = 1;
  [actionSheet showInView:self.view];
}

-(void) addButtonPressed {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose New Brush Step" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

  for (NSString *filename in [IMPaintingAttributes filenames]) {
    [actionSheet addButtonWithTitle:filename];
  }
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (actionSheet.tag == 1) {
    if (buttonIndex == 0) {
      [self addButtonPressed];
    }
    if (buttonIndex == 1) {
      [self saveJSON];
    }
    else {
      IMAppDelegate *del = [[UIApplication sharedApplication] delegate];
      IMRootViewController *rootVC = (IMRootViewController *)[[del window] rootViewController];
      [rootVC editPresetDoneButtonPressed:nil];
    }

    return;
  }

  //NSString *json = [IMPaintingAttributes JSONStringFromAttributeFileWithIndex:buttonIndex];
  NSString *name = [IMPaintingAttributes filenameWithIndex:buttonIndex];
  [[_sequence steps] addObject:@{@"brush": name, @"duration": @1.0}];
  [self.tableView reloadData];
}
@end
