import 'package:chat_app/model/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Shot {
  String photoUrl; //shot的url地址
  String email; //发送者邮箱，以String形式存储，自己/联系人
  String sendTime; //shot发布时间
  String shotID; //shot的uuid

  Shot(
      {required this.photoUrl,
      required this.email,
      required this.sendTime,
      required this.shotID});
}

//可见(联系人及自己)的shot列表
List<Shot> shotList = [];

//Shot的时间转换
String dateTimeToIsoString(DateTime dt) {
  //从DateTime格式转换成数据库格式的string记录时间戳
  return dt.toIso8601String();
}

String dataBaseTimeParseToString(String iso) {
  //从数据库中的时间戳格式字符串转换成屏幕显示的时间字符串
  return DateTime.parse(iso).toString().substring(0, 19);
}

//shot的数据库管理模块
Future<void> createAndSendShotToDataBase(XFile photo) async {
  //创建并上传shot方法
  final sendTime = dateTimeToIsoString(DateTime.now()); //数据库时间戳
  const uid = Uuid();
  final shotID = uid.v1();
  final supabase = Supabase.instance.client;
  //先上传图片
  final photoName = 'shot/$shotID.jpg';
  final photoBytes = await photo.readAsBytes();
  try {
    await supabase.storage
        .from('user_moment')
        .uploadBinary(photoName, photoBytes);
    //获取照片的url地址
    final photoUrl =
        supabase.storage.from('user_moment').getPublicUrl(photoName);
    //上传shot条目
    await supabase.from('shot').insert({
      'shot_id': shotID,
      'email': currentUser.email,
      'shot_url': photoUrl,
      'send_time': sendTime,
    });
  } catch (e) {
    print("createAndSendShotToDataBase()问题:$e");
  }
}

Future<void> loadShotListFromDataBase() async {
  //从数据库获取shotList条目
  final supabase = Supabase.instance.client;
  List<Shot> returnList = [];
  List tempList;
  List searchList = contactEmailList;
  searchList.add(currentUser.email); //包括自己的记录一并搜索
  //开始搜索符合的记录,并且按照发送时间排序
  try {
    tempList = await supabase
        .from('shot')
        .select()
        .inFilter('email', searchList)
        .order('send_time');
    //按序对tempList进行转换
    for (var s in tempList) {
      returnList.add(Shot(
          photoUrl: s['shot_url'],
          email: s['email'],
          sendTime: s['send_time'],
          shotID: s['shot_id']));
    }
  } on Exception catch (e) {
    print("loadShotListFromDataBase()问题:$e");
  }
  shotList = returnList;
  print(shotList);
}

Future deleteUserShotFromDataBase(Shot shot) async {
  if (shot.email != currentUser.email) {
    return -1; //删除非本人的shot,属于非法操作
  }

  try {
    //删除对应的shot数据
    //先删shot条目
    final supabase = Supabase.instance.client;
    await supabase.from('shot').delete().eq('shot_id', shot.shotID);
    //再删对应storage的图片
    await supabase.storage
        .from('user_moment')
        .remove(['shot/${shot.shotID}.jpg']);
  } catch (e) {
    print("deleteUserShotFromDataBase()问题:$e");
  }
}
