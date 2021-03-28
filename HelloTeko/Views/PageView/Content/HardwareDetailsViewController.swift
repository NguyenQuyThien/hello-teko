//
//  HardwareDetailsViewController.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

class HardwareDetailsViewController: UIViewController {

    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource = [
        HardwareDetail(title: "Thương hiệu", detail: "Cooler Master"),
        HardwareDetail(title: "Bảo hành", detail: "36 tháng"),
        HardwareDetail(title: "Công suất", detail: "140W"),
        HardwareDetail(title: "Xuất xứ", detail: "Trung Quốc"),
        HardwareDetail(title: "Bộ nhớ đệm", detail: "8.25MB"),
        HardwareDetail(title: "Thương hiệu 2", detail: "Cool"),
        HardwareDetail(title: "Bảo hành 2", detail: "3 tháng"),
        HardwareDetail(title: "Công suất 2", detail: "10W")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setCornerRadius(cornerRadius: 10)
        tableView.register(R.nib.hardwareDetailTableViewCell)
    }

}

extension HardwareDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.hardwareDetailTableViewCell.identifier) as! HardwareDetailTableViewCell
        cell.bind(model: dataSource[indexPath.row])
        cell.backgroundColor = indexPath.row % 2 == 0 ? .paleGrey : .white
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

struct HardwareDetail {
    let title, detail: String
}
