//
//  ViewController.swift
//  NewsApp
//
//  Created by Anna on 11.07.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "News"
        
        APICaller.shared.getNews { result in
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}

