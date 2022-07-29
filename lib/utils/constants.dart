import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/categories_model.dart';
import 'package:helpozzy/models/dashboard_menu_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PRIMARY_COLOR = Color(0xFF0F464C);
const GRAY = Color(0xFFEAEAEA);
const DARK_GRAY = Color(0xFF6F757A);
const TRANSPARENT_BLACK = Color.fromRGBO(15, 5, 5, 0.3);
const LIGHT_BLACK = Color(0xFF50555C);
const BLACK = Color(0xFF232323);
const BUTTON_GRAY_COLOR = Color(0xFF707070);
const SILVER_GRAY = Color(0xFFADB3BC);
const DARK_BLACK = Color.fromRGBO(1, 3, 7, 0.97);
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
const DARK_BLUE = Color(0xFF005BD8);
const SHADOW_GRAY = Color.fromRGBO(0, 0, 0, 0.16);
const WHITE = Color(0xFFFFFFFF);
const DARK_PINK_COLOR = Color(0xFFD93864);
const PINK_COLOR = Color(0xFFE53B69);
const UNSELECTED_TAB_COLOR = Color(0xFF957979);
const ACCENT_GRAY = Color(0xFFE6E2E3);
const DARK_ACCENT_GRAY = Color(0xFFF8F5F5);
const LIGHT_ACCENT_GRAY = Color(0xFFE5DBDD);
const TABLE_ROW_GRAY_COLOR = Color(0xFFFBFAFA);
const PURPLE_BLUE_COLOR = Color(0xFF89C4FB);
const BLUE_COLOR = Color(0xFF007AFF);
const RED_COLOR = Colors.red;
const LABEL_TILE_COLOR = Color(0xFFD8D9DD);
const ACCENT_GREEN = Color(0xFF34C759);
const ACCENT_GRAY_COLOR = Color(0xFFF7F4F4);
const ACCENT_PINK_COLOR = Color.fromARGB(255, 255, 172, 194);

//Splash color
const PURPLE_COLOR = Color(0xFF445393);
const DARK_BLUE_COLOR = Color(0xFF4C63C6);
const MATE_WHITE = Color(0xFFFDEFFF);

//Graph bar color
const DARK_BAR_COLOR = Color(0xff3b8c75);
const NORMAL_BAR_COLOR = Color(0xff64caad);
const LIGHT_BAR_COLOR = Color(0xff73e8c9);

const BASE_URL = 'https://prismapi.parksquarehomes.com/api/';
const APP_ICON_URL =
    'https://firebasestorage.googleapis.com/v0/b/helpozzyapp.appspot.com/o/helpozzy_icon%2Fhelpozzy_icon.png?alt=media&token=4e4a5fa0-ea75-4fbe-8f36-7db01347da3f';
const ANDROID_MAP_API_KEY = 'AIzaSyCLWAG1kDcGh8S8ac0RdyIhKUgS8jdQ64g';
FirebaseFirestore firestore = FirebaseFirestore.instance;

late SharedPreferences prefsObject;

//Qualification List
final List<String> qualifications = [
  PRIMARY_EDUCATION,
  SECONDARY_HIGHER_SECONDARY,
  UNDER_GRADUATE,
  POST_GRADUATE,
  DOCTORAL_STUDIES,
  VOCATIONAL_EDUCATION,
  CERTIFICATE_DIPLOMA,
  DISTANCE_EDUCATION,
];

//Enum
enum ProjectTabType {
  PROJECT_OPEN_TAB,
  PROJECT_UPCOMING_TAB,
  MY_PROJECTS_TAB,
  OWN_TAB,
  MY_ENROLLED_TAB,
  PROJECT_COMPLETED_TAB,
  PROJECT_CONTRIBUTION_TRACKER_TAB,
  EXPLORE_SCREEN,
}

enum SearchBottomSheetType {
  STATE_BOTTOMSHEET,
  CITY_BOTTOMSHEET,
  SCHOOL_BOTTOMSHEET,
}

enum TaskProgressType {
  START,
  COMPLETED,
  LOG_HRS,
  DECLINE,
}

enum OrganizationTypes {
  LLC,
  PARTNERSHIP,
  CORP,
  SOLE_PROP,
}

//Font family
const QUICKSAND = 'Quicksand';

//API keyword
const AUTH_TOKEN = 'auth_token';
const STATUS = 'STATUS';
const SUCCESS = 'success';
const MESSAGE = 'message';
const RESULT = 'RESULT';
const DATA = 'data';
const IS_TOKEN_EXPIRED = 'is_token_expire';
const HTTP_CODE = 'code';

//Loading
const LOADING = 'Loading..';
const DOT = '• ';

// Routes
const INTRO = 'intro';
const DASHBOARD = 'dashboard';
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
const PROJECT_DETAILS_SCREEN = 'project_details_screen';
const REWARDS_SCREEN = 'rewards_screen';
const COMING_SOON_SCREEN_TEXT = 'Coming Soon!';

//Bottom Tabbar
const EXPLORE_TAB = 'Explore';
const REWARD_TAB = 'Rewards';
const HOME_TAB = 'Home';
const NOTIFICATIONS_TAB = 'Notifications';
const CHAT_TAB = 'Chat';
const PROFILE_TAB = 'Profile';

//Dropdown hint
const SELECT_RELATION_HINT = 'Select Relation';
const SELECT_GRADE_HINT = 'Select Grade Level';
const GRADE_HINT = 'Grade Level';
const SELECT_TYPE_HINT = 'Select Type';
const SELECT_CATEGORY_HINT = 'Select Category';
const FILTERS_HINT = 'Filters';
const SORT_BY_HINT = 'Sort by';
const FAVORITE_HINT = 'Favorite';
const SELECT_YEAR_HINT = 'Select Year';
const SELECT_MONTH_HINT = 'Select Month';

