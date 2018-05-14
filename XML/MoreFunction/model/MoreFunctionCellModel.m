#import "MoreFunctionCellModel.h"


@implementation MoreFunctionCellModel
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}
- (void)setAutoWidthText:(NSString *)autoWidthText{
	_autoWidthText=autoWidthText;
	self.width=[autoWidthText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
}

@end
