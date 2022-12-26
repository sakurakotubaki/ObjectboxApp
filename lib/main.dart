import 'package:flutter/material.dart';
import 'package:object_box_app/object_box.dart';
import 'package:object_box_app/objectbox.g.dart';
import 'package:object_box_app/user.dart';

/// アプリ全体を通してObjectBox Storeにアクセスできるようにします。
late ObjectBox objectbox;

Future<void> main() async {
  // これは、ObjectBox がデータベースを格納するアプリケーション ディレクトリを取得するために必要です。
  // に格納するためです。
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(MyApp());
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

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  // objectboxをインスタンス化して、DBにアクセスできるようにする.
  final userBox = objectbox.store.box<User>();

  final controller = TextEditingController();
  // DBからtomという名前の人物を検索して表示する.
  List<User> query() {
    late final query =
        (userBox.query(User_.name.equals('tom'))..order(User_.name)).build();
    final results = query.find();
    query.close();
    return results;
  }

  // 状態を破棄する.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBox'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(hintText: 'ユーザー名'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                // Userクラスのnameプロパティにcontrollerの値を保存する.
                final user = User(name: controller.text);
                // objectboxにデータを保存する.
                userBox.put(user);
                // 状態の変更を伝えるのに、setStateを書く.
                setState(() {});
              },
              child: Text('ユーザーを追加する')),
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
          const SizedBox(height: 16),
          const Text('検索'),
          Column(
              // nameがtomだけ画面に描画する.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: query()
                  .map((e) => Text('ID: ${e.id}, name: ${e.name ?? '名無し'}'))
                  .toList()),
        ],
      ),
    );
  }
}
