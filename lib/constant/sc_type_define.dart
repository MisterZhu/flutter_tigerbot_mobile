/// typeDefine

class SCTypeDefine {
  /************************* 首页-cellType *************************/
  /// banner
  static const int SC_HOME_TYPE_BANNER = 0;
  /// 所有应用列表
  static const int SC_HOME_TYPE_ALLITEMS = 1;
  /// 热门活动列表
  static const int SC_HOME_TYPE_ACTIVITY = 2;
  /// 精选商家
  static const int SC_HOME_TYPE_FEATURE = 3;
  /// 精选资讯
  static const int SC_HOME_TYPE_NEWS = 4;
  /// 一张图片
  static const int SC_HOME_TYPE_IMAGE = 5;
  /// swiper广告图
  static const int SC_HOME_TYPE_SWIPER = 6;
  /// 网格图片,4等分，宽高1：1，1行
  static const int SC_HOME_TYPE_GRID = 7;
  /// 网格图片,2等分，多行
  static const int SC_HOME_TYPE_GRID_GROUP = 8;
  /// 园区活动1
  static const int SC_HOME_TYPE_COMMUNITY1 = 9;
  /// 园区活动2
  static const int SC_HOME_TYPE_COMMUNITY2 = 10;
  /// 美好生活1
  static const int SC_HOME_TYPE_LIFE1 = 11;
  /// 美好生活2
  static const int SC_HOME_TYPE_LIFE2 = 12;
  /// 精选商品
  static const int SC_HOME_TYPE_GOODS = 13;


  /************************* 工作台 *************************/
  /// 板块-工单处理
  static const int SC_WORKBENCH_TASK_TYPE_WORKORDER = 0;
  /// 板块-实地核验
  static const int SC_WORKBENCH_TASK_TYPE_VERIFICATION = 1;
  /// 板块-订单处理
  static const int SC_WORKBENCH_TASK_TYPE_ORDER = 2;
  /// 板块-物资入库
  static const int SC_WORKBENCH_TASK_TYPE_MATERIAL_IN = 3;
  /// 板块-物资出库
  static const int SC_WORKBENCH_TASK_TYPE_MATERIAL_OUT = 4;
  /// 板块-物资报损
  static const int SC_WORKBENCH_TASK_TYPE_MATERIAL_FRMLSS = 5;
  /// 板块-物资调拨
  static const int SC_WORKBENCH_TASK_TYPE_MATERIAL_TRANSFER = 6;

  /************************* 我的-cellType *************************/
  /// header
  static const int SC_MINE_TYPE_HEADER = 0;
  /// 切换房号
  static const int SC_MINE_TYPE_CHANGERHOUSE = 1;
  /// 积分
  static const int SC_MINE_TYPE_SCORE = 2;
  /// 钱包
  static const int SC_MINE_TYPE_WALLET = 3;
  /// 资产
  static const int SC_MINE_TYPE_PROPERTY = 4;
  /// 服务
  static const int SC_MINE_TYPE_SERVICE = 5;
  /************************* 我的-cellType *************************/

  /************************* 登录页面-cellType *************************/
  /// 标题
  static const int SC_LOGIN_TYPE_TITLE = 0;
  /// 手机号验证码输入框
  static const int SC_LOGIN_TYPE_TEXTFIELD = 1;
  /// 登录按钮
  static const int SC_LOGIN_TYPE_LOGIN_BUTTON = 2;
  /// 协议
  static const int SC_LOGIN_TYPE_AGREEMENT = 3;
  /// 底部图片
  static const int SC_LOGIN_TYPE_BOTTOM_IMAGE = 4;
  /************************* 登录页面-cellType *************************/

  /// 皮肤类型1
  static const int SC_SKIN_TYPE1 = 1;
  /// 皮肤类型2
  static const int SC_SKIN_TYPE2 = 2;

/************************* 用户协议、隐私政策富文本类型 *************************/

  /// 0-间隔,1-image,2-普通文本
  /// 0-间隔(sizeBox)
  static const int richTextTypeSpace = 0;

  /// 1-图片
  static const int richTextTypeImage = 1;

  /// 2-文本
  static const int richTextTypeText = 2;

/************************* 用户实名认证状态 *************************/

  /// 0-未实名
  static const int realNameVerifyStatusNo = 0;

  /// 1-已实名
  static const int realNameVerifyStatusSuccess = 1;

  /// 2-审核中
  static const int realNameVerifyStatusReview = 2;

  /// 3-未通过
  static const int realNameVerifyStatusFailed = 3;

  /************************* 巡查任务详情页面-cellType *************************/
  /// 0-标题
  static const int SC_PATROL_TYPE_TITLE = 0;
  /// 1-检查项
  static const int SC_PATROL_TYPE_CHECK = 1;
  /// 1-任务日志
  static const int SC_PATROL_TYPE_LOG = 2;
  /// 编号、时间等信息
  static const int SC_PATROL_TYPE_INFO = 3;

  static const int SC_PATROL_TYPE_PINGFEN = 4;

  static const int SC_PATROL_TYPE_TAB = 5;

}