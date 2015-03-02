#pragma mark - App Constant

//#define APP_NAME                              @"Consumer App"
#define Alert_Ok_Button                         NSLocalizedString(@"OK", nil)
#define Alert_Cancel_Button                     NSLocalizedString(@"Cancel", nil)
#define Internet_Not_Available                  NSLocalizedString(@"Please check your internet connection.", nil)
#define ERROR_INTERNET                          NSLocalizedString(@"Connection Error. Please check your internet connection and try again.", nil)
#define ERROR_TIMEOUT						    NSLocalizedString(@"Timeout error. Please check your internet connection and try again.", nil)


#define Embrima     @"Ebrima"
#define Ebrima_Bold  @"Ebrima-Bold"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

 #define NSCalederUnit  NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
#define kSAAPIBaseURLString @"http://10.1.1.18/DemMobile/" //local server path

#define  transactionPicURL  @"http://10.1.1.22/DemMobile/PicUrl/transaction_pics/"
#define  reminderPicURL  @"http://10.1.1.22/DemMobile/PicUrl/reminder_pics/"
#define  categoryPicURL  @"http://10.1.1.22/DemMobile/PicUrl/category_pics/"


//#define  transactionPicURL  @"http://68.169.58.198/DemMobile/PicUrl/transaction_pics/"
//#define  reminderPicURL  @"http://68.169.58.198/DemMobile/PicUrl/reminder_pics/"
//#define  categoryPicURL  @"http://68.169.58.198/DemMobile/PicUrl/category_pics/"


#define DATEFORMATTER @"yyyy-MM-dd HH:mm:ss"
#define TIMEFORMATTER @"yyyy-MM-dd HH:mm:ss"

#define DATEFORMATTER2 @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
#define TIMEFORMATTER2 @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"

#define SharedPreferences preferences = null;
#define  CURRENT_CURRENCY_TIMESTAMP  @"CurrentCurrencyTimeStamp "
#define  POPUP_SESSION_STARTED  @"popup_session_started "

#define  LOGOUT_DONE_ACCORDINGTOKEN  @"logout_according_token "
#define  FORCEFULL_FORGOT_PASSWORD  @"forcefull_forgot_pass "
#define  GMAIL_LOGIN_DONE  @"gmail_login_done "
#define  CURRENT_TOKEN_ID_SELECTED_INSIDE  @"currentTokenIdSelectedInside "
#define  MIN_DATE  @"minDate "

#define  OPENED_FIRSTTIME  @"app_opened_first_time "
#define  TWO_DAYS_GAP_TO_SHOW_POPUP  @"gap_period_to_show_popup "
#define  FACEBOOK_LIKE  @"facebook_like "
#define  GOOGLE_LIKE  @"google_like "
#define  REVIEW  @"review "
#define  NO_ADS_BOUGHT  @"no_ads_bought "
// ////////////DATE_FORMAT 0 for mmddyyyy //// DATE_FORMAT 1 ddmmyyyy

#define  MAIN_TOKEN_ID_DIALOG  @"TokenIdDialogVal "
#define  ADD_CATEGORY_PAYMENTMODE  @"addDistinctCategoryPaymentMode "
#define  REMOVE_DUPLICATE_ENTRIES  @"removeDuplicateEntries "
#define  LANGUAGE_DATA_CONVERSION  @"languageDataConversion "
#define  IsExportPathShown  @"isexportpathshown "
#define  IsViewReportPathShown  @"isviewreportpathshown "
#define  IsDemDirectoryVisible  @"isdemdirectoryvisible "
#define  POPUP_TO_SHOW_VAL  @"popup_to_show "
#define  UPDATE_AVAILABLE  @"update_available "
#define  UPDATE_MESSAGE  @"update_message "
#define  UPDATE_URL  @"update_url "
#define  HOMESCREEN_COUNTER  @"home_screen_counter "
#define  GUEST_EMAIL_SEND  @"guest_email_send "
#define  LastSynced  @"lastsynced "

//***************************************************************************
#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//***************************************************************************

#define HelveticaNeue               @"HelveticaNeue"
#define HelveticaNeueBold           @"HelveticaNeue-Bold"
#define HelveticaNeueLight          @"HelveticaNeue-Light"
#define HelveticaNeueMedium         @"HelveticaNeue-Medium"

#pragma mark - Define Color

