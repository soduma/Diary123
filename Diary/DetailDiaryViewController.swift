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
        guard let indexPath = indexpath else { return }

        if isStar {
            starButton?.image = UIImage(systemName: "star")
        } else {
            starButton?.image = UIImage(systemName: "star.fill")
        }
        diary?.isStar = !isStar
        NotificationCenter.default.post(name: NSNotification.Name("starDiary"),object: [
                "isStar": diary?.isStar ?? false,
                "indexPath": indexPath
            ],
            userInfo: nil)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
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
        guard let indexpath = indexpath else { return }
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: indexpath, userInfo: nil)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
