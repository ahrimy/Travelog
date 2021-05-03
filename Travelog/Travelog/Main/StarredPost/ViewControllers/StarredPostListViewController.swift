//
//  StarredPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import UIKit

class StarredPostListViewController: UIViewController {

    lazy var sections: [Section] = {
        return Bundle.main.decode([Section].self, from: "StarredPostList.json")
    }()
    
    lazy var StarredPostListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StarredPostListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        StarredPostListCollectionView.backgroundColor = .systemBackground
        view.addSubview(StarredPostListCollectionView)
        
        StarredPostListCollectionView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 설정
        StarredPostListCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        StarredPostListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        StarredPostListCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        StarredPostListCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        StarredPostListCollectionView.register(StarredPostListCell.self, forCellWithReuseIdentifier: StarredPostListCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StarredPostListCollectionView.reloadData()
    }
}
extension StarredPostListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[0].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StarredPostListCell.reuseIdentifier, for: indexPath) as? StarredPostListCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: sections[0].items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(sections[0].items[indexPath.item])") // TODO: 셀 클릭 했을 때, 동작
        
        // 포스트 상세 페이지 모달
        let postDetailView = self.storyboard?.instantiateViewController(withIdentifier: "postDetailView")
        postDetailView?.modalTransitionStyle = .coverVertical
        self.present(postDetailView!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 2, height: 350) // TODO: 셀 사이즈 지정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