//Helpozzy Text
const HELPOZZY_REMAINING_TEXT = 'elpozzy';
const HELPOZZY_TEXT = 'Helpozzy';
const HELPOZZY_TAGLINE_TEXT =
    'Connecting Volunteers, Donors and Organizations to build a strong community !!';

// Messages
const MSG_SIGN_UP = 'Sign Up';
const MSG_LOGIN = 'Login';
const MSG_NEW_USER = 'New User? ';
const MSG_FORGOT_PASSWORD = 'Forgot your password? ';
const MSG_RESET_IT = 'Reset It';

//Option Text
const SELECT_OPTION = 'Select Option';
const CAMERA_OPTION = 'Camera';
const GALLERY_OPTION = 'Gallery';

//Hint Msg
const SEARCH_PROJECT_HINT = 'Search for projects';
const SEARCH_SCHOOL_HINT = 'Search for school';
const SEARCH_STATE_NAME_HINT = 'Search for state';
const SEARCH_CITY_NAME_HINT = 'Search for city';
const REVIEW_HINT = 'Tap to review..';
const SELECT_STATE_HINT = 'Select State';
const SELECT_CITY_HINT = 'Select City';
const ENTER_NAME_HINT = 'Enter name';
const ENTER_STATE_HINT = 'Enter State';
const ENTER_CITY_HINT = 'Enter City';
const ADDRESS_HINT = 'Enter address';
const HOUSE_NO_HINT = 'Enter House/Apt. Number';
const STREET_NAME_HINT = 'Enter Street Name';
const ENTER_ZIP_CODE_HINT = 'Enter Zip Code';
const ENTER_FIRST_NAME_HINT = 'Enter first name';
const ENTER_LAST_NAME_HINT = 'Enter last name';
const TELL_US_ABOUT_HINT = 'Tell us about';
const ENTER_EMAIL_HINT = 'Enter email';
const ENTER_OTP_HINT = 'Enter OTP';
const ENTER_PARENTS_EMAIL_HINT = 'Enter parents email';
const SELECT_DATE_OF_BIRTH_HINT = 'MM/DD/YYYY';
const SELCT_GENDER_HINT = 'Select gender';
const SELCT_QUALIFICATION_HINT = 'Select qualification';
const ENTER_PHONE_NUMBER_HINT = 'Enter phone number';
const ENTER_SCHOOL_HINT = 'Enter your school';
const SELECT_YOUR_GRADE = 'Select your grade';
const ENTER_TARGET_HOURS_HINT = 'Enter target hours';
const ENTER_PASSWORD_HINT = 'Enter password';
const ENTER_CONFIRM_PASSWORD_HINT = 'Enter confirm password';
const SEARCH_COUNTRY_HINT = 'Search Here';
const ENTER_COMMENT_HINT = 'Comment';

//Prefs Keys
const CURRENT_USER_ID = 'uID';
const PEER_USRE_ID = 'PeerId';
const CURRENT_USER_PROFILE_URL = 'profileImage';
const CURRENT_USER_DATA = 'currentUser';

//Snakbar message
const LOGIN_SUCEED_POPUP_MSG = 'Login Successfully';
const SIGN_UP_FAILED_POPUP_MSG = 'Sign-Up Failed!';
const AUTHENTICATION_SUCCESS_POPUP_MSG = 'Authentication Success!';
const AUTHENTICATION_FAILED_POPUP_MSG = 'Authentication Failed!';
const FAILED_POPUP_MSG = 'Failed!';
const OTP_SENT_TO_POPUP_MSG = 'OTP sent to';
const ENTER_HRS_POPUP_MSG = 'Enter your hrs in field';
const PROJECT_CREATED_SUCCESSFULLY_POPUP_MSG = 'Project created successfully!';
const PROJECT_UPDATED_SUCCESSFULLY_POPUP_MSG = 'Project updated successfully!';
const PROJECT_DELETED_SUCCESSFULLY_POPUP_MSG = 'Project deleted successfully!';
const PROJECT_NOT_CREATED_ERROR_POPUP_MSG =
    'Project not created due some error, Try again!';
const PROJECT_NOT_UPDATED_ERROR_POPUP_MSG =
    'Project not updated due some error, Try again!';
const PROJECT_NOT_DELETED_ERROR_POPUP_MSG =
    'Project not deleted due some error, Try again!';
const PROJECT_SELECT_LOCATION = 'Add project location';
const TASK_COMPLETED_POPUP_MSG = 'Task completed';
const TASK_STARTED_POPUP_MSG = 'Task started';
const TASK_DECLINE_POPUP_MSG = 'Task Declined';
const TASK_LOG_HRS_POPUP_MSG = 'Task Hrs submited to admin, Wait for approve';
const TASK_NOT_UPDATED_POPUP_MSG = 'Technical issue! Task not updated';
const MESSAGE_COPIED_POPUP_MSG = 'Message copied';
const PROFILE_UPDATED_POPUP_MSG = 'Profile Updated';
const PROFILE_NOT_UPDATED_POPUP_MSG = 'Technical issue! Profile not updated';
const TASK_UPDATED_SUCCESSFULLY_POPUP_MSG = 'Task updated successfully!';
const TASK_CREATED_SUCCESSFULLY_POPUP_MSG = 'Task created successfully!';
const TASK_DELETED_SUCCESSFULLY_POPUP_MSG = 'Task deleted successfully!';
const TASK_NOT_UPDATED_ERROR_POPUP_MSG =
    'Task not updated due some error, Try again!';
const TASK_NOT_CREATED_ERROR_POPUP_MSG =
    'Task not created due some error, Try again!';
