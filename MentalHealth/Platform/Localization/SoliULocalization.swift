//
//  SoliULocalization.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/1/25.
//

import Foundation

//Add Localization here
public enum SoliULocalizationKey: String, CaseIterable {
    case home = "home"
    case day = "day"
    case account = "account"
    
    //Home
    case quoteOfTheDay = "quote_of_the_day"
    case weeklyMoodLog = "weekly_mood_log"
    case yes = "yes"
    case no = "no"
    case selfTest = "self_test"
    case aiCounselorHome = "ai_counselor"
    case steps = "steps"
    case mentalhealthScore = "mentalhealth_score"
    case usageTime = "usage_time_label"

    //login
    case genderTitle = "gender_title"
    case male = "male"
    case female = "female"
    case other = "other"
    case welcomeBack = "welcome_back"
    case signInPrompt = "sign_in_prompt"
    case email = "email"
    case enterEmail = "enter_email"
    case password = "password"
    case enterPassword = "enter_password"
    case forgotPassword = "forgot_password"
    case signIn = "sign_in"
    case noAccount = "no_account"
    case signUp = "sign_up"
    case continueAsGuest = "continue_as_guest"
    case forgotPasswordTitle = "forgot_password_title"
    case forgotPasswordDescription = "forgot_password_description"
    case emailPlaceholder = "email_placeholder"
    case sendCodeButton = "send_code_button"
    case codeSentMessage = "code_sent_message"
    case ok = "ok"
    case passwordLengthWarning = "password_length_warning"
    case alreadyHaveAccount = "already_have_account"
    case login = "login"
    case correctPassword = "correct_password"
    case incorrectPassword = "incorrect_password"
    case confirmPassword = "confirm_password"
    case enterYourDetails = "enter_your_details"
    case whatsYourAge = "whats_your_age"
    case enterYourAge = "enter_your_age"
    case whatsYourCurrentStatus = "whats_your_current_status"
    case student = "student"
    case employed = "employed"
    case whatsYourEthnicity = "whats_your_ethnicity"
    case americanIndian = "americanIndian"
    case alaskaNative = "alaskaNative"
    case asian = "asian"
    case black = "black"
    case africanAmerican = "africanAmerican"
    case nativeHawaiian = "nativeHawaiian"
    case otherPacificIslander = "otherPacificIslander"
    case white = "white"
    case enterYourNickname = "enter_your_nickname"
    case whatsYourNickname = "whats_your_nickname"
    case confirmDataTitle = "confirm_data_title"
    case nickname = "nickname"
    case gender = "gender"
    case age = "age"
    case status = "status"
    case ethnicity = "ethnicity"
    case confirm = "confirm"
    case continueAsGuestTitle = "continue_as_guest_title"
    case continueAsGuestDescription = "continue_as_guest_description"
    /// Navigation
    case next = "next"
    case submit = "submit"

    //Firebase Auth Error
    case resetFailed = "reset_failed"
    case invalidEmailTitle = "invalid_email_title"
    case invalidEmailMessage = "invalid_email_message"
    case emailNotFoundTitle = "email_not_found_title"
    case emailNotFoundMessage = "email_not_found_message"
    case tooManyAttemptsTitle = "too_many_attempts_title"
    case tooManyAttemptsMessage = "too_many_attempts_message"
    case networkErrorTitle = "network_error_title"
    case networkErrorMessage = "network_error_message"

    //Error alert
    case missingInformationTitle = "missing_information_title"
    case missingInformationMessage = "missing_information_message"

    /// Account Key
    case guest = "guest"
    case medicalReference = "medical_reference"
    case disclaimerText = "disclaimer_text"
    case languageSetting = "language_setting"
    case setting = "setting"
    case visitWebsite = "visit_website"
    case demographics = "demographics"
    case update = "update"
    case version = "version"
    case latestVersion = "latest_version"
    case editProfile = "edit_profile"
    case upToDate = "up_to_date"
    case youAreUpToDate = "you_are_up_to_date"
    case feedback = "feedback"
    case createAccount = "create_account"
    case deleteAccount = "delete_account"
    case deleteAccountDescription = "delete_account_description"
    case feedbackTitle = "feedback_title"
    case feedbackSubTitle = "feedback_sub_title"
    case currentStatus = "current_status"
    case logOut = "log_out"
    case logoutConfirmation = "logout_confirmation"
    case deleteAccountConfirmation = "delete_account_confirmation"
    case goToLoginPage = "goToLoginPage"

    /// Answer Choices
    case veryRarely = "very_rarely"
    case rarely = "rarely"
    case sometimes = "sometimes"
    case often = "often"
    case veryOften = "very_often"

    //// Test start
    case beforeWeStart = "before_we_start"
    case testComposedOf = "test_composed_of"
    case testSections = "test_sections"
    case testStartProceeding = "test_start_proceeding"
    case start = "start"
    case seeMyResult = "see_my_result"

    /// Test 1: Depression
    case testOneDepression = "test_one_depression"
    case testOneFirstQuestion = "test_one_first_question"
    case testOneSecondQuestion = "test_one_second_question"
    case testOneThirdQuestion = "test_one_third_question"
    case testOneForthQuestion = "test_one_forth_question"
    case testOneFifthQuestion = "test_one_fifth_question"

    // Test 2: Anxiety
    case testTwoAnxiety = "test_two_anxiety"
    case testTwoFirstQuestion = "test_two_first_question"
    case testTwoSecondQuestion = "test_two_second_question"
    case testTwoThirdQuestion = "test_two_third_question"
    case testTwoForthQuestion = "test_two_forth_question"
    case testTwoFifthQuestion = "test_two_fifth_question"

