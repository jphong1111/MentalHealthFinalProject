//
//  SurveyResultViewController.swift
//  MentalHealth
//
//  Created by Yoon on 4/11/24.
//

import UIKit

final class SurveyResultViewController: BaseViewController {
    private var chart: TKRadarChart!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var myScoreLabel: SoliULabel! {
        didSet {
            self.myScoreLabel.text = .localized(.myScore)
        }
    }
    @IBOutlet weak var allUserAverageLabel: SoliULabel!
    
    // Image Views
    @IBOutlet weak var depressionImageView: UIImageView!
    @IBOutlet weak var anxietyImageView: UIImageView!
    @IBOutlet weak var stressImageView: UIImageView!
    @IBOutlet weak var socialMediaAddictionImageView: UIImageView!
    @IBOutlet weak var lonelinessImageView: UIImageView!
    @IBOutlet weak var hrqolImageView: UIImageView!
    
    // Title Labels
    @IBOutlet weak var depressionTitleLabel: SoliULabel!
    @IBOutlet weak var anxietyTitleLabel: SoliULabel!
    @IBOutlet weak var stressTitleLabel: SoliULabel!
    @IBOutlet weak var socialMediaAddictionTitleLabel: SoliULabel!
    @IBOutlet weak var lonelinessTitleLabel: SoliULabel!
    @IBOutlet weak var hrqolTitleLabel: SoliULabel!
    
    // Personal Score Labels
    @IBOutlet weak var depressionMyScoreLabel: SoliULabel!
    @IBOutlet weak var anxietyMyScoreLabel: SoliULabel!
    @IBOutlet weak var stressMyScoreLabel: SoliULabel!
    @IBOutlet weak var socialMediaAddictionMyScoreLabel: SoliULabel!
    @IBOutlet weak var lonelinessMyScoreLabel: SoliULabel!
    @IBOutlet weak var hrqolMyScoreLabel: SoliULabel!
    
    // Average Score Labels
    @IBOutlet weak var depressionAverageScoreLabel: SoliULabel!
    @IBOutlet weak var anxietyAverageScoreLabel: SoliULabel!
    @IBOutlet weak var stressAverageScoreLabel: SoliULabel!
    @IBOutlet weak var socialMediaAddictionAverageScoreLabel: SoliULabel!
    @IBOutlet weak var lonelinessAverageScoreLabel: SoliULabel!
    @IBOutlet weak var hrqolAverageScoreLabel: SoliULabel!
    
    @IBOutlet weak var depressionInfoImageView: UIImageView!
    @IBOutlet weak var anxietyInfoImageView: UIImageView!
    @IBOutlet weak var stressInfoImageView: UIImageView!
    @IBOutlet weak var socialMediaAddictionInfoImageView: UIImageView!
    @IBOutlet weak var lonelinessInfoImageView: UIImageView!
    @IBOutlet weak var hrqolInfoImageView: UIImageView!
    
    
    // DangerView
    @IBOutlet weak var dangerLabel: SoliULabel! {
        didSet {
            self.dangerLabel.text = .localized(.dangerLevel)
        }
    }
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet weak var dangerView: DangerView!
    
    @IBOutlet weak var meLabel: SoliULabel!
    @IBOutlet weak var avgLabel: SoliULabel!
    
    
    // Tooltip Views
    var tooltipViews: [UIView] = []
    
    var myTestScore: [Int:Int] = [:]
    var allUsersAverageResult: [Int: Double] = [ : ]
    let categories = [0: "Depression",
                      5: "Anxiety",
                      10: "Stress",
                      15: "Social Media Addiction",
                      20: "Loneliness",
                      25: "HRQOL"]
    var shouldHideData = false
    var scoreResults: [Int: [Int: Double]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackNavigationButton()
        self.title = .localized(.testResult)
        warningTextView.isEditable = false
        self.imageSetup()
        self.labelSetup()
        self.fetchUsersAverageResult()
        self.setupWarningView()
        self.setupTooltips()
    }
    
