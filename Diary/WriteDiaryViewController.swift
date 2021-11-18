//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 장기화 on 2021/11/14.
//

import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputField()
        configureContentsTextView()
        configureDatePicker()
        configureEditMode()
        confirmButton.isEnabled = false
    }
    
    //유저가 화면을 터치하면 호출되는 메서드!!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        contentsTextView.layer.borderColor = borderColor.cgColor
        contentsTextView.layer.borderWidth = 0.5
        contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ko_KR")
        dateTextField.inputView = datePicker
    }
    
    private func configureInputField() {
        contentsTextView.delegate = self
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureEditMode() {
        switch diaryEditorMode {
        case let .edit(_, diary):
            titleTextField.text = diary.title
            contentsTextView.text = diary.contents
            dateTextField.text = dateToString(date: diary.date)
            diaryDate = diary.date
            confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func validateInputField() {
        confirmButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && !(contentsTextView.text.isEmpty ) && !(dateTextField.text?.isEmpty ?? true)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        diaryDate = datePicker.date
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        validateInputField()
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let contents = contentsTextView.text else { return }
        guard let date = diaryDate else { return }
        
        switch diaryEditorMode {
        case .new:
            let diary = Diary(uuidString: UUID().uuidString, title: title, contents: contents, date: date, isStar: false)
            delegate?.didSelectRegister(diary: diary)
            
        case let .edit(indexPath, diary):
            let diary = Diary(uuidString: diary.uuidString, title: title, contents: contents, date: date, isStar: diary.isStar)
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        navigationController?.popViewController(animated: true)
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateInputField()
    }
}
