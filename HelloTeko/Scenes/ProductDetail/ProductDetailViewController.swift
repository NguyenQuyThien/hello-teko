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
import RxAnimated

final class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var btnBackLeftBarButton: UIButton!
    @IBOutlet weak var lblTitleProductName: UILabel!
    @IBOutlet weak var lblTitleProductPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lblDetailProductName: UILabel!
    @IBOutlet weak var lblProuctCodeLabel: UILabel!
    @IBOutlet weak var lblProductCode: UILabel!
    @IBOutlet weak var lblDetailProductPrice: UILabel!
    
    @IBOutlet var pagingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewOfSameItems: UICollectionView!
    @IBOutlet weak var indicatorOfSameItems: UIActivityIndicatorView!
    
    @IBOutlet weak var gradientBackgroundAddToCartBtn: UIView!
    @IBOutlet weak var valueStepperView: ValueStepper!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnAddItemsToCart: UIButton!
    @IBOutlet weak var addToCartImage: UIImageView!
    @IBOutlet weak var totalItemsOrderInCart: UILabel!
    
    
    private let disposeBag = DisposeBag()
    var product: Product!
    private var totalOrder: Int = 0 {
        didSet {
            guard viewIfLoaded != nil else {return}
            Observable.just((totalOrder * (product.price.toVND)).formattedWithSeparatorVND)
                .asDriver(onErrorJustReturn: "0 đ")
                .bind(animated: lblTotalPrice.rx.animated.tick(.bottom, duration: 0.3).text)
                .dispose()
        }
    }
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    private let menuCellIndentifier = "MenuCell"
    
    private static var mockTabBarView: (UIColor) -> HardwareDetailsViewController = { (color) in
        let vc = R.storyboard.pagingContent.hardwareDetailsViewController()!
        vc.view.backgroundColor = color
        if color == .clear {
            vc.dataSource.removeAll()
        }
        return vc
    }
    private lazy var mockTabBars: [HardwareDetailsViewController] = [ProductDetailViewController.mockTabBarView(.clear),
                                                                     ProductDetailViewController.mockTabBarView(.white0),
                                                                     ProductDetailViewController.mockTabBarView(.clear)]
    private lazy var dataSource = [(menuTitle: mockTitleTabBar.descriptionTitle.rawValue, vc: mockTabBars[0]),
                                   (menuTitle: mockTitleTabBar.hardwareTitle.rawValue, vc: mockTabBars[1]),
                                   (menuTitle: mockTitleTabBar.priceTitle.rawValue, vc: mockTabBars[2])]
    
    private let viewModel = ProductDetailViewModel()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        collectionViewOfSameItems.layoutIfNeeded()
        let width = collectionViewOfSameItems.frame.size.width / 375 * 150
        let height = collectionViewOfSameItems.frame.size.height - 12
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        return layout
    }()
      
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupTap()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reload PagingView when viewDidAppear
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    private func setupUI() {
        lblTitleProductName.text = product.name
        lblTitleProductName.font = .textStyle3
        lblTitleProductPrice.text = String(product.price.toVND.formattedWithSeparatorVND)
        imgProduct.setImage(url: URL(string: product.imageURL), getThumbnailImage: true, completion: nil)
        lblDetailProductName.text = product.name
        lblDetailProductPrice.attributedText = String(product.price.toVND.formattedWithSeparatorVND).setVNDAsSuperscript()
        
        gradientBackgroundAddToCartBtn.applyGradient(colours: [.tomatoTwo, .reddishOrange], locations: [0.0, 0.85, 1.0])
        
        menuViewController.register(nib: UINib(resource: R.nib.menuCell), forCellWithReuseIdentifier: menuCellIndentifier)
        menuViewController.registerFocusView(nib: UINib(resource: R.nib.menuCellFocusView))

        ShoppingCart.shared.getTotalCount()
            .map { String($0) }
            .bind(animated: totalItemsOrderInCart.rx.animated.flip(.top, duration: 0.33).text)
            .disposed(by: disposeBag)
        
        ShoppingCart.shared.products
            .asDriver(onErrorJustReturn: [:])
            .filter { (products: [Product : Int]) -> Bool in
                return !products.isEmpty
            }.map({ (_) -> UIImage in
                return R.image.addToCart()!
            })
            .drive(addToCartImage.rx.animated.tick(.left, duration: 0.75).image)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionViewOfSameItems.setCollectionViewLayout(flowLayout, animated: true)
        collectionViewOfSameItems.register(R.nib.horizontalProductListingCollectionViewCell)
    }
    
    private func setupTap() {
        btnBackLeftBarButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        valueStepperView.valueDidChangeHandler = { [weak self] totalOrder in
            self?.totalOrder = Int(totalOrder)
        }
        
        btnAddItemsToCart.rx.tap
            .asDriver()
            .throttle(.milliseconds(500))
            .drive(onNext: { [unowned self] in
                ShoppingCart.shared.addProduct(self.product, withCount: self.totalOrder)
            }).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        viewModel.sameProducts
            .observe(on: MainScheduler.instance)
            .bind(to: collectionViewOfSameItems.rx.items(
                cellIdentifier: R.reuseIdentifier.horizontalProductListingCollectionViewCell.identifier,
                cellType: HorizontalProductListingCollectionViewCell.self)
            ){ (item: Int, data: Product, cell: HorizontalProductListingCollectionViewCell) in
                cell.bindUI(model: data)
        }.disposed(by: disposeBag)
        
        viewModel.sameProducts
            .asDriver()
            .map { (products: [Product]) -> Bool in
                return !products.isEmpty
            }
            .drive(indicatorOfSameItems.rx.isHidden)
        .disposed(by: disposeBag)
        
        viewModel.getSameProducts(id: product.id)
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
        // expand or collapse hardware tab (PagingView)
        if index == 1 {
            dataSource[index].vc.isShowMoreInfo = { [weak self] isShowMoreInfomation in
                UIView.animate(withDuration: 0.3) {
                    if isShowMoreInfomation {
                        // height menu cell (PagingView) + table view content pading
                        let magicNumber: CGFloat = 68
                        self?.pagingViewHeightConstraint.constant =
                            (self?.dataSource[index].vc.getTableViewContentHeight() ?? 0) + magicNumber
                    } else {
                        self?.pagingViewHeightConstraint.constant = UIScreen.width / 375 * 238
                    }
                    self?.view.layoutIfNeeded()
                }
            }
        }
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
