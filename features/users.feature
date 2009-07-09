フィーチャー: ユーザ管理
  ユーザの追加、削除などを行う
  ユーザを追加したり削除したりする
  
#   シナリオテンプレート: 新規ユーザ登録
#     前提 言語は "ja"
#     かつ "ユーザ登録" にアクセスしている
#     もし "ログイン名" に "<login>" と入力する
#     かつ "パスワード" に "<password>" と入力する
#     かつ "作成" ボタンをクリックする
#     かつ "ユーザ登録確認" へ移動する
#     かつ "確認" ボタンをクリックする
#     ならば "ユーザ登録完了" というページが表示されていること
# 
#   例:
#     | user    | password |
#     | yu-yan  | test     |
#     | quentin | test     |
#     | aaron   | test     |


  シナリオ: 新規ユーザ登録 email
    前提 言語は "ja"
    かつ "メールアドレスによるサインアップ" にアクセスしている
    もし "Email" に "quentin@example.com" と入力する
    かつ "Password" に "monkey" と入力する
    かつ "Password confirmation" に "monkey" と入力する
    かつ "確認画面へ" ボタンをクリックする
    ならば "登録確認" と表示されていること
    かつ "quentin@example.com" と表示されていること
    もし "登録" ボタンをクリックする
    ならば "仮登録完了" と表示されていること
    もし "quentin@example.com" はアクティベーションを実行する
    ならば "本登録確認" と表示されていること
    もし "本登録" ボタンをクリックする
    ならば "本登録完了" と表示されていること
    もし "ログインする" リンクをクリックする
    ならば "メールアドレスによるログイン" と表示されていること
    もし "Email" に "quentin@example.com" と入力する
    かつ "Password" に "monkey" と入力する
    かつ "ログイン" ボタンをクリックする
    # ならば


  シナリオ: 新規ユーザ登録 OpenID
    前提 言語は "ja"
    かつ "OpenID によるサインアップ" にアクセスしている
    もし "OpenID URL" に "livedoor.com" と入力する
    かつ "次へ" ボタンをクリックする
    ならば OpenID 認証に成功すること
    かつ "認証完了" と表示されていること
    もし "登録" ボタンをクリックする
    ならば "登録完了" と表示されていること