#define GRAY_COLOR [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0]
#define BLUE_COLOR [UIColor colorWithRed:45/255.0 green:95/255.0 blue:221/255.0 alpha:1.0]
//#define GREEN_COLOR [UIColor colorWithRed:62/255.0 green:145/255.0 blue:13/255.0 alpha:1.0]
#define GREEN_COLOR  [UIColor colorWithRed:0/255.0f green:150/255.0f blue:136/255.0f alpha:1.0f]

#pragma mark - Facebook Notification

#define GetFacebookUserInfoNotification               @"GetFacebookUserInfoNotification"
//GetFacebookAccessToken
#define GetFacebookAccessToken                        @"GetFacebookAccessToken"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define ACCEPTABLE_CHARECTERS @"0123456789."
#define  SERVICE_URL @"http://68.169.58.198/DemMobile/DemService/ServiceData/Register"

#define  DEFAULT_TOKEN_ID   @"0_GUEST"

#define LAST_TABLE_COUNT  @"last_table_count"
#define LAST_TABLE_TYPE  @"last_table_type"


#define  DEVICE_ID   @"deviceid"
#define  NAME   @"name"
#define  EMAIL_ADDRESS   @"email"
#define  USER_PIC   @"avatar"
#define  CALL_NAME  @"cn"
#define  TIMEZONE   @"timezone"
#define  DOB   @"dob"
#define  PASSWORD   @"password"
#define  DATE_FORMAT   @"date_format"
#define  STATUS   @"status"
#define  SERVICE_MESSAGE   @"message"
#define  TOKEN_ID   @"TokenId"
#define  Account_ID   @"AccountId"
#define  DATA   @"data"
#define  CODE   @"security_code"
#define  RESET_TOKEN   @"reset_token"
#define  RETRY  @"retry"
#define  DEVICE_NAME  @"device_name"

// /////////////////////////////////////////////////////////////////////////
// //Transaction Add Edit Delete Added
#define  PIC_DESCRIPTION  @"description"
#define  CATEGORYNAME  @"category"
#define  SUB_CATEGORY   @"sub_category"
#define  HIDE_STATUS   @"hide_status"
#define  PAYMENT_MODE   @"paymentmode"
#define  CURRENCY   @"currency"
#define  INCOME_DATE   @"transaction_date"
#define  BUDGET_FROM   @"budget_date_from"
#define  BUDGET_TO   @"budget_date_to"
#define  PRICE   @"price"
#define  ATTACHMENT   @"attachments"
#define  WARRANTY   @"warranty"
#define  WITH_PERSON   @"person"
#define  LOCATION   @"location"
#define  TRANSACTION_ID  @ "transaction_id"
#define  TRANSACTION_TYPE   @"transaction_type"
#define  ACCOUNT_ID  @"account_id"
#define  HEADING   @"reminder_heading"
#define  RECURRING_TYPE   @"reminder_recurring_type"
#define  REMINDER_TIME_PERIOD   @"reminder_time_period"
#define  REMINDER_WHEN_TO_ALERT   @"reminder_when_to_alert"
#define  REMINDER_HAS_SUB_ALARM   @"reminder_sub_alarm"
#define  REMINDER_ALARM_INVOKED   @"reminder_alarm"
#define  REMINDER_ALERT_ON   @"reminder_alert"
#define  USER_TOKEN_ID   @"usertoken_id"
#define  USER_TOKEN_ID_FROM   @"usertoken_id_from"
#define  USER_TOKEN_ID_TO   @"usertoken_id_to"
#define  INCOME_ID   @"income_id"
#define  EXPENSE_ID   @"expense_id"
#define  DATABASE_TYPE  @"databaseType"
#define  UPDATION_ON_SERVER_TIME   @"updateon_server"
#define  ACCOUNT_CREATED_DATE   @"created_date"
#define  SUBACCOUNTS_LIST  @ "subaccounts"
// /////////////////////////////////////////////////////////////////
#define  REGISTER   @"Register"
#define  LOGIN      @"Login"
#define  FORGOT_PASS   @"ForgotPass"
#define  UPDATE_PASS   @"UpdatePass"
#define  RETRIEVE_CODE   @"RetrieveCode"
#define  FORGOT_PASS_LOCK   @"ApplockSecurityCode"
#define  SET_LOCK   @"ApplockRegister"
#define  SET_IMEI   @"imei_id"
#define  RETRIEVE_CODE_LOCK   @"ApplockResetSecurityCode"
// /////////////////////////////////////////////////////////////////////////
#define  PIE_CHART  @ "HomeScreenPie"
#define  INCOME   @"income"
#define  EXPENSE  @ "expense"
#define  URL_ADDRESS   @"url_address"