const TASK_NOT_DELETED_ERROR_POPUP_MSG =
    'Task not deleted due some error, Try again!';
const REVIEW_NOT_POSTED_ERROR_POPUP_MSG = 'Try again! Review not posted';

//Oraganization sign up
const ORAGANIZATION_SIGN_UP_LABEL = 'Oraganization Sign Up';
const LEGAL_ORGANIZATION_NAME_LABEL = 'Legal Oraganization Name';
const ORAGANIZATION_DISCRIPTION_LABEL = 'Oraganization Discription';
const ORAGANIZATION_TYPE_LABEL = 'Organization Type';
const OTHER_LABEL = 'Other';
const TAX_ID_NUMBER_LABEL = 'Tax ID Number';
const INVITE_OTHER_ADMIN_LABEL = 'Invite Other Admin';
const CORP_RADIO = 'Corp.';
const LLC_RADIO = 'LLC';
const PARTNERSHIP_RADIO = 'Partnership';
const SOLE_PROP_RADIO = 'Sole Prop.';
const NON_PROFIT_ORGANIZATION_CHECKBOX = 'Are You A Non-profit Organization?';
const ORGANIZATION_NAME_HINT = 'Organization Name';
const ORGANIZATION_DISCRIPTION_HINT = 'Organization Description';
const ENTER_STRUCTURE_HINT = 'Enter Structure';
const TAX_ID_NUM_HINT = 'XX_XXXXXXX';
const INVITEES_EMAIL_ADDRESS_HINT = 'Email Address';

//Terms&Condition Privacy Policy
const TERMS_AND_CONDITION_LABEL = 'Terms & Conditions';
const PRIVACY_POLICY_LABEL = 'Privacy policy';
const TERMS_CONDITION_CONTENT = "Welcome to Helpozzy!"
    "\n\nThese terms and conditions outline the rules and regulations for the use of Helpozzy."
    "\n\nBy using this app we assume you accept these terms and conditions. Do not continue to use Helpozzy if you do not agree to take all of the terms and conditions stated on this page."
    '\n\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company’s terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same. Our Terms and Conditions were created with the help of the App Terms and Conditions Generator from App-Privacy-Policy.com'
    '\n\nLicense'
    '\n\nUnless otherwise stated, Helpozzy and/or its licensors own the intellectual property rights for all material on Helpozzy. All intellectual property rights are reserved. You may access this from Helpozzy for your own personal use subjected to restrictions set in these terms and conditions.'
    '\n\nYou must not:'
    '\n\n • Republish material from Helpozzy'
    '\n • Sell, rent or sub-license material from Helpozzy'
    '\n • Reproduce, duplicate or copy material from Helpozzy'
    '\n • Redistribute content from Helpozzy'
    '\n\nThis Agreement shall begin on the date hereof.'
    '\n\nParts of this app offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Helpozzy does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Helpozzy, its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Helpozzy shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.'
    '\nHelpozzy reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.'
    '\n\nYou warrant and represent that:'
    '\n\n • You are entitled to post the Comments on our App and have all necessary licenses and consents to do so;'
    '\n • The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;'
    "\n • The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy'The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity."
    '\n\nYou hereby grant Helpozzy a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.'
    '\n\nHyperlinking to our App'
    '\nThe following organizations may link to our App without prior written approval:'
    '\n\n • Government agencies;'
    '\n • Search engines;'
    '\n • News organizations;'
    '\n • Online directory distributors may link to our App in the same manner as they hyperlink to the Websites of other listed businesses; and'
    '\n • System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.'
    '\n\nThese organizations may link to our home page, to publications or to other App information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.'
    '\n\nWe may consider and approve other link requests from the following types of organizations:'
    '\n\n • commonly-known consumer and/or business information sources;'
    '\n • dot.com community sites;'
    '\n • associations or other groups representing charities;'
    '\n • online directory distributors;'
    '\n • internet portals;'
    '\n • accounting, law and consulting firms; and'
    '\n • educational institutions and trade associations.'
    '\n\nWe will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Helpozzy; and (d) the link is in the context of general resource information.'
    '\n\nThese organizations may link to our App so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site.'
    '\n\nIf you are one of the organizations listed in paragraph 2 above and are interested in linking to our App, you must inform us by sending an e-mail to Helpozzy. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our App, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.'
    '\n\nApproved organizations may hyperlink to our App as follows:'
    '\n • By use of our corporate name; or'
    '\n • By use of the uniform resource locator being linked to; or'
    "\n • By use of any other description of our App being linked to that makes sense within the context and format of content on the linking party’s site."
    "\n\nNo use of Helpozzy's logo or other artwork will be allowed for linking absent a trademark license agreement."
    '\n\niFrames'
    '\n\nWithout prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our App.'
    '\n\nContent Liability'
    '\n\nWe shall not be hold responsible for any content that appears on your App. You agree to protect and defend us against all claims that is rising on our App. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.';

const PRIVACY_POLICY_CONTENT = 'Please read Privacy Policy.'
    '\n\nReservation of Rights'
    '\n\nWe reserve the right to request that you remove all links or any particular link to our App. You approve to immediately remove all links to our App upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our App, you agree to be bound to and follow these linking terms and conditions.'
    '\n\nRemoval of links from our App'
    '\n\nIf you find any link on our App that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.'
    '\n\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.'
    '\n\nDisclaimer'
    '\n\nTo the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our App and the use of this website. Nothing in this disclaimer will:'
    '\n\n • limit or exclude our or your liability for death or personal injury;'
    '\n • limit or exclude our or your liability for fraud or fraudulent misrepresentation;'
    '\n • limit any of our or your liabilities in any way that is not permitted under applicable law; or'
    '\n • exclude any of our or your liabilities that may not be excluded under applicable law.'
    '\n\nThe limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.'
    '\n\nAs long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.';

