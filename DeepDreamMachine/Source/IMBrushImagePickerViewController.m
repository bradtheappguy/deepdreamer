//
//  IMBrushImagePickerViewController.m
//  Impressionism
//
//  Created by Brad on 7/1/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMBrushImagePickerViewController.h"
#import "CAWSpriteLayer.h"
#import "CAWSpriteReader.h"


@interface IMBrushImagePickerViewController () {
  NSMutableArray *images;
}

@end

@implementation IMBrushImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
  images = [NSMutableArray new];
  //NSDictionary *spriteData = [CAWSpriteReader spritesWithContentOfFile:@"brushes.json"];
  //UIImage *texture = [UIImage imageNamed:@"spritesheet.png"];
  //CAWSpriteLayer *staticImageLayer = [CAWSpriteLayer layerWithSpriteData:spriteData andImage:texture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
  cell.backgroundColor = [UIColor grayColor];
  NSString *imageName = [NSString stringWithFormat:@"brush%02d.png",indexPath.row+1];
  UIImage *image = [UIImage imageNamed:imageName];
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
  iv.image = image;
  [cell addSubview:iv];
  cell.tag = indexPath.row;
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSString *imageName = [NSString stringWithFormat:@"brush%02d.png",indexPath.row+1];
  [self.attributes setValue:imageName forKey:@"brushImage"];
  [self.delegate performSelector:@selector(paintingAttribute:didChangeToValue:) withObject:@"brushImage"  withObject:imageName];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
