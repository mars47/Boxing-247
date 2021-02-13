//
//  NewsFeedVC.swift
//  Boxing 247
//
//  Copyright © 2018 Omar. All rights reserved.
//

import UIKit

class NewsFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties 

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationPanelButton: UIBarButtonItem!
    let viewModel = NewsFeedVM()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureView()
        configureReloadTask()
        viewModel.downloadNews{}
    }
    
    // MARK: - Configuration
    
    fileprivate func configureView() {
        
        collectionView.register(UINib.init(nibName: "NewsFeedCell4", bundle: nil), forCellWithReuseIdentifier: "tCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl

        layout.minimumLineSpacing = 18.5
        refreshControl.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        view.backgroundColor = dark247
        navigationController?.navigationBar.isTranslucent = true
    }

    fileprivate func configureReloadTask() {
        viewModel.reloadCollectionView = { [self] in
            collectionView?.reloadData()
        }
    }
    
    // MARK: - Refresh

    @objc private func refreshNews(_ sender: Any) {
        viewModel.downloadNews {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }


    // MARK: - collectionView Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tCell", for: indexPath) as! NewsFeedCell
        let article = viewModel.articles[indexPath.row]
        cell.configureCell(with: article)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let deviceSize = UIScreen.main.bounds.size
        let cellInsets = 2 * 20 as CGFloat
        let labelInsets = 16 * 2 as CGFloat
        let cellWidth = (deviceSize.width - cellInsets)
        
        // Calulates height of cell by adding the heights of all views + spacing found in NewsFeedCell.xib
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tCell", for: indexPath) as! NewsFeedCell
        let article = viewModel.articles[indexPath.row]
        let cellHeight =
            
                cell.calculateHeightForLable(text: article.title, font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold), width: cellWidth - labelInsets, lines: 2)
                //+ cell.calculateHeightForLable(text: cellViewModel.article.author, font: UIFont.italicSystemFont(ofSize: 13), width: cellWidth - labelInsets, lines: 1)
                + 25 // button stackview
                + cellWidth / 5.63 
                //+ cell.thumbnail.bounds.size.height
                //+ 16 // stackview subview spacing
                //+ 12 // top+bottom stackview space
        
        return CGSize(width: cellWidth , height: cellHeight)
    }
    
    // MARK: collectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showNewsDetail", sender: nil)
        
        //guard let newsFeedDetailVC = storyboard?.instantiateViewController(withIdentifier: "NewsFeedDetail") as? NewsFeedDetailVC else { return }
        //self.centerNavigationController?.pushViewController(newsFeedDetailVC, animated: true)
    }
}
// https://stackoverflow.com/questions/44187881/uicollectionview-full-width-cells-allow-autolayout-dynamic-height/44352072