//Reset password
const FORGOT_YOUR_PASSWORD = 'Forgot your password?';
const RESET_PASSWORD = 'Reset Password';
const TERMS_AND_CONDITION_1 = 'By signing up, you agree to HelPozzy';
const TERMS_AND_CONDITION = ' Terms & Conditions ';
const TERMS_AND_CONDITION_2 = 'and acknowledge you have read the';
const PRIVACY_POLICY = ' Privacy policy.';
const SENTENCE_END = '.';
const RESET_PASS_MSG =
    "That's okay, It happens! Enter your email and Click on button below to reset your password.";
const PASSWORD_TOOLTIP =
    '- At least 8 characters—the more characters, the better.'
    '\n- A mixture of both uppercase and lowercase letters.'
    '\n- A mixture of letters and numbers.'
    '\n- Inclusion of at least one special character'
    '\n e.g., ! @ # ? ]';

//Dashboard scrreen
const PROJECTS_TILE = 'Projects';
const MY_TASKS_TILE = 'My Tasks';
const REPORTS_TILE = 'Report';
const TIME_TRACKER_TILE = 'Time Tracker';

// Explore Screen
const MSG_DASHBOARD = 'Changing the World,\nOne Project At a Time';
const SEARCH_PROJECT_LABEL = 'Find volunteering opportunities';
const TYPE_KEYWORD_HINT = 'Look-up active projects';
const SEARCH_BY_CATEGORY = 'Search by category';
const CURRENT_OPEN_PROJECT_LABEL =
    'Current available volunteering opportunities';
const YOUR_HOURS_1 = 'You have ';
const YOUR_HOURS_2 = ' volunteer hours for - ';
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
const NO_CURRENT_VOLUNTEERING_OPPORTUNITIES =
    'Not any current volunteering opportunities';

//Project list labels
const NEW_PROJECT_LABEL = 'New Projects';
const RECENTLY_COMPLETED_LABEL = 'Recently Completed';
const LATEST_CONTRIBUTION_HOURS_LABEL = 'Latest Contribution Hours';
const ONGOING_PROJECT_LABEL = 'Ongoing Projects';

//Sign-UP screen
const SELECT_USER_TYPE = 'Select your user type?';
const SELECT_CATEGORY = 'Select your volunteering choice?';
const FIRST_NAME = 'First Name';
const LAST_NAME = 'Last Name';
const RESIDENTAL_ADDRESS = 'Residential Address';
const WHICH_STATE = 'Which state are you from?';
const WHICH_CITY = 'Which city are you from?';
const ENTER_ZIP_CODE = 'Enter your ZIP code';
const ENTER_YOUR_NAME = 'Enter your name';
const ENTER_YOUR_EMAIL = 'Enter your email address';
const SELECT_BIRTH_DATE = 'Select your Date of Birth';
const SELECT_GENDER = 'Select Your Gender';
const ENTER_YOUR_PHONE_NUMBER = 'Enter your phone number';
const ENTER_PARENT_EMAIL = 'Enter your parents/guardian email';
const CHOOSE_YOUR_AREA_OF_INTEREST = 'Choose your area of interest';
const CURRENT_YEAR_TARGET_HOURS = 'Target hours for current year';
const CHOOSE_YOUR_PASSWORD = 'Choose your password';
const PASSWORD = 'Password';
const CONFIRM_PASSWORD = 'Confirm Password';
const FINGERPRINT_AND_FACE_ID = 'Fingerprint & Face ID';
const PRIVACY_AND_SECURITY = 'Privacy & Security';
const CHANGE_COUNTRY_CODE = 'Change country code';
const RELATIONSHIP_STATUS = 'Relationship';
const SCHOOL_STATE = 'State of School';
const SCHOOL_CITY = 'City of School';
const SCHOOL_NAME = 'School Name';
const GRADE_LEVEL = 'Grade Level';
const EMAIL_OTP_TEXT = 'Helpozzy App';

//School search type
const STATE_BOTTOMSHEET = 'State Bottomsheet';
const CITY_BOTTOMSHEET = 'City Bottomsheet';
const SCHOOL_BOTTOMSHEET = 'School Bottomsheet';

//Qualifications
const PRIMARY_EDUCATION = 'Primary';
const SECONDARY_HIGHER_SECONDARY = 'Secondary/Higher Secondary';
const UNDER_GRADUATE = 'Under-Graduate/Bachelor’s level education';
const POST_GRADUATE = 'Post-Graduate/Master’s level';
const DOCTORAL_STUDIES = 'Doctoral studies/Ph.D level';
const VOCATIONAL_EDUCATION = 'Vocational Education & Training';
const CERTIFICATE_DIPLOMA = 'Certificate and Diploma programs';
const DISTANCE_EDUCATION = 'Distance Education';

//Alert Text
const ALERT = 'Alert';
const SUCCESSFULL = 'Successful';
const SIGN_OUT_TITLE = 'Sign Out';
const SIGN_OUT_FROM_APP = 'You want to sign out from app!';
const CONFIRM = 'Confirm';
const DELETE_PROJECT_TEXT = 'Are you sure! Want to delete this project!';
const DELETE_TASK_TEXT = 'Are you sure! Want to delete this task!';

