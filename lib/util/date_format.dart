String dateFormat(DateTime dateTime) {
  DateTime currentDateTime = DateTime.now();
  int currentTimestamp = currentDateTime.millisecondsSinceEpoch;
  int timestamp = dateTime.millisecondsSinceEpoch;
  final timeDiff = currentTimestamp - timestamp;
  final min = 60 * 1000;
  final hour = min * 60;
  final day = hour * 24;
  final twoDay = hour * 48;
  final threeDay = hour * 72;
  final fourDay = hour * 96;
  final fiveDay = hour * (24 * 5);
  final sixDay = hour * (24 * 6);
  final sevenDay = hour * (24 * 7);
  final eightDay = hour * (24 * 8);
  final nineDay = hour * (24 * 9);
  final tenDay = hour * (24 * 10);
  final elevenDay = hour * (24 * 10);
  final halfMonth = hour * (24 * 15);
  final oneMonth = hour * (24 * 30);
  final twoMonth = hour * (24 * 60);
  final threeMonth = hour * (24 * 90);

  final exceedHour = (timeDiff / hour).floor();
  final exceedMin = (timeDiff / min).floor();
  if (timeDiff < 0) {
    return '刚刚';
  }
  if (timeDiff < hour) {
    return "$exceedMin分钟前";
  }
  if (timeDiff < day) {
    return "$exceedHour分钟前";
  }
  if (timeDiff >= day && timeDiff < twoDay) {
    return '1天前';
  }
  if (timeDiff >= twoDay && timeDiff < threeDay) {
    return '2天前';
  }
  if (timeDiff >= threeDay && timeDiff < fourDay) {
    return '3天前';
  }
  if (timeDiff >= fourDay && timeDiff < fiveDay) {
    return '4天前';
  }
  if (timeDiff >= fiveDay && timeDiff < sixDay) {
    return '5天前';
  }
  if (timeDiff >= sixDay && timeDiff < sevenDay) {
    return '6天前';
  }
  if (timeDiff >= sevenDay && timeDiff < eightDay) {
    return '7天前';
  }
  if (timeDiff >= eightDay && timeDiff < nineDay) {
    return '8天前';
  }
  if (timeDiff >= nineDay && timeDiff < tenDay) {
    return '9天前';
  }
  if (timeDiff >= tenDay && timeDiff < elevenDay) {
    return '10天前';
  }
  if (timeDiff >= elevenDay && timeDiff < halfMonth) {
    return '半月前';
  }
  if (timeDiff >= halfMonth && timeDiff < oneMonth) {
    return '1月前';
  }
  if (timeDiff >= oneMonth && timeDiff < twoMonth) {
    return '2月前';
  }
  if (timeDiff >= twoMonth && timeDiff < threeMonth) {
    return '3月前';
  }

  if (timeDiff > threeMonth) {
    final year = dateTime.year;
    final month = dateTime.month;
    return "$year-$month-";
  }
  return "";
}
