//
//  IMPaintingsAttributesTableViewController.m
//  Impressionism
//
//  Created by Brad on 5/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMPaintingsAttributesTableViewController.h"
#import "IMPaintingAttributes.h"
#import "IMAttributeTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "IMBrushImagePickerViewController.h"
#import "IMBrush.h"

@interface IMPaintingsAttributesTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
  NSArray *_attributesInfomation;
  NSDictionary *_attributes;
}

@end

@implementation IMPaintingsAttributesTableViewController

- (id) initWithJSON:(NSString *)attributes {
  if (self = [super initWithNibName:nil bundle:nil]) {
    NSData *data = [attributes dataUsingEncoding:NSUTF8StringEncoding];
    _attributes = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
  }
  return self;
}

-(void) updateTitle {
  if (self.hasBeenModified) {
    self.title = [NSString stringWithFormat:@"%@ - modified",self.fileName];
  }
  else {
    self.title = [NSString stringWithFormat:@"%@",self.fileName];
  }
}

- (void)viewDidLoad
{
  [self.tableView registerNib:[UINib nibWithNibName:@"IMFloatAttributeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"float"];
  [self.tableView registerNib:[UINib nibWithNibName:@"IMBooleanAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"boolean"];
  NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"attributes" ofType:@"json"]];



  id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  if ([JSON isKindOfClass:[NSDictionary class]]) {
    _attributesInfomation = JSON[@"attributes"];
  }


    [super viewDidLoad];
    

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];



  [self updateTitle];

}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_attributesInfomation count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  NSString *type = _attributesInfomation[indexPath.row][@"type"];
  NSString *attributeName = _attributesInfomation[indexPath.row][@"name"];
  CGFloat min = [_attributesInfomation[indexPath.row][@"min"] floatValue];
  CGFloat max = [_attributesInfomation[indexPath.row][@"max"] floatValue];

  NSNumber *value = _attributes[attributeName];
  if (NO == [value isKindOfClass:[NSNumber class]]) {
    value = 0;
  }

  if (![type isEqualToString:@"brushImage"]) {
    IMAttributeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:type forIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //UITableViewCell *cell = [[UITableViewCell alloc] init];


    cell.attributeName = attributeName;
    cell.attributeValue = [NSNumber numberWithFloat:0.1f];
    cell.maximumValue =max;
    cell.minimumValue = min;
    cell.attributeValue = value;
    cell.delegate = self;
    return cell;
  }
  else {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"BrushImage";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *imageName = [_attributes objectForKey:@"brushImage"];
    if (imageName) {
      cell.imageView.image = [UIImage imageNamed:imageName];
      cell.imageView.backgroundColor = [UIColor blackColor];
    }
    return cell;
  }

}


-(NSString *) toJSON {
  NSData *data  = [NSJSONSerialization dataWithJSONObject:_attributes options:NSJSONWritingPrettyPrinted error:0];
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return string;
}

-(void)saveButtonPressed:(id)sender {
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Save" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Reset Defaults", @"Email", nil];
  [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    NSString *toJSON = [self toJSON];
    [[IMBrush currentBrush] setJSON:toJSON];
    [[IMBrush currentBrush] save];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Preset Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
    self.hasBeenModified = YES;
    [self updateTitle];
  }

  if (buttonIndex == 1) {
    // NSString *toJSON = [self toJSON];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.fileName];

    [[NSFileManager defaultManager] removeItemAtPath:path error:0];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Custom Preset Deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];

  }

  if (buttonIndex == 2) {
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    [vc setSubject:[NSString stringWithFormat:@"Saved Preset: %@.json",self.fileName]];
    [vc setMessageBody:[self toJSON] isHTML:NO];
    NSData *data = [[self toJSON] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *fileName = self.fileName;
    [vc addAttachmentData:data mimeType:@"test/json" fileName:fileName];
    [vc setMailComposeDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
  }

}

-(void) tableViewCell:(IMAttributeTableViewCell *)cell valueDidChange:(NSNumber *)value {
  [_attributes setValue:value forKey:cell.attributeName];
  //[self.delegate paintingAttribute:cell.attributeName didChangeToValue:value];
  [self.delegate currentBrushEdited:[self toJSON]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 1) {
    if (self.navigationController.viewControllers.count > 1) {
      [self.navigationController popViewControllerAnimated:YES];
    }
    else {
      [self dismissViewControllerAnimated:YES completion:nil];
    }
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    IMBrushImagePickerViewController *vc =[[IMBrushImagePickerViewController alloc] initWithNibName:@"IMBrushImagePickerViewController" bundle:nil];
    vc.attributes = _attributes;
    vc.delegate = self.delegate;
    [self.navigationController pushViewController:vc animated:YES];
  }


}
@end
