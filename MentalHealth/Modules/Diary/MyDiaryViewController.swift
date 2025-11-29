//
//  MyDiaryViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 4/15/24.
//

import UIKit

// Note: This is AI counseler Section
final class MyDiaryViewController: BaseViewController {
    @IBOutlet weak var greetLabel: SoliULabel!
    @IBOutlet weak var titleLabel: SoliULabel!
    
    private lazy var submitButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.setTitle(.localized(.startTalking), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: SoliUSpacing.space16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = SoliUColor.diarySubmitButton
        button.layer.cornerRadius = SoliUSpacing.space16
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }


    var dataSource: [AdviceItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: DiarcyCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DiarcyCell.reuseIdentifier)

        setCustomBackNavigationButton()
        update()
        setUpDataSource()
        setupView()
    }
    
        func setupView() {
        view.addSubView(submitButton)

        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        submitButton.addTarget(self, action: #selector(navigateToMyDiaryRecordScreen), for: .touchUpInside)
    }
    
    func update() {
        greetLabel.text =  "\(String.localized(.hey)), \(LoginManager.shared.getNickName())"
        let fullText: String = .localized(.aiCounselorTitle)
        var range: NSRange
        
        // Define the attributes for the word "concern"
        if SoliULanguageManager.shared.currentLanguage == "ko" {
            range = (fullText as NSString).range(of: "걱정")
        } else {
            range = (fullText as NSString).range(of: "concern")
        }
        let attributedString = NSMutableAttributedString(string: fullText)

        // Add underline and color attributes
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString.addAttribute(.foregroundColor, value: SoliUColor.diarySubmitButton, range: range)

        // Assign the attributed string to the label
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
    }
    
    
    
    func appendToDataSource(newItem: AdviceItem) {
           dataSource.append(newItem)
           let dateFormatter = ISO8601DateFormatter()
           dataSource.sort { (item1, item2) -> Bool in
               guard let date1 = dateFormatter.date(from: item1.date),
                     let date2 = dateFormatter.date(from: item2.date) else {
                   return false
               }
               return date1 > date2
           }
           tableView.reloadData()
    }
    
    func setUpDataSource() {
        dataSource = LoginManager.shared.getDiaryEntriesList()
        let dateFormatter = ISO8601DateFormatter()
        dataSource.sort { (item1, item2) -> Bool in
            guard let date1 = dateFormatter.date(from: item1.date),
                  let date2 = dateFormatter.date(from: item2.date) else {
                return false
            }
            return date1 > date2
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func openDiaryTextViewController(adviceItem: AdviceItem) {
        navigate(to: MyDiaryTextViewController.self, storyboardName: "MyDiaryFlow") { myDiaryTextViewController in
            myDiaryTextViewController.adviceItem = adviceItem
        }
    }
}
extension MyDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myDiaryItem = dataSource[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiarcyCell.reuseIdentifier) as? DiarcyCell else {
            return UITableViewCell()
        }
        cell.populate(myDiary: myDiaryItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let adviceItem = dataSource[indexPath.row]
        openDiaryTextViewController(adviceItem: adviceItem)
    }
}

extension MyDiaryViewController {
    @objc func navigateToMyDiaryRecordScreen() {
        navigate(to: MyDiaryRecordViewController.self, storyboardName: "MyDiaryFlow")
    }
}