// /////////////////////////FRAGMENTS IDS
#define  ADD_TRANSACTION_FRAGMENT_TAG   @"1"
#define  SELECT_CATEGORY_FRAGMENT_TAG   @"2"
#define  ADD_CATEGORY_FRAGMENT_TAG   @"3"
#define  SHOW_ALL_REMINDERS_FRAGMENT_TAG   @"4"
#define  ADD_REMINDER_FRAGMENT_TAG   @"5"
#define  SHOW_ALL_PENDING_FRAGMENT_TAG   @"6"
#define  SELECT_REMINDER_CATEGORY_FRAGMENT_TAG   @"7"
#define  SELECT_TRANSFER_CATEGORY_FRAGMENT_TAG   @"8"
#define  SELECT_BUDGET_CATEGORY_FRAGMENT_TAG   @"12"
#define  ADD_TRANSFER_FRAGMENT_TAG   @"9"
#define  ADD_BUDGET_FRAGMENT_TAG   @"10"
#define  ADD_ACCOUNT_FRAGMENT_TAG   @"18"

#define  SHOW_ALL_BUDGET_FRAGMENT_TAG   @"11"
#define  SHOW_ALL_TRANSFER_FRAGMENT_TAG   @"13"
#define  SHOW_ALL_TRANSACTIONS_FRAGMENT_TAG   @"14"
#define  SHOW_ALL_ACCOUNTS_FRAGMENT_TAG   @"15"
#define  SHOW_ALL_DETAILS_FRAGMENT_TAG   @"16"
#define  SHOW_ALL_WARRANTY_FRAGMENT_TAG   @"17"
#define  SHOW_OVERALL_HISTORY_FRAGMENT_TAG  @"19"
#define  FRAGMENTLOGIN   @"20"
#define  FRAGMENTFORGOT_PASS   @"21"
#define  FRAGMENTUPDATE_PASSWORD  @"22"
#define  SELECT_PAYMENTMODE_FRAGMENT_TAG   @"23"
#define  ADD_PAYMENTMODE_FRAGMENT_TAG   @"24"
#define  SETTINGS_FRAGMENT   @"25"
#define  CURRENCY_FRAGMENT   @"26"
#define  IMAGEVIEW_FRAGMENT   @"27"
#define  FRAGMENTRETREIVE_CODE   @"28"
#define  FRAGMENTLOCK   @"30"
#define  FRAGMENT_PASSWORD_PROTECTION   @"31"
#define  HOME_SCREEN_FRAGMENT   @"32"

// /////////////////////BASIC ANTS
#define  ROW_ID_REMINDER   @"rowId"
#define  TRANSACTIONID   @"transactionId"
#define  MFacebook_Like_URL   @"https://www.facebook.com/dailyexpensemanager"
#define  DEMPAGE_ID   @"615697788479823"



#define PICK_FROM_CAMERA ((int) 1)
#define PICK_FROM_FILE  ((int)3)
#define CROP_FROM_CAMERA   ((int)2)
#define  VALUE   @"VALUE"
#define  QUICK   @"QUICK"
#define  DETAIL   @"DETAIL"
#define  BEAN_TO_BE_EDITED   @"TransactionBean"
#define Add_Milles ((int)0)
#define TYPE_INCOME   ((int)1)
#define TYPE_EXPENSE  ((int) 0)
#define TYPE_PENDING  ((int) 2)
#define  TYPE_REMINDER ((int)  3)
#define TYPE_TRANSFER  ((int) 4)
#define TYPE_BUDGET   ((int)5)
#define TYPE_CATEGORY  ((int) 6)
#define TYPE_PAYMENT   ((int)7)
#define TYPE_MAIN_ACCOUNT   ((int)8)
#define TYPE_SUB_ACCOUNT  ((int)9)

#define  TYPE_ADDED  ((int) 0)
#define TYPE_EDITED  ((int) 1)
#define TYPE_DELETED  ((int) 2)



//#define TRANSACTION_INSERTED_FROM ((int)12)
// //////////////////////////////////////////////CALL NAMES ALL

