//
//  UIViewController+Extensions.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func exampleFunction(arr: [Int], index: Int) throws -> Int {
        guard (0..<arr.count).contains(index) else {
            throw SampleError.IndexOutofBounds
        }
        return arr[index]
    }
    
}

enum SampleError: Error {
    case IndexOutofBounds
}