//Button Text
const SIGN_UP = 'Sign-Up';
const REDEEM_MY_POINT = 'Redeem my points';
const ENROLL_BUTTON = 'Enroll';
const CONTINUE_BUTTON = 'Continue';
const OK_BUTTON = 'OK';
const SIGN_OUT_BUTTON = 'Sign Out';
const CANCEL_BUTTON = 'Cancel';
const SEND_MAIL_BUTTON = 'Send Email';
const ADD_NEW_PROJECT_BUTTON = 'Project';
const LOGOUT_BUTTON = 'Logout';
const DELETE_BUTTON = 'Delete';
const SEND_VERIFICATION_CODE_BUTTON = 'Send Verification Code';
const START_BUTTON = 'START';
const COMPLETED_BUTTON = 'Completed';
const APPROVE_BUTTON = 'APPROVE';
const DECLINE_BUTTON = 'DECLINE';
const LOG_HOURS_BUTTON = 'Thank you! Click to log your hours';
const SUBMIT_BUTTON = 'SUBMIT';
const ADD_NEW_ADMIN = 'Add New Admin';

//User Project Details Text
const CURRENT_LOCATION = 'Current Location';
const ABOUT_ORGANIZER = 'About Organizer';
const OVERVIEW = 'Overview';
const PROJECT_DETAILS = 'Project Details';
const SCHEDULE = '• Schedule Info';
const DIRECTION = 'Direction';
const INFO = 'Info';
const TASKS = 'Tasks';
const REVIEWS = 'Reviews';
const ESTIMATED_HRS = 'Estimated Hrs : ';
const MEMBERS_SIGNED_UP = ' Members signed up';
const PROJECT_CREATED_ON = 'Project created on : ';
const ESTIMATED_END_DATE = 'Estimated end date : ';
const PROJECT_LEAD_LABEL = 'Project Lead : ';

//User project tabbar title
const TASKS_TAB = 'Tasks';
const MEMBERS_TAB = 'Members';
const MESSENGER_TAB = 'Messenger';
const ATTACHMENTS_TAB = 'Attachments';

//User project task details
const TASK_DETAILS = '• Task Details';
const MY_TASKS_LABEL = 'My Tasks';
const TASK_CREATED_ON = 'Task created on : ';
const VIEW_ALL_TASKS_LABEL = 'View all Tasks';
const TASK_ARE_YOU_RUNNING_LATE = 'Are you running late?';
const NO_TASKS_FOUND = 'No tasks found';
const NO_COMPLETED_TASKS_FOUND = 'No completed tasks found';
const GO_FOR_NEW_SIGNUP =
    'Please visit projects section and sign-up for new volunteering tasks';

//Tabbar title
const DETAILS_TAB = 'Details';
const POINT_TAB = 'Points';
const MY_REWARDS_TAB = 'My Rewards';
const REDEEM_TAB = 'Redeem';
const TRANSFER_POINT_TAB = 'Transfer Points';

//Chat
const CHAT_TITLE = 'Chat';
const ALL_USERS_TITLE = 'Volunteers in project';
const ENTER_MESSAGE_HINT = 'Enter Message';
const SART_CONVERSATION = 'Start Conversation';
const START_NEW_CONVERSATION = 'Start new conversation';

//Notification
const NO_NOTIFICATIONS_FOUND = 'No new notifications';
const FEEDBACK_LABEL = 'Feedback : ';
const REQUESTED_HRS = 'Reuested Hrs : ';
const APPROVED_HRS = 'Approved Hrs : ';
const HRS_LABEL = 'hrs';
const MINS_LABEL = 'mins';
const DASH_LABEL = ' - ';

//Profile
const CONTACT_TEXT = 'Contact';
const ABOUT_TEXT = 'About';
const ORGANIZATION_DETAILS_TEXT = 'Organization Details';
const PROJECT_PREFERENCES_TEXT = 'My Volunteering Preferences';
const COMPLETED_PROJECT_TEXT = 'Completed Projects';
const VOLUNTEER_REPORT_TEXT = 'Reports';
const MEMBER_SYNC_LABEL = 'Member Sync : ';
const ADD_NOW = 'Add now!';
const TELL_ME_ABOUT_YOUR_SELF = 'Tell me about your self';
const ORGANIZATION_TAX_ID_NUMBER = '• Tax ID No. : ';
const PROFIT_ORGANIZATION = '• Profile Organization';
const NON_PROFIT_ORGANIZATION = '• Non Profit organization';
const SIGN_OUT_POPUP_MENU = 'Sign Out';
const EDIT_PROFILE_MENU = 'Edit Profile';

//Edit profile
const EDIT_PROFILE_TEXT = 'Edit Profile';
const PROFILE_IMAGE_LABEL = 'Profile Image';
const PERSONAL_DETAILS_LABEL = 'Personal Details';
const EMAIL_LABEL = 'Email';
const DATE_OF_BIRTH_LABEL = 'Date of Birth';
const GENDER_LABEL = 'Gender';
const LIVING_INFO_LABEL = 'Living Info';
const ADDRESS_LABEL = 'Address';
const ZIPCODE_LABEL = 'Zip Code';
const CONTACT_INFO_LABEL = 'Contact Info';
const TARGET_HOURS_LABEL = 'Target Hours';
const AREA_OF_INTEREST_LABEL = 'Area of Interests';
const PERSONAL_PHN_LABEL = 'Personal Phone Number';
const PARENT_GUARDIAN_EMAIL_LABEL = 'Parent/Gaurdian Email';
const RELATION_LABEL = 'Relation with Parent/Guardian';
const STATE_LABEL = 'State';
const CITY_LABEL = 'City';
const SCHOOL_INFO_LABEL = 'School Info';
const SCHOOL_NAME_LABEL = 'School Name';
const GRADE_LEVEL_LABEL = 'Grade Level';

//Drop Down items
const SELECT_PARENT = 'Parent';
const SELECT_GAURDIAN = 'Guardian';
const SELECT_MALE = 'Male';
const SELECT_FEMALE = 'Female';
const SELECT_OTHER = 'Other';
const SLECT_DECLINE_TO_ANSWER = 'Decline to answer';

