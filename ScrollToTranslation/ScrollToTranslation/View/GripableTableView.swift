//
//  GripableTableView.swift
//  ScrollToTranslation
//
//  Created by Gaétan Zanella on 08/08/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol GripableTableViewDelegate : class {
    func gripableTableView(_ tableView: UITableView,
                           shouldResetContentOffsetDuringLayout newValue: CGPoint) -> Bool
}

class GripableTableView: UITableView {

    weak var gripableDelegate: GripableTableViewDelegate?

    override func layoutSubviews() {
        if gripableDelegate?.gripableTableView(self, shouldResetContentOffsetDuringLayout: contentOffset) ?? false {
            contentOffset = .zero
        }
        super.layoutSubviews()
    }
}
