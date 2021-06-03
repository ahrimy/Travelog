//
//  SearchViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/30.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var SearchViewCollectionView: UICollectionView!
    @IBOutlet weak var SearchViewResultTableView: UITableView!
    
    var posts:[PostOverview] = []
    let cellIdentifier: String = "SearchViewPostCell"
    //서치바 만들기
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        setSearchBar()
        
        SearchViewCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        SearchViewCollectionView.backgroundColor = .systemBackground
        view.addSubview(SearchViewCollectionView)
        
        SearchViewCollectionView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 설정
        SearchViewCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SearchViewCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        SearchViewCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        SearchViewCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        SearchViewCollectionView.register(SearchViewPostCell.self, forCellWithReuseIdentifier: SearchViewPostCell.reuseIdentifier)
        
        SearchViewCollectionView.dataSource = self
        SearchViewCollectionView.delegate = self
        
        PostService.shared.loadPostOverviewsForStarredPostList(loadPosts: loadPosts(posts:))
    }
    
    func appendPost(post:PostOverview){
        self.posts.append(post)
        self.SearchViewCollectionView.reloadData()
    }
    
    func loadPosts(posts:[PostOverview]){
        self.posts = posts
        self.SearchViewCollectionView.reloadData()
    }
    
    func setSearchBar() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        searchController.searchBar.placeholder = "Search"
        //왼쪽 서치아이콘 이미지 세팅하기
        searchController.searchBar.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        //오른쪽 x버튼 이미지 세팅하기
        searchController.searchBar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        searchController.searchBar.scopeButtonTitles = [ "장소", "계정"]
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([.foregroundColor : UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .selected)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.tintColor = UIColor.white

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
        //네비게이션에 서치바 넣기
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // FIXME: 이거 추가하니까 상단에 잘 나와요
        definesPresentationContext = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewPostCell", for: indexPath) as? SearchViewPostCell else { return UICollectionViewCell()}
        
        cell.configure(with: posts[indexPath.row])
        
        return cell
    }
    
}



extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UICollectionViewDelegateFlowLayout {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 2, height: 300) // TODO: 셀 사이즈 지정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
