//
//  FavoriteViewController.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FavoriteViewController: UIViewController {

    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var favoriteMovies: [MovieModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        // Do any additional setup after loading the view.
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

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoriteMovies?.count ?? 0 == 0 {
            let emptyDataView = EmptyDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            emptyDataView.setup(image: UIImage(named: "logo"),
                                title: "No data",
                                subTitle: "No anime cartoon favorite")
            collectionView.backgroundView = emptyDataView
            return 0
        }
        collectionView.backgroundView = nil
        return favoriteMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell {
            
            if let movie = favoriteMovies?[indexPath.row] {
                cell.setMovieDataCell(movie: movie)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let favoriteMovies = favoriteMovies else { return }
        
        /*
        let movie = favoriteMovies[indexPath.item]
        guard let documentId = movie.documentId else { return }
        let db = Firestore.firestore()
        LoadingStart(loadingText: .Removing)
        db.collection(LoginModel.userID).document(documentId).delete() { [weak self] err in
            guard let strongSelf = self else { return }
            
            if let err = err {
                print("Error removing document: \(err)")
                strongSelf.LoadingStop()
            } else {
                print("Document successfully removed!")
                strongSelf.LoadingStop()
                strongSelf.favoriteMovies?.removeAll(where: { $0.mal_id == movie.mal_id } )
                strongSelf.mainCollectionView.reloadData()
            }
        }
         */
        let movie = favoriteMovies[indexPath.item]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.movieModel = movie
            vc.favoriteMovies = favoriteMovies
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


extension FavoriteViewController: DetailViewControllerProtocol {
    func detailViewControllerProtocolRemove(movie: MovieModel) {
        favoriteMovies?.removeAll(where: { $0.mal_id == movie.mal_id } )
        mainCollectionView.reloadData()
    }
    
    func detailViewControllerProtocolAdd(movie: MovieModel) {
        mainCollectionView.reloadData()
    }
}
