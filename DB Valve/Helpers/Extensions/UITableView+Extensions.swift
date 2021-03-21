//
//  UITableView+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 04/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit


// MARK: - Properties
extension UITableView {
    
    /// Index path of last row in tableView.
    public var indexPathForLastRow: IndexPath? {
        return indexPathForLastRow(inSection: lastSection)
    }
    
    /// Index of last section in tableView.
    public var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    /// Number of all rows in all sections of tableView.
    public var numberOfRows: Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
}

// MARK: - Methods
extension UITableView {
    
    /// IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    public func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    public func reloadDataWith(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// Remove TableFooterView.
    public func removeTableFooterView() {
        tableFooterView = nil
    }
    
    /// Remove TableHeaderView.
    public func removeTableHeaderView() {
        tableHeaderView = nil
    }
    
    
    /// Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    /// Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name (optional value)
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as? T
    }
    
    /// Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    /// Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name (optional value)
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    public func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    public func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    public func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    public func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
}

extension UITableView {
    
    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }
}


extension UITableView {
    
    @objc func reloadEmptyView() {
        self.reloadEmptyView()
        guard let dataSource = dataSource else { return }
        
        if dataSource.responds(to: #selector(dataSource.numberOfSections(in:))) {
            if dataSource.numberOfSections!(in: self) == 0 {
                if self.backgroundView?.alpha == 0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView?.alpha = 1
                    })
                }
            } else {
                var showEmptyView = true
                for section in 0..<dataSource.numberOfSections!(in: self) {
                    if dataSource.tableView(self, numberOfRowsInSection: section) > 0 {
                        showEmptyView = false
                        break
                    }
                }
                if showEmptyView {
                    if self.backgroundView?.alpha == 0 {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView?.alpha = 1
                        })
                    }
                }else {
                    if self.backgroundView?.alpha == 1 {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView?.alpha = 0
                        })
                    }
                }
            }
            
        } else if dataSource.responds(to: #selector(dataSource.tableView(_:numberOfRowsInSection:))) {
            if dataSource.tableView(self, numberOfRowsInSection: 0) > 0 {
                if self.backgroundView?.alpha == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView?.alpha = 0
                    })
                }
            } else {
                if self.backgroundView?.alpha == 0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView?.alpha = 1
                    })
                }
            }
        }
    }
    
    @objc func reloadEmptyView_onEnd() {
        self.reloadEmptyView_onEnd()
        guard let dataSource = dataSource else { return }
        
        if dataSource.responds(to: #selector(dataSource.numberOfSections(in:))) {
            if dataSource.numberOfSections!(in: self) == 0 {
                if self.backgroundView?.alpha == 0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView?.alpha = 1
                    })
                }
            }else {
                var showEmptyView = true
                for section in 0..<dataSource.numberOfSections!(in: self) {
                    if dataSource.tableView(self, numberOfRowsInSection: section) > 0 {
                        showEmptyView = false
                        break
                    }
                }
                if showEmptyView {
                    if self.backgroundView?.alpha == 0 {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView?.alpha = 1
                        })
                    }
                }else {
                    if self.backgroundView?.alpha == 1 {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView?.alpha = 0
                        })
                    }
                }
            }
        }
    }
    
    func setEmptyView(_ view: UIView?) {
        self.backgroundView = view
        self.backgroundView?.layer.zPosition = -2
    }
    
}
#endif
