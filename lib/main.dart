import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:object_box_app/object_box.dart';
import 'package:object_box_app/objectbox.g.dart';
import 'package:object_box_app/model/user.dart';

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

/// アプリ全体を通してObjectBox Storeにアクセスできるようにします。
late ObjectBox objectbox;

Future<void> main() async {
  // これは、ObjectBox がデータベースを格納するアプリケーション ディレクトリを取得するために必要です。
  // に格納するためです。
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(
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
    final boxProvider = ref.watch(objectboxProvider);
    final controllerProvider = ref.watch(textProvider);
    final stream = ref.watch(objectStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('ObjectBox'),
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
                boxProvider.put(user);
              },
              child: Text('ユーザーを追加する')),
          const SizedBox(height: 16),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Userクラスを全て削除する.
                boxProvider.removeAll();
              },
              child: Text('ユーザーを全て削除する')),
          const SizedBox(height: 16),
          Expanded(
              child: stream.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (users) {
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      child: ListTile(
                        title: Text(user.name!),
                        trailing: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            boxProvider.remove(user.id);
                          },
                        ),
                      ),
                    );
                  });
            },
          ))
        ],
      ),
    );
  }
}