    private func setupWarningView() {
        warningView.backgroundColor = SoliUColor.surveyWarningBackground
        warningView.addBorderAndColor(color: SoliUColor.surveyWarningBackground, width: 1, corner_radius: SoliUSpacing.space12)
        warningTextView.font = SoliUFont.bold12
        warningTextView.textColor = SoliUColor.surveyWarningLabel
        warningTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func fetchUsersAverageResult() {
        self.activityIndicator.startAnimating()
        
        FBNetworkLayer.shared.getAverageScore { [weak self] result in
            guard let strongSelf = self else { return }
            
            // Ensure everything happens on the main thread
            DispatchQueue.main.async {
                strongSelf.activityIndicator.stopAnimating() // Stop loader first
                
                switch result {
                case .success(let averageTest):
                    strongSelf.remappingTestAverageScore(testAverage: averageTest)
                    strongSelf.setupScoreResult()
                    
                    // Check if the view is still loaded before updating UI
                    if strongSelf.isViewLoaded {
                        strongSelf.labelResultSetup()
                        strongSelf.chartSetup()
                    }
                    
                case .failure(let error):
                    strongSelf.showAlertWithButton(title: "Test Score Retrieval Failed", message: error.localizedDescription) {
                        DispatchQueue.main.async {
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    private func chartSetup() {
        chart = TKRadarChart()
        chart.configuration.borderWidth = 1
        chart.configuration.lineWidth = 3
        chart.configuration.showBorder = true
        chart.configuration.showBgLine = true
        
        let padding: CGFloat = 4
        let w = containerView.bounds.width - padding * 2
        let h = containerView.bounds.height - padding * 2
        
        chart.configuration.radius = min(w, h) / 3
        chart.dataSource = self
        chart.delegate = self
        
        containerView.addSubview(chart)
        
        chart.frame = CGRect(x: padding, y: padding, width: w, height: h)
        chart.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
        
        chart.reloadData()
    }
    
    private func setupTooltips() {
        let tooltipsData = [
            (depressionInfoImageView, String.localized(.depressionInfo)),
            (anxietyInfoImageView, String.localized(.anxietyInfo)),
            (stressInfoImageView, String.localized(.stressInfo)),
            (socialMediaAddictionInfoImageView, String.localized(.socialMediaAddictionInfo)),
            (lonelinessInfoImageView, String.localized(.lonelinessInfo)),
            (hrqolInfoImageView, String.localized(.hrqolInfo))
        ]
        
        for (imageView, text) in tooltipsData {
            let tooltipView = createTooltipView(withText: text)
            guard let targetImageView = imageView else {
                return
            }
            targetImageView.tintColor = SoliUColor.detailsIconColor
            view.addSubView(tooltipView)
            
            NSLayoutConstraint.activate([
                tooltipView.centerXAnchor.constraint(equalTo: targetImageView.centerXAnchor),
                tooltipView.topAnchor.constraint(equalTo: targetImageView.bottomAnchor, constant: SoliUSpacing.space8),
                tooltipView.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
            ])
            tooltipView.isHidden = true
            tooltipViews.append(tooltipView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoImageViewTapped(_:)))
            targetImageView.addGestureRecognizer(tapGesture)
            targetImageView.isUserInteractionEnabled = true
        }
    }
    
    private func createTooltipView(withText text: String) -> UIView {
        let tooltipView = UIView()
        tooltipView.backgroundColor = .white
        tooltipView.addBorderAndColor(color: SoliUColor.depressionColor, width: 1, corner_radius: SoliUSpacing.space12)
        
        let tooltipLabel = SoliULabel()
        tooltipLabel.font = SoliUFont.bold10
        tooltipLabel.numberOfLines = 0
        tooltipLabel.text = text
        
        tooltipView.addSubView(tooltipLabel)
        
        NSLayoutConstraint.activate([
            tooltipLabel.leadingAnchor.constraint(equalTo: tooltipView.leadingAnchor, constant: SoliUSpacing.space8),
            tooltipLabel.trailingAnchor.constraint(equalTo: tooltipView.trailingAnchor, constant: -SoliUSpacing.space8),
            tooltipLabel.topAnchor.constraint(equalTo: tooltipView.topAnchor, constant: SoliUSpacing.space8),
            tooltipLabel.bottomAnchor.constraint(equalTo: tooltipView.bottomAnchor, constant: -SoliUSpacing.space8)
        ])
        return tooltipView
    }
    
    @objc private func infoImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
              let index = [depressionInfoImageView, anxietyInfoImageView, stressInfoImageView,
                           socialMediaAddictionInfoImageView, lonelinessInfoImageView, hrqolInfoImageView]
            .firstIndex(of: imageView) else {
            return
        }
        
        for (i, tooltipView) in tooltipViews.enumerated() {
            if i != index && !tooltipView.isHidden {
                UIView.animate(withDuration: 0.2, animations: {
                    tooltipView.alpha = 0
                }, completion: { _ in
                    tooltipView.isHidden = true
                })
            }
        }
        
        let tooltipView = tooltipViews[index]
        if tooltipView.isHidden {
            tooltipView.alpha = 0
            tooltipView.isHidden = false
            UIView.animate(withDuration: 0.25) {
                tooltipView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                tooltipView.alpha = 0
            }, completion: { _ in
                tooltipView.isHidden = true
            })
        }
    }
    
    private func remappingTestAverageScore(testAverage: TestAverage) {
        allUsersAverageResult = [0: testAverage.DepressionAverage,
                                 1: testAverage.AnxietyAverage,
                                 2: testAverage.StressAverage,
                                 3: testAverage.SocialMediaAddictionAverage,
                                 4: testAverage.LonelinessAverage,
                                 5: (6 - testAverage.HRQOLAverage)
        ]
    }
    
    private func stringForValue(_ index: Int) -> String {
        switch index {
        case 0:
            return .localized(.depression)
        case 1:
            return .localized(.anxiety)
        case 2:
            return .localized(.stress)
        case 3:
            return .localized(.socialMedia)
        case 4:
            return .localized(.loneliness)
        case 5:
            return .localized(.hrql)
        default:
            return ""
        }
    }
    
    private func imageSetup() {
        depressionImageView.image = UIImage(assetIdentifier: .depressionIcon)
        anxietyImageView.image = UIImage(assetIdentifier: .anxietyIcon)
        stressImageView.image = UIImage(assetIdentifier: .stressIcon)
        socialMediaAddictionImageView.image = UIImage(assetIdentifier: .socialmediaIcon)
        lonelinessImageView.image = UIImage(assetIdentifier: .lonelinessIcon)
        hrqolImageView.image = UIImage(assetIdentifier: .hrqolIcon)
    }
    
    private func setupScoreResult() {
        scoreResults[0] = [:]
        scoreResults[1] = [:]
        
        for (startKey, _) in categories {
            let range = startKey..<startKey + 5
            let sum1 = range.reduce(0) { total, index in
                let score = myTestScore[index] ?? 0
                return total + score
            }
            let myAvg1 = Double(sum1) / 5.0
            
            let chartCategoryID = startKey / 5
            
            // Store the averages in scoreResults
            scoreResults[0]?[chartCategoryID] = myAvg1
            scoreResults[1] = self.allUsersAverageResult
        }
    }
    
    private func oppositeScore(_ score: Int) -> Int {
        switch score {
        case 1: return 5
        case 2: return 4
        case 3: return 3
        case 4: return 2
        case 5: return 1
        default: return score
        }
    }
    
    private func labelSetup() {
        myScoreLabel.font = SoliUFont.bold12
        allUserAverageLabel.font = SoliUFont.bold12
        depressionTitleLabel.font = SoliUFont.semiBold16
        anxietyTitleLabel.font = SoliUFont.semiBold16
        stressTitleLabel.font = SoliUFont.semiBold16
        socialMediaAddictionTitleLabel.font = SoliUFont.semiBold16
        lonelinessTitleLabel.font = SoliUFont.semiBold16
        hrqolTitleLabel.font = SoliUFont.semiBold16
        dangerLabel.font = SoliUFont.semiBold12
        meLabel.font = SoliUFont.bold12
        avgLabel.font = SoliUFont.semiBold12
        avgLabel.textColor = SoliUColor.surveyAvgTitle
    }
    
    private func colorMapping(myScore: Double) -> UIColor {
        if myScore < 2.0 {
            return SoliUColor.surveyResultLow
        }
        else if myScore < 4.0 {
            return SoliUColor.surveyResultModerate
        }
        return SoliUColor.surveyResultHigh
    }
    
    private func labelResultSetup() {
        for (startKey, category) in categories {
            let range = startKey..<startKey + 5
            let sum1 = range.reduce(0) { total, index in
                let score = myTestScore[index] ?? 0
                return total + score
            }
            let avg1 = Double(sum1) / 5.0
            
            let myScoreString = NSAttributedString(
                string: "\(avg1)",
                attributes: [
                    .font: SoliUFont.semiBold16,
                    .foregroundColor: self.colorMapping(myScore: avg1)
                ]
            )
            
            let categoryID = startKey / 5
            guard let targetScore = self.allUsersAverageResult[categoryID] else {
                return
            }
            
            let targetScoreString = String(targetScore)
            guard targetScoreString == targetScoreString else {
                return
            }
            
            let averageScoreString = NSAttributedString(
                string: targetScoreString,
                attributes: [
                    .font: SoliUFont.semiBold16,
                    .foregroundColor: UIColor.black
                ]
            )
            
            switch category {
            case "Depression":
                depressionMyScoreLabel.attributedText = myScoreString
                depressionAverageScoreLabel.attributedText = averageScoreString
            case "Anxiety":
                anxietyMyScoreLabel.attributedText = myScoreString
                anxietyAverageScoreLabel.attributedText = averageScoreString
            case "Stress":
                stressMyScoreLabel.attributedText = myScoreString
                stressAverageScoreLabel.attributedText = averageScoreString
            case "Social Media Addiction":
                socialMediaAddictionMyScoreLabel.attributedText = myScoreString
                socialMediaAddictionAverageScoreLabel.attributedText = averageScoreString
            case "Loneliness":
                lonelinessMyScoreLabel.attributedText = myScoreString
                lonelinessAverageScoreLabel.attributedText = averageScoreString
            case "HRQOL":
                hrqolMyScoreLabel.attributedText = myScoreString
                hrqolAverageScoreLabel.attributedText = averageScoreString
            default:
                break
            }
        }
    }
}

extension SurveyResultViewController: TKRadarChartDataSource, TKRadarChartDelegate, UITableViewDelegate {
    func numberOfStepForRadarChart(_ radarChart: TKRadarChart) -> Int {
        //      Max value
        return 5
    }
    func numberOfRowForRadarChart(_ radarChart: TKRadarChart) -> Int {
        //      Row value
        return 6
    }
    
    func numberOfSectionForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 2
    }
    
    func titleOfRowForRadarChart(_ radarChart: TKRadarChart, row: Int) -> String {
        return stringForValue(row)
    }
    
    func valueOfSectionForRadarChart(withRow row: Int, section: Int) -> CGFloat {
        if let averages = scoreResults[section], let value = averages[row] {
            return CGFloat(value)
        } else {
            // Return a default value or handle the error as appropriate.
            return 0.0
        }
    }
    
    
    func colorOfLineForRadarChart(_ radarChart: TKRadarChart) -> UIColor {
        return .gray.withAlphaComponent(0.7)
    }
    
    func colorOfFillStepForRadarChart(_ radarChart: TKRadarChart, step: Int) -> UIColor {
        return UIColor.clear
    }
    
    func colorOfSectionFillForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
        if section == 0 {
            return SoliUColor.chartMyScoreFill.withAlphaComponent(0.60)
        } else {
            return UIColor.clear
        }
    }
    
    func colorOfSectionBorderForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
        if section == 0 {
            return UIColor.clear
        } else {
            return SoliUColor.chartAverageBorder
        }
    }
    
    func colorOfTitleForRadarChart(_ radarChart: TKRadarChart, row: Int) -> UIColor {
        switch row {
        case 0:
            return SoliUColor.depressionColor
        case 1:
            return SoliUColor.anxietyColor
        case 2:
            return SoliUColor.stressColor
        case 3:
            return SoliUColor.socialMediaColor
        case 4:
            return SoliUColor.lonelinessColor
        default:
            return SoliUColor.hrqolColor
        }
    }
    
    func fontOfTitleForRadarChart(_ radarChart: TKRadarChart) -> UIFont {
        return SoliUFont.bold10
    }
}

#if DEBUG
extension SurveyResultViewController {
    var testHooks: TestHooks { .init(target: self) }
    
