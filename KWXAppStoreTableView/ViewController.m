//
//  ViewController.m
//  tile
//
//  Created by Michael Hurni on 20/10/2018.
//  Copyright © 2018 Michael Hurni. All rights reserved.
//

#import "ViewController.h"
#import "KWXAppStoreTableView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> @end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KWXAppStoreTableView *tableView = [[KWXAppStoreTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(tableView.layoutMargins.top, 0, tableView.layoutMargins.bottom, 0);
    
    [self.view addSubview:tableView];
    [self.view setBackgroundColor:UIColor.whiteColor];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 8; }

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (t.bounds.size.height - t.contentInset.top) / 1.5;
}

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [t dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *tile = [UIView new];
        tile.layer.cornerRadius = 10;
        tile.translatesAutoresizingMaskIntoConstraints = NO;
        tile.clipsToBounds = YES;
        
        [cell.contentView addSubview:tile];
        [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tile]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tile)]];
        [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tile]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tile)]];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tile"]];
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.layer.cornerRadius = 10;
        [tile addSubview:iv];
        tile.layoutMargins = UIEdgeInsetsMake(15, 15, 15, 15);
        
        [tile addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(iv)]];
        [tile addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(iv)]];
        
        UILabel *label = [UILabel new];
        label.text = @"App\nof\nthe day".uppercaseString;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"SFProDisplay-Black" size:35.0];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = UIColor.whiteColor;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 0;
        paragraphStyle.maximumLineHeight = 35.0;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        
        label.attributedText = attributedString;
        
        [tile addSubview:label];
        
        [tile addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [tile addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        
        CGRect shadowRect = CGRectMake(0, 0, t.frame.size.width - t.layoutMargins.left - t.layoutMargins.right, [self tableView:t heightForRowAtIndexPath:indexPath] - cell.layoutMargins.top - cell.layoutMargins.bottom);
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:10];
        tile.layer.masksToBounds = false;
        tile.layer.shadowRadius = 6;
        tile.layer.shadowColor = UIColor.blackColor.CGColor;
        tile.layer.shadowOffset = CGSizeMake(0, 0);
        tile.layer.shadowOpacity = .20;
        tile.layer.shadowPath = shadowPath.CGPath;
        
        [(KWXAppStoreTableView *)t addGestureReconizersToView:cell];
    }
    
    return cell;
}

@end
