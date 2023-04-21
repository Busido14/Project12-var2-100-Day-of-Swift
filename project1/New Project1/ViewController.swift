//
//  ViewController.swift
//  New Project1
//
//  Created by Артем Чжен on 08/12/22.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "savedPictures") as? Data {
            let jsonDecoder = JSONDecoder()
                        do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load data")
            }
        }
        
        if pictures.isEmpty {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            //        print(items)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    let picture = Picture(image: item, views: 0)
                    pictures.append(picture)
                }
            }
            //        print(pictures)
            //        pictures.sort()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.item]
        cell.textLabel?.text = picture.image
        cell.textLabel?.text = "Viewed: \(picture.views)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            let picture = pictures[indexPath.item]
            dc.selectedImage = picture.image
            dc.selectedPictureNumber = indexPath.row + 1
            dc.totalPictures = pictures.count
            picture.views += 1
            save()
            tableView.reloadData()
            navigationController?.pushViewController(dc, animated: true)
        }
    }
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
}
