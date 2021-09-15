import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PRIMARY_COLOR = Color(0xFF0F464C);
const GRAY = Color(0xFFEAEAEA);
const DARK_GRAY = Color(0xFF6F757A);
const TRANSPARENT_BLACK = Color.fromRGBO(15, 5, 5, 0.3);
const LIGHT_BLACK = Color(0xFF50555C);
const BLACK = Color(0xFF232323);
const DARK_BLACK = Color.fromRGBO(1, 3, 7, 0.97);
const PISTACHIO = Color(0xFFE4F6E8);
const GREEN = Color(0xFF69B479);
const LIGHT_BLUE = Color(0xFFE7EDF8);
const TRANSPARENT_WHITE = Color.fromRGBO(255, 255, 255, 0.1);
const SCREEN_BACKGROUND = Color(0xFFDFE6E6);
const CLOSE_ICON = Color(0xFF393A3A);
const MARUN = Color(0xFF5D5073);
const DARK_MARUN = Color(0xFF862663);
const DARK_GRAY_FONT_COLOR = Color.fromRGBO(15, 70, 76, 1);
const AMBER_COLOR = Color.fromRGBO(249, 205, 60, 1);
const LIGHT_GRAY = Color(0xFFD7DBDD);
const LIGHT_MARUN = Color(0xFF862663);
const DIVIDER_COLOR = Color.fromRGBO(112, 112, 112, 0.3);
const BLUR_GRAY = Color.fromRGBO(112, 112, 112, 0.1);
const BLUE_GRAY = Color(0xFF188D88);
const BLUE = Color(0xFF005BD8);
const SHADOW_GRAY = Color.fromRGBO(0, 0, 0, 0.16);
const WHITE = Color(0xFFFFFFFF);
const DARK_PINK_COLOR = Color(0xFFD93864);
const PINK_COLOR = Color(0xFFE53B69);
const UNSELECTED_TAB_COLOR = Color(0xFF957979);
const ACCENT_GRAY = Color(0xFFE6E2E3);
const DARK_ACCENT_GRAY = Color(0xFFF8F5F5);
const LIGHT_ACCENT_GRAY = Color(0xFFE5DBDD);
const TABLE_ROW_GRAY_COLOR = Color(0xFFFBFAFA);

//Splash color
const PURPLE_COLOR = Color(0xFF445393);
const DARK_BLUE_COLOR = Color(0xFF4C63C6);
const MATE_WHITE = Color(0xFFFDEFFF);

const BASE_URL = 'https://prismapi.parksquarehomes.com/api/';

FirebaseFirestore firestore = FirebaseFirestore.instance;

const AUTH_TOKEN = 'auth_token';
late SharedPreferences prefsObject;

//Font family
const QUICKSAND = 'Quicksand';

//API keyword
const STATUS = 'STATUS';
const SUCCESS = 'success';
const MESSAGE = 'message';
const RESULT = 'RESULT';
const DATA = 'data';
const IS_TOKEN_EXPIRED = 'is_token_expire';
const HTTP_CODE = 'code';

// Routes
const INTRO = 'intro';
const LOGIN = 'login';
const SIGNUP = 'signup';
const LIVING_INFO_SCREEN = 'state_select';
const ZIP_CODE_SCREEN = 'zipcode_enter';
const EMAIL_SCREEN = 'email_screen';
const PERSOAL_INFO_SCREEN = 'first_last_name_screen';
const BIRTH_DATE_SCREEN = 'birth_date_screen';
const PHONE_WITH_PARENT_GUARDIAN_NUMBER = 'phone_with_parent_guardian_number';
const RESIDENTIAL_ADDRESS = 'residential_address';
const SCHOOL_AND_GRADE_SCREEN = 'school_screen';
const PASSWORD_SET_SCREEN = 'password_setScreen';
const HOME_SCREEN = 'home_screen';
const EXPLORE_SCREEN = 'explore_screen';
const EVENT_DETAILS_SCREEN = 'event_details_screen';
const REWARDS_SCREEN = 'rewards_screen';

//Dropdown hint
const SELECT_RELATION_HINT = '--Select Relation--';
const SELECT_GRADE_HINT = '--Select Grade--';

//Helpozzy Text
const HELPOZZY_REMAINING_TEXT = 'elpozzy';

