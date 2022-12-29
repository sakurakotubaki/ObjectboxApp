# Objectboxアプリの学習
## 概要
### 公式によると
ObjectBox は、オブジェクトを保持する超高速のモバイル データベースです。
多くの反復的なタスクを回避し、データへのシンプルなインターフェイスを提供します。

[objectboxのチュートリアル](https://docs.objectbox.io/getting-started)<br>
[ビルドランナーのドキュメント](https://pub.dev/packages/build_runner)<br>
[objectbox](https://pub.dev/packages/objectbox)<br>
[objectbox_flutter_libs](https://pub.dev/packages/objectbox_flutter_libs)<br>
[objectbox_generator](https://pub.dev/packages/objectbox_generator)<br>
[参考にした公式のサンプル](https://github.com/objectbox/objectbox-dart/tree/main/objectbox/example/flutter/event_management_tutorial/event_manager)<br>

ビルドランナーでファイルを生成するコマンド.
もし、modelのファイルを移動したら、関係したファイルのimportしている場所が変化して、
赤いエラーの原因になるので、もう一度コマンドを実行して、ファイルを自動生成する。
```
flutter pub run build_runner build
```

## 今回実装した機能
1. 追加.
2. idを指定して削除.
3. 全てのデータを削除.

## 今回使用した技術
objectboxに関係したpackageはversionを合わせる.

| 使用する技術 |  Version |
|--------------|----------|
|Flutter       |3.3.1     |
|Dart          |2.18.0    |
|objectbox          |^1.7.0    |
|objectbox_flutter_libs |^1.7.0    |
|build_runner          |^2.3.3    |
|objectbox_generator |^1.7.0     |
|flutter_riverpod |^2.1.1     |

-----

## アプリを作ることにした背景
LocalDBをあまり使ったことがなく、objectboxが人気があり使いやすいことから、
チュートリアルをやって勉強してみた。

作成したアプリのversion3.0.0では、Riverpodへのリファクタリングを行いました。
GitのTagで、version1、version2を作成して、どんなソースコードで作成していた
かversionごとに記録を残しました。

--------
## 感想
Flutter大学の動画で、公式ドキュメントを見ながらデータを保存するアプリを作るのを
体験して過去に使ったことがあるsqflite、Hiveよりは個人的に使いやすいなと思いました。
動作も速いみたいです。
