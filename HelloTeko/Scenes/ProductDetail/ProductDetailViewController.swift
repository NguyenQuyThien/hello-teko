//
//  ProductDetailViewController.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import PagingKit
import RxCocoa
import RxSwift

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var btnBackLeftBarButton: UIButton!
    @IBOutlet weak var lblTitleProductName: UILabel!
    @IBOutlet weak var lblTitleProductPrice: UILabel!
    @IBOutlet weak var lblNumberItemsInCart: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lblDetailProductName: UILabel!
    @IBOutlet weak var lblProuctCodeLabel: UILabel!
    @IBOutlet weak var lblProductCode: UILabel!
    
    @IBOutlet var pagingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewOfSameItems: UICollectionView!
    
    @IBOutlet weak var gradientBackgroundAddToCartBtn: UIView!
    @IBOutlet weak var btbRemoveItems: UIButton!
    @IBOutlet weak var lblTotalItems: UIButton!
    @IBOutlet weak var btbAddItems: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnAddItemsToCart: UIButton!
    
    private let disposeBag = DisposeBag()
    var product: Product!
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    private let menuCellIndentifier = "MenuCell"
    
    private static var mockTabBarView: (UIColor) -> HardwareDetailsViewController = { (color) in
        let vc = R.storyboard.pagingContent.hardwareDetailsViewController()!
        vc.view.backgroundColor = color
        vc.container.isHidden = color == .white ? false : true
        return vc
    }
    private let mockTabBars: [HardwareDetailsViewController] = [mockTabBarView(.green), mockTabBarView(.white), mockTabBarView(.yellow)]
    private lazy var dataSource = [(menuTitle: mockTitleTabBar.descriptionTitle.rawValue, vc: mockTabBars[0]),
                                   (menuTitle: mockTitleTabBar.hardwareTitle.rawValue, vc: mockTabBars[1]),
                                   (menuTitle: mockTitleTabBar.priceTitle.rawValue, vc: mockTabBars[2])]
    
    private let viewModel = ProductDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTap()
    }

    private func setupUI() {
        // expand or collapse paging view
        dataSource[1].vc.isShowMoreInfo = { [weak self] isShowMoreInfomation in
            guard let weakSelf = self else {
                return
            }
            if isShowMoreInfomation {
                let magicNumber: CGFloat = 82 // height menu cell paging view + table view content pading
                weakSelf.pagingViewHeightConstraint.constant =  weakSelf.dataSource[1].vc.getTableViewContentHeight() + magicNumber
            } else {
                weakSelf.pagingViewHeightConstraint.constant = UIScreen.width / 375 * 238
            }
            weakSelf.view.layoutIfNeeded()
        }
        
        gradientBackgroundAddToCartBtn.applyGradient(colours: [.tomatoTwo, .reddishOrange], locations: [0.0, 0.85, 1.0])
        
        menuViewController.register(nib: UINib(resource: R.nib.menuCell), forCellWithReuseIdentifier: menuCellIndentifier)
        menuViewController.registerFocusView(nib: UINib(resource: R.nib.menuCellFocusView))
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    private func setupTap() {
        btnBackLeftBarButton.rx.tap.bind { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    // MARK: - Config for PagingMenu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
}

// MARK: - Menu content for PagingContentViewController
extension ProductDetailViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return UIScreen.width / 3
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: menuCellIndentifier, for: index) as! MenuCell
        cell.lblTitleLabel.text = dataSource[index].menuTitle
        return cell
    }
}

// MARK: - Data for menu PagingContentViewController
extension ProductDetailViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

// MARK: - synchronize user interactions between Menu and Content (paging view)
extension ProductDetailViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}
extension ProductDetailViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
// MARK: - Mock data for paging view
enum mockTitleTabBar: String {
    case descriptionTitle = "Mô tả sản phẩm"
    case hardwareTitle = "Thông số kỹ thuật"
    case priceTitle = "So sánh giá"
}
