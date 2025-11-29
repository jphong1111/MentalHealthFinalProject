//
//  ChartSectionViewController.swift
//  MentalHealth
//
//

import Foundation
import UIKit
import DGCharts
import HealthKit

// Note: Each Section Needs to conform to SectionRegisterable to get a unique id
extension ChartSectionViewController: SectionRegisterable {
    static var identifier: SectionIdentifier { return .chart }
}

//REVISIT: Needs to change the last section's height dynamically based on the calculation of previous cells
// REVISIT: Drop down shadow implementation
// stepConfigLabel needs to adjust
class ChartSectionViewController: BaseSectionViewController {
    var stepCounts: [Int] = []
    var days: [String] = []
    private var healthStore = HKHealthStore()

    private lazy var combinedChartView: CombinedChartView = {
        let combinedChartView = CombinedChartView()
        return combinedChartView
    }()
    
    private lazy var stepCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = SoliUColor.newSoliuBlue
        view.layer.cornerRadius = 4

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: SoliUSpacing.space8),
            view.heightAnchor.constraint(equalToConstant: SoliUSpacing.space8)
        ])
        return view
    }()

    private lazy var stepConfigLabel: SoliULabel = {
        let stepConfigLabel = SoliULabel()
        stepConfigLabel.font = SoliUFont.medium14
        stepConfigLabel.text = .localized(.steps)
        return stepConfigLabel
    }()
    
    private lazy var mentalHealthCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = SoliUColor.newSoliuOrange
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var mentalHealthConfigLabel: SoliULabel = {
        let mentalHealthConfigLabel = SoliULabel()
        mentalHealthConfigLabel.font = SoliUFont.medium14
        mentalHealthConfigLabel.text = .localized(.mentalhealthScore)
        return mentalHealthConfigLabel
    }()
    
    private lazy var myStepCountLabel: SoliULabel = {
        let myStepCountLabel = SoliULabel()
        myStepCountLabel.font = SoliUFont.bold20
        myStepCountLabel.text = "0"
        return myStepCountLabel
    }()
    
    private lazy var maximumCountLabel: SoliULabel = {
        let maximumCountLabel = SoliULabel()
        maximumCountLabel.font = SoliUFont.regular12
        maximumCountLabel.text = "/8,000"
        return maximumCountLabel
    }()
    
    private lazy var myMentalScoreLabel: SoliULabel = {
        let myMentalScoretLabel = SoliULabel()
        let myScore = LoginManager.shared.getMyTestAverageScore()
        myMentalScoretLabel.font = SoliUFont.bold20
        myMentalScoretLabel.text = "\(myScore)"
        return myMentalScoretLabel
    }()
    
    private lazy var maximumMentalScoreLabel: SoliULabel = {
        let maximumMentalScoreLabel = SoliULabel()
        maximumMentalScoreLabel.font = SoliUFont.regular12
        maximumMentalScoreLabel.text = "/5.0"
        return maximumMentalScoreLabel
    }()

    private lazy var stepCountStackView: SoliUStackView = {
        let stackView = SoliUStackView(axis: .horizontal, spacing: 0)
        stackView.addArrangedSubview(myStepCountLabel)
        stackView.addArrangedSubview(maximumCountLabel)
        return stackView
    }()
    
    private lazy var mentalScoreStackView: SoliUStackView = {
        let stackView = SoliUStackView(axis: .horizontal, spacing: 0)
        stackView.addArrangedSubview(myMentalScoreLabel)
        stackView.addArrangedSubview(maximumMentalScoreLabel)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.clipsToBounds = true
        setupView()
        setupChart()
        fetchStepCounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myMentalScoreLabel.text = "\(LoginManager.shared.getMyTestAverageScore())"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set corner radius to half of the width for a perfect circle
        stepCircleView.layer.cornerRadius = stepCircleView.frame.width / 2
        mentalHealthCircleView.layer.cornerRadius = mentalHealthCircleView.frame.width / 2
    }
    
    private func setupView() {
        addAutoLayoutSubView(combinedChartView)
        addAutoLayoutSubView(stepCircleView)
        addAutoLayoutSubView(stepConfigLabel)
        addAutoLayoutSubView(mentalHealthCircleView)
        addAutoLayoutSubView(mentalHealthConfigLabel)
        addAutoLayoutSubView(stepCountStackView)
        addAutoLayoutSubView(mentalScoreStackView)

        NSLayoutConstraint.activate([
            combinedChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: SoliUSpacing.space16),
            combinedChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space8),
            combinedChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space8),
            
            stepCircleView.topAnchor.constraint(equalTo: combinedChartView.bottomAnchor, constant: SoliUSpacing.space8),
            stepCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            stepCircleView.widthAnchor.constraint(equalToConstant: SoliUSpacing.space8),
            stepCircleView.heightAnchor.constraint(equalToConstant: SoliUSpacing.space8),
            
            stepConfigLabel.centerYAnchor.constraint(equalTo: stepCircleView.centerYAnchor),
            stepConfigLabel.leadingAnchor.constraint(equalTo: stepCircleView.trailingAnchor, constant: SoliUSpacing.space8),
            
            mentalHealthCircleView.topAnchor.constraint(equalTo: stepCircleView.bottomAnchor, constant: SoliUSpacing.space12),
            mentalHealthCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SoliUSpacing.space16),
            mentalHealthCircleView.widthAnchor.constraint(equalToConstant: SoliUSpacing.space8),
            mentalHealthCircleView.heightAnchor.constraint(equalToConstant: SoliUSpacing.space8),
            
            mentalHealthConfigLabel.centerYAnchor.constraint(equalTo: mentalHealthCircleView.centerYAnchor),
            mentalHealthConfigLabel.leadingAnchor.constraint(equalTo: mentalHealthCircleView.trailingAnchor, constant: SoliUSpacing.space8),
            mentalHealthConfigLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SoliUSpacing.space16),
            
            //Right side step label
            stepCountStackView.centerYAnchor.constraint(equalTo: stepConfigLabel.centerYAnchor),
            stepCountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16),
            
            //Right side mental healther score label
            mentalScoreStackView.centerYAnchor.constraint(equalTo: mentalHealthConfigLabel.centerYAnchor),
            mentalScoreStackView.leadingAnchor.constraint(equalTo: stepCountStackView.leadingAnchor),
            mentalScoreStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SoliUSpacing.space16)
        ])
    }
    
    private func updateChart() {
        var barChartDataEntries: [BarChartDataEntry] = []
        var lineDataEntries: [ChartDataEntry] = []
        let testResultCounts = LoginManager.shared.getRecentMentalHealthScoresDouble(days: 14)
        let n = min(stepCounts.count, testResultCounts.count)

        for i in 0..<n {
            let barChartDataEntry = BarChartDataEntry(x: Double(i), y: Double(stepCounts[i]))
            barChartDataEntries.append(barChartDataEntry)
            //If there is no data, we can keep as 0 score
            let lineDataEntry = ChartDataEntry(x: Double(i), y: Double(testResultCounts[i]))
            lineDataEntries.append(lineDataEntry)
        }
        
        
        //Note: Bar Chart for step count
        let barChartDataSet = BarChartDataSet(entries: barChartDataEntries, label: "")
        barChartDataSet.drawValuesEnabled = false // Disable value labels above bars
        barChartDataSet.colors = [SoliUColor.newSoliuBlue]
        barChartDataSet.highlightEnabled = false
        barChartDataSet.barCornerRadiusFactor = 1
        barChartDataSet.axisDependency = .left
        
        //Note: Line Chart for test result
        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "")
        lineChartDataSet.drawValuesEnabled = false // Disable value labels above bars
        lineChartDataSet.highlightEnabled = false
        lineChartDataSet.colors = [SoliUColor.newSoliuOrange]
        lineChartDataSet.circleColors = [SoliUColor.newSoliuOrange] // Circle color
        lineChartDataSet.circleHoleColor = SoliUColor.newSoliuOrange // Circle hole color
        lineChartDataSet.circleRadius = 4 // Circle size
        lineChartDataSet.axisDependency = .right
        lineChartDataSet.setColor(.clear)   // 라인 컬러 투명
        lineChartDataSet.lineWidth = 0

        let combinedData = CombinedChartData()
        combinedData.barData = BarChartData(dataSets: [barChartDataSet])
        combinedData.barData.barWidth = 0.4
        combinedData.lineData = LineChartData(dataSets: [lineChartDataSet])
        
        combinedChartView.data = combinedData
        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        combinedChartView.xAxis.granularity = 1
        combinedChartView.highlightPerTapEnabled = false
        combinedChartView.dragEnabled = false
        
        // Hide legend for this dataset
        combinedChartView.legend.enabled = false
        combinedChartView.xAxis.axisMinimum = -0.2
        combinedChartView.xAxis.axisMaximum = Double(stepCounts.count) - 0.8
    }

    private func setupChart() {
        // Customize x-axis
        let xAxis = combinedChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 14
        
        // Customize y-axis (left)
        let leftAxis = combinedChartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        
        // Customize y-axis (right)
        let rightAxis = combinedChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 5
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false

        // Customize chart description
        combinedChartView.chartDescription.enabled = false
        combinedChartView.legend.enabled = true
        
        // Customize additional chart settings
        combinedChartView.setScaleEnabled(false)
        combinedChartView.pinchZoomEnabled = false
        combinedChartView.doubleTapToZoomEnabled = false
    }
    
    func fetchStepCounts() {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        
        // Calculate the start date 13 days before today
        var dateComponents = DateComponents()
        dateComponents.day = -13
        let startDate = calendar.date(byAdding: dateComponents, to: startOfToday)!
        
        // Predicate for the past 13 days
        let pastDaysPredicate = HKQuery.predicateForSamples(withStart: startDate, end: startOfToday, options: .strictStartDate)
        
        // Predicate for today
        let todayPredicate = HKQuery.predicateForSamples(withStart: startOfToday, end: now, options: .strictStartDate)
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Query for the past 13 days
        let pastDaysQuery = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: pastDaysPredicate,
            options: [.cumulativeSum],
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        pastDaysQuery.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                self.processStepCounts(statsCollection: statsCollection)
            }
        }
        
        // Query for today
        let queryForToday = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: todayPredicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle the error appropriately, e.g., log it or display an alert
                    print("Error while fetching today's step count: \(error.localizedDescription)")
                    self.handleNoDataForSteps()
                    return
                }
                
                if let result = result, let sum = result.sumQuantity() {
                    let steps = Int(sum.doubleValue(for: HKUnit.count()))
                    // Remove the last entry to update today's steps
                    if !self.stepCounts.isEmpty {
                        self.stepCounts.removeLast()
                    }
                    self.stepCounts.append(steps)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d"
                    let dateString = dateFormatter.string(from: now)
                    if !self.days.isEmpty {
                        self.days.removeLast()
                    }
                    self.days.append(dateString)
                    self.myStepCountLabel.text = "\(steps)"
                    print("Debug - Today's steps: \(steps)")
                    self.updateChart()
                } else {
                    print("No data available for today's step count.")
                    self.handleNoDataForSteps()
                }
            }
        }
        
        healthStore.execute(pastDaysQuery)
        healthStore.execute(queryForToday)
    }

    func handleNoDataForSteps() {
        // Set default values or show a message to the user
        if !self.stepCounts.isEmpty {
            self.stepCounts.removeLast()  // Remove the last entry
        }
        self.stepCounts.append(0)  // Set steps to 0 for today
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let dateString = dateFormatter.string(from: Date())
        if !self.days.isEmpty {
            self.days.removeLast()
        }
        self.days.append(dateString)
        self.myStepCountLabel.text = "0"  // Update the label to show 0 steps
        self.updateChart()  // Update the chart with the new data
    }

    func processStepCounts(statsCollection: HKStatisticsCollection) {
        let calendar = Calendar.current
        let now = Date()
        let endDate = calendar.startOfDay(for: now)
        
        var dateComponents = DateComponents()
        dateComponents.day = -13
        let startDate = calendar.date(byAdding: dateComponents, to: endDate)!
        
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let stepCount = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let date = statistics.startDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            let dateString = dateFormatter.string(from: date)
            
            self.stepCounts.append(Int(stepCount))
            self.days.append(dateString)
        }
        
        DispatchQueue.main.async {
            self.updateChart()
        }
    }
}

