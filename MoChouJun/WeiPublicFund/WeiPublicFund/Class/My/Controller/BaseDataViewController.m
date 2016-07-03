//
//  BaseDataViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "BaseDataViewController.h"
#import "AccountIconTableViewCell.h"
#import "AccountSetTableViewCell.h"
#import "BaseDataTableViewCell.h"
#import "ProvincesViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "WriteSignatureViewController.h"
#import "User.h"
#import "PSActionSheet.h"
#import "SendCMDMessageUtil.h"
#import "User.h"
#import "BaseDataEditViewController.h"
#import "ZHBPickerView.h"

@interface BaseDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,ZHBPickerViewDataSource,ZHBPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *baseDataTableView;
@property (nonatomic , strong) UIImagePickerController *imagePicerController;

@property (nonatomic,strong) NSMutableDictionary *addressDic;
@property (nonatomic,strong)NSString *sigNatureStr;

@property (nonatomic,strong)NSDictionary *baseDataDic;

@property (nonatomic,strong)NSString *nickNameStr;
@property (nonatomic,strong)NSString *jobStr;
@property (nonatomic,strong)NSString *schoolStr;
@property (nonatomic,strong)NSString *companyStr;
@property (nonatomic,strong)NSString *sexStr;
@property (nonatomic,assign)NSInteger sexInt;

@property (nonatomic,assign)NSInteger districtId;

@property (nonatomic,assign)BOOL zhBPickBool;
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;
@property (nonatomic,strong)NSArray *sexArr;
@end

@implementation BaseDataViewController

- (void)change:(NSNotification *)aNoti
{
    NSDictionary *dict = [aNoti userInfo];
    _sigNatureStr = [dict objectForKey:@"Info"];
    [_baseDataTableView reloadData];
}

- (void)baseChange:(NSNotification *)aNoti
{
    NSDictionary *dict = [aNoti userInfo];
    if ([[dict objectForKey:@"Type"] isEqual:@"昵称"]) {
        _nickNameStr = [dict objectForKey:@"Info"];
    }else if ([[dict objectForKey:@"Type"] isEqual:@"性别"]){
        _sexStr = [dict objectForKey:@"Info"];
        if ([_sexStr isEqual:@"男"]) {
            _sexInt = 1;
        }else if ([_sexStr isEqual:@"女"]) {
            _sexInt = 2;
        }else{
            _sexInt = 0;
        }
    }else if ([[dict objectForKey:@"Type"] isEqual:@"职业"]){
        _jobStr = [dict objectForKey:@"Info"];
    }else if ([[dict objectForKey:@"Type"] isEqual:@"学校"]){
        _schoolStr = [dict objectForKey:@"Info"];
    }else if ([[dict objectForKey:@"Type"] isEqual:@"公司"]){
        _companyStr = [dict objectForKey:@"Info"];
    }
    [_baseDataTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"个人资料";
    _sexInt = -1;
    _zhBPickBool = NO;
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"WriteSignature" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseChange:) name:@"BaseDataEdit" object:nil];
    [self setNaviInfo];
    [self setTableViewInfo];
    [MBProgressHUD showStatus:nil toView:self.view];
    [self getBaseDataInfo];
}

- (void)setNaviInfo
{
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(saveClick) leftOrRight:NO];
    [self backBarItem];
}

- (void)backAction
{
    if (_nickNameStr != [_baseDataDic objectForKey:@"NickName"] || _jobStr != [_baseDataDic objectForKey:@"Occupation"] ||
        _schoolStr != [_baseDataDic objectForKey:@"School"] ||
        _companyStr != [_baseDataDic objectForKey:@"Company"] ||
        _districtId != [[_baseDataDic objectForKey:@"DistrictId"] integerValue] || _sigNatureStr != [_baseDataDic objectForKey:@"Signature"] || _sexInt != -1) {

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"个人小档案还没有建立哦!" delegate:self cancelButtonTitle:@"继续建立" otherButtonTitles:@"不想折腾", nil];

        [alert show];
    }else{
        [self performSelector:@selector(popPrevious) withObject:nil afterDelay:0.25];
    }
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSelector:@selector(popPrevious) withObject:nil afterDelay:0.25];
    }
}