// Messages
const MSG_SIGN_UP = 'Sign Up';
const MSG_LOGIN = 'Login';
const MSG_NEW_USER = 'New User? ';
const MSG_FORGOT_PASSWORD = 'Forgot your password? ';
const MSG_RESET_IT = 'Reset it';

//Hint Msg
const SEARCH_HINT = 'Search for events';
const REVIEW_HINT = 'Tap to review..';
const ENTER_STATE_HINT = 'Enter State';
const ENTER_CITY_HINT = 'Enter City';
const ENTER_ZIP_CODE_HINT = 'Enter Zip Code';
const ENTER_FIRST_NAME_HINT = 'Enter first name';
const ENTER_LAST_NAME_HINT = 'Enter last name';
const ENTER_EMAIL_HINT = 'Enter email';
const ENTER_PASSWORD_HINT = 'Enter password';
const ENTER_CONFIRM_PASSWORD_HINT = 'Enter confirm password';
const BIRTH_DATE_HINT = 'MM/DD/YYYY';
const ENTER_PHONE_NUMBER_HINT = 'Enter phone number';
const ENTER_SCHOOL_HINT = 'Enter your school';
const SELECT_YOUR_GRADE = 'Select your grade';
const HOUSE_NO_HINT = 'House/Apt. Number';
const STREET_NAME_HINT = 'Street Name';
const CITY_HINT = 'City';
const SEARCH_COUNTRY_HINT = 'Search Here';

//Reset password
const RESET_PASSWORD = 'Forgot your password?';
const RESER_PASS_MSG =
    "That's okay, it happens!\nEnter your email and Click on button below to reset your password.";

// Explore Screen
const MSG_DASHBOARD = 'Let’s do it\ntogether';
const MSG_GOAL = 'Your target goal for 2021';
const DETAILS = 'Details';
const REDEEM = 'Redeem';
const FOOD_BANK = 'Food\nBank';
const VOLUNTEER_WITH_CHILDREN = 'Volunteer with\nChildren';
const TEACH = 'Teaching';
const HOMELESS_SHELTER = 'Homeless\nShelter';
const ANIMAL_CARE = 'Animal\nCare';
const SENIOR_CENTER = 'Senior\nCenter';
const CHILDREN_AND_YOUTH = 'Children\nand Youth';
const MORE = 'More..';

//Sign-UP screen
const SELECT_CATEGORY = 'Select your volunteering choice?';
const WHICH_STATE = 'Which state are you from?';
const WHICH_CITY = 'Which city are you from?';
const ENTER_ZIP_CODE = 'Enter your ZIP code';
const ENTER_YOUR_NAME = 'Enter your name';
const ENTER_YOUR_EMAIL = 'Enter your email address';
const CHOOSE_YOUR_PASSWORD = 'Choose your password';
const SELECT_BIRTH_DATE = 'Date of Birth';
const DO_YOU_HAVE_NUMBER = 'Do you have a phone number?';
const ENTER_PARENT_NUMBER = 'Enter your parents/guardian number';
const FIRST_NAME = 'First Name';
const LAST_NAME = 'Last Name';
const PASSWORD = 'Password';
const CONFIRM_PASSWORD = 'Confirm Password';
const CHANGE_COUNTRY_CODE = 'Change country code';
const RELATIONSHIP_STATUS = 'Relationship';
const SCHOOL_NAME = 'School Name';
const GRADE_LEVEL = 'Grade Level';

//Alert Text
const ALERT = 'Alert';
const SUCCESSFULL = 'Successfull';

//Button Text
const SIGN_UP = 'Sign-Up';
const REDEEM_MY_POINT = 'Redeem my points';
const CONTINUE_BUTTON = 'Continue';
const OK_BUTTON = 'OK';
const SEND_MAIL_BUTTON = 'Send Email';

//Event Details Text
const CURRENT_LOCATION = 'Current Location';
const ABOUT_ORGANIZER = 'About Organizer';
const OVERVIEW = 'Overview';
const EVENT_DETAILS = 'Event Details';
const SCHEDULES = 'Schedules';
const DIRECTION = 'Direction';
const INFO = 'Info';
const REVIEWS = 'Reviews';

//Tabbar title
const DETAILS_TAB = 'Details';
const POINT_TAB = 'Points';
const MY_REWARDS_TAB = 'My Rewards';
const REDEEM_TAB = 'Redeem';
const TRANSFER_POINT_TAB = 'Transfer Points';

