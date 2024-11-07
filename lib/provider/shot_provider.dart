import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:chat_app/model/shot_model.dart';

class ShotProvider extends ChangeNotifier {
  List<ShotModel> _shots = [];

  List<ShotModel> get shots => _shots;

  ShotProvider() {
    loadShots(); // 在构造函数中加载数据
  }

  Future<void> loadShots() async {
    try {
      final box = Hive.box<ShotModel>('shots');
      // print('Number of shots: ${box.length}');
      _shots = box.values.toList();
      _shots.sort((a, b) =>
          box.keyAt(box.length - 1).compareTo(box.keyAt(0))); // 根据添加顺序排序
      notifyListeners(); // 通知监听者更新
    } catch (e) {
      print('Error loading shots: $e');
    }
  }

  Future<void> addShot(ShotModel shot) async {
    final box = Hive.box<ShotModel>('shots');
    await box.add(shot);
    await loadShots(); // 重新加载并更新列表
  }
}
