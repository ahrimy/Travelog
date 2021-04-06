//
//  StarredPostListViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/04/06.
//

import UIKit

class StarredPostListViewController: UIViewController {
    
    let sections = Bundle.main.decode([Section].self, from: "StarredPostList.json")
    var StarredPostListCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, StarredPostList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StarredPostListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        StarredPostListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        StarredPostListCollectionView.backgroundColor = .systemBackground
        view.addSubview(StarredPostListCollectionView)
        
        StarredPostListCollectionView.register(StarredPostListCell.self, forCellWithReuseIdentifier: StarredPostListCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with starredpostlist: StarredPostList, for indexPath: IndexPath) -> T {
        guard let cell = StarredPostListCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: starredpostlist)
        
        return cell
    }
    
    func createDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, StarredPostList>(collectionView: StarredPostListCollectionView){ StarredPostListCollectionView, indexPath, starredpostlist in switch self.sections[indexPath.section].type {
        default: return self.configure(StarredPostListCell.self, with: starredpostlist, for: indexPath)}
        }
    }
    
    func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, StarredPostList>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in let section = self.sections[sectionIndex]
            switch section.type {
            default:
                return self.createSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createSection(using section: Section) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(340))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
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
