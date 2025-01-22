import '../constant/tb_export_common.dart';

class TBCustomClipper extends CustomClipper<Path> {
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  TBCustomClipper({
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height); // 左下角
    path.lineTo(0, 0); // 左上角
    path.lineTo(size.width, 0); // 右上角
    path.lineTo(size.width, size.height); // 右下角
    path.quadraticBezierTo(0, size.height, 0, size.height); // 添加左上角圆角
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
