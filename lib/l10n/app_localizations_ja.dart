// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ラックスステイ';

  @override
  String get home => 'ホーム';

  @override
  String get bookings => '予約';

  @override
  String get profile => 'プロフィール';

  @override
  String get myStays => '私の滞在';

  @override
  String get upcomingBookings => '今後';

  @override
  String get pastBookings => '過去';

  @override
  String get cancelledBookings => 'キャンセル済み';

  @override
  String get luxeStayReservations => 'ラックスステイ予約';

  @override
  String get luxeStayMember => 'ラックスステイメンバー';

  @override
  String get manageBooking => '予約を管理';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get modifyDates => '日付を変更';

  @override
  String get changeCheckInOut => 'チェックイン日またはチェックアウト日を変更';

  @override
  String get updateGuests => 'ゲストを更新';

  @override
  String get changeNumberOfGuests => 'ゲスト数を変更';

  @override
  String get viewConfirmation => '確認を表示';

  @override
  String get bookingId => '予約ID';

  @override
  String get contactSupport => 'サポートに連絡';

  @override
  String get getHelpWithBooking => '予約についてヘルプを取得';

  @override
  String get cancellation => 'キャンセル';

  @override
  String get selectNewCheckInOut => '新しいチェックイン日とチェックアウト日を選択してください';

  @override
  String get checkIn => 'チェックイン';

  @override
  String get checkOut => 'チェックアウト';

  @override
  String get nights => '泊';

  @override
  String get estimated => '推定';

  @override
  String get cancel => 'キャンセル';

  @override
  String get saveChanges => '変更を保存';

  @override
  String datesUpdatedSuccessfully(String date) {
    return '日付が正常に更新されました！新しいチェックイン日：$date';
  }

  @override
  String failedUpdateDates(String error) {
    return '日付の更新に失敗しました：$error';
  }

  @override
  String get adults => '大人';

  @override
  String get ages13OrAbove => '13歳以上';

  @override
  String get children => '子供';

  @override
  String get ages0To12 => '0〜12歳';

  @override
  String get total => '合計';

  @override
  String get guests => 'ゲスト';

  @override
  String get adjustNumberOfGuests => '滞在中のゲスト数を調整してください';

  @override
  String get guestsUpdatedSuccessfully => 'ゲストが正常に更新されました！';

  @override
  String failedUpdateGuests(String error) {
    return '更新に失敗しました：$error';
  }

  @override
  String get language => '言語';

  @override
  String get currency => '通貨';

  @override
  String get saveSettings => '設定を保存';

  @override
  String settingsSaved(String language, String currency) {
    return '設定が保存されました！言語：$language、通貨：$currency';
  }

  @override
  String get personalInformation => '個人情報';

  @override
  String get paymentMethods => '支払い方法';

  @override
  String get rewardsPoints => 'リワード＆ポイント';

  @override
  String get savedDestinations => '保存済みの目的地';

  @override
  String get notifications => '通知';

  @override
  String get languageCurrency => '言語と通貨';

  @override
  String get signIn => 'サインイン';

  @override
  String get welcome => 'ラックスステイへようこそ';

  @override
  String get signInToAccess => 'サインインしてアカウントにアクセスしてプロフィールを管理してください';

  @override
  String get loadingProfile => 'プロフィールを読み込み中...';

  @override
  String get loadingBookings => '予約を読み込み中...';

  @override
  String get usDollar => '米国ドル';

  @override
  String get japaneseYen => '日本円';

  @override
  String get rewardsAndPoints => 'リワード＆ポイント';

  @override
  String get currentPoints => '現在のポイント';

  @override
  String get tierStatus => 'ティアステータス';

  @override
  String get standard => 'スタンダード';

  @override
  String get nextTier => '次のティア';

  @override
  String get points => 'ポイント';

  @override
  String progressTo(String tier) {
    return '$tierへの進行';
  }

  @override
  String get recentActivity => '最近のアクティビティ';

  @override
  String get noRecentActivity => '最近のアクティビティがありません';

  @override
  String get redeem100Points => '100ポイントを使う';

  @override
  String get insufficientPoints => 'ポイントが不足しています';

  @override
  String get successfullyRedeemed => '100ポイントが正常に使用されました！';

  @override
  String failedRedeem(String error) {
    return '使用に失敗しました：$error';
  }

  @override
  String get errorLoadingRewards => 'リワードの読み込みエラー';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get retry => '再試行';

  @override
  String get membershipAccount => 'メンバーシップとアカウント';

  @override
  String get preferences => '設定';

  @override
  String get signOut => 'サインアウト';

  @override
  String get version => 'バージョン 1.0.0';

  @override
  String get luxeStayMemberTitle => 'ラックスステイメンバー';

  @override
  String get member => 'メンバー';

  @override
  String get checkInCheckOut => 'チェックイン/チェックアウト';

  @override
  String get checkInTime => 'チェックイン：午後3時、チェックアウト：午前11時';

  @override
  String get cancellationPolicy => 'チェックイン48時間前までキャンセル無料';

  @override
  String get aboutThisRoom => 'このお部屋について';

  @override
  String get roomAmenities => '客室アメニティ';

  @override
  String get policiesInformation => 'ポリシーと情報';

  @override
  String get standardAmenities => '標準的な客室アメニティが含まれています';

  @override
  String get freeWiFi => '無料WiFi';

  @override
  String get smartTV => 'スマートTV';

  @override
  String get airConditioning => 'エアコン';

  @override
  String get breakfast => '朝食';

  @override
  String get parking => '駐車場';

  @override
  String get avgPerNight => '1泊当たりの平均';

  @override
  String get reserveNow => '今すぐ予約';

  @override
  String get priceBreakdown => '料金内訳';

  @override
  String get roomRate => '客室料金';

  @override
  String get serviceFee => 'サービス料';

  @override
  String get taxes => '税金';

  @override
  String get totalPerNight => '1泊当たりの合計';

  @override
  String get priceNote => '※最終価格は滞在期間と予約日によって異なる場合があります';

  @override
  String get close => '閉じる';

  @override
  String get selectGuests => 'ゲストを選択';

  @override
  String get confirmGuests => 'ゲストを確認';

  @override
  String get luxuryAwaitsYou => '豪華さがあなたを待っています';

  @override
  String get hospitalityDescription => '美しくデザインされたお部屋で\n世界一流のおもてなしをご体験ください';

  @override
  String get secureBooking => '安全な予約';

  @override
  String get bestPrices => '最高の価格';

  @override
  String get support24 => '24時間サポート';

  @override
  String get premiumQuality => 'プレミアムクオリティ';

  @override
  String get featuredAccommodations => '注目の宿泊施設';

  @override
  String get errorLoadingRooms => '客室の読み込みエラー';

  @override
  String get noRoomsFound => '客室が見つかりません';

  @override
  String get tryDifferentCategory => '別のカテゴリーを選択してください';

  @override
  String get errorLoadingRoom => '客室の読み込みエラー';

  @override
  String get roomNotFound => '客室が見つかりません';

  @override
  String get searchAvailability => '空室状況を検索';

  @override
  String get bookNow => '今すぐ予約';

  @override
  String get cancelBooking => '予約をキャンセル';

  @override
  String freeCancellationUntil(String date) {
    return '$dateまでキャンセル無料';
  }

  @override
  String get checkout => 'チェックアウト';

  @override
  String get guestDetails => 'ゲスト詳細情報';

  @override
  String get fullName => 'フルネーム';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get paymentMethod => '支払い方法';

  @override
  String get savedPaymentMethods => '保存された支払い方法';

  @override
  String get orAddNewPaymentMethod => 'または新しい支払い方法を追加';

  @override
  String get cards => 'カード';

  @override
  String get creditDebitCard => 'クレジット/デビットカード';

  @override
  String get digitalWallets => 'デジタルウォレット';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get managePaymentMethods => '支払い方法を管理';

  @override
  String endsWith(String last4) {
    return '$last4で終わる';
  }

  @override
  String get priceSummary => '料金サマリー';

  @override
  String get subTotal => '小計';

  @override
  String get confirmBooking => '予約を確認';

  @override
  String get bookingConfirmed => '予約が正常に確認されました！';

  @override
  String failedBooking(String error) {
    return '予約の完了に失敗しました：$error';
  }

  @override
  String get yourPaymentMethods => 'あなたの支払い方法';

  @override
  String get noPaymentMethodsYet => '支払い方法がまだあります。チェックアウトを高速化するために追加してください。';

  @override
  String get addPaymentMethod => '支払い方法を追加';

  @override
  String get methodType => '方法の種類';

  @override
  String get cardNumber => 'カード番号';

  @override
  String get expMonth => '有効期限 月';

  @override
  String get expYear => '有効期限 年';

  @override
  String get billingName => '請求名';

  @override
  String get brand => 'ブランド（例：Visa）';

  @override
  String get token => 'トークン（トークン化されている場合）';

  @override
  String get setAsDefaultLabel => 'デフォルトとして設定';

  @override
  String get save => '保存';

  @override
  String get paymentMethodAdded => '支払い方法が追加されました';

  @override
  String get billingNameRequired => '請求名は必須です';

  @override
  String get defaultPaymentUpdated => 'デフォルト支払いが更新されました';

  @override
  String get paymentMethodDeleted => '支払い方法が削除されました';

  @override
  String get setAsDefaultMenu => 'デフォルトに設定';

  @override
  String get delete => '削除';

  @override
  String get addPaymentMethodButton => '支払い方法を追加';

  @override
  String get personalInformationTitle => '個人情報';

  @override
  String get edit => '編集';

  @override
  String get done => '完了';

  @override
  String get firstName => '名前';

  @override
  String get lastName => '姓';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get dateOfBirth => '生年月日';

  @override
  String get fillAllRequiredFields => 'すべての必須フィールドに入力してください';

  @override
  String get personalInfoUpdatedSuccessfully => '個人情報が正常に更新されました';

  @override
  String errorUpdatingProfile(String error) {
    return 'プロフィール更新エラー：$error';
  }

  @override
  String get manage => '管理';

  @override
  String get tokenizedMethod => 'トークン化された方法';

  @override
  String expires(String expMonth, String expYear) {
    return '$expMonth/$expYearに期限切れ';
  }

  @override
  String get active => '有効';

  @override
  String get defaultLabel => 'デフォルト';

  @override
  String get availableRooms => '空室情報';

  @override
  String get noRoomsAvailable => '空室がありません。';

  @override
  String nightsLabel(int count) {
    return '$count泊';
  }

  @override
  String adultsChildren(int adults, int children) {
    return '大人$adults名、子供$children名';
  }

  @override
  String roomsAvailableCount(int count) {
    return '$count室空室あり';
  }

  @override
  String get perNight => '/ 泊';

  @override
  String get totalPrice => '合計';

  @override
  String get sortBy => '並べ替え';

  @override
  String get recommended => 'おすすめ順';

  @override
  String get priceLowToHigh => '価格：安い順';

  @override
  String get priceHighToLow => '価格：高い順';

  @override
  String get rating => '評価順';
}
