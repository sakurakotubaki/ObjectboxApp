import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:object_box_app/object_box.dart';
import 'package:object_box_app/objectbox.g.dart';
import 'package:object_box_app/user.dart';

final textProvider = StateProvider.autoDispose((ref) {
  // riverpodで使うには、('')が必要
  return TextEditingController(text: '');
});

/// アプリ全体を通してObjectBox Storeにアクセスできるようにします。
late ObjectBox objectbox;

Future<void> main() async {
  // これは、ObjectBox がデータベースを格納するアプリケーション ディレクトリを取得するために必要です。
  // に格納するためです。
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return const DemoPage();
        },
      ),
    );
  }
}

class DemoPage extends ConsumerWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // objectboxをインスタンス化して、DBにアクセスできるようにする.
    final userBox = objectbox.store.box<User>();
    final controllerProvider = ref.watch(textProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBoxRiverpod2.1.1'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: TextFormField(
              controller: controllerProvider,
              decoration: InputDecoration(hintText: 'ユーザー名'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                // Userクラスのnameプロパティにcontrollerの値を保存する.
                final user = User(name: controllerProvider.text);
                // objectboxにデータを保存する.
                userBox.put(user);
              },
              child: Text('ユーザーを追加する')),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                // Userクラスを削除する.
                userBox.removeAll();
              },
              child: Text('ユーザーを削除する')),
          const SizedBox(height: 16),
          const Text('データ全体'),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // objectboxからデータを取得して、mapメソッドで新しくリストを生成して、
              // 画面に描画する.
              children: userBox
                  .getAll()
                  .map((e) => Text('ID: ${e.id}, name: ${e.name ?? '名無し'}'))
                  .toList()),
        ],
      ),
    );
  }
}
