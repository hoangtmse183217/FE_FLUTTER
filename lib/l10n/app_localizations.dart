import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @myProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ của tôi'**
  String get myProfile;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @displayName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get displayName;

  /// No description provided for @phoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get address;

  /// No description provided for @gender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get gender;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @notUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cập nhật'**
  String get notUpdated;

  /// No description provided for @noEmail.
  ///
  /// In vi, this message translates to:
  /// **'Không có email'**
  String get noEmail;

  /// No description provided for @unknownState.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái không xác định'**
  String get unknownState;

  /// No description provided for @saveSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu hồ sơ thành công!'**
  String get saveSuccess;

  /// No description provided for @selectTheme.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giao diện'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @light.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get dark;

  /// No description provided for @warm.
  ///
  /// In vi, this message translates to:
  /// **'Ấm'**
  String get warm;

  /// No description provided for @ocean.
  ///
  /// In vi, this message translates to:
  /// **'Biển'**
  String get ocean;

  /// No description provided for @forest.
  ///
  /// In vi, this message translates to:
  /// **'Rừng'**
  String get forest;

  /// No description provided for @aurora.
  ///
  /// In vi, this message translates to:
  /// **'Cực quang'**
  String get aurora;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In vi, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get thisWeek;

  /// No description provided for @discover.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get discover;

  /// No description provided for @whatsYourMood.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trạng của bạn là...'**
  String get whatsYourMood;

  /// No description provided for @noRestaurantsFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy nhà hàng nào phù hợp.'**
  String get noRestaurantsFound;

  /// No description provided for @diverseCuisine.
  ///
  /// In vi, this message translates to:
  /// **'Ẩm thực đa dạng'**
  String get diverseCuisine;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In vi, this message translates to:
  /// **'Yêu thích'**
  String get favorites;

  /// No description provided for @favoriteRestaurants.
  ///
  /// In vi, this message translates to:
  /// **'Nhà hàng yêu thích'**
  String get favoriteRestaurants;

  /// No description provided for @errorOccurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra: '**
  String get errorOccurred;

  /// No description provided for @selectYourLocation.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vị trí của bạn'**
  String get selectYourLocation;

  /// No description provided for @locationServicesOff.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật dịch vụ định vị.'**
  String get locationServicesOff;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập vị trí đã bị từ chối.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần cấp quyền vị trí trong cài đặt.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @cannotGetLocation.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy được vị trí.'**
  String get cannotGetLocation;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get user;

  /// No description provided for @helloUser.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào, {userName}!'**
  String helloUser(String userName);

  /// No description provided for @howAreYouFeelingToday.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cảm thấy thế nào hôm nay?'**
  String get howAreYouFeelingToday;

  /// No description provided for @featuredSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý nổi bật'**
  String get featuredSuggestions;

  /// No description provided for @vietnameseCuisine.
  ///
  /// In vi, this message translates to:
  /// **'Món Việt'**
  String get vietnameseCuisine;

  /// No description provided for @pizzaAndPasta.
  ///
  /// In vi, this message translates to:
  /// **'Pizza & Mì Ý'**
  String get pizzaAndPasta;

  /// No description provided for @family.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình'**
  String get family;

  /// No description provided for @relaxing.
  ///
  /// In vi, this message translates to:
  /// **'Thư giãn'**
  String get relaxing;

  /// No description provided for @romantic.
  ///
  /// In vi, this message translates to:
  /// **'Lãng mạn'**
  String get romantic;

  /// No description provided for @filters.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get filters;

  /// No description provided for @priceLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức giá'**
  String get priceLevel;

  /// No description provided for @ratingFrom.
  ///
  /// In vi, this message translates to:
  /// **'Rating từ'**
  String get ratingFrom;

  /// No description provided for @apply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply;

  /// No description provided for @price100k.
  ///
  /// In vi, this message translates to:
  /// **'100.000₫'**
  String get price100k;

  /// No description provided for @price500k.
  ///
  /// In vi, this message translates to:
  /// **'500.000₫'**
  String get price500k;

  /// No description provided for @price1m.
  ///
  /// In vi, this message translates to:
  /// **'1.000.000₫'**
  String get price1m;

  /// No description provided for @searchRestaurantsCuisine.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nhà hàng, ẩm thực...'**
  String get searchRestaurantsCuisine;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách trống'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hãy khám phá và nhấn vào biểu tượng trái tim để lưu lại những nhà hàng bạn yêu thích nhé!'**
  String get emptyFavoritesSubtitle;

  /// No description provided for @yourCurrentLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí hiện tại của bạn'**
  String get yourCurrentLocation;

  /// No description provided for @updating.
  ///
  /// In vi, this message translates to:
  /// **'Đang cập nhật...'**
  String get updating;

  /// No description provided for @refreshLocation.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lại vị trí'**
  String get refreshLocation;

  /// No description provided for @lively.
  ///
  /// In vi, this message translates to:
  /// **'Sôi động'**
  String get lively;

  /// No description provided for @luxurious.
  ///
  /// In vi, this message translates to:
  /// **'Sang trọng'**
  String get luxurious;

  /// No description provided for @quick.
  ///
  /// In vi, this message translates to:
  /// **'Nhanh gọn'**
  String get quick;

  /// No description provided for @friends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get friends;

  /// No description provided for @seeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get seeAll;

  /// No description provided for @changeAddress.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi địa chỉ'**
  String get changeAddress;

  /// No description provided for @enterYourNewAddress.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ mới của bạn'**
  String get enterYourNewAddress;

  /// No description provided for @addressCannotBeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ không được để trống'**
  String get addressCannotBeEmpty;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @changeDisplayName.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi tên hiển thị'**
  String get changeDisplayName;

  /// No description provided for @enterYourNewName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên mới của bạn'**
  String get enterYourNewName;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Tên không được để trống'**
  String get nameCannotBeEmpty;

  /// No description provided for @changePhoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi số điện thoại'**
  String get changePhoneNumber;

  /// No description provided for @enterYourNewPhoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại mới'**
  String get enterYourNewPhoneNumber;

  /// No description provided for @phoneNumberCannotBeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không được để trống'**
  String get phoneNumberCannotBeEmpty;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ'**
  String get invalidPhoneNumber;

  /// No description provided for @selectGender.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giới tính'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get male;

  /// No description provided for @female.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get female;

  /// No description provided for @other.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get other;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