    // Test 3: Stress
    case testThreeStress = "test_three_stress"
    case testThreeFirstQuestion = "test_three_first_question"
    case testThreeSecondQuestion = "test_three_second_question"
    case testThreeThirdQuestion = "test_three_third_question"
    case testThreeForthQuestion = "test_three_forth_question"
    case testThreeFifthQuestion = "test_three_fifth_question"
    
    // Test 4: Social Media Addiction
    case testFourSocialMediaAddiction = "test_four_social_media_addiction"
    case testFourFirstQuestion = "test_four_first_question"
    case testFourSecondQuestion = "test_four_second_question"
    case testFourThirdQuestion = "test_four_third_question"
    case testFourForthQuestion = "test_four_forth_question"
    case testFourFifthQuestion = "test_four_fifth_question"

    // Test 5: Loneliness
    case testFiveLoneliness = "test_five_loneliness"
    case testFiveFirstQuestion = "test_five_first_question"
    case testFiveSecondQuestion = "test_five_second_question"
    case testFiveThirdQuestion = "test_five_third_question"
    case testFiveForthQuestion = "test_five_forth_question"
    case testFiveFifthQuestion = "test_five_fifth_question"
     
    // Test 6 HRQOL
    case testSixHRQOL = "test_six_hrqol"
    case testSixFirstQuestion = "test_six_first_question"
    case testSixSecondQuestion = "test_six_second_question"
    case testSixThirdQuestion = "test_six_third_question"
    case testSixForthQuestion = "test_six_forth_question"
    case testSixFifthQuestion = "test_six_fifth_question"

    // Test 6 Answer
    case poor = "poor"
    case fair = "fair"
    case good = "good"
    case veryGood = "very_good"
    case excellent = "excellent"

    case veryFrequentlyDays = "very_frequently_days"
    case frequentlyDays = "frequently_days"
    case occasionallyDays = "occasionally_days"
    case rarelyDays = "rarely_days"
    case neverDays = "never_days"
    
    //Test Result
    case testResult = "test_result"
    case myScore = "my_score"
    case dangerLevel = "danger_level"
    case low = "low"
    case moderate = "moderate"
    case high = "high"
    case depression = "depression"
    case anxiety = "anxiety"
    case stress = "stress"
    case socialMedia = "social_media"
    case loneliness = "loneliness"
    case hrql = "hrql"
    case depressionInfo = "depression_info"
    case anxietyInfo = "anxiety_info"
    case stressInfo = "stress_info"
    case socialMediaAddictionInfo = "social_media_addiction_info"
    case lonelinessInfo = "loneliness_info"
    case hrqolInfo = "hrqol_info"

    //AI counselor
    case hey = "hey"
    case aiCounselorTitle = "ai_counselor_title"
    case startTalking = "start_talking"
    case startRecording = "start_recording"
    case counselorGood = "counselor_good"
    case counselorBad = "counselor_bad"
    case counselorQuestionLabel = "counselor_question_label"
    case counselorQuestionSubLabel = "counselor_question_sub_label"
    case getAdvice = "get_advice"
    case save = "save"
    case generatedAnswer = "generated_answer"
    case generatingAnswer = "generating_answer"
    case adviceEmptyLabel = "advice_empty_label"
    
    case counselorAdviceTitleGood = "counselor_advice_title_good"
    case counselorAdviceTitleBad = "counselor_advice_title_bad"
    case seekerRecordExampleBad = "seeker_record_example_bad"
    case seekerRecordExampleGood = "seeker_record_example_good"
    case savedAdviceTitleBad = "saved_advice_title_bad"
    case savedAdviceRecordBad = "saved_advice_record_bad"
    case savedAdviceTitleGood = "saved_advice_record_good"
    case adviceSaveErrorMessage = "advice_save_error_message"
    case adviceSaveSuccessMessage = "advice_save_success_message"
    case adviceGenerationFailedText = "advice_generation_failed"
    
    case loginRequiredTitle = "login_required_title"
    case loginRequiredMessage = "login_required_message"
    case loginNow = "login_now"
    case maybeLater = "maybe_later"


    //Feeling record
    case howDoYouFeelToday = "how_do_you_feel_today"
    case logYourFeeling = "log_your_feeling"
    
    //etc
    case success = "success"
    case show = "show"
    case hide = "hide"
    case welcome = "welcome"
    case welcomeDescription = "welcome_description"
    case errorTitle = "error_title"
    case errorTryAgain = "error_try_again"
    case infoUpdated = "info_updated"
    case updateAppVerion = "update_app_version"

    //Notification
    case dailyNotificationBody1 = "daily_notification_body1"
    case dailyNotificationBody2 = "daily_notification_body2"
    case dailyNotificationBody3 = "daily_notification_body3"
    case dailyNotificationBody4 = "daily_notification_body4"
    case dailyNotificationBody5 = "daily_notification_body5"
    case dailyNotificationBody6 = "daily_notification_body6"
    
    //Meditation
    case breatheIn = "breathe_in"
    case breatheOut = "breathe_out"
}

/// Usage: .localized(.button)
/// Usage: .localized("button")
extension String {
    var soliuLocalized: String {
        if let key = SoliULocalizationKey(rawValue: self) {
            return SoliULanguageManager.shared.localized(key)
        } else {
            return self
        }
    }

    static func localized(_ key: SoliULocalizationKey) -> String {
        SoliULanguageManager.shared.localized(key)
    }

    static func localized(_ key: SoliULocalizationKey, _ args: CVarArg...) -> String {
        SoliULanguageManager.shared.localized(key, arguments: args)
    }

    static func localized(_ rawKey: String) -> String {
        rawKey.soliuLocalized
    }
}
