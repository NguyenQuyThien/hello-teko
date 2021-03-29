//
//  HardwareDetailsViewController.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import RxSwift

class HardwareDetailsViewController: UIViewController {
    
    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var btnViewTapped: UIButton!
    
    var isShowMoreInfo: ((Bool)->Void)?
    private let disposeBag = DisposeBag()
    
    private var dataSource = [
        HardwareDetail(title: "Thương hiệu", detail: "Cooler Master"),
        HardwareDetail(title: "Bảo hành", detail: "36 tháng"),
        HardwareDetail(title: "Công suất", detail: "140W"),
        HardwareDetail(title: "Xuất xứ", detail: "Trung Quốc"),
        HardwareDetail(title: "Bộ nhớ đệm", detail: "8.25MB")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        setupTap()
    }
    
    private func setupTableView() {
        tableView.setCornerRadius(cornerRadius: 10)
        tableView.register(R.nib.hardwareDetailTableViewCell)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
    
    private func setupUI() {
        gradientBackground.applyGradient(colours: [.init(white: 1, alpha: 0), .white],
                                         locations: [0.0, 0.75, 1.0], isVertical: true)
    }
    
    private func setupTap() {
        btnViewTapped.rx.tap
            .bind { [unowned self] in
                self.btnViewTapped.isSelected.toggle()
                self.gradientBackground.isHidden = self.btnViewTapped.isSelected
                self.view.layoutIfNeeded()
                self.isShowMoreInfo?(self.btnViewTapped.isSelected)
        }.disposed(by: disposeBag)
    }
        
    func getTableViewContentHeight() -> CGFloat {
        tableView.reloadData()
        tableView.layoutSubviews()
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
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
