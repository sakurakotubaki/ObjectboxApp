import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:object_box_app/main.dart';
import 'package:object_box_app/model/user.dart';
import 'package:object_box_app/objectbox.g.dart';

// TextEditingControllerを使うProvider
final textProvider = StateProvider.autoDispose((ref) {
  // riverpodで使うには、('')が必要
  return TextEditingController(text: '');
});
// objectboxをインスタンス化して、DBにアクセスできるようにするProvider.
final objectboxProvider = Provider((ref) => objectbox.store.box<User>());

// StreamでListを使って、Userを型にしてモデルの情報を取得するProvider
final objectStreamProvider = StreamProvider<List<User>>((ref) {
  final builder = ref.watch(objectboxProvider).query()
    ..order(User_.id, flags: Order.descending);
  return builder.watch(triggerImmediately: true).map((query) => query.find());
});
