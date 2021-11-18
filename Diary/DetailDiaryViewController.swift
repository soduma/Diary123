//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by 장기화 on 2021/11/14.
//

import UIKit

class DetailDiaryViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsTextLabel: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    var diary: Diary?
    var indexpath: IndexPath?
    var starButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
    }
    
    private func configureView() {
        guard let diary = diary else { return }
        titleLabel.text =  diary.title
        contentsTextLabel.text = diary.contents
        dateLabel.text = dateToString(date: diary.date)
        starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        starButton?.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = starButton
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func tapStarButton() {
        guard let isStar = diary?.isStar else { return }

        if isStar {
            starButton?.image = UIImage(systemName: "star")
        } else {
            starButton?.image = UIImage(systemName: "star.fill")
        }
        diary?.isStar = !isStar
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: ["diary": diary,
                     "isStar": diary?.isStar ?? false,
                     "uuidString": diary?.uuidString
                    ],
            userInfo: nil)
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = diary else { return }
        
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            configureView()
        }
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        configureView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexpath = indexpath else { return }
        guard let diary = diary else { return }
        viewController.diaryEditorMode = .edit(indexpath, diary)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = diary?.uuidString else { return }
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: uuidString, userInfo: nil)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