#define  CALLNAME_ADD   @"addTransaction"
#define  CALLNAME_EDIT   @"editTransaction"
#define  CALLNAME_DELETE  @ "deleteTransaction"
#define  CALLNAME_ADD_REMINDER   @"addReminder"
#define  CALLNAME_EDIT_REMINDER   @"editReminder"
#define  CALLNAME_DELETE_REMINDER   @"deleteReminder"
#define  CALLNAME_ADD_TRANSFER  @ "addTransfer"
#define  CALLNAME_EDIT_TRANSFER   @"editTransfer"
#define  CALLNAME_DELETE_TRANSFER   @"deleteTransfer"
#define  CALLNAME_ADD_BUDGET   @"addBudget"
#define  CALLNAME_EDIT_BUDGET   @"editBudget"
#define CALLNAME_DELETE_BUDGET   @"deleteBudget"
#define  CALLNAME_ADD_CATEGORY   @"addCategory"
#define  CALLNAME_EDIT_CATEGORY   @"editCategory"
#define CALLNAME_DELETE_CATEGORY   @"deleteCategory"
#define  CALLNAME_ADD_PAYMENTMODE   @"addPaymentMode"
#define  CALLNAME_EDIT_PAYMENTMODE   @"editPaymentMode"
#define  CALLNAME_DELETE_PAYMENTMODE   @"deletePaymentMode"
#define  CALLNAME_GET_ADDED   @"getAddedTransaction"
#define  CALLNAME_GET_EDITED   @"getEditedTransaction"
#define  CALLNAME_GET_DELETED   @"getDeletedTransaction"
#define  CALLNAME_GET_ALL   @"getAllTransaction"
#define  CALLNAME_ADD_SUBACCOUNT   @"addSubaccount"
#define CALLNAME_EDIT_SUBACCOUNT   @"editSubaccount"
#define  CALLNAME_EDIT_MAINACCOUNT   @"editMainAccount"
#define CALLNAME_DELETE_SUBACCOUNT   @"deleteSubaccount"
#define THEME  @"AppColorTheme"
#define POLICY_AND_TERMS  @"PolicyTerms"
#define CURRENT_CURRENCY  @"CurrentCurrency"
#define CURRENT_USER__TOKEN_ID @"currentuser"
#define CURRENT_CITY @"currentcity"
#define DATE_PERIOD  @"DatePeriod"
#define MAIN_CATEGORY_SELECTED  @"MainCategorySelectedPos"
#define MAIN_PAYMENTMODE_SELECTED  @"PaymentModeSelectedPos"
#define MAIN_CATEGORY_WITH_SUBCATEGORY_SELECTED  @"MainCategorySubCategorySelectedPos"
#define EDIT_CATEGORY_DATA  @"EditCategoryData"
#define ADDED_THROUGH_WIDGET  @"WidgetTransaction"
#define CITY_SELECTED  @"selectcity"
#define CITY_SELECTED_AGAIN  @"selectcityagain"
#define SESSION_STARTED  @"session_started"
#define LOGIN_DONE  @"login_done"

#define DOWNLOAD_STARTED  @"download_started"
#define MAX_DATE  @"maxDate"
#define MONTH_DIFFERENCE  @"monthDifference"
#define WEEK_DIFFERENCE  @"weekDifference"
#define DAYS_DIFFERENCE  @"daysDifference"
#define YEARS_DIFFERENCE  @"yearsDifference"
#define START_END_TIME  @"start_end_time"
#define CITY_SELECTED_FIRST_TIME  @"selectcityfirsttime"
#define OTHER_APP_DB_DATA_COPIED  @"otherapps_db_data"
#define DEM_IMAGES_FOLDER  @"dem_images"
#define LOCK_SCREEN_PASSWORD  @"Password"
#define PasswordProtectionCheckBox  @"PasswordChange"
// ////////////DATE_FORMAT 0 for mmddyyyy //// DATE_FORMAT 1 ddmmyyyy

#define CURRENT_TOKEN_ID  @"AccountTokenId"
#define MAIN_TOKEN_ID  @"TokenId"
#define INCOME_CHECKBOX  @"incomecheckbox"
#define EXPENSE_CHECKBOX  @"expensecheckbox"
#define UpgradeFromDemFreeToDemNew  @"upgradeFromDemFree"
#define EDIT_DATA_UPGRADE  @"editDataUpgrade"
#define ADDD_DATA_UPGRADE  @"addDataUpgrade"
#define ADD_SUB_ACCOUNT  @"addSubaccount"
#define EDIT_SUB_ACCOUNT  @"editSubaccount"
#define DELETE_SUB_ACCOUNT  @"deleteSubaccount"
#define UPDATE_MAIN_ACCOUNT @"updateMainAccount"
#define DELEETE_DATA_UPGRADE  @"deleteDataUpgrade"