//Report screen
const REPORT_VOLUNTEERING_SUMMARY = 'Volunteering Summary';
const CHART_HOURS_VERTICAL_LABEL = 'H\no\nu\nr\ns';
const SERVICE_ACCOMPLISHMENTS_LABEL = 'Service Accomplishments';
const SERVICE_DETAILS_LABEL = 'Service Detail';
const CHART_HOURS_LABEL = 'Hours';
const CHART_MONTHS_LABEL = 'Months';

// Project Tab
const MY_PROJECTS_TAB = 'My Projects';
const OWN_TAB = 'Own';
const ENROLLED_TAB = 'Enrolled';
const PROJECT_UPCOMING_TAB = 'Upcoming';
const PROJECT_OPEN_TAB = 'Open';
const PROJECT_COMPLETED_TAB = 'Completed';
const PROJECT_CONTRIBUTION_TRACKER_TAB = 'Contribution Tracker';

//Project
const NO_PROJECTS_FOUNDS = 'No projects found';
const NO_PREFERENCES_FOUNDS = 'No preferences found';
const PLEASE_VISIT_OTHER = 'Please visit other categories section';
const NO_ACTIVITIES_FOUNDS = 'No activities found';

// Project categories
const VOLUNTEER_0 = 'Volunteer';
const FOOD_BANK_1 = 'Food Bank';
const TEACHING_2 = 'Teaching';
const HOMELESS_SHELTER_3 = 'Homeless Shelter';
const ANIMAL_CARE_4 = 'Animal Care';
const SENIOR_CENTER_5 = 'Senior Center';
const CHILDREN_AND_YOUTH_6 = 'Children and Youth';
const OTHER_7 = 'Other';

//Reorts
const MONTHLY_REPORTS_LABEL = 'Volunteer Activity Reports';
const ANALYSIS_LABEL = 'Analysis';
const UNFOLD_REPORT = 'Unfold Report ';
const MONTHY_HOURS = 'Monthly Hours';
const PROJECT_HOURS_LABEL = 'Project Hours';
const PROJECTS_LABEL = 'Projects : ';
const TOTAL_HRS_LABEL = 'Total volunteering hours : ';
const SERVICE_RECORDS = 'Service records';
const NO_RECORDS_FOUNDS = 'No records found';
const NO_ANALYST_FOUNDS =
    'No analyst record found, Go to project and do volunteering';

//Project sign up
const VOLUNTEER_EMAIL_LABEL = 'Volunteer Email';
const VOLUNTEER_NAME_LABEL = 'Volunteer Name';
const VOLUNTEER_PHONE_LABEL = 'Volunteer Phone';

//Appbar Title
const REWARDS_APPBAR = 'Rewards';
const PROJECT_APPBAR = 'Projects';
const REPORTS_APPBAR = 'Reports';
const MY_TAKS_APPBAR = 'My Tasks';
const PROJECT_SIGNUP_APPBAR = 'Project Sign-up';
const TASK_SIGNUP_APPBAR = 'Task Sign-up';
const EDIT_PROFILE_APPBAR = 'Edit Profile';
const TASK_DETAILS_APPBAR = 'Task Detail';
const PVSA_CHART_APPBAR = "President's Volunteer Service Award Chart";

//Member Tab
const NO_MEMBERS_AVAILABLE = 'No members available';

//Details Tab
const COLUMN_ONE = 'Age\nGroup\n(Yrs old)';
const COLUMN_TWO = 'Kids\n(5-10)';
const COLUMN_THREE = 'Teens\n(11-15)';
const COLUMN_FOUR = 'Youngs\nAdult\n(16–25)';
const COLUMN_FIVE = 'Adults\n(26+)';
const TOP_REWARD_DETAILS =
    'Star Points required to Earn Reward Badges in each Age Group';
const SECOND_REWARD_DETAILS_TEXT = '60 minutes contribution = 1 point';

//Points Tab
const BEGINNER_MEMBER = 'BEGINNER MEMBER';
const BRONZE_MEMBER = 'BRONZE MEMBER';
const SILVER_MEMBER = 'SILVER MEMBER';
const GOLD_MEMBER = 'GOLD MEMBER';
const LIFETIME_ACHIEVMENT = 'LIFETIME ACHIEVMENT';
const POINT_TO_REDEEM = 'Points to Redeem';
const MEMBER_SINCE = 'Member since';
const MEMBERSHIP_NUMBER = 'Membership number';
const EARNED_POINT = 'Lifetime points earned';
const EARN_POINTS = 'Earn ';
const REMAING_POINT_TO_GET_BADGE = ' more points to reach ';
const BEGINNER_BADGE = 'Beginner Badge';
const BRONZE_BADGE = 'Bronze Badge';
const SILVER_BADGE = 'Silver Badge';
const GOLD_BADGE = 'Gold Badge';
const LIFETIME_ACHIEVEMENT_BADGE = 'Lifetime Achievement Badge';

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

//User Project Sign-up
const CONTACT_PRO_LEAD = 'Contact Project Lead';

//Project expansion text
const LOCATION = 'Location';
const CONTACT = 'Contact';
const ENROLLMENTS_LABEL = 'Enrollments';
const NAME_TEXT = 'NAME';
const REVIEWS_TEXT = 'REVIEWS';
const RATING_TEXT = 'RATINGS';

//Appbar title
const CREATE_PROJECT_APPBAR = 'Create Project';
const EDIT_PROJECT_APPBAR = 'Edit Project';
const TASKS_APPBAR = 'Tasks';
const CREATE_TASK_APPBAR = 'Create Task';
const EDIT_TASK_APPBAR = 'Edit Task';
const MEMBERS_APPBAR = 'Members';
const PROJECTS_APPBAR = 'Projects';

