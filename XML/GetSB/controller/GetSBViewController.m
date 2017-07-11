#import "GetSBViewController.h"

#import "GetSBTableViewCell.h"
#import "GetXIBTableViewCell.h"

#import "TabBarAndNavagation.h"

#import "ZHFileManager.h"

#import "MBProgressHUD.h"

@interface GetSBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;

@end


@implementation GetSBViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshSB_XIB];
}
- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
	self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [TabBarAndNavagation setRightBarButtonItemTitle:@"刷新" TintColor:[UIColor blackColor] target:self action:@selector(refreshSB_XIB)];
    [TabBarAndNavagation setTitleColor:[UIColor blackColor] forNavagationBar:self];
    self.title=@"SB XIB 生成Masonry";
    
    [self loadData];
}

- (void)refreshSB_XIB{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在寻找桌面上的StroyBoard和Xib文件!";
    [self loadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}

- (void)loadData{
    [self.dataArr removeAllObjects];
    
    NSString *mainPath=[ZHFileManager getMacHomeDirectorInIOS];
    mainPath=[mainPath stringByAppendingPathComponent:@"Desktop"];
    
    if ([ZHFileManager fileExistsAtPath:mainPath]==NO) {
        return;
    }
    
    NSArray *filesArr=[ZHFileManager contentsOfDirectoryAtPath:mainPath];
    
    NSMutableArray *filesXIB=[NSMutableArray array];
    NSMutableArray *filesSB=[NSMutableArray array];
    
    for (NSString *filePath in filesArr) {
        if ([filePath hasSuffix:@".xib"]) {
            GetXIBCellModel *GetXIBModel=[GetXIBCellModel new];
            GetXIBModel.title=filePath;
            GetXIBModel.filePath=[mainPath stringByAppendingPathComponent:filePath];
            GetXIBModel.iconImageName=@"xib.png";
            [filesXIB addObject:GetXIBModel];
        }else if ([filePath hasSuffix:@"storyboard"]){
            GetSBCellModel *GetSBModel=[GetSBCellModel new];
            GetSBModel.filePath=[mainPath stringByAppendingPathComponent:filePath];
            GetSBModel.title=filePath;
            GetSBModel.iconImageName=@"sb.png";
            [filesSB addObject:GetSBModel];
        }
    }
    
    if (filesSB.count==0&&filesXIB.count==0) {
        self.promoteLabel.text=@"桌面上没有StroyBoard 和xib 文件";
        self.promoteLabel.backgroundColor=[UIColor redColor];
    }else{
        self.promoteLabel.text=@"数据来源于桌面,StroyBoard 和xib 文件";
        self.promoteLabel.backgroundColor=[UIColor grayColor];
    }
    
    if (filesSB.count==0) {
        GetSBCellModel *GetSBModel=[GetSBCellModel new];
        GetSBModel.title=@"桌面无StroyBoard文件";
        GetSBModel.iconImageName=@"sb.png";
        GetSBModel.noFile=YES;
        [filesSB addObject:GetSBModel];
    }
    if (filesXIB.count==0) {
        GetXIBCellModel *GetXIBModel=[GetXIBCellModel new];
        GetXIBModel.title=@"桌面无Xib文件";
        GetXIBModel.iconImageName=@"xib.png";
        GetXIBModel.noFile=YES;
        [filesXIB addObject:GetXIBModel];
    }
    
    [self.dataArr addObject:filesSB];
    [self.dataArr addObject:filesXIB];
    
    [self.tableView reloadData];
}
#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.section][indexPath.row];
	if ([modelObjct isKindOfClass:[GetSBCellModel class]]){
		GetSBTableViewCell *GetSBCell=[tableView dequeueReusableCellWithIdentifier:@"GetSBTableViewCell"];
		GetSBCellModel *model=modelObjct;
		[GetSBCell refreshUI:model];
		return GetSBCell;
	}
	if ([modelObjct isKindOfClass:[GetXIBCellModel class]]){
		GetXIBTableViewCell *GetXIBCell=[tableView dequeueReusableCellWithIdentifier:@"GetXIBTableViewCell"];
		GetXIBCellModel *model=modelObjct;
		[GetXIBCell refreshUI:model];
		return GetXIBCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"选择了某一行");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"storyboard";
    }else if (section==1){
        return @"xib";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
@end