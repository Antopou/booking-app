import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

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
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LuxeStay'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myStays.
  ///
  /// In en, this message translates to:
  /// **'My Stays'**
  String get myStays;

  /// No description provided for @upcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingBookings;

  /// No description provided for @pastBookings.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get pastBookings;

  /// No description provided for @cancelledBookings.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledBookings;

  /// No description provided for @luxeStayReservations.
  ///
  /// In en, this message translates to:
  /// **'LuxeStay Reservations'**
  String get luxeStayReservations;

  /// No description provided for @luxeStayMember.
  ///
  /// In en, this message translates to:
  /// **'LuxeStay Member'**
  String get luxeStayMember;

  /// No description provided for @manageBooking.
  ///
  /// In en, this message translates to:
  /// **'Manage Booking'**
  String get manageBooking;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @modifyDates.
  ///
  /// In en, this message translates to:
  /// **'Modify Dates'**
  String get modifyDates;

  /// No description provided for @changeCheckInOut.
  ///
  /// In en, this message translates to:
  /// **'Change check-in or check-out dates'**
  String get changeCheckInOut;

  /// No description provided for @updateGuests.
  ///
  /// In en, this message translates to:
  /// **'Update Guests'**
  String get updateGuests;

  /// No description provided for @changeNumberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Change number of guests'**
  String get changeNumberOfGuests;

  /// No description provided for @viewConfirmation.
  ///
  /// In en, this message translates to:
  /// **'View Confirmation'**
  String get viewConfirmation;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @getHelpWithBooking.
  ///
  /// In en, this message translates to:
  /// **'Get help with your booking'**
  String get getHelpWithBooking;

  /// No description provided for @cancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get cancellation;

  /// No description provided for @selectNewCheckInOut.
  ///
  /// In en, this message translates to:
  /// **'Select new check-in and check-out dates'**
  String get selectNewCheckInOut;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'night(s)'**
  String get nights;

  /// No description provided for @estimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get estimated;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @datesUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Dates updated successfully! New check-in: {date}'**
  String datesUpdatedSuccessfully(String date);

  /// No description provided for @failedUpdateDates.
  ///
  /// In en, this message translates to:
  /// **'Failed to update dates: {error}'**
  String failedUpdateDates(String error);

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @ages13OrAbove.
  ///
  /// In en, this message translates to:
  /// **'Ages 13 or above'**
  String get ages13OrAbove;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @ages0To12.
  ///
  /// In en, this message translates to:
  /// **'Ages 0-12'**
  String get ages0To12;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'guest(s)'**
  String get guests;

  /// No description provided for @adjustNumberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Adjust the number of guests for your stay'**
  String get adjustNumberOfGuests;

  /// No description provided for @guestsUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guests updated successfully!'**
  String get guestsUpdatedSuccessfully;

  /// No description provided for @failedUpdateGuests.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String failedUpdateGuests(String error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'SAVE SETTINGS'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved! Language: {language}, Currency: {currency}'**
  String settingsSaved(String language, String currency);

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @rewardsPoints.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Points'**
  String get rewardsPoints;

  /// No description provided for @savedDestinations.
  ///
  /// In en, this message translates to:
  /// **'Saved Destinations'**
  String get savedDestinations;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @languageCurrency.
  ///
  /// In en, this message translates to:
  /// **'Language & Currency'**
  String get languageCurrency;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to LuxeStay'**
  String get welcome;

  /// No description provided for @signInToAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account and manage your profile'**
  String get signInToAccess;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @loadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Loading your bookings...'**
  String get loadingBookings;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usDollar;

  /// No description provided for @japaneseYen.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get japaneseYen;

  /// No description provided for @rewardsAndPoints.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Points'**
  String get rewardsAndPoints;

  /// No description provided for @currentPoints.
  ///
  /// In en, this message translates to:
  /// **'Current Points'**
  String get currentPoints;

  /// No description provided for @tierStatus.
  ///
  /// In en, this message translates to:
  /// **'Tier Status'**
  String get tierStatus;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @nextTier.
  ///
  /// In en, this message translates to:
  /// **'Next Tier'**
  String get nextTier;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @progressTo.
  ///
  /// In en, this message translates to:
  /// **'Progress to {tier}'**
  String progressTo(String tier);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @redeem100Points.
  ///
  /// In en, this message translates to:
  /// **'REDEEM 100 POINTS'**
  String get redeem100Points;

  /// No description provided for @insufficientPoints.
  ///
  /// In en, this message translates to:
  /// **'Insufficient points to redeem'**
  String get insufficientPoints;

  /// No description provided for @successfullyRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Successfully redeemed 100 points!'**
  String get successfullyRedeemed;

  /// No description provided for @failedRedeem.
  ///
  /// In en, this message translates to:
  /// **'Failed to redeem: {error}'**
  String failedRedeem(String error);

  /// No description provided for @errorLoadingRewards.
  ///
  /// In en, this message translates to:
  /// **'Error loading rewards'**
  String get errorLoadingRewards;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retry;

  /// No description provided for @membershipAccount.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP & ACCOUNT'**
  String get membershipAccount;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'SIGN OUT'**
  String get signOut;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @luxeStayMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'LuxeStay Member'**
  String get luxeStayMemberTitle;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @checkInCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-in/out'**
  String get checkInCheckOut;

  /// No description provided for @checkInTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in: 3:00 PM • Check-out: 11:00 AM'**
  String get checkInTime;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation up to 48 hours before check-in'**
  String get cancellationPolicy;

  /// No description provided for @aboutThisRoom.
  ///
  /// In en, this message translates to:
  /// **'About This Room'**
  String get aboutThisRoom;

  /// No description provided for @roomAmenities.
  ///
  /// In en, this message translates to:
  /// **'Room Amenities'**
  String get roomAmenities;

  /// No description provided for @policiesInformation.
  ///
  /// In en, this message translates to:
  /// **'Policies & Information'**
  String get policiesInformation;

  /// No description provided for @standardAmenities.
  ///
  /// In en, this message translates to:
  /// **'Standard room amenities included'**
  String get standardAmenities;

  /// No description provided for @freeWiFi.
  ///
  /// In en, this message translates to:
  /// **'Free WiFi'**
  String get freeWiFi;

  /// No description provided for @smartTV.
  ///
  /// In en, this message translates to:
  /// **'Smart TV'**
  String get smartTV;

  /// No description provided for @airConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning'**
  String get airConditioning;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @avgPerNight.
  ///
  /// In en, this message translates to:
  /// **'avg / night'**
  String get avgPerNight;

  /// No description provided for @reserveNow.
  ///
  /// In en, this message translates to:
  /// **'RESERVE NOW'**
  String get reserveNow;

  /// No description provided for @priceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdown;

  /// No description provided for @roomRate.
  ///
  /// In en, this message translates to:
  /// **'Room rate'**
  String get roomRate;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get serviceFee;

  /// No description provided for @taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// No description provided for @totalPerNight.
  ///
  /// In en, this message translates to:
  /// **'Total per night'**
  String get totalPerNight;

  /// No description provided for @priceNote.
  ///
  /// In en, this message translates to:
  /// **'* Final price may vary based on length of stay and booking dates'**
  String get priceNote;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @selectGuests.
  ///
  /// In en, this message translates to:
  /// **'Select Guests'**
  String get selectGuests;

  /// No description provided for @confirmGuests.
  ///
  /// In en, this message translates to:
  /// **'Confirm Guests'**
  String get confirmGuests;

  /// No description provided for @luxuryAwaitsYou.
  ///
  /// In en, this message translates to:
  /// **'Luxury Awaits You'**
  String get luxuryAwaitsYou;

  /// No description provided for @hospitalityDescription.
  ///
  /// In en, this message translates to:
  /// **'Experience world-class hospitality in beautifully designed rooms'**
  String get hospitalityDescription;

  /// No description provided for @secureBooking.
  ///
  /// In en, this message translates to:
  /// **'Secure Booking'**
  String get secureBooking;

  /// No description provided for @bestPrices.
  ///
  /// In en, this message translates to:
  /// **'Best Prices'**
  String get bestPrices;

  /// No description provided for @support24.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get support24;

  /// No description provided for @premiumQuality.
  ///
  /// In en, this message translates to:
  /// **'Premium Quality'**
  String get premiumQuality;

  /// No description provided for @featuredAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Featured Accommodations'**
  String get featuredAccommodations;

  /// No description provided for @errorLoadingRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms'**
  String get errorLoadingRooms;

  /// No description provided for @noRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No rooms found'**
  String get noRoomsFound;

  /// No description provided for @tryDifferentCategory.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different category'**
  String get tryDifferentCategory;

  /// No description provided for @errorLoadingRoom.
  ///
  /// In en, this message translates to:
  /// **'Error loading room'**
  String get errorLoadingRoom;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @searchAvailability.
  ///
  /// In en, this message translates to:
  /// **'Search Availability'**
  String get searchAvailability;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @freeCancellationUntil.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation until {date}'**
  String freeCancellationUntil(String date);

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @guestDetails.
  ///
  /// In en, this message translates to:
  /// **'Guest Details'**
  String get guestDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @savedPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Saved Payment Methods'**
  String get savedPaymentMethods;

  /// No description provided for @orAddNewPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Or Add New Payment Method'**
  String get orAddNewPaymentMethod;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditDebitCard;

  /// No description provided for @digitalWallets.
  ///
  /// In en, this message translates to:
  /// **'Digital Wallets'**
  String get digitalWallets;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @googlePay.
  ///
  /// In en, this message translates to:
  /// **'Google Pay'**
  String get googlePay;

  /// No description provided for @managePaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'MANAGE PAYMENT METHODS'**
  String get managePaymentMethods;

  /// No description provided for @endsWith.
  ///
  /// In en, this message translates to:
  /// **'Ends with {last4}'**
  String endsWith(String last4);

  /// No description provided for @priceSummary.
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subTotal;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM BOOKING'**
  String get confirmBooking;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed successfully!'**
  String get bookingConfirmed;

  /// No description provided for @failedBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete booking: {error}'**
  String failedBooking(String error);

  /// No description provided for @yourPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Your Payment Methods'**
  String get yourPaymentMethods;

  /// No description provided for @noPaymentMethodsYet.
  ///
  /// In en, this message translates to:
  /// **'No payment methods yet. Add one to speed up checkout.'**
  String get noPaymentMethodsYet;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @methodType.
  ///
  /// In en, this message translates to:
  /// **'Method Type'**
  String get methodType;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expMonth.
  ///
  /// In en, this message translates to:
  /// **'Exp. Month'**
  String get expMonth;

  /// No description provided for @expYear.
  ///
  /// In en, this message translates to:
  /// **'Exp. Year'**
  String get expYear;

  /// No description provided for @billingName.
  ///
  /// In en, this message translates to:
  /// **'Billing Name'**
  String get billingName;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand (e.g., Visa)'**
  String get brand;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token (if tokenized)'**
  String get token;

  /// No description provided for @setAsDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get setAsDefaultLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @paymentMethodAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment method added'**
  String get paymentMethodAdded;

  /// No description provided for @billingNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Billing name is required'**
  String get billingNameRequired;

  /// No description provided for @defaultPaymentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Default payment updated'**
  String get defaultPaymentUpdated;

  /// No description provided for @paymentMethodDeleted.
  ///
  /// In en, this message translates to:
  /// **'Payment method deleted'**
  String get paymentMethodDeleted;

  /// No description provided for @setAsDefaultMenu.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefaultMenu;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @addPaymentMethodButton.
  ///
  /// In en, this message translates to:
  /// **'ADD PAYMENT METHOD'**
  String get addPaymentMethodButton;

  /// No description provided for @personalInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformationTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllRequiredFields;

  /// No description provided for @personalInfoUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Personal information updated successfully'**
  String get personalInfoUpdatedSuccessfully;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: {error}'**
  String errorUpdatingProfile(String error);

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'MANAGE'**
  String get manage;

  /// No description provided for @tokenizedMethod.
  ///
  /// In en, this message translates to:
  /// **'Tokenized method'**
  String get tokenizedMethod;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires {expMonth}/{expYear}'**
  String expires(String expMonth, String expYear);

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @availableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available Rooms'**
  String get availableRooms;

  /// No description provided for @noRoomsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rooms available.'**
  String get noRoomsAvailable;

  /// No description provided for @nightsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} nights'**
  String nightsLabel(int count);

  /// No description provided for @adultsChildren.
  ///
  /// In en, this message translates to:
  /// **'{adults} Adults, {children} Children'**
  String adultsChildren(int adults, int children);

  /// No description provided for @roomsAvailableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms available'**
  String roomsAvailableCount(int count);

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'/ night'**
  String get perNight;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get totalPrice;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;
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
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
