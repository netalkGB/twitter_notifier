# twitter_notifier
フォローとリムーブとブロックの通知

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