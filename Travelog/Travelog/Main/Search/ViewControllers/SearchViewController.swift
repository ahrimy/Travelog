//
//  SearchViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/30.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        // Do any additional setup after loading the view.
    }
    
    func setSearchBar(){
        
        //서치바 만들기
        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = "Search"
        //왼쪽 서치아이콘 이미지 세팅하기
        searchController.searchBar.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        //오른쪽 x버튼 이미지 세팅하기
        searchController.searchBar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        //네비게이션에 서치바 넣기
//        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        searchController.searchBar.scopeButtonTitles = [ "장소", "계정", "태그"]
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .selected)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.searchController = searchController
        searchController.automaticallyShowsCancelButton = true
    
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            //플레이스홀더 글씨 색 정하기
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            //서치바 텍스트입력시 색 정하기
            textfield.textColor = UIColor.white
            //왼쪽 아이콘 이미지넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트컬러 정하기
                leftView.tintColor = UIColor.white
            }
            //오른쪽 x버튼 이미지넣기
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트 정하기
                rightView.tintColor = UIColor.white
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
