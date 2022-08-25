//
//  DetailViewController.swift
//  TestProject
//
//  Created by Bas on 25/8/2565 BE.
//

import UIKit
import FirebaseFirestore

protocol DetailViewControllerProtocol: NSObjectProtocol {
    func detailViewControllerProtocolRemove(movie: MovieModel)
    func detailViewControllerProtocolAdd(movie: MovieModel)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var contentImageView: UIImageView!
//    @IBOutlet weak var starImageView: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let db = Firestore.firestore()
    var movieModel: MovieModel?
    var favoriteMovies = [MovieModel]()
    weak var delegate: DetailViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let movieModel = movieModel {
            setMovieDataCell(movie: movieModel)
        }
    }

    func setMovieDataCell(movie: MovieModel) {
        titleLabel.text = movie.title
        subTitleLabel.text = movie.synopsis
        do {
            let url = try? movie.images.jpg.large_image_url.asURL()
            contentImageView.kf.setImage(with: url)
        }
        
        if let score = movie.score {
            scoreLabel.isHidden = false
            scoreLabel.text = "Score \(score.string)/10"
        } else {
            scoreLabel.isHidden = true
        }
        
        favoriteButton.isHidden = (movie.documentId != nil)
        removeButton.isHidden = (movie.documentId == nil)
//        starImageView.isSelected = isFavorite
    }

    
    @IBAction func openWebsite(_ sender: Any) {
        guard let first = UIStoryboard(name: "WebViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController, let url = try? movieModel?.url.asURL() else { return }
        
        first.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        first.url = url
        present(first, animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        guard let movieModel = movieModel else { return }
        guard let documentId = movieModel.documentId else { return }
        
        let db = Firestore.firestore()
//        LoadingStart(loadingText: .Removing)
        db.collection(LoginModel.userID).document(documentId).delete() { [weak self] err in
            guard let strongSelf = self else { return }
            
            if let err = err {
                print("Error removing document: \(err)")
//                strongSelf.LoadingStop()
            } else {
                print("Document successfully removed!")
//                strongSelf.LoadingStop()
                strongSelf.navigationController?.popViewController(animated: true)
                strongSelf.delegate?.detailViewControllerProtocolRemove(movie: movieModel)
            }
        }
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
    
        guard var movie = movieModel else {
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
//                    strongSelf.mainTableView.reloadData()
                    strongSelf.delegate?.detailViewControllerProtocolAdd(movie: movie)
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection(LoginModel.userID).addDocument(data: movie.toJson()) { [weak self] err in
                guard let strongSelf = self else { return }
                
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                    movie.documentId = ref?.documentID
                    strongSelf.movieModel?.documentId = movie.documentId
                    strongSelf.favoriteMovies.append(movie)
                    strongSelf.delegate?.detailViewControllerProtocolAdd(movie: movie)
                    strongSelf.favoriteButton.isHidden = true
                    strongSelf.removeButton.isHidden = false
                }
            }
        }
    }
    
    func checkFavariteMovie(movie: MovieModel) -> Bool {
        return favoriteMovies.filter({ $0.mal_id == movie.mal_id }).count > 0
    }
}