    struct TestHooks {
        var target: SurveyResultViewController
        
        var chart: TKRadarChart! { target.chart }
        
        var containerView: UIView! { target.containerView }
        
        var stackView: UIStackView! { target.stackView }
        
        var activityIndicator: UIActivityIndicatorView! { target.activityIndicator }
        
        var myScoreLabel: SoliULabel! { target.myScoreLabel }
        
        var allUserAverageLabel: SoliULabel! { target.allUserAverageLabel }
        
        var depressionImageView: UIImageView! { target.depressionImageView }
        
        var anxietyImageView: UIImageView! { target.anxietyImageView }
        
        var stressImageView: UIImageView! { target.stressImageView }
        
        var socialMediaAddictionImageView: UIImageView! { target.socialMediaAddictionImageView }
        
        var lonelinessImageView: UIImageView! { target.lonelinessImageView }
        
        var hrqolImageView: UIImageView! { target.hrqolImageView }
        
        var depressionTitleLabel: SoliULabel! { target.depressionTitleLabel }
        
        var anxietyTitleLabel: SoliULabel! { target.anxietyTitleLabel }
        
        var stressTitleLabel: SoliULabel! { target.stressTitleLabel }
        
        var socialMediaAddictionTitleLabel: SoliULabel! { target.socialMediaAddictionTitleLabel }
        
