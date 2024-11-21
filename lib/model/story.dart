import 'package:chat_app/model/contact.dart';
import 'package:chat_app/model/shot.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Story {
  String storyID;
  String email; //sender的邮箱
  String content; //文本内容
  List<String> photoUrlList; //photo的url列表
  String sendTime;
  List<String> likeContactEmailList; //点赞的联系人邮箱列表
  List<String> commentsIDList; //评论ID列表

  Story(
      {required this.storyID,
      required this.email,
      required this.content,
      required this.photoUrlList,
      required this.commentsIDList,
      required this.likeContactEmailList,
      required this.sendTime});
}

//默认空story列表，获取联系人及自己的story
List<Story> storyList = [];

//创建story并上传条目至db
Future<void> createAndSendStoryToDataBase(
    String content, List<XFile> photoList) async {
  final sendTime = dateTimeToIsoString(DateTime.now()); //数据库时间戳
  const uid = Uuid();
  final storyID = uid.v1();
  final supabase = Supabase.instance.client;
  //先上传图片,并获取url列表
  int counter = 0;
  List<String> photoUrlList = [];
  try {
    for (var photo in photoList) {
      counter++;
      final photoName = 'story/$storyID-$counter.jpg';
      final photoBytes = await photo.readAsBytes();
      await supabase.storage
          .from('user_moment')
          .uploadBinary(photoName, photoBytes);
      final photoUrl =
          supabase.storage.from('user_moment').getPublicUrl(photoName);
      photoUrlList.add(photoUrl);
    }
    //上传条目
    await supabase.from('story').insert({
      'story_id': storyID,
      'email': currentUser.email,
      'content': content,
      'photo_url': photoUrlList,
      'send_time': sendTime,
      'like_contact_emails': [],
      'comment_id_array': [],
    });
  } catch (e) {
    print("createAndSendStoryToDataBase问题:$e");
  }
}

//对story进行点赞，并且将数据同步至db
Future<void> likeStoryToDataBase(Story story) async {
  final supabase = Supabase.instance.client;
  try {
    final dbResponse = await supabase
        .from('story')
        .select('like_contact_emails')
        .eq('story_id', story.storyID)
        .single();
    List<String> likeList =
        List<String>.from(dbResponse['like_contact_emails']);
    //不允许重复点赞
    if (!likeList.contains(currentUser.email)) {
      likeList.add(currentUser.email);
      story.likeContactEmailList = likeList;
      //上传数据
      await supabase.from('story').upsert({
        'story_id': story.storyID,
        'email': story.email,
        'content': story.content,
        'photo_url': story.photoUrlList,
        'send_time': story.sendTime,
        'like_contact_emails': story.likeContactEmailList,
        'comment_id_array': story.commentsIDList,
      });
    }
  } on Exception catch (e) {
    print("likeStoryToDataBase问题:$e");
  }
}
