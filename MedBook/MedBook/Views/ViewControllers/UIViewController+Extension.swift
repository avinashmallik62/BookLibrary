//
//  UIViewController+Extension.swift
//  MedBook
//
//  Created by Avinash Kumar on 29/01/24.
//

import Foundation
import UIKit

extension UIViewController {
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    private struct AssociatedKeys {
        static var dataBaseHandler = "dataBaseHandler"
    }
    
    var dataBaseHandler: DataBaseHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dataBaseHandler) as? DataBaseHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dataBaseHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func initialiseDataBaseHandler() {
        guard let userModelName = appDelegate?.userModelName,
              let bookModelName = appDelegate?.bookModelName else {
                fatalError("User model name or book model name is nil.")
            }

        let userDBManager = DataBaseManager(modelName: userModelName)
        let bookDBManager = DataBaseManager(modelName: bookModelName)
        dataBaseHandler = DataBaseHandler(userDataBaseManager: userDBManager, bookDataBaseManager: bookDBManager)
    }
}