//Appbar Title
const REWARDS_APPBAR = 'Rewards';

//Details Tab
const COLUMN_ONE = 'Age\nGroup\n(Yrs old)';
const COLUMN_TWO = 'Kids\n(5-10)';
const COLUMN_THREE = 'Teens\n(11-15)';
const COLUMN_FOUR = 'Young\nAdult\n(16–25)';
const COLUMN_FIVE = 'Adults\n(26+)';
const TOP_REWARD_DETAILS =
    'Star Points required to Earn Reward Badges in each Age Group';
const SECOND_REWARD_DETAILS_TEXT = '60 minutes contribution = 1 points';

//Points Tab
const SILVER_MEMBER = 'SILVER MEMBER';
const POINT_TO_REDEEM = 'Points to Redeem';
const MEMBER_SINCE = 'Member since';
const MEMBERSHIP_NUMBER = 'Membership number';
const EARNED_POINT = 'Lifetime points earned';
const SECOND_TEXT_POINTS = 'Earn 15 more points to reach Gold Badge';

//My Rewards Tab
const REWARDS_RECEIVED = 'Rewards Received';
const REWARDS_REDEEM = 'Rewards Redeemed';
const EXPAND_ALL = 'See All';
const EXPAND_LESS = 'Hide';
const USED_POINTS = 'Points Used';
const GIFT_REDEEM = 'Gifts Redeemed';
const POINT_SENT = 'Points Sent';
const ACCEPT_GIFT = 'Accept Gift';

//Transfer Point Tab
const AVAILABLE_POINT = 'Available points to redeem :';

//Event Sign-up
const CONTACT_PRO_LEAD = 'Contact Project Lead';

const SAMPLE_LONG_TEXT =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    " when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    " It has survived not only five centuries, but also the leap into electronic typesetting,"
    " remaining essentially unchanged. "
    "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,"
    " and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

//Dropdowns
List<String> relationShips = [SELECT_RELATION_HINT, 'Parent', 'Guardian'];

List<String> gradeLevels = [
  SELECT_GRADE_HINT,
  '6th',
  '7th',
  '8th',
  '9th',
  '10th',
  '11th',
  '12th',
  'College',
];
//Temp Data
List<int> items = [25, 50, 75, 100, 125, 150, 175, 200];

List<Map<String, dynamic>> categories = [
  {
    'id': 0,
    'img_url': 'assets/images/groceries.png',
    'label': FOOD_BANK,
  },
  {
    'id': 1,
    'img_url': 'assets/images/volunteer.png',
    'label': VOLUNTEER_WITH_CHILDREN,
  },
  {
    'id': 2,
    'img_url': 'assets/images/teach.png',
    'label': TEACH,
  },
  {
    'id': 3,
    'img_url': 'assets/images/animal_shelter.png',
    'label': HOMELESS_SHELTER,
  },
  {
    'id': 4,
    'img_url': 'assets/images/animal_care.png',
    'label': ANIMAL_CARE,
  },
  {
    'id': 5,
    'img_url': 'assets/images/senior.png',
    'label': SENIOR_CENTER,
  },
  {
    'id': 6,
    'img_url': 'assets/images/youth.png',
    'label': CHILDREN_AND_YOUTH,
  },
  {
    'id': 7,
    'img_url': 'assets/images/more.png',
    'label': MORE,
  },
];

List<Map<String, dynamic>> eventList = [
  {
    'category_id': 5,
    'event_id': 0,
    'image_url': 'assets/images/event1.jpg',
    'date_time': 'Thu, Dec 31 - 10:30 AM (PST)',
    'event_name': 'New Year Eve Food Carting',
    'oraganization': 'Dublin Senior Center',
    'location': '7600 Amador Valley Blvd,\nDublin, CA 94568',
    'review_count': 112,
    'is_liked': false,
    'rating': 3.3,
    'about_organizer': SAMPLE_LONG_TEXT,
    'details': SAMPLE_LONG_TEXT,
  },
  {
    'category_id': 1,
    'event_id': 1,
    'image_url': 'assets/images/event2.jpg',
    'date_time': 'Sat / Sun (All Weekends)',
    'event_name': 'Give joy to Sick Child',
    'oraganization': 'Children Cancer Association',
    'location': '1200 NW Naito Pkway #14,\nPleasanton, CA 95677',
    'review_count': 74,
    'is_liked': true,
    'rating': 4,
    'about_organizer': SAMPLE_LONG_TEXT,
    'details': SAMPLE_LONG_TEXT,
  },
  {
    'category_id': 0,
    'event_id': 2,
    'image_url': 'assets/images/event3.jpg',
    'date_time': 'Thu, Jan 07 - 4:30 (PST)',
    'event_name': 'Food Distribution',
    'oraganization': 'Food Camping Association',
    'location': '1200 NW Naito Pkway #14,\nPleasanton, CA 95677',
    'review_count': 104,
    'is_liked': false,
    'rating': 4.5,
    'about_organizer': SAMPLE_LONG_TEXT,
    'details': SAMPLE_LONG_TEXT,
  },
];

