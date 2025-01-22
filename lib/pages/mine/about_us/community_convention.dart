import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConventionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SCCustomScaffold(
      leading: _leading(),
      leadingWidth: 100,
      body: _body(),
      centerTitle: true,
      showBackIcon: true,
      showBackgroundImage: false,
      navBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      bodyBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      customTitleWidget: Text(
        'community_agreement'.tr,
        style: TextStyle(
          color: themed.theme_c.textColor,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  /// leading
  Widget _leading() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 44,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44.0,
              child: Image.asset(
                Assets.commonCommonBackIcon,
                width: 24.0,
                height: 24.0,
                color: themed.theme_c.textColor, // 你想要的颜色
                colorBlendMode: BlendMode.srcIn,
              ),
              onPressed: () {
                TBRouterHelper.back(null);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '使用、分享与传播指引',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _buildParagraph(
            '引言',
            content:
                'TigerBot APP（以下简称“本产品”）由虎博网络技术（上海）有限公司（以下简称“我们”或“虎博”）提供。本产品提供人工智能服务，以实现问答、对话与写作等功能（以下简称“本服务”）。为了有效控制AI生成内容的风险，根据《中华人民共和国个人信息保护法》《生成式人工智能服务管理暂行办法》《网络信息内容生态治理规定》《互联网信息服务管理办法》等法律、法规，同时参考相关标准与行业良好实践，制作本《使用、分享与传播指引》（以下简称“本指引”），旨在向用户（以下简称“您”）详细阐述在使用本服务的过程中，使用、传播与分享利人工智能生成物的具体要求。',
          ),
          _buildListItem(
            '禁止行为',
            content: '您在使用本服务的过程，不得制作、复制、上传、发布、传播法律、行政法规禁止的以下行为，亦不得鼓励以下行为：',
            items: [
              '反对宪法确定的基本原则的；',
              '危害国家安全和利益，泄露国家秘密的；',
              '颠覆国家政权，推翻社会主义制度、煽动分裂国家、破坏国家统一的；',
              '损害国家形象、荣誉和利益的；',
              '宣扬恐怖主义、极端主义的；',
              '宣扬民族仇恨、民族歧视，破坏民族团结的；',
              '煽动地域歧视、地域仇恨的；',
              '宣扬信仰、国别、地域、性别、年龄、职业、健康等歧视；',
              '破坏国家宗教政策，宣扬邪教和迷信的；',
              '编造、散布谣言、虚假信息，扰乱经济秩序和社会秩序、破坏社会稳定的；',
              '散布、传播暴力、淫秽、色情、赌博、凶杀、恐怖或者教唆犯罪的；',
              '侵害未成年人合法权益或者损害未成年人身心健康的；',
              '未获他人允许，偷拍、偷录他人，侵害他人合法权利的；',
              '包含恐怖、暴力血腥、高危险性、危害表演者自身或他人身心健康内容的；',
              '危害网络安全、利用网络从事危害国家安全、荣誉和利益的；',
              '侮辱或者诽谤他人，侵害他人合法权益的；',
              '对他人进行暴力恐吓、威胁，实施人肉搜索的；',
              '涉及他人隐私、个人信息或资料的；',
              '散布污言秽语，损害社会公序良俗的；',
              '侵犯他人隐私权、名誉权、肖像权、知识产权、商业秘密等合法权益内容的；',
              '未经公司许可，利用本产品为自己或第三方进行推广、发布广告的（包括但不限于加入第三方链接、广告等行为）；',
              '过度营销信息，骚扰信息和/或垃圾信息、低俗类信息、垃圾广告的；',
              '与所制作、复制、上传、发布、传播的内容、留言、评论的信息毫无关系的；',
              '所发布、传播的内容毫无意义的，或刻意使用字符组合以逃避技术审核的；',
              '制作、复制、发布、传播虚假新闻信息；',
              '其他违反法律法规、政策及公序良俗、干扰本产品合作平台正常运营或侵犯其他用户或第三方合法权益内容的其他信息。',
            ],
          ),
          _buildListItem(
            '公开发布与传播的要求',
            content: '为减少可能引起的误解、纠纷与风险，您利用本服务在公开渠道发布与传播人工智能生成内容时，应当遵守以下规则：',
            items: [
              '在公开渠道发布与传播人工智能生成内容时，您应当手动审查每一次生成的内容，确保所生成的内容不存在本指引第（1）条所禁止生成的内容，以及生成任何违法法律法规的内容。',
              '在使用本服务的过程中，您应对利用虎博大模型所生成的内容承担责任，并在任何场合下明确该内容由您生成。同时，您应以不会引起他人忽视或误解的方式指明内容是借助虎博大模型生成的，并清晰地揭示虎博模型在内容创作中的作用。',
              '在公开渠道发布与传播人工智能生成内容时，您应当遵守我们的《用户协议》。',
            ],
          ),
          _buildParagraph(
            '意见反馈',
            content:
                '我们非常期待在提供本服务的过程中收到您的宝贵意见。如果您对利用本服务生成的内容有任何反馈建议，您可以向我们反馈，我们会根据您在测试期间的输入和反馈持续改进技术和优化功能。',
          ),
          _buildParagraph(
            '',
            content:
                '如遇发现任何利用我们的服务公开发布与传播违法、违规、侵害他人合法权益的行为，欢迎您随时通过本产品的邮箱【contact@tigerbot.com】进行举报反馈，也可拨打以下电话：(021)63888086。我们将对您的意见高度重视并采取及时有效的处理措施，同时对您表示十分感谢！',
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildParagraph(String title, {required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 8.0),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildListItem(String title,
      {required String content, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(content),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text('• $item'),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