#define SECURITY_SCREEN_TIME  @"securityscreentime"
#define RETEIVE_PASS_TOKEN  @"retreivepasstoken"
#define OLD_CURRENCY  @"STRING_WISE_CURRENCY"
#define OLD_CURRENCY_INDEX_WISE  @"index"
#define CURRENT_CURRENCY  @"CurrentCurrency"
#define BIRTHDAY   @"birthday"
#define GOOGLE_PLUS_PROFILE   @"google_plus_profile"
#define LANGUAGE   @"language"
#define MAX_AGE   @"max_age"
#define RELEATIONSHIP   @"relationship"
#define MIN_AGE   @"min_age"
#define LOGIN_TYPE   @"login_type"
#define APP_VERSION   @"app_version"
#define VERSION_CODE   @"version_code"
#define CATEGORY_COMBINATION   @"boolean"
#define PACKAGE   @"package_name"
#define APPSTORE   @"appstore"
// /////////////////////////////////////////////////////////////////////////
// //Transaction Add Edit Delete Added
#define CATEGORY   @"category"
#define TRANSACTION_REFERENCE_ID   @"transaction_reference_id"
#define MCC   @"mcc"
#define DATE_FORMAT_ACTUAL   @"MM-dd-yyyy"
#define DATE_FORMAT_OTHER   @"dd-MM-yyyy"
// /////////////////////////////////////////////////////////////////
#define GMAIL_LOGIN   @"GmailLogin"
#define LOGOUT   @"Logout"
#define FORGOT_PASS_FORCEFULL   @"ForgotPassForcefull"
#define FORCE_LOGIN_RESPONSE   @"force_login"
#define FORCE_LOGIN   @"forceLogin"
#define CHECK_ACTIVE_USER   @"checkLogin"
// /////////////////////////////////////////////////////////////////////////

#define PATH_FOR_EXPORTED_DATA   @"/DEM_NEW/ExportData/"
#define  TYPE_XLS ((int) 10)
#define  TYPE_PDF ((int) 11)
#define  TYPE_ALL ((int) 12)
// //////////////////////Pics URL for data export
//#define transactionPicURL   @"http://68.169.58.198/DemMobile/PicUrl/transaction_pics/"
//#define reminderPicURL   @"http://68.169.58.198/DemMobile/PicUrl/reminder_pics/"
//#define categoryPicURL   @"http://68.169.58.198/DemMobile/PicUrl/category_pics/"

#define NONE   @"None"
#define BOTH   @"Both"
#define WARANTY_SCREEN   @"WarrantyScreen"
#define NEWLY_ADDED   @"Recent Transactions"
#define OLD_ADDED   @"Old Transactions"
#define HIGHEST_AMOUNT   @"Highest Amount"
#define LOWEST_AMOUNT   @"Lowest Amount"
#define CATEGORY_TEXT   @"Category"
#define PAYMENT_MODE_TEXT   @"Payment Mode"
#define CATEGORY_PAYMENT_BOTH   @"Category_Payment"

// /////////////////////////////////////


// /////////////////////////FRAGMENTS IDS

#define SHOW_ALL_BUDGET_SUMMING_DETAILS_FRAGMENT_TAG   @"29"

#define CUSTOM_EXPORT_FRAGMENT   @"33"
#define USER_ACCOUNT_FRAGMENT   @"34"
#define CHANGE_PROFILE_FRAGMENT   @"35"
#define CHANGE_LOG_FRAGMENT   @"36"

#define  VISIBILITY_0N ((int) 0)
#define  VISIBILITY_OFF ((int) 1)

// /////////////////////BASIC CONSTANTS

#define  PICK_FROM_CAMERA ((int) 1)
#define lockscreen_shown ((int) 1)

#define  TYPE_BOTH_INCOME_EXPENSE ((int) -1)

#define  TYPE_EXPENSE ((int) 0)
#define  TYPE_PENDING ((int) 2)
#define  TYPE_REMINDER ((int) 3)
#define  TYPE_TRANSFER ((int) 4)

#define  TYPE_CATEGORY ((int) 6)

#define  USER_ACCOUNT ((int) 10)
#define  TYPE_TRANSACTION ((int) 11)
#define  TYPE_WARRANTY ((int) 12)

#define  TYPE_ADDED ((int) 0)
#define  TYPE_EDITED ((int) 1)
#define  TYPE_DELETED ((int) 2)
// //////////////////////////////////////////////CALL NAMES ALL

#define CALLNAME_EDIT_CURRENCY   @"editCurrency"
#define CALLNAME_GETUPDATE   @"getPromotionurl"
#define CALLNAME_DEM_DIRECTORY   @"getMcccode"



