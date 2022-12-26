# Objectboxアプリの学習
## 概要
### 公式によると
ObjectBox は、オブジェクトを保持する超高速のモバイル データベースです。
多くの反復的なタスクを回避し、データへのシンプルなインターフェイスを提供します。

[objectboxのチュートリアル](https://docs.objectbox.io/getting-started)
[ビルドランナーのドキュメント](https://pub.dev/packages/build_runner)
[objectbox](https://pub.dev/packages/objectbox)
[objectbox_flutter_libs](https://pub.dev/packages/objectbox_flutter_libs)
[objectbox_generator](https://pub.dev/packages/objectbox_generator)

ビルドランナーでファイルを生成するコマンド.
```
flutter pub run build_runner build
```

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

-----

## アプリを作ることにした背景
LocalDBをあまり使ったことがなく、objectboxが人気があり使いやすいことから、
チュートリアルをやって勉強してみた。

--------
## 感想
Flutter大学の動画で、公式ドキュメントを見ながらデータを保存するアプリを作るのを
体験して過去に使ったことがあるsqflite、Hiveよりは個人的に使いやすいなと思いました。
動作も速いみたいです。