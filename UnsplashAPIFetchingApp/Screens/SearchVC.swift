//
//  SearchVC.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import UIKit


class SearchVC: DataLoadingVC {
    
    private lazy  var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    private var timer: Timer?
    
    var requestImagesResults: [imagesResult]       = []
    var randomImagesResults:  [RandomImagesResult] = []
    
    var isSearchingByRandom = true
    var isLoadingMoreImages = false
    var moreImages = true
    
    var searchRequest = ""
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifureViewController()
        configureCollectionView()
        getRandomImages()
        configureSearchController()
        createDismissKeyboardTapGesture()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.WhiteandFluffyColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
    //MARK: - Fetching Data
    func getImagesByRequest(request: String, page: Int) {
        isSearchingByRandom = false
        showLoadingView()
        isLoadingMoreImages = true
        NetworkManager.shared.getImagesByRequest(for: request, page: page)  { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let resultsImages):
                if resultsImages.results.count < 20{self.moreImages = false}
                else {self.moreImages = true}
                self.requestImagesResults.append(contentsOf: resultsImages.results)
                self.reloadCollectionView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
            
            self.isLoadingMoreImages = false
        }
    }
    
    
    func getRandomImages() {
        isSearchingByRandom = true
        moreImages          = false
        showLoadingView()
        NetworkManager.shared.getRandomImages(){ [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let randomImagesResult):
                self.randomImagesResults.removeAll()
                self.randomImagesResults = randomImagesResult
                self.reloadCollectionView()
                
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
        title = "Random"
    }
    
    private func congifureViewController(){
        view.backgroundColor = .systemBackground
    }
    
    
    //MARK: - Configure UI elements
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
    }
    
    //MARK: - Configure Search Controller
    func configureSearchController() {
        let searchController             = UISearchController()
        searchController.searchBar.delegate                     = self
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search for a image"
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.searchController                         = searchController
        
    }
    
    //MARK: -  Additional Functions
    private func reloadCollectionView(){
        DispatchQueue.main.async{
            self.collectionView.reloadData()
            
        }
    }
    
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
    }
    
    func setOldRandomImages(){
        requestImagesResults.removeAll()
        isSearchingByRandom = true
        reloadCollectionView()
        title = "Random"
    }
    
}



//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isSearchingByRandom {
        case true:
            return randomImagesResults.count
        default:
            return requestImagesResults.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        
        switch isSearchingByRandom {
        case true:
            let image = randomImagesResults[indexPath.row]
            cell.setDefaultImage()
            cell.setForRandom(image: image)
            
        default:
           print("requestImagesResults.count \(requestImagesResults.count)")//testing for 0 value
            switch requestImagesResults.count {
            case 1...:
                let image = requestImagesResults[indexPath.row]
                cell.setForRequest(image: image)
            default:
                break
            }
           
            
        }
        
        return cell
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y//already scrolled data
        let contentHeight = scrollView.contentSize.height//total height of data
        let height = scrollView.frame.size.height//screen height
        
        
        if offSetY > contentHeight - height{
            guard moreImages, !isLoadingMoreImages, !isSearchingByRandom else {return}
            page += 1
            getImagesByRequest(request: searchRequest, page: page)
            moreImages = false
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = ImageInfoVC()
        if isSearchingByRandom == false{
            let resultRequest         = requestImagesResults[indexPath.item]
            
            destinationVC.authorsName = resultRequest.user.username
            destinationVC.imageUrl    = resultRequest.urls.small
            destinationVC.updatedAt   = resultRequest.updatedAt
            destinationVC.userHTML    = resultRequest.user.links.html
            destinationVC.likes       = resultRequest.likes
            destinationVC.idOfImage   = resultRequest.id
        }
        else {
            let resultRandom          = randomImagesResults[indexPath.item]
            
            destinationVC.authorsName = resultRandom.user.username
            destinationVC.imageUrl    = resultRandom.urls.small
            destinationVC.updatedAt   = resultRandom.updatedAt
            destinationVC.userHTML    = resultRandom.user.links.html
            destinationVC.likes       = resultRandom.likes
            destinationVC.idOfImage   = resultRandom.id
        }
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
    
}


//MARK: - UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
extension SearchVC: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
        searchRequest = searchController.searchBar.text ?? ""
        guard let filter = searchController.searchBar.text,  !filter.isEmpty else {
            setOldRandomImages()
            return }
        
        page = 1
        requestImagesResults.removeAll()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){ _ in
            self.requestImagesResults.removeAll()
            self.getImagesByRequest(request: self.searchRequest, page: self.page)
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.setOldRandomImages()
        
    }
    
}

