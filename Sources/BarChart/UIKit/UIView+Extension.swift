//
//  UIView+MakeCircle.swift
//  MyExpenses
//
//  Created by Marek Pridal on 26.08.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit

extension UIView {
    @available(iOS, deprecated: 14.0, message: "Use UIAction instead")
    func addTapGestureRecognizer(action: (() -> Void)?) {
        tapAction = action
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(recognizer)
    }
}

fileprivate extension UIView {
    typealias Action = (() -> Void)

    enum Key {
        static var id = "tapAction"
    }

    var tapAction: Action? {
        get {
            return objc_getAssociatedObject(self, &Key.id) as? Action
        }
        set {
            guard let value = newValue else { return }
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            objc_setAssociatedObject(self, &Key.id, value, policy)
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        tapAction?()
    }
}