- (void)popPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveClick
{
    [self setupBarButtomItemWithTitle:nil target:self action:nil leftOrRight:NO];
    if ([[self.addressDic allKeys] containsObject:kDistrictKey])
    {
        District *district = [_addressDic valueForKey:kDistrictKey];
        _districtId = district.districtId;
    }else{
        _districtId = [[_baseDataDic objectForKey:@"DistrictId"] integerValue];
    }

    if (IsStrEmpty(_nickNameStr)) {
        _nickNameStr = @"";
    }
    if (IsStrEmpty(_sigNatureStr)) {
        _sigNatureStr = @"";
    }
    if (IsStrEmpty(_jobStr)) {
        _jobStr = @"";
    }
    if (IsStrEmpty(_schoolStr)) {
        _schoolStr = @"";
    }
    if (IsStrEmpty(_companyStr)) {
        _companyStr = @"";
    }
    if (_sexInt == -1) {
        _sexInt = [[_baseDataDic objectForKey:@"Sex"] integerValue];
    }
    [self.httpUtil requestDic4MethodName:@"Personal/SaveInfo" parameters:@{@"NickName":_nickNameStr,@"Signature":_sigNatureStr,@"Occupation":_jobStr,@"School":_schoolStr,@"Company":_companyStr,@"DistrictId":@(_districtId),@"UserName":[_baseDataDic objectForKey:@"UserName"],@"Sex":@(_sexInt)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {

            [MBProgressHUD showSuccess:@"缤果" toView:self.view];

            [User userFromFile].nickName = _nickNameStr;
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            
            // 发送透传消息
            if (!IsStrEmpty(_nickNameStr))
            {
                [SendCMDMessageUtil sendNicknameCMDMEessage:_nickNameStr];
            }
        }
        else
        {
            [self setupBarButtomItemWithTitle:@"保存 " target:self action:@selector(saveClick) leftOrRight:NO];
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_baseDataTableView reloadData];
}

- (void)getBaseDataInfo
{
    [self.httpUtil requestDic4MethodName:@"Personal/BaseInfo" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            _baseDataDic = dic;
            NSLog(@"------%@",_baseDataDic);
            _nickNameStr = [_baseDataDic objectForKey:@"NickName"];
            if ([[_baseDataDic objectForKey:@"Sex"] integerValue] == 1) {
                _sexStr = @"男";
            }else if ([[_baseDataDic objectForKey:@"Sex"] integerValue] == 2) {
                _sexStr = @"女";
            }else{
                _sexStr = @"";
            }
            _jobStr = [_baseDataDic objectForKey:@"Occupation"];
            _schoolStr = [_baseDataDic objectForKey:@"School"];
            _companyStr = [_baseDataDic objectForKey:@"Company"];
            _sigNatureStr = [_baseDataDic objectForKey:@"Signature"];
            _districtId = [[_baseDataDic objectForKey:@"DistrictId"] integerValue];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        [_baseDataTableView reloadData];
    }];
}

#pragma mark - Setter & Getter
- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController)
    {
        _imagePicerController = [[UIImagePickerController alloc]init];
        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _imagePicerController.navigationBar.barTintColor = NaviColor;
        _imagePicerController.delegate = self;
        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _imagePicerController.allowsEditing = YES;
    }
    return _imagePicerController;
}

- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}