List<String> eventStrings = [
  'Wildlife Conservation',
  'Volunteer with Children',
  'Teaching',
  'Public Health',
  'Animal Care',
  'Women’s Empowerment',
  'Children and Youth',
];

List<Map<String, dynamic>> reviewData = [
  {
    'image_url': 'assets/images/event1.jpg',
    'name': 'Roy Merlin',
    'address': 'Dublin, CA 94568',
    'rating': 4.5,
    'date_time': '2 Days ago',
    'review_text': 'They are so good! I wish to visit this place again.',
  },
  {
    'image_url': 'assets/images/event1.jpg',
    'name': 'Kay Codetta',
    'address': 'Sacrdmento, CA 94203',
    'rating': 4,
    'date_time': '12 Days ago',
    'review_text': '',
  },
];

Map<String, dynamic> rewardsList = {
  'Bronze': {
    'asset': 'assets/images/medal_bronze.png',
    'points': [
      {
        'rating': 50,
        'points': 50,
        'hrs': '26-49 hrs',
      },
      {
        'rating': 50,
        'points': 50,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 50,
        'points': 50,
        'hrs': '100-174 hrs',
      },
      {
        'rating': 50,
        'points': 50,
        'hrs': '100-249 hrs',
      },
    ],
  },
  'Silver': {
    'asset': 'assets/images/medal_silver.png',
    'points': [
      {
        'rating': 100,
        'points': 100,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 100,
        'points': 100,
        'hrs': '75-99 hrs',
      },
      {
        'rating': 100,
        'points': 100,
        'hrs': '175-249 hrs',
      },
      {
        'rating': 100,
        'points': 100,
        'hrs': '250-499 hrs',
      },
    ],
  },
  'Gold': {
    'asset': 'assets/images/medal_gold.png',
    'points': [
      {
        'rating': 150,
        'points': 150,
        'hrs': '75+ hrs',
      },
      {
        'rating': 150,
        'points': 150,
        'hrs': '100+ hrs',
      },
      {
        'rating': 150,
        'points': 150,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 150,
        'points': 150,
        'hrs': '50-74 hrs',
      },
    ],
  },
  'Lifetime\nAchievement': {
    'asset': 'assets/images/trophy.png',
    'points': [
      {
        'rating': 200,
        'points': 200,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 200,
        'points': 200,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 200,
        'points': 200,
        'hrs': '50-74 hrs',
      },
      {
        'rating': 200,
        'points': 200,
        'hrs': '50-74 hrs',
      },
    ],
  },
};

List<Map<String, dynamic>> peoplesList = [
  {
    'image_url': '',
    'fav': false,
    'user_name': 'John Smith',
    'point_gifted': 0,
    'mail': 'Sample123@gmail.com',
  },
  {
    'image_url': '',
    'fav': true,
    'user_name': 'Abdul Iqbal',
    'point_gifted': 3,
    'mail': 'Sample123@gmail.com',
  },
  {
    'image_url': '',
    'fav': false,
    'user_name': 'Smith Andda',
    'point_gifted': 1,
    'mail': 'Sample123@gmail.com',
  },
  {
    'image_url': '',
    'fav': true,
    'user_name': 'John Smith',
    'point_gifted': 7,
    'mail': 'Sample123@gmail.com',
  },
  {
    'image_url': '',
    'fav': true,
    'user_name': 'John Carter',
    'point_gifted': 5,
    'mail': 'Sample123@gmail.com',
  },
  {
    'image_url': '',
    'fav': false,
    'user_name': 'Bob Jons',
    'point_gifted': 2,
    'mail': 'Sample123@gmail.com',
  },
];
