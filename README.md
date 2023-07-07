# growth_buddy
成長記録育成ゲーム

## アプリ(flutter)の起動
```
cd growth_buddy_front
flutter run
```

## flutterアプリの実機検証(本当に簡単な説明)
iphoneで検証するためにはxcodeが必要です。AppStoreからxcodeをインストールしてください。

あとはxcodeでアカウントを登録したり、使用するiphoneでデベロッパーモードをオンにしたりする必要があります。

vscodeで```flutter devices```を実行して、実機が認識されていることを確認し、そのあと、```flutter run -d [デバイスID]```をすれば実機にインストールされて起動します。

参考
- https://next-k.site/blog/archives/2022/03/22/757
- https://qiita.com/nonkapibara/items/d14c796ca69c8a4e58d2



## API サーバの起動

### 必要なライブラリのインストール

```bash
pip install -r requirements.txt
```

### サーバの起動
```bash
cd backend
python manage.py runserver
```

