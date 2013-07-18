//
//  BaseCustomTableViewController.h
//  CustomTableViewStructure
//
//  Created by Korovkina on 18.07.13.
//  Copyright (c) 2013 Korovkina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableDataStructure.h"

@interface BaseCustomTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) CustomTableDataStructure *tableStructure;

@end
