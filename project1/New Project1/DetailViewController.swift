//
//  DetailViewController.swift
//  New Project1
//
//  Created by Артем Чжен on 08/12/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        title = selectedImage - создает заголовок в виде nssl038
        title = "This image is \(selectedPictureNumber) out of \(totalPictures)"
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareLink))
        
        
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        
    }
    @objc func shareLink() {
        let link = "https://github.com/Busido14/project1"
    
        let dc = UIActivityViewController(activityItems: [link], applicationActivities: [])
        dc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(dc, animated: true)
    }
}
