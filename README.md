# twitter_notifier
フォローとリムーブとブロックの通知  
ブロックは相互フォローだったが、お互いにフォローが外れたときのみに検出する
通知は設定したGmailのアカウントを使用してメールで自分に送信する（他の方法を検討している）
## 設定
settings.rbにTwitterのコンシューマーキーとコンシューマーシークレットと
GmailのID(@gmail.comを含めた)、パスワードを書く
### gemのインストール(bundlerが必要)
```
bundle install --path vendor/bundle
```
### 起動
```
ruby twitter_notifier.rb
```
あとはcronで定期的に実行する