- (void)setTableViewInfo
{
    [self setupHeaderRefresh:_baseDataTableView];
    [_baseDataTableView registerNib:[UINib nibWithNibName:@"AccountSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountSetTableViewCell"];
    [_baseDataTableView registerNib:[UINib nibWithNibName:@"AccountIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountIconTableViewCell"];
    [_baseDataTableView registerNib:[UINib nibWithNibName:@"BaseDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"BaseDataTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }
        return 50;
    }else if (indexPath.section == 1){
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 14;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AccountSetTableViewCell";
    AccountSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AccountSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellID = @"AccountIconTableViewCell";
            AccountIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[AccountIconTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [NetWorkingUtil setImage:cell.accounticonImageView url:[_baseDataDic objectForKey:@"Avatar"] defaultIconName:@"home_默认"];
            return cell;
        }else if (indexPath.row == 1){
            cell.accountNameLab.text = @"昵称";
            if (IsStrEmpty(_nickNameStr)) {
                cell.accountInfoLab.text = @"请填写";
            }else{
                cell.accountInfoLab.text = _nickNameStr;
            }
        }else if (indexPath.row == 2){
            cell.accountNameLab.text = @"性别";
            if (IsStrEmpty(_sexStr)) {
                cell.accountInfoLab.text = @"请选择";
            }else{
                cell.accountInfoLab.text = _sexStr;
            }
        }else if (indexPath.row == 3){
            cell.accountNameLab.text = @"个性签名";
            cell.accountInfoLab.numberOfLines = 1;
            if (IsStrEmpty(_sigNatureStr)) {
                cell.accountInfoLab.text = @"请填写";               
            }else{
                cell.accountInfoLab.text = _sigNatureStr;
            }
        }else if (indexPath.row == 4){
            cell.accountNameLab.text = @"目前所在地";
            cell.accountInfoLab.numberOfLines = 0;
            if ([[self.addressDic allKeys] containsObject:kDistrictKey])
            {
                Province *province =[_addressDic valueForKey:kProvincesKey];
                City *city = [_addressDic valueForKey:kCityKey];
                District *district = [_addressDic valueForKey:kDistrictKey];
                _districtId = district.districtId;
                cell.accountInfoLab.text = [NSString stringWithFormat:@"%@-%@-%@",province.provinceName,city.cityName,district.districtName];
            }else{
                if ([[_baseDataDic objectForKey:@"Address"] isEqual:@""]) {
                    cell.accountInfoLab.text = @"未设置";
                }else{
                    cell.accountInfoLab.text = [_baseDataDic objectForKey:@"Address"];
                }
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.accountNameLab.text = @"职业";
            if (IsStrEmpty(_jobStr)) {
                cell.accountInfoLab.text = @"未设置";
            }else{
                cell.accountInfoLab.text = _jobStr;
            }
        }else if (indexPath.row == 1){
            cell.accountNameLab.text = @"学校";
            if (IsStrEmpty(_schoolStr)) {
                cell.accountInfoLab.text = @"未设置";
            }else{
                cell.accountInfoLab.text = _schoolStr;
            }
        }else if (indexPath.row == 2){
            cell.accountNameLab.text = @"公司";
            if (IsStrEmpty(_companyStr)) {
                cell.accountInfoLab.text = @"未设置";
            }else{
                cell.accountInfoLab.text = _companyStr;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",nil];
            [actionSheet showInView:self.view];
        }else if (indexPath.row == 1){
            BaseDataEditViewController *baseDataEditVC = [BaseDataEditViewController new];
            baseDataEditVC.baseDataStr = _nickNameStr;
            baseDataEditVC.titleStr = @"昵称";
            [self.navigationController pushViewController:baseDataEditVC animated:YES];
        }else if (indexPath.row == 2){
            if (_zhBPickBool == NO) {
                _zhBPickBool = YES;
                _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
                
                _zhBPickerView.dataSource = self;
                _zhBPickerView.delegate = self;
                _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
                [_window addSubview:_zhBPickerView];
                
                self.sexArr = @[@"男",@"女"];
            }else{
                _zhBPickBool = NO;
                [_zhBPickerView removeFromSuperview];
            }
        }
        else if (indexPath.row == 3){
            WriteSignatureViewController *writeSignatureVC = [[WriteSignatureViewController alloc] init];
            if (_sigNatureStr == nil)
            {
                if (![[_baseDataDic objectForKey:@"Signature"] isEqual:@""])
                {
                    writeSignatureVC.signatureStr = [_baseDataDic objectForKey:@"Signature"];
                }
            }
            else
            {
                writeSignatureVC.signatureStr = _sigNatureStr;
            }
            [self.navigationController pushViewController:writeSignatureVC animated:YES];
        }else if (indexPath.row == 4){
            ProvincesViewController *provinceVC = [[ProvincesViewController alloc] init];
            provinceVC.addressDic = self.addressDic;
            [self.navigationController pushViewController:provinceVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            BaseDataEditViewController *baseDataEditVC = [BaseDataEditViewController new];
            baseDataEditVC.baseDataStr = _jobStr;
            baseDataEditVC.titleStr = @"职业";
            [self.navigationController pushViewController:baseDataEditVC animated:YES];
        }else if (indexPath.row == 1){
            BaseDataEditViewController *baseDataEditVC = [BaseDataEditViewController new];
            baseDataEditVC.baseDataStr = _schoolStr;
            baseDataEditVC.titleStr = @"学校";
            [self.navigationController pushViewController:baseDataEditVC animated:YES];
        }else if (indexPath.row == 2){
            BaseDataEditViewController *baseDataEditVC = [BaseDataEditViewController new];
            baseDataEditVC.baseDataStr = _companyStr;
            baseDataEditVC.titleStr = @"公司";
            [self.navigationController pushViewController:baseDataEditVC animated:YES];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 拍照
        // 判断是否能拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicerController.showsCameraControls = YES;//takePicture
            [self presentViewController:self.imagePicerController animated:YES completion:nil];
        }
        else
        {
            ULog(@"设备不支持");
        }
    }
    else if (buttonIndex == 1)
    {
        // 相册
        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicerController animated:YES completion:nil];
    }
}

//修改照片尺寸
-(UIImage *)changeImageviewSize:(UIImageView *)Imageview{
    UIGraphicsBeginImageContext(Imageview.bounds.size);
    [Imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 选取图片后的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImageView *Imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320, 320)];
    Imageview.image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *changeImage = [self changeImageviewSize:Imageview];

    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestImageMethodName:@"Personal/UploadAvatar" parameters:nil images:@[changeImage] result:^(NSString *avatar, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {

            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"头像美四方噢"];

            User *user = [User shareUser];
            user.avatar = avatar;
            [user saveUser];
            [_baseDataTableView reloadData];
            [SendCMDMessageUtil sendAvatarCMDMEessage:avatar];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)headerRefreshloadData
{
    [self getBaseDataInfo];
    [_baseDataTableView.mj_header endRefreshing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSArray *)sexArr
{
    if (!_sexArr) {
        _sexArr = [NSArray array];
    }
    return _sexArr;
}

//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        return _sexArr;
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    _zhBPickBool = NO;
    
    _sexStr = content;
    if ([_sexStr isEqual:@"男"]) {
        _sexInt = 1;
    }else if ([_sexStr isEqual:@"女"]) {
        _sexInt = 2;
    }else{
        _sexInt = 0;
    }
    if ([content isEqual:@""]) {
        _sexStr = @"男";
    }
    [_baseDataTableView reloadData];
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
}

@end