import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ko.dart';

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
    Locale('fr'),
    Locale('ko'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SafarNama'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSection;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @onboard1TitlePart1.
  ///
  /// In en, this message translates to:
  /// **'Life is short and the world is '**
  String get onboard1TitlePart1;

  /// No description provided for @onboard1TitlePart2.
  ///
  /// In en, this message translates to:
  /// **'wide'**
  String get onboard1TitlePart2;

  /// No description provided for @onboard1Description.
  ///
  /// In en, this message translates to:
  /// **'At Friends tours and travel, we customize reliable and trutworthy educational tours to destinations all over the world'**
  String get onboard1Description;

  /// No description provided for @onboard2TitlePart1.
  ///
  /// In en, this message translates to:
  /// **'It’s a big world out there go '**
  String get onboard2TitlePart1;

  /// No description provided for @onboard2TitlePart2.
  ///
  /// In en, this message translates to:
  /// **'explore'**
  String get onboard2TitlePart2;

  /// No description provided for @onboard2Description.
  ///
  /// In en, this message translates to:
  /// **'To get the best of your adventure you just need to leave and go where you like. we are waiting for you'**
  String get onboard2Description;

  /// No description provided for @onboard3TitlePart1.
  ///
  /// In en, this message translates to:
  /// **'People don’t take trips, trips take '**
  String get onboard3TitlePart1;

  /// No description provided for @onboard3TitlePart2.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get onboard3TitlePart2;

  /// No description provided for @onboard3Description.
  ///
  /// In en, this message translates to:
  /// **'To get the best of your adventure you just need to leave and go where you like. we are waiting for you'**
  String get onboard3Description;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in now'**
  String get signInTitle;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue our app'**
  String get signInSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get enterEmailPassword;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get signInFailed;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @orConnect.
  ///
  /// In en, this message translates to:
  /// **'Or connect'**
  String get orConnect;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get signUpTitle;

  /// No description provided for @signingUp.
  ///
  /// In en, this message translates to:
  /// **'Signing up...'**
  String get signingUp;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please fill the details and create account'**
  String get signUpSubtitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHint;

  /// No description provided for @passwordLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8 characters'**
  String get passwordLengthHint;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'📧 Verification email sent. Please verify and sign in.'**
  String get verificationEmailSent;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signUpFailed;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @exploreThe.
  ///
  /// In en, this message translates to:
  /// **'Explore the\n'**
  String get exploreThe;

  /// No description provided for @beautiful.
  ///
  /// In en, this message translates to:
  /// **'Beautiful '**
  String get beautiful;

  /// No description provided for @world.
  ///
  /// In en, this message translates to:
  /// **'world!'**
  String get world;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @locationToronto.
  ///
  /// In en, this message translates to:
  /// **'Toronto'**
  String get locationToronto;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @tripChecklist.
  ///
  /// In en, this message translates to:
  /// **'Trip Checklist'**
  String get tripChecklist;

  /// No description provided for @tripItinerary.
  ///
  /// In en, this message translates to:
  /// **'Trip Itinerary'**
  String get tripItinerary;

  /// No description provided for @rewardPoints.
  ///
  /// In en, this message translates to:
  /// **'Reward Points'**
  String get rewardPoints;

  /// No description provided for @travelTrips.
  ///
  /// In en, this message translates to:
  /// **'Travel Trips'**
  String get travelTrips;

  /// No description provided for @bucketList.
  ///
  /// In en, this message translates to:
  /// **'Bucket List'**
  String get bucketList;

  /// No description provided for @bookmarkedPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Places'**
  String get bookmarkedPlacesTitle;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarks;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @searchPlacesHeader.
  ///
  /// In en, this message translates to:
  /// **'Search Places'**
  String get searchPlacesHeader;

  /// No description provided for @surpriseAdventures.
  ///
  /// In en, this message translates to:
  /// **'Surprise Adventures'**
  String get surpriseAdventures;

  /// No description provided for @pickRandomPlaces.
  ///
  /// In en, this message translates to:
  /// **'Pick places for me to visit today'**
  String get pickRandomPlaces;

  /// No description provided for @clickForSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Click the button to get suggestions!'**
  String get clickForSuggestions;

  /// No description provided for @aboutDestination.
  ///
  /// In en, this message translates to:
  /// **'About Destination'**
  String get aboutDestination;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get readLess;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'/Person'**
  String get perPerson;

  /// No description provided for @souvenirsTitle.
  ///
  /// In en, this message translates to:
  /// **'Souvenirs'**
  String get souvenirsTitle;

  /// No description provided for @allPopularSouvenirs.
  ///
  /// In en, this message translates to:
  /// **'All Popular Trip Souvenirs'**
  String get allPopularSouvenirs;

  /// No description provided for @foodDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get foodDrink;

  /// No description provided for @foodDrinkDesc.
  ///
  /// In en, this message translates to:
  /// **'Local Snacks, Spices & More'**
  String get foodDrinkDesc;

  /// No description provided for @culturalHandicrafts.
  ///
  /// In en, this message translates to:
  /// **'Cultural & Handicrafts'**
  String get culturalHandicrafts;

  /// No description provided for @culturalDesc.
  ///
  /// In en, this message translates to:
  /// **'Handmade Jewelry, Pottery...'**
  String get culturalDesc;

  /// No description provided for @artStationery.
  ///
  /// In en, this message translates to:
  /// **'Art & Stationery'**
  String get artStationery;

  /// No description provided for @artDesc.
  ///
  /// In en, this message translates to:
  /// **'Postcards, Paintings & More'**
  String get artDesc;

  /// No description provided for @practicalUnique.
  ///
  /// In en, this message translates to:
  /// **'Practical & Unique'**
  String get practicalUnique;

  /// No description provided for @practicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Local Fashion, Accessories...'**
  String get practicalDesc;

  /// No description provided for @foodiesFavourite.
  ///
  /// In en, this message translates to:
  /// **'Foodies Favourite'**
  String get foodiesFavourite;

  /// No description provided for @personalisedPick.
  ///
  /// In en, this message translates to:
  /// **'Personalised Pick'**
  String get personalisedPick;

  /// No description provided for @artsyPick.
  ///
  /// In en, this message translates to:
  /// **'Artsy Pick'**
  String get artsyPick;

  /// No description provided for @safePick.
  ///
  /// In en, this message translates to:
  /// **'Safe Pick'**
  String get safePick;

  /// No description provided for @nItems.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String nItems(int count);

  /// No description provided for @translateTitle.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateTitle;

  /// No description provided for @translateButton.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateButton;

  /// No description provided for @currencyConverterTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency Converter'**
  String get currencyConverterTitle;

  /// No description provided for @exchangeRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRateTitle;

  /// No description provided for @popularCurrenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Currencies'**
  String get popularCurrenciesTitle;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @liveRate.
  ///
  /// In en, this message translates to:
  /// **'Live Rate'**
  String get liveRate;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @checklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel Checklist'**
  String get checklistTitle;

  /// No description provided for @essentialItems.
  ///
  /// In en, this message translates to:
  /// **'Essential Items'**
  String get essentialItems;

  /// No description provided for @rainyEssentials.
  ///
  /// In en, this message translates to:
  /// **'Rainy Weather Essentials'**
  String get rainyEssentials;

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'Checklist Progress'**
  String get checklistProgress;

  /// No description provided for @itemsChecked.
  ///
  /// In en, this message translates to:
  /// **'{checked} out of {total} items checked'**
  String itemsChecked(int checked, int total);

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noSchedulesToday.
  ///
  /// In en, this message translates to:
  /// **'No schedules for today'**
  String get noSchedulesToday;

  /// No description provided for @addScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new schedule'**
  String get addScheduleHint;

  /// No description provided for @noUpcomingSchedules.
  ///
  /// In en, this message translates to:
  /// **'No upcoming schedules'**
  String get noUpcomingSchedules;

  /// No description provided for @planAheadHint.
  ///
  /// In en, this message translates to:
  /// **'Plan ahead by adding future schedules'**
  String get planAheadHint;

  /// No description provided for @noCompletedSchedules.
  ///
  /// In en, this message translates to:
  /// **'No completed schedules'**
  String get noCompletedSchedules;

  /// No description provided for @checkOffHint.
  ///
  /// In en, this message translates to:
  /// **'Check off schedules as you complete them'**
  String get checkOffHint;

  /// No description provided for @addNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add New Schedule'**
  String get addNewSchedule;

  /// No description provided for @scheduleAdded.
  ///
  /// In en, this message translates to:
  /// **'Schedule added successfully!'**
  String get scheduleAdded;

  /// No description provided for @scheduleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated successfully!'**
  String get scheduleUpdated;

  /// No description provided for @scheduleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted successfully!'**
  String get scheduleDeleted;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Cultural Guide'**
  String get chatTitle;

  /// No description provided for @clearChatDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChatDialogTitle;

  /// No description provided for @clearChatDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all chat messages? This will delete your current conversation.'**
  String get clearChatDialogContent;

  /// No description provided for @welcomeChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cultural Guide!'**
  String get welcomeChatTitle;

  /// No description provided for @welcomeChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m your personal cultural tour guide and storyteller. Tell me which tourist attraction you\'d like to explore, and I\'ll create an immersive travel narrative just for you.'**
  String get welcomeChatSubtitle;

  /// No description provided for @tryAskingAbout.
  ///
  /// In en, this message translates to:
  /// **'Try asking about:'**
  String get tryAskingAbout;

  /// No description provided for @chatFeaturesList.
  ///
  /// In en, this message translates to:
  /// **'I\'ll provide:\n• Immersive travel narratives\n• Fun facts and cultural insights\n• Local customs and etiquette\n• Must-see spots and hidden gems'**
  String get chatFeaturesList;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about a place or culture...'**
  String get chatHint;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'This app needs access to your location to show routes and nearby places. Please allow location access to continue.'**
  String get locationPermissionContent;

  /// No description provided for @locationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Error'**
  String get locationErrorTitle;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open App Settings'**
  String get openAppSettings;

  /// No description provided for @locationRequiredMsg.
  ///
  /// In en, this message translates to:
  /// **'Location access is required for this feature'**
  String get locationRequiredMsg;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'WHERE TO GO?'**
  String get whereToGo;

  /// No description provided for @enterDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter destination...'**
  String get enterDestinationHint;

  /// No description provided for @routeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Route Info'**
  String get routeInfoTitle;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String stopsCount(int count);

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @totalSpendings.
  ///
  /// In en, this message translates to:
  /// **'Total spendings of this month'**
  String get totalSpendings;

  /// No description provided for @transactionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetailsTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @billPayment.
  ///
  /// In en, this message translates to:
  /// **'Bill Payment'**
  String get billPayment;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @souvenirArtTitle.
  ///
  /// In en, this message translates to:
  /// **'Art & Stationery'**
  String get souvenirArtTitle;

  /// No description provided for @souvenirArtSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Creative tools and souvenirs for the art enthusiast!'**
  String get souvenirArtSubtitle;

  /// No description provided for @souvenirArtRating.
  ///
  /// In en, this message translates to:
  /// **'Artsy Persons\' Favourite'**
  String get souvenirArtRating;

  /// No description provided for @souvenirArtAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Art & Stationery'**
  String get souvenirArtAboutTitle;

  /// No description provided for @souvenirArtAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'From sketchbooks to locally designed art supplies, these items inspire creativity and capture memories from your travels.'**
  String get souvenirArtAboutDesc;

  /// No description provided for @souvenirArtItem1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Postcards or Prints of Local Artwork – '**
  String get souvenirArtItem1Title;

  /// No description provided for @souvenirArtItem1Desc.
  ///
  /// In en, this message translates to:
  /// **'Compact and visually appealing, these show the artistic style of the region.'**
  String get souvenirArtItem1Desc;

  /// No description provided for @souvenirArtItem2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Handmade Notebooks or Journals – '**
  String get souvenirArtItem2Title;

  /// No description provided for @souvenirArtItem2Desc.
  ///
  /// In en, this message translates to:
  /// **'Locally crafted journals often include traditional designs or natural materials.'**
  String get souvenirArtItem2Desc;

  /// No description provided for @souvenirArtItem3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Local Calligraphy or Art Prints – '**
  String get souvenirArtItem3Title;

  /// No description provided for @souvenirArtItem3Desc.
  ///
  /// In en, this message translates to:
  /// **'Prints and calligraphy highlight the aesthetic traditions of the area.'**
  String get souvenirArtItem3Desc;

  /// No description provided for @souvenirArtItem4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Stickers or Pins Reflecting Local Culture – '**
  String get souvenirArtItem4Title;

  /// No description provided for @souvenirArtItem4Desc.
  ///
  /// In en, this message translates to:
  /// **'Fun, collectible items that showcase local icons, art, or symbols.'**
  String get souvenirArtItem4Desc;

  /// No description provided for @souvenirCulturalTitle.
  ///
  /// In en, this message translates to:
  /// **'Cultural & Handicrafts'**
  String get souvenirCulturalTitle;

  /// No description provided for @souvenirCulturalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authentic handmade treasures that tell a story!'**
  String get souvenirCulturalSubtitle;

  /// No description provided for @souvenirCulturalRating.
  ///
  /// In en, this message translates to:
  /// **'Receivers\' Favourite'**
  String get souvenirCulturalRating;

  /// No description provided for @souvenirCulturalAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Cultural & Handicrafts'**
  String get souvenirCulturalAboutTitle;

  /// No description provided for @souvenirCulturalAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore unique handmade artifacts, traditional crafts, and cultural treasures. Perfect for collectors or as memorable souvenirs from your travels.'**
  String get souvenirCulturalAboutDesc;

  /// No description provided for @souvenirCulturalItem1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Handmade Jewelry – '**
  String get souvenirCulturalItem1Title;

  /// No description provided for @souvenirCulturalItem1Desc.
  ///
  /// In en, this message translates to:
  /// **'Unique accessories crafted by local artisans showcase traditional designs and craftsmanship.'**
  String get souvenirCulturalItem1Desc;

  /// No description provided for @souvenirCulturalItem2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Local Ceramics or Pottery – '**
  String get souvenirCulturalItem2Title;

  /// No description provided for @souvenirCulturalItem2Desc.
  ///
  /// In en, this message translates to:
  /// **'Decorative or functional pottery pieces represent regional artistry and culture.'**
  String get souvenirCulturalItem2Desc;

  /// No description provided for @souvenirCulturalItem3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Handwoven Scarves – '**
  String get souvenirCulturalItem3Title;

  /// No description provided for @souvenirCulturalItem3Desc.
  ///
  /// In en, this message translates to:
  /// **'Scarves made from local fabrics are both stylish and a wearable piece of culture.'**
  String get souvenirCulturalItem3Desc;

  /// No description provided for @souvenirCulturalItem4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Decorative Fridge Magnets – '**
  String get souvenirCulturalItem4Title;

  /// No description provided for @souvenirCulturalItem4Desc.
  ///
  /// In en, this message translates to:
  /// **'Lightweight and fun, magnets often feature iconic landmarks or cultural symbols.'**
  String get souvenirCulturalItem4Desc;

  /// No description provided for @souvenirCulturalItem5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Small Figurines Representing Local Culture – '**
  String get souvenirCulturalItem5Title;

  /// No description provided for @souvenirCulturalItem5Desc.
  ///
  /// In en, this message translates to:
  /// **'Mini statues capture folklore, traditions, or famous symbols of the region.'**
  String get souvenirCulturalItem5Desc;

  /// No description provided for @souvenirCulturalItem6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Keychains – '**
  String get souvenirCulturalItem6Title;

  /// No description provided for @souvenirCulturalItem6Desc.
  ///
  /// In en, this message translates to:
  /// **'Handy souvenirs that feature local motifs or miniature replicas of famous landmarks.'**
  String get souvenirCulturalItem6Desc;

  /// No description provided for @souvenirFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get souvenirFoodTitle;

  /// No description provided for @souvenirFoodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delicious bites that make hearts (and taste buds) smile!'**
  String get souvenirFoodSubtitle;

  /// No description provided for @souvenirFoodRating.
  ///
  /// In en, this message translates to:
  /// **'Foodies\' Favourite'**
  String get souvenirFoodRating;

  /// No description provided for @souvenirFoodAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Food'**
  String get souvenirFoodAboutTitle;

  /// No description provided for @souvenirFoodAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'From savory local snacks to sweet treats and aromatic teas, Food & Drink souvenirs bring a taste of your travels to life. Perfect to share with friends or enjoy as a special treat yourself!'**
  String get souvenirFoodAboutDesc;

  /// No description provided for @souvenirFoodItem1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Local Snacks – '**
  String get souvenirFoodItem1Title;

  /// No description provided for @souvenirFoodItem1Desc.
  ///
  /// In en, this message translates to:
  /// **'Small packs of savory or sweet treats that are unique to the region, perfect for sharing with friends and family.'**
  String get souvenirFoodItem1Desc;

  /// No description provided for @souvenirFoodItem2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Traditional Sweets or Chocolates – '**
  String get souvenirFoodItem2Title;

  /// No description provided for @souvenirFoodItem2Desc.
  ///
  /// In en, this message translates to:
  /// **'Handmade sweets or chocolates highlight local flavors and culinary traditions.'**
  String get souvenirFoodItem2Desc;

  /// No description provided for @souvenirFoodItem3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Local Tea or Coffee Blends – '**
  String get souvenirFoodItem3Title;

  /// No description provided for @souvenirFoodItem3Desc.
  ///
  /// In en, this message translates to:
  /// **'Specialty teas or coffee beans provide an aromatic taste of the destination.'**
  String get souvenirFoodItem3Desc;

  /// No description provided for @souvenirFoodItem4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Regional Spices or Herbs – '**
  String get souvenirFoodItem4Title;

  /// No description provided for @souvenirFoodItem4Desc.
  ///
  /// In en, this message translates to:
  /// **'Locally grown spices or herbs capture the authentic flavors and cooking culture of the area.'**
  String get souvenirFoodItem4Desc;

  /// No description provided for @souvenirPracticalTitle.
  ///
  /// In en, this message translates to:
  /// **'Practical & Unique'**
  String get souvenirPracticalTitle;

  /// No description provided for @souvenirPracticalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Useful items that make travel memories practical!'**
  String get souvenirPracticalSubtitle;

  /// No description provided for @souvenirPracticalRating.
  ///
  /// In en, this message translates to:
  /// **'Perfect for Anyone'**
  String get souvenirPracticalRating;

  /// No description provided for @souvenirPracticalAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Practical & Unique'**
  String get souvenirPracticalAboutTitle;

  /// No description provided for @souvenirPracticalAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'These souvenirs are both functional and memorable, from handcrafted mugs to unique home gadgets, letting you bring practicality and style home.'**
  String get souvenirPracticalAboutDesc;

  /// No description provided for @souvenirPracticalItem1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Local Fashion – '**
  String get souvenirPracticalItem1Title;

  /// No description provided for @souvenirPracticalItem1Desc.
  ///
  /// In en, this message translates to:
  /// **'Clothing featuring local patterns, logos, or prints allows travelers to wear their memories. (T-Shirts, Caps, Blouses, Skirts, Dresses etc).'**
  String get souvenirPracticalItem1Desc;

  /// No description provided for @souvenirPracticalItem2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Mugs or Cups with City/Country Motifs – '**
  String get souvenirPracticalItem2Title;

  /// No description provided for @souvenirPracticalItem2Desc.
  ///
  /// In en, this message translates to:
  /// **'Everyday items with iconic designs that remind you of your trip.'**
  String get souvenirPracticalItem2Desc;

  /// No description provided for @souvenirPracticalItem3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Small Home Decor Items like Candles or Trinket Boxes – '**
  String get souvenirPracticalItem3Title;

  /// No description provided for @souvenirPracticalItem3Desc.
  ///
  /// In en, this message translates to:
  /// **'Decorative pieces bring a touch of local artistry into any home.'**
  String get souvenirPracticalItem3Desc;

  /// No description provided for @souvenirPracticalItem4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Traditional Board or Card Games – '**
  String get souvenirPracticalItem4Title;

  /// No description provided for @souvenirPracticalItem4Desc.
  ///
  /// In en, this message translates to:
  /// **'Regional games are fun to play and teach about local culture.'**
  String get souvenirPracticalItem4Desc;

  /// No description provided for @souvenirPracticalItem5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Local Folklore or Children’s Storybooks – '**
  String get souvenirPracticalItem5Title;

  /// No description provided for @souvenirPracticalItem5Desc.
  ///
  /// In en, this message translates to:
  /// **'Books that capture local stories, legends, and cultural lessons.'**
  String get souvenirPracticalItem5Desc;

  /// No description provided for @souvenirPracticalItem6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Local Perfumes – '**
  String get souvenirPracticalItem6Title;

  /// No description provided for @souvenirPracticalItem6Desc.
  ///
  /// In en, this message translates to:
  /// **'Fragrances inspired by native flowers, herbs, or spices create lasting sensory memories.'**
  String get souvenirPracticalItem6Desc;

  /// No description provided for @souvenirPracticalItem7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Mug/Glass Coasters – '**
  String get souvenirPracticalItem7Title;

  /// No description provided for @souvenirPracticalItem7Desc.
  ///
  /// In en, this message translates to:
  /// **'Functional and decorative items featuring local motifs, perfect as gifts.'**
  String get souvenirPracticalItem7Desc;

  /// No description provided for @souvenirPracticalItem8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Handmade Soaps or Bath Products – '**
  String get souvenirPracticalItem8Title;

  /// No description provided for @souvenirPracticalItem8Desc.
  ///
  /// In en, this message translates to:
  /// **'Locally made soaps, scrubs, or bath items often use natural ingredients unique to the region.'**
  String get souvenirPracticalItem8Desc;

  /// No description provided for @souvenirPracticalItem9Title.
  ///
  /// In en, this message translates to:
  /// **'9. Hair/Essential Oils – '**
  String get souvenirPracticalItem9Title;

  /// No description provided for @souvenirPracticalItem9Desc.
  ///
  /// In en, this message translates to:
  /// **'Aromatic oils crafted from local plants, herbs, or flowers, often used in beauty or wellness rituals.'**
  String get souvenirPracticalItem9Desc;

  /// No description provided for @souvenirPracticalItem10Title.
  ///
  /// In en, this message translates to:
  /// **'10. Tote Bags with Local Prints – '**
  String get souvenirPracticalItem10Title;

  /// No description provided for @souvenirPracticalItem10Desc.
  ///
  /// In en, this message translates to:
  /// **'Lightweight, reusable bags featuring regional designs, perfect as a practical souvenir.'**
  String get souvenirPracticalItem10Desc;

  /// No description provided for @popularPicks.
  ///
  /// In en, this message translates to:
  /// **'Popular Picks'**
  String get popularPicks;
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
      <String>['en', 'fr', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
