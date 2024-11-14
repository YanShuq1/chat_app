import 'dart:io';

import 'package:chat_app/model/contact.dart';
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

extension ShotSendTimeFormat on Shot {
  //Shot的时间转换
  String DateTimeToIsoString(DateTime dt) {
    //从DateTime格式转换成数据库格式的string记录时间戳
    return dt.toIso8601String();
  }

  String DBTimeParseToString(String iso) {
    //从数据库中的时间戳格式字符串转换成屏幕显示的时间字符串
    return DateTime.parse(iso).toString().substring(0, 19);
  }
}

extension ShotDataBase on Shot {
  //shot的数据库管理模块
  Future<void> createAndSendShotToDataBase(File photo) async {
    //创建并上传shot方法
    final sendTime = DateTime.now().toIso8601String(); //数据库时间戳
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
    } catch (e) {
      print("上传照片问题:$e");
    }
    //上传shot条目
    try {
      await supabase.from('shot').insert({
        'shot_id': shotID,
        'email': currentUser.email,
        'shot_url': photoUrl,
        'send_time': sendTime,
      });
    } catch (e) {
      print("上传shot条目问题:$e");
    }
  }

  Future<List<Shot>> loadShotListFromDataBase() async {
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
      print("获取shotList问题:$e");
    }
    return returnList;
  }
}
