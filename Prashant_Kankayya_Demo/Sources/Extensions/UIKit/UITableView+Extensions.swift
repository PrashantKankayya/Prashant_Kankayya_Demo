//
//  File.swift
//  Prashant_Kankayya_Demo


import UIKit

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        return lastIndexPath == indexPath
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
       let className = cellType.className
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
       register(nib, forCellReuseIdentifier: className)
   }

    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
       cellTypes.forEach { register(cellType: $0) }
   }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
       return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
   }
}