//Button
const PUBLISH_PROJECT_BUTTON = 'Publish Project';
const UPDATE_BUTTON = 'Update';
const SAVE_BUTTON = 'Save';
const ADD_PROJECT_BUTTON = 'New Project';
const ADD_TASK_BUTTON = 'New Task';
const ADD_NEW_TASK_BUTTON = 'Create New Task';
const TASK_LIST_BUTTON = 'Task List';
const MEMBERS_LIST_BUTTON = 'Members List';
const DETAILS_BUTTON = 'Details';
const TASK_DETAILS_BUTTON = 'Task Details';
const SEARCH_MEMBERS_HINT = 'Search Members';

//Create project
const PROJECT_NAME_LABEL = 'Project Name';
const PROJECT_DESCRIPTION_LABEL = 'Project Description';
const PROJECT_LOCATION_LABEL = 'Project Location';
const PROJECT_CATEGORY_LABEL = 'Project Category';
const PROJECT_COLLABORATOR_LABEL = 'Collaborators/Co-Admin';
const MEMBERS_LABEL = 'Members';
const TASKS_LABEL = 'Tasks';
const HOURS_LABEL = 'Estimated Hours';
const STATUS_LABEL = 'Status';
const TIMELINE_LABEL = 'Timeline';
const PROJECT_INVITE_COLLABORATOR_LABEL = 'Invite Collaborators';
const PROJECT_NAME_HINT = 'Enter Name';
const PROJECT_DESCRIPTION_HINT = 'Enter Description';
const PROJECT_LOCATION_HINT = 'Search Location';
const PROJECT_START_DATE_HINT = 'Start Date';
const PROJECT_END_DATE_HINT = 'End Date';
const PROJECT_START_TIME_HINT = 'Start Time';
const PROJECT_END_TIME_HINT = 'End Time';
const PROJECT_CATEGORY_HINT = 'Enter Project Category';
const PROJECT_COLLABORATOR_HINT = 'Collaborators/Co-Admin';
const PROJECT_SEARCH_WITH_EMAIL_HINT = 'Search with email';
const TOGGLE_NOT_STARTED = 'Not Started';
const TOGGLE_INPROGRESS = 'In Progress';
const TOGGLE_COMPLETE = 'Complete';
const TO = 'to';
const COPY_LINK = 'Copy Link';
const PROJECT_COMPLETED = 'Completed';

//Create task
const TASK_NAME_LABEL = 'Task Name';
const TASK_DESCRIPTION_LABEL = 'Description';
const TASK_TIMELINE_LABEL = 'Timeline';
const TASK_MEMBERS_REQUIREMENT_LABEL = 'Members Requirements';
const TASK_MEMBERS_LABEL = '# of Members';
const TASK_MINIMUM_AGE_LABEL = 'Minimum Age';
const TASK_QUALIFICATION_LABEL = 'Any Qualification';
const START_DATE_LABEL = 'Start Date : ';
const END_DATE_LABEL = 'End Date : ';
const TASK_NAME_HINT = 'Enter Task Name';
const TASK_DESCRIPTION_HINT = 'Enter Task Description';
const TASK_MEMBERS_REQUIREMENT_HINT = 'Enter no of Members';
const TASK_MINIMUM_AGE_HINT = 'Enter Minimum Age';
const TASK_QUALIFICATION_HINT = 'Enter Qualification';
const TASK_END_HINT = 'End Date';
const SELECT_MEMBER_LABEL = 'Select Members';
const POST_ON_LOCAL_FEED = 'Post on Local Feed';
const SELECTED_HOURS_LABEL = 'Selected Hours';
const ENTER_ESTIMATED_HOURS_HINT = 'Enter estimated hours';
const WAITING_FOR_APPROVAL = 'Waiting for log hours approval';
const LOG_HRS = 'Log Hrs';
const LOG_HRS_APPROVED = 'Log Hrs Approved';

const NOT_STARTED_TASKS = 'Not Started Tasks';
const COMPLETED_TASKS = 'Completed Tasks';
const INPROGRESS_TASKS = 'In Progress Tasks';

const SAMPLE_LONG_TEXT =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
    " when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    " It has survived not only five centuries, but also the leap into electronic typesetting,"
    " remaining essentially unchanged. "
    "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,"
    " and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

//Dropdowns
List<String> gendersItems = [
  SELECT_MALE,
  SELECT_FEMALE,
  SELECT_OTHER,
  SLECT_DECLINE_TO_ANSWER
];

List<String> relationShips = [SELECT_PARENT, SELECT_GAURDIAN];

List<String> gradeLevels = [
  '6th',
  '7th',
  '8th',
  '9th',
  '10th',
  '11th',
  '12th',
  'College',
];

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

List<MenuModel> dashBoardMenuList = [
  MenuModel(
    id: 0,
    asset: 'assets/images/projects.png',
    label: PROJECTS_TILE,
  ),
  MenuModel(
    id: 1,
    asset: 'assets/images/tasks.png',
    label: MY_TASKS_TILE,
  ),
  MenuModel(
    id: 2,
    asset: 'assets/images/reports.png',
    label: REPORTS_TILE,
  ),
  MenuModel(
    id: 3,
    asset: 'assets/images/tracker.png',
    label: TIME_TRACKER_TILE,
  ),
];