        var lonelinessTitleLabel: SoliULabel! { target.lonelinessTitleLabel }
        
        var hrqolTitleLabel: SoliULabel! { target.hrqolTitleLabel }
        
        var depressionMyScoreLabel: SoliULabel! { target.depressionMyScoreLabel }
        
        var anxietyMyScoreLabel: SoliULabel! { target.anxietyMyScoreLabel }
        
        var stressMyScoreLabel: SoliULabel! { target.stressMyScoreLabel }
        
        var socialMediaAddictionMyScoreLabel: SoliULabel! { target.socialMediaAddictionMyScoreLabel }
        
        var lonelinessMyScoreLabel: SoliULabel! { target.lonelinessMyScoreLabel }
        
        var hrqolMyScoreLabel: SoliULabel! { target.hrqolMyScoreLabel }
        
        var depressionAverageScoreLabel: SoliULabel! { target.depressionAverageScoreLabel }
        
        var anxietyAverageScoreLabel: SoliULabel! { target.anxietyAverageScoreLabel }
        
        var stressAverageScoreLabel: SoliULabel! { target.stressAverageScoreLabel }
        
        var socialMediaAddictionAverageScoreLabel: SoliULabel! { target.socialMediaAddictionAverageScoreLabel }
        
        var lonelinessAverageScoreLabel: SoliULabel! { target.lonelinessAverageScoreLabel }
        
