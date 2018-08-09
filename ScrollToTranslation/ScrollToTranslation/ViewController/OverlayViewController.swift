//
//  OverlayViewController.swift
//  ScrollToTranslation
//
//  Created by Gaétan Zanella on 08/08/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    private(set) lazy var tableView = GripableTableView()

    override func loadView() {
        view = tableView
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
    }
}

extension OverlayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Cell \(indexPath)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}
