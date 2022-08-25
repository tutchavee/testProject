//
//  SecondViewController.swift
//  TestProject
//
//  Created by Bas on 19/8/2565 BE.
//

import UIKit
import FirebaseAuth
import Alamofire
import FirebaseCore
import FirebaseFirestore

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    let db = Firestore.firestore()
    let searchController = UISearchController(searchResultsController: nil)
    var arrMovie = [MovieModel]()
    var filteredMovies = [MovieModel]()
    var favoriteMovies = [MovieModel]()
    var isFavorite: Bool = false

    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
   
    private var movieName: String {
        get {
            return UserDefaults.standard.value(forKey: "KEY_ANIME") as? String ?? "naruto"
        } set {
            UserDefaults.standard.set(newValue, forKey: "KEY_ANIME")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        
        let font = UIFont(name: "Noteworthy-Light", size: 20)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = font
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = font


        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let _ = Auth.auth().currentUser else {
            gotoLoginPage()
            return
        }
        
        feedData()
        getFireStore()
    }
    
    private func feedData() {
        guard let url = try? "https://api.jikan.moe/v4/anime?q=\(movieName)".asURL() else {
            return
        }
        
        LoadingStart(loadingText: .Loading)
        
        AF.request(url).responseString { [weak self] response in
            guard let strongSelf = self else { return }
            
            do {
                guard let data = response.data else {
                    return
                }
                
                let responseModel = try JSONDecoder().decode(ModelResponse.self, from: data)
                strongSelf.arrMovie = responseModel.data
                strongSelf.mainTableView.reloadData()
                strongSelf.LoadingStop()
            } catch let error {
                strongSelf.LoadingStop()
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func gotoLoginPage() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController_nav") as? UINavigationController {
            present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func changeMovieName(_ sender: Any) {
        sortCategory()
    }
    
    @IBAction func favoriteMoviesAction(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
            vc.favoriteMovies = favoriteMovies
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            gotoLoginPage()
        }
        catch {
            print("already logged out")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func getFireStore() {
        db.collection(LoginModel.userID).getDocuments() { [weak self] (querySnapshot, err) in
            guard let strongSelf = self else { return }
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapshot = querySnapshot else {
                    return
                }
                
                strongSelf.favoriteMovies.removeAll()
                for doc in querySnapshot.documents {
                    let movie = MovieModel.createModel(dict: doc.data(), doccumentId: doc.documentID)
                    strongSelf.favoriteMovies.append(movie)
                }
                
                strongSelf.mainTableView.reloadData()
            }
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filteredMovies = arrMovie.filter { $0.title.contains(searchController.searchBar.text ?? "") }
        mainTableView.reloadData()
    }
}

extension MainViewController {
    func checkFavariteMovie(movie: MovieModel) -> Bool {
        return favoriteMovies.filter({ $0.mal_id == movie.mal_id }).count > 0
    }
    
    func sortCategory() {
        showInputDialog(title: "Movies name",
                        subtitle: "Please enter movie name",
                        actionTitle: "OK",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Movie name",
                        inputKeyboardType: .default, actionHandler:
                            { [weak self] (input:String?) in
            guard let strongSelf = self else { return }
            strongSelf.movieName = input ?? "onepiece"
            strongSelf.feedData()
        })
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredMovies.isEmpty {
                let emptyDataView = EmptyDataView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
                emptyDataView.setup(image: UIImage(named: "logo"),
                                    title: "No data",
                                    subTitle: "No anime cartoon data")
                tableView.backgroundView = emptyDataView
                return 0
            }
            tableView.backgroundView = nil
            return filteredMovies.count
        }
        
        if arrMovie.isEmpty {
            let emptyDataView = EmptyDataView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            emptyDataView.setup(image: UIImage(named: "logo"),
                                title: "No data",
                                subTitle: "No anime cartoon data")
            tableView.backgroundView = emptyDataView
            return 0
        }
        tableView.backgroundView = nil
        return arrMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell {
            cell.delegate = self
            let movie: MovieModel
            if isFiltering {
                movie = filteredMovies[indexPath.row]
            } else {
                movie = arrMovie[indexPath.row]
            }
            cell.setMovieDataCell(movie: movie, isFavorite: checkFavariteMovie(movie: movie))
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
            } else {
                cell.backgroundColor = .tableViewGrey
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movie: MovieModel
        if isFiltering {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = arrMovie[indexPath.row]
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            let moviesFilterd = favoriteMovies.filter { $0.mal_id == movie.mal_id }
            if let movieFilter = moviesFilterd.first {
                vc.movieModel = movieFilter
            } else {
                vc.movieModel = movie
            }
            vc.favoriteMovies = favoriteMovies
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension MainViewController: MainTableViewCellProtocol {
    func mainTableViewCellProtocolFavorite(movie: MovieModel) {
        
        var movieModel: MovieModel?
        if isFiltering {
            movieModel = filteredMovies.filter{ $0.mal_id == movie.mal_id }.first
        } else {
            movieModel = arrMovie.filter{ $0.mal_id == movie.mal_id }.first
        }
    
        guard var movieModel = movieModel else {
            return
        }

        
        if checkFavariteMovie(movie: movie) {
            let moviesFilterd = favoriteMovies.filter { $0.mal_id == movie.mal_id }
            guard let movieFiltred = moviesFilterd.first, let documentId = movieFiltred.documentId else { return }
//            LoadingStart(loadingText: .Saving)
            db.collection(LoginModel.userID).document(documentId).delete() { [weak self] err in
                guard let strongSelf = self else { return }
                
                if let err = err {
                    print("Error removing document: \(err)")
//                    strongSelf.LoadingStop()
                } else {
                    print("Document successfully removed!")
//                    strongSelf.LoadingStop()
                    strongSelf.favoriteMovies.removeAll(where: { $0.mal_id == movie.mal_id } )
                    strongSelf.mainTableView.reloadData()
                }
            }
        } else {
//            LoadingStart(loadingText: .Saving)
            var ref: DocumentReference? = nil
            ref = db.collection(LoginModel.userID).addDocument(data: movie.toJson()) { [weak self] err in
                guard let strongSelf = self else { return }
                
                if let err = err {
                    print("Error adding document: \(err)")
//                    strongSelf.LoadingStop()
                } else {
                    print("Document added")
//                    strongSelf.LoadingStop()
                    movieModel.documentId = ref?.documentID
                    strongSelf.favoriteMovies.append(movieModel)
                    strongSelf.mainTableView.reloadData()
                }
            }
        }
    }
}
