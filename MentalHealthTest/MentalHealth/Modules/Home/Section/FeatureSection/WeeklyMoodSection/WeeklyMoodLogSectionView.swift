//
//  WeeklyMoodLogSectionView.swift
//  MentalHealth
//
//  Created by JungpyoHong on 1/21/25.
//

import Foundation
import UIKit

final class WeeklyMoodLogSectionView: UIView {
    private let days = ["S", "M", "T", "W", "TH", "F", "ST"]
    private var dates: [String] = []
    private var moodImages: [UIImage?] = Array(repeating: nil, count: 7)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: 75)
        layout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeeklyMoodCell.self, forCellWithReuseIdentifier: WeeklyMoodCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var cellWidth: CGFloat {
        let totalSpacing = CGFloat((days.count - 1)) * SoliUSpacing.space8
        let totalWidth = UIScreen.main.bounds.width - SoliUSpacing.space32 // 16px margin on each side
        return (totalWidth - totalSpacing) / CGFloat(days.count)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchImages()
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fetchImages()
        setupView()
    }
    
    func fetchImages() {
            let myDayList = WeekViewHelper.createfilteredMood()

            myDayList.forEach { myDay in
                guard let moodDate = myDay.parsedDate else { return }
                let weekday = Calendar.current.component(.weekday, from: moodDate)
                updateRecentMood(for: weekday, mood: myDay.myMood)
            }
        }
    
    private func updateRecentMood(for weekday: Int, mood: MyMood) {
        
        switch weekday {
        case 1:
            moodImages[0] = mood.moodImage
        case 2:
            moodImages[1] = mood.moodImage
        case 3:
            moodImages[2] = mood.moodImage
        case 4:
            moodImages[3] = mood.moodImage
        case 5:
            moodImages[4] = mood.moodImage
        case 6:
            moodImages[5] = mood.moodImage
        case 7:
            moodImages[6] = mood.moodImage
        default :
            return
        }
    }
    

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = SoliUSpacing.space16
        layer.masksToBounds = true

        addSubView(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SoliUSpacing.space16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SoliUSpacing.space16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

extension WeeklyMoodLogSectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyMoodCell.identifier, for: indexPath) as? WeeklyMoodCell else {
            return UICollectionViewCell()
        }

        let moodImage = moodImages[indexPath.row] ?? UIImage(emotionAssetIdentifier: .noIcon)
        dates = dateSettingForWeekday()
        let isToday = indexPath.row == isToday()
        cell.configure(day: days[indexPath.row], date: dates[indexPath.row], moodImage: moodImage, isToday: isToday)
        return cell
    }

    func updateImageForToday(image: UIImage) {
         let todayIndex = isToday()
         moodImages[todayIndex] = image
         collectionView.reloadItems(at: [IndexPath(item: todayIndex, section: 0)])
     }

    private func isToday() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        return weekday - 1
    }
    
    private func dateSettingForWeekday() -> [String] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }

        var weekDates: [String] = []
        for offset in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                let dayString = dateFormatter.string(from: day)
                weekDates.append(dayString)
            }
        }
        return weekDates
    }
}

#if DEBUG
extension WeeklyMoodLogSectionView {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: WeeklyMoodLogSectionView

        var dates: [String] { target.dates }

        var moodImages: [UIImage?] { target.moodImages }

        var collectionView: UICollectionView { target.collectionView }

        var cellWidth: CGFloat { target.cellWidth }

        func fetchImages() { target.fetchImages() }

        func updateImageForToday(image: UIImage) {
            target.updateImageForToday(image: image)
        }
    }
}
#endif
