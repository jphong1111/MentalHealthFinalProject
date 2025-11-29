//
//  SurveyListDetailViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/4/24.
//

import Foundation
import UIKit

final class SurveyListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var answeredQuestionsCount = 0
    var allSurveyQuestion: [TestQuestion] = []
    var selectedSurveyQuestion: [TestQuestion] = []
    var surveyResultArray: [Int] = []
    var selectedQuestionId: Int = 0
    var readyToSubmit = false
    var surveyResultRecord: [Int: Int] = [:]
    var userInfomration: UserInformation = LoginManager.shared.getUserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuestions()
        setCustomBackNavigationButton()
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: SurveyListViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SurveyListViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: SurveyNextButtonCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SurveyNextButtonCell.reuseIdentifier)
        updateTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavigationBar()
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = SoliUColor.testNavigationBar
        navigationController?.navigationBar.tintColor = SoliUColor.soliuBlack
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SoliUColor.soliuBlack]
        navigationController?.navigationBar.backgroundColor = SoliUColor.testNavigationBar
        let backButtonImage = UIImage(assetIdentifier: .whiteBackButton)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: navigationController!.navigationBar.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0)).cgPath
        navigationController?.navigationBar.layer.mask = maskLayer
    }
    
    private func resetNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.barTintColor = nil
        navigationBar.tintColor = SoliUColor.soliuBlack
        navigationBar.titleTextAttributes = nil
        navigationBar.backgroundColor = nil
        navigationBar.backIndicatorImage = nil
        navigationBar.backIndicatorTransitionMaskImage = nil
        navigationBar.layer.mask = nil
        navigationBar.topItem?.backBarButtonItem = nil
    }
    
    private func fetchQuestions() {
        allSurveyQuestion = TestingInformation().createTestingSurveyQuestion()
        reorderQuestion()
    }
    
    private func updateTitle() {
        var title = ""
        switch selectedQuestionId {
        case 0:
            title = .localized(.testOneDepression)
        case 1:
            title = .localized(.testTwoAnxiety)
        case 2:
            title = .localized(.testThreeStress)
        case 3:
            title = .localized(.testFourSocialMediaAddiction)
        case 4:
            title = .localized(.testFiveLoneliness)
        case 5:
            title = .localized(.testSixHRQOL)
        default:
            title = ""
            
        }
        self.title = title
    }
    
    private func navigateToResultScreen() {
        let surveyAnswersArray = getSurveyResultArray()
        let newSurveyResult = SurveyResult(surveyDate: getDefaultDateFormat(),
                                        surveyAnswer: surveyAnswersArray)
        
        FBNetworkLayer.shared.addSurvey(userInfomration: userInfomration,
                                        newSurveyResult: newSurveyResult) { error in
            if error != nil {
                self.showAlert(title: "Submission Issue",
                               description: "Your score could not be submitted at this time. Please try again later.")
            }
            else {
                LoginManager.shared.saveSurveyRecentResultTemp(newSurveyResult)
            }
        }
        
        if let surveyResultVC = storyboard?.instantiateViewController(withIdentifier: "SurveyResultViewController") as? SurveyResultViewController {
            surveyResultVC.myTestScore = surveyResultRecord
            let viewControllers = navigationController?.viewControllers ?? []
            
            if let surveyEntryIndex = viewControllers.firstIndex(where: { $0 is SurveyEntryViewController }) {
                let filteredViewControllers = viewControllers[0...surveyEntryIndex]
                var newStack = Array(filteredViewControllers)
                newStack.append(surveyResultVC)
                navigationController?.setViewControllers(newStack, animated: true)
            } else {
                navigationController?.pushViewController(surveyResultVC, animated: true)
            }
        }
    }
    
    private func nextButtonPressed() {
        if selectedQuestionId < 5 {
            selectedQuestionId += 1
            answeredQuestionsCount = 0 // Reset the count for the new section
            reorderQuestion()
            if selectedQuestionId == 5 {
                readyToSubmit = true
            }
            return
        }
        
        if selectedQuestionId == 5 {
            navigateToResultScreen()
        }
    }
    
    private func reorderQuestion() {
        updateTitle()
        resetAllCellImages()
        selectedSurveyQuestion = allSurveyQuestion.filter { testQuestion in
            selectedQuestionId == testQuestion.id
        }
        reloadDataAndScrollToTop()
        tableView.reloadData()
    }
    
    func reloadDataAndScrollToTop() {
        tableView.reloadData()
        DispatchQueue.main.async {
            if self.tableView.numberOfSections > 0 {
                let topIndexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
            }
        }
    }
    
    private func getSurveyResultArray() -> [Int] {
        for i in 0..<30 {
            if let value = surveyResultRecord[i] {
                surveyResultArray.append(value)
            } else {
                surveyResultArray.append(3)
            }
        }
        return surveyResultArray
    }
    
    
    private func resetAllCellImages() {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SurveyListViewCell {
                DispatchQueue.main.async {
                    cell.resetImagesToUnmarked(row: i)
                }
            }
        }
    }
}
extension SurveyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSurveyQuestion.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row  == selectedSurveyQuestion.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveyNextButtonCell.reuseIdentifier) as? SurveyNextButtonCell else {
                return UITableViewCell()
            }
            let isActive = (answeredQuestionsCount == selectedSurveyQuestion.count)
            cell.populate(readySubmit: readyToSubmit, isActive: isActive)
            cell.delegate = self
            return cell
        }
        
        else {
            let testQuestion = self.selectedSurveyQuestion[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveyListViewCell.reuseIdentifier, for: indexPath) as? SurveyListViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.populate(testQuestion: testQuestion)
            return cell
        }
    }
    
}
extension SurveyListViewController: SurveyListViewCellDelegate {
    func mappingSelectedValue(id: Int, questionNumber: Int , value: Int) {
        let previousValue = surveyResultRecord[questionNumber]
        surveyResultRecord[questionNumber] = value
        if previousValue == nil {
            answeredQuestionsCount += 1
        }
        
        if value == 0 {
            answeredQuestionsCount -= 1
        }
        tableView.reloadRows(at: [IndexPath(row: selectedSurveyQuestion.count, section: 0)], with: .none)
    }
}

extension SurveyListViewController: SurveyNextButtonCellDelegate {
    func nextButtonClicked() {
        self.nextButtonPressed()
    }
}

#if DEBUG
extension SurveyListViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SurveyListViewController

        var tableView: UITableView! { target.tableView }

        var allSurveyQuestion: [TestQuestion] { target.allSurveyQuestion }

        var selectedSurveyQuestion: [TestQuestion] { target.selectedSurveyQuestion }

        var surveyResultArray: [Int] { target.surveyResultArray }

        var selectedQuestionId: Int { target.selectedQuestionId }

        var surveyResultRecord: [Int: Int] { target.surveyResultRecord }

        var userInfomration: UserInformation { target.userInfomration }

        func reloadDataAndScrollToTop() { target.reloadDataAndScrollToTop() }

        func mappingSelectedValue(id: Int, questionNumber: Int, value: Int) {
            target.mappingSelectedValue(id: id, questionNumber: questionNumber, value: value)
        }

        func nextButtonClicked() { target.nextButtonClicked() }
    }
}
#endif
