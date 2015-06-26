//
//  BHCityTableViewController.m
//  BHCityTable
//
//  Created by libohao on 15/6/26.
//  Copyright (c) 2015年 libohao. All rights reserved.
//

#import "BHProvinceTableViewController.h"
#import "BHChooseCityTableViewController.h"

@interface BHProvinceTableViewController ()

@property (nonatomic, strong) NSMutableArray* provinceArray;
@property (nonatomic, strong) NSMutableArray* cityArray;

@end

@implementation BHProvinceTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData * data = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area_ios" ofType:@"json"]];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.provinceArray = [dict objectForKey:@"province"];
        
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.provinceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"当前定位城市";
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row < self.provinceArray.count) {
            cell.textLabel.text = [self.provinceArray[indexPath.row] objectForKey:@"name"];
        }
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerVeiw = [[UIView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), 48)];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 23, 200, 15)];
    if (section) {
        label.text = @"全部";
    }else {
        label.text = @"定位到城市";
    }
    label.font = [UIFont systemFontOfSize:14];
    
    [headerVeiw addSubview:label];
    
    return headerVeiw;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        BHChooseCityTableViewController* chooseCity = [[BHChooseCityTableViewController alloc]init];
        chooseCity.cityArray = [[self.provinceArray objectAtIndex:0] objectForKey:@"city"];
        [self.navigationController pushViewController:chooseCity animated:YES];
    }

}


@end
