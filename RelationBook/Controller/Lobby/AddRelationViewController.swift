//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/9.
//

import UIKit

class AddRelationViewController: UIViewController {
    
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
            searchTextField.layer.masksToBounds = true
            searchTextField.layer.borderWidth = 1
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func confirm(_ sender: UIButton) {
        print("confirm")
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddRelationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

extension AddRelationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension AddRelationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
}
