//
//  ViewController.swift
//  Diary
//
//  Created by 장기화 on 2021/11/14.
//

import UIKit

class ViewController: UIViewController, WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        diaryList.append(diary)
        diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadDiaryList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func saveDiaryList() {
        let data = diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diary", for: indexPath) as? DiaryCollectionViewCell else { return UICollectionViewCell() }
        
        let diary = diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
        return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 200)
    }
}