List<CategoryModel> categoriesList = [
  CategoryModel(
    id: 0,
    asset: 'assets/images/volunteer.png',
    label: VOLUNTEER_0,
  ),
  CategoryModel(
    id: 1,
    asset: 'assets/images/food_bank.png',
    label: FOOD_BANK_1,
  ),
  CategoryModel(
    id: 2,
    asset: 'assets/images/teaching.png',
    label: TEACHING_2,
  ),
  CategoryModel(
    id: 3,
    asset: 'assets/images/homeless_shelter.png',
    label: HOMELESS_SHELTER_3,
  ),
  CategoryModel(
    id: 4,
    asset: 'assets/images/animal_care.png',
    label: ANIMAL_CARE_4,
  ),
  CategoryModel(
    id: 5,
    asset: 'assets/images/cenior_center.png',
    label: SENIOR_CENTER_5,
  ),
  CategoryModel(
    id: 6,
    asset: 'assets/images/children_and_youth.png',
    label: CHILDREN_AND_YOUTH_6,
  ),
  CategoryModel(
    id: 7,
    asset: 'assets/images/other.png',
    label: OTHER_7,
  ),
];

Map<String, dynamic> rewardsList = {
  'Age\nGroup\n(Yrs old)': {
    'asset': '',
    'points': [
      {
        'title': 'Kids',
        'rating': 0,
        'points': 0,
        'to': 5,
        'from': 10,
      },
      {
        'title': 'Teens',
        'rating': 0,
        'points': 0,
        'to': 11,
        'from': 15,
      },
      {
        'title': 'Youngs',
        'rating': 0,
        'points': 0,
        'to': 16,
        'from': 25,
      },
      {
        'title': 'Adults',
        'rating': 0,
        'points': 0,
        'to': 26,
        'from': 26,
      },
    ],
  },
  'Beginner': {
    'asset': 'assets/images/medal_beginer.png',
    'points': [
      {
        'rating': 10,
        'points': 10,
        'to': 1,
        'from': 25,
      },
      {
        'rating': 10,
        'points': 10,
        'to': 1,
        'from': 49,
      },
      {
        'rating': 10,
        'points': 10,
        'to': 1,
        'from': 99,
      },
      {
        'rating': 10,
        'points': 10,
        'to': 1,
        'from': 99,
      },
    ],
  },
  'Bronze': {
    'asset': 'assets/images/medal_bronze.png',
    'points': [
      {
        'rating': 50,
        'points': 50,
        'to': 26,
        'from': 49,
      },
      {
        'rating': 50,
        'points': 50,
        'to': 50,
        'from': 74,
      },
      {
        'rating': 50,
        'points': 50,
        'to': 100,
        'from': 174,
      },
      {
        'rating': 50,
        'points': 50,
        'to': 100,
        'from': 249,
      },
    ],
  },
  'Silver': {
    'asset': 'assets/images/medal_silver.png',
    'points': [
      {
        'rating': 100,
        'points': 100,
        'to': 50,
        'from': 74,
      },
      {
        'rating': 100,
        'points': 100,
        'to': 75,
        'from': 99,
      },
      {
        'rating': 100,
        'points': 100,
        'to': 175,
        'from': 249,
      },
      {
        'rating': 100,
        'points': 100,
        'to': 250,
        'from': 499,
      },
    ],
  },
  'Gold': {
    'asset': 'assets/images/medal_gold.png',
    'points': [
      {
        'rating': 150,
        'points': 150,
        'to': 75,
        'from': 75,
      },
      {
        'rating': 150,
        'points': 150,
        'to': 100,
        'from': 100,
      },
      {
        'rating': 150,
        'points': 150,
        'to': 250,
        'from': 250,
      },
      {
        'rating': 150,
        'points': 150,
        'to': 500,
        'from': 500,
      },
    ],
  },
  'Lifetime\nAchievement': {
    'asset': 'assets/images/trophy.png',
    'points': [
      {
        'rating': 200,
        'points': 200,
        'to': 4000,
        'from': 4000,
      },
      {
        'rating': 200,
        'points': 200,
        'to': 4000,
        'from': 4000,
      },
      {
        'rating': 200,
        'points': 200,
        'to': 4000,
        'from': 4000,
      },
      {
        'rating': 200,
        'points': 200,
        'to': 4000,
        'from': 4000,
      },
    ],
  },
};

List<String> volunteerProjectImage = [
  'assets/images/volunteer_1.jpg',
  'assets/images/volunteer_2.jpg',
  'assets/images/volunteer_3.png',
];

List<String> childrenYouthProjectImage = [
  'assets/images/children_youth_1.jpg',
  'assets/images/children_youth_2.jpg',
  'assets/images/children_youth_3.jpg',
];

List<String> fooBankProjectImage = [
  'assets/images/food_bank_1.jpg',
  'assets/images/food_bank_2.jpg',
  'assets/images/food_bank_3.png',
];

List<String> seniorCenterProjectImage = [
  'assets/images/senior_center_1.jpg',
  'assets/images/senior_center_2.jpg',
  'assets/images/senior_center_3.jpg',
];

List<String> teachingProjectImage = [
  'assets/images/teaching_1.jpg',
  'assets/images/teaching_2.jpg',
  'assets/images/teaching_3.jpg',
];

List<String> animalCareProjectImage = [
  'assets/images/animal_care_1.jpg',
  'assets/images/animal_care_2.jpg',
  'assets/images/animal_care_3.jpg',
];

List<String> homelessSeleterProjectImage = [
  'assets/images/homeless_seleter_1.jpg',
  'assets/images/homeless_seleter_2.jpg',
  'assets/images/homeless_seleter_3.jpg',
];

List<String> otherProjectImage = [
  'assets/images/other_1.png',
  'assets/images/other_2.PNG',
  'assets/images/other_3.jpg',
];

int generateIds() {
  final rng = Random();
  int randomInt;
  randomInt = rng.nextInt(100);
  return randomInt;
}
