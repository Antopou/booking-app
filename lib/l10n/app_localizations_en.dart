// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LuxeStay';

  @override
  String get home => 'Home';

  @override
  String get bookings => 'Bookings';

  @override
  String get profile => 'Profile';

  @override
  String get myStays => 'My Stays';

  @override
  String get upcomingBookings => 'Upcoming';

  @override
  String get pastBookings => 'Past';

  @override
  String get cancelledBookings => 'Cancelled';

  @override
  String get luxeStayReservations => 'LuxeStay Reservations';

  @override
  String get luxeStayMember => 'LuxeStay Member';

  @override
  String get manageBooking => 'Manage Booking';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get modifyDates => 'Modify Dates';

  @override
  String get changeCheckInOut => 'Change check-in or check-out dates';

  @override
  String get updateGuests => 'Update Guests';

  @override
  String get changeNumberOfGuests => 'Change number of guests';

  @override
  String get viewConfirmation => 'View Confirmation';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get getHelpWithBooking => 'Get help with your booking';

  @override
  String get cancellation => 'Cancellation';

  @override
  String get selectNewCheckInOut => 'Select new check-in and check-out dates';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get nights => 'night(s)';

  @override
  String get estimated => 'Estimated';

  @override
  String get cancel => 'CANCEL';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String datesUpdatedSuccessfully(String date) {
    return 'Dates updated successfully! New check-in: $date';
  }

  @override
  String failedUpdateDates(String error) {
    return 'Failed to update dates: $error';
  }

  @override
  String get adults => 'Adults';

  @override
  String get ages13OrAbove => 'Ages 13 or above';

  @override
  String get children => 'Children';

  @override
  String get ages0To12 => 'Ages 0-12';

  @override
  String get total => 'Total';

  @override
  String get guests => 'guest(s)';

  @override
  String get adjustNumberOfGuests =>
      'Adjust the number of guests for your stay';

  @override
  String get guestsUpdatedSuccessfully => 'Guests updated successfully!';

  @override
  String failedUpdateGuests(String error) {
    return 'Failed to update: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get saveSettings => 'SAVE SETTINGS';

  @override
  String settingsSaved(String language, String currency) {
    return 'Settings saved! Language: $language, Currency: $currency';
  }

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get rewardsPoints => 'Rewards & Points';

  @override
  String get savedDestinations => 'Saved Destinations';

  @override
  String get notifications => 'Notifications';

  @override
  String get languageCurrency => 'Language & Currency';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get welcome => 'Welcome to LuxeStay';

  @override
  String get signInToAccess =>
      'Sign in to access your account and manage your profile';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get loadingBookings => 'Loading your bookings...';

  @override
  String get usDollar => 'US Dollar';

  @override
  String get japaneseYen => 'Japanese Yen';

  @override
  String get rewardsAndPoints => 'Rewards & Points';

  @override
  String get currentPoints => 'Current Points';

  @override
  String get tierStatus => 'Tier Status';

  @override
  String get standard => 'Standard';

  @override
  String get nextTier => 'Next Tier';

  @override
  String get points => 'points';

  @override
  String progressTo(String tier) {
    return 'Progress to $tier';
  }

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get redeem100Points => 'REDEEM 100 POINTS';

  @override
  String get insufficientPoints => 'Insufficient points to redeem';

  @override
  String get successfullyRedeemed => 'Successfully redeemed 100 points!';

  @override
  String failedRedeem(String error) {
    return 'Failed to redeem: $error';
  }

  @override
  String get errorLoadingRewards => 'Error loading rewards';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get retry => 'RETRY';

  @override
  String get membershipAccount => 'MEMBERSHIP & ACCOUNT';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get signOut => 'SIGN OUT';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get luxeStayMemberTitle => 'LuxeStay Member';

  @override
  String get member => 'Member';

  @override
  String get checkInCheckOut => 'Check-in/out';

  @override
  String get checkInTime => 'Check-in: 3:00 PM • Check-out: 11:00 AM';

  @override
  String get cancellationPolicy =>
      'Free cancellation up to 48 hours before check-in';

  @override
  String get aboutThisRoom => 'About This Room';

  @override
  String get roomAmenities => 'Room Amenities';

  @override
  String get policiesInformation => 'Policies & Information';

  @override
  String get standardAmenities => 'Standard room amenities included';

  @override
  String get freeWiFi => 'Free WiFi';

  @override
  String get smartTV => 'Smart TV';

  @override
  String get airConditioning => 'Air Conditioning';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get parking => 'Parking';

  @override
  String get avgPerNight => 'avg / night';

  @override
  String get reserveNow => 'RESERVE NOW';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String get roomRate => 'Room rate';

  @override
  String get serviceFee => 'Service fee';

  @override
  String get taxes => 'Taxes';

  @override
  String get totalPerNight => 'Total per night';

  @override
  String get priceNote =>
      '* Final price may vary based on length of stay and booking dates';

  @override
  String get close => 'CLOSE';

  @override
  String get selectGuests => 'Select Guests';

  @override
  String get confirmGuests => 'Confirm Guests';

  @override
  String get luxuryAwaitsYou => 'Luxury Awaits You';

  @override
  String get hospitalityDescription =>
      'Experience world-class hospitality in beautifully designed rooms';

  @override
  String get secureBooking => 'Secure Booking';

  @override
  String get bestPrices => 'Best Prices';

  @override
  String get support24 => '24/7 Support';

  @override
  String get premiumQuality => 'Premium Quality';

  @override
  String get featuredAccommodations => 'Featured Accommodations';

  @override
  String get errorLoadingRooms => 'Error loading rooms';

  @override
  String get noRoomsFound => 'No rooms found';

  @override
  String get tryDifferentCategory => 'Try selecting a different category';

  @override
  String get errorLoadingRoom => 'Error loading room';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get searchAvailability => 'Search Availability';

  @override
  String get bookNow => 'Book Now';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String freeCancellationUntil(String date) {
    return 'Free cancellation until $date';
  }

  @override
  String get checkout => 'Checkout';

  @override
  String get guestDetails => 'Guest Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get savedPaymentMethods => 'Saved Payment Methods';

  @override
  String get orAddNewPaymentMethod => 'Or Add New Payment Method';

  @override
  String get cards => 'Cards';

  @override
  String get creditDebitCard => 'Credit / Debit Card';

  @override
  String get digitalWallets => 'Digital Wallets';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get managePaymentMethods => 'MANAGE PAYMENT METHODS';

  @override
  String endsWith(String last4) {
    return 'Ends with $last4';
  }

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get confirmBooking => 'CONFIRM BOOKING';

  @override
  String get bookingConfirmed => 'Booking confirmed successfully!';

  @override
  String failedBooking(String error) {
    return 'Failed to complete booking: $error';
  }

  @override
  String get yourPaymentMethods => 'Your Payment Methods';

  @override
  String get noPaymentMethodsYet =>
      'No payment methods yet. Add one to speed up checkout.';

  @override
  String get addPaymentMethod => 'Add Payment Method';

  @override
  String get methodType => 'Method Type';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expMonth => 'Exp. Month';

  @override
  String get expYear => 'Exp. Year';

  @override
  String get billingName => 'Billing Name';

  @override
  String get brand => 'Brand (e.g., Visa)';

  @override
  String get token => 'Token (if tokenized)';

  @override
  String get setAsDefaultLabel => 'Set as default';

  @override
  String get save => 'Save';

  @override
  String get paymentMethodAdded => 'Payment method added';

  @override
  String get billingNameRequired => 'Billing name is required';

  @override
  String get defaultPaymentUpdated => 'Default payment updated';

  @override
  String get paymentMethodDeleted => 'Payment method deleted';

  @override
  String get setAsDefaultMenu => 'Set as Default';

  @override
  String get delete => 'Delete';

  @override
  String get addPaymentMethodButton => 'ADD PAYMENT METHOD';

  @override
  String get personalInformationTitle => 'Personal Information';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get fillAllRequiredFields => 'Please fill in all required fields';

  @override
  String get personalInfoUpdatedSuccessfully =>
      'Personal information updated successfully';

  @override
  String errorUpdatingProfile(String error) {
    return 'Error updating profile: $error';
  }

  @override
  String get manage => 'MANAGE';

  @override
  String get tokenizedMethod => 'Tokenized method';

  @override
  String expires(String expMonth, String expYear) {
    return 'Expires $expMonth/$expYear';
  }

  @override
  String get active => 'Active';

  @override
  String get defaultLabel => 'Default';

  @override
  String get availableRooms => 'Available Rooms';

  @override
  String get noRoomsAvailable => 'No rooms available.';

  @override
  String nightsLabel(int count) {
    return '$count nights';
  }

  @override
  String adultsChildren(int adults, int children) {
    return '$adults Adults, $children Children';
  }

  @override
  String roomsAvailableCount(int count) {
    return '$count rooms available';
  }

  @override
  String get perNight => '/ night';

  @override
  String get totalPrice => 'total';

  @override
  String get sortBy => 'Sort By';

  @override
  String get recommended => 'Recommended';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get rating => 'Rating';
}
