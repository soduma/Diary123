//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by 장기화 on 2021/11/14.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexpath: IndexPath)
}

class DetailDiaryViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsTextLabel: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    var diary: Diary?
    var indexpath: IndexPath?
    weak var delegate: DiaryDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        guard let diary = diary else { return }
        titleLabel.text =  diary.title
        contentsTextLabel.text = diary.contents
        dateLabel.text = dateToString(date: diary.date)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexpath = indexpath else { return }
        delegate?.didSelectDelete(indexpath: indexpath)
        navigationController?.popViewController(animated: true)
    }
}