        var hrqolAverageScoreLabel: SoliULabel! { target.hrqolAverageScoreLabel }
        
        var depressionInfoImageView: UIImageView! { target.depressionInfoImageView }
        
        var anxietyInfoImageView: UIImageView! { target.anxietyInfoImageView }
        
        var stressInfoImageView: UIImageView! { target.stressInfoImageView }
        
        var socialMediaAddictionInfoImageView: UIImageView! { target.socialMediaAddictionInfoImageView }
        
        var lonelinessInfoImageView: UIImageView! { target.lonelinessInfoImageView }
        
        var hrqolInfoImageView: UIImageView! { target.hrqolInfoImageView }
        
        var dangerLabel: SoliULabel! { target.dangerLabel }
        
        var warningView: UIView! { target.warningView }
        
        var warningTextView: UITextView! { target.warningTextView }
        
        var dangerView: DangerView! { target.dangerView }
        
        var meLabel: SoliULabel! { target.meLabel }
        
        var avgLabel: SoliULabel! { target.avgLabel }
        
        var tooltipViews: [UIView] { target.tooltipViews }
        
        var myTestScore: [Int:Int] { target.myTestScore }
        
        var allUsersAverageResult: [Int: Double] { target.allUsersAverageResult }
        
        var scoreResults: [Int: [Int: Double]] { target.scoreResults }
        
        func numberOfStepForRadarChart(_ radarChart: TKRadarChart) -> Int {
            target.numberOfStepForRadarChart(radarChart)
        }
        
        func numberOfRowForRadarChart(_ radarChart: TKRadarChart) -> Int {
            target.numberOfRowForRadarChart(radarChart)
        }
        
        func numberOfSectionForRadarChart(_ radarChart: TKRadarChart) -> Int {
            target.numberOfSectionForRadarChart(radarChart)
        }
        
        func titleOfRowForRadarChart(_ radarChart: TKRadarChart, row: Int) -> String {
            target.titleOfRowForRadarChart(radarChart, row: row)
        }
        
        func valueOfSectionForRadarChart(withRow row: Int, section: Int) -> CGFloat {
            target.valueOfSectionForRadarChart(withRow: row, section: section)
        }
        
        func colorOfLineForRadarChart(_ radarChart: TKRadarChart) -> UIColor {
            target.colorOfLineForRadarChart(radarChart)
        }
        
        func colorOfFillStepForRadarChart(_ radarChart: TKRadarChart, step: Int) -> UIColor {
            target.colorOfFillStepForRadarChart(radarChart, step: step)
        }
        
        func colorOfSectionFillForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
            target.colorOfSectionFillForRadarChart(radarChart, section: section)
        }
        
        func colorOfSectionBorderForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
            target.colorOfSectionBorderForRadarChart(radarChart, section: section)
        }
        
        func colorOfTitleForRadarChart(_ radarChart: TKRadarChart, row: Int) -> UIColor {
            target.colorOfTitleForRadarChart(radarChart, row: row)
        }
        
        func fontOfTitleForRadarChart(_ radarChart: TKRadarChart) -> UIFont {
            target.fontOfTitleForRadarChart(radarChart)
        }
    }
}
#endif
