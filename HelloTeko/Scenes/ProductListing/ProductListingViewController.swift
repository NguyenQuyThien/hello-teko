//
//  ProductListingViewController.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductListingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyProductsList: UIStackView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearchInput: UITextField!
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        collectionView.layoutIfNeeded()
        let width = collectionView.frame.size.width
        layout.itemSize = CGSize(width: width, height: 104)
        layout.minimumLineSpacing = 4
        return layout
    }()
    
    private let viewModel = ProductListingViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // dismiss Keyboard when tap arround
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupCollectionView()
        setupViewModel()
    }

    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(R.nib.productListingCollectionViewCell)
        collectionView.rx
            .modelSelected(Product.self)
            .asDriver()
            .drive(onNext: { [unowned self] (model: Product) in
                let vc = R.storyboard.main.productDetailViewController()!
                vc.product = model
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        collectionView.rx
            .willBeginDragging
            .asDriver()
            .drive(onNext: { [unowned self] in
                if self.tfSearchInput.isFirstResponder {
                    self.tfSearchInput.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        viewModel.products
            .observe(on: MainScheduler.instance)
            .bind(to:
                collectionView.rx.items(cellIdentifier: R.reuseIdentifier.productListingCollectionViewCell.identifier,
                                        cellType: ProductListingCollectionViewCell.self)
            ){ (item: Int, data: Product, cell: ProductListingCollectionViewCell) in
                cell.bindUI(model: data)
        }.disposed(by: disposeBag)
        
        viewModel.products
            .asDriver()
            .map { (products: [Product]) -> Bool in
                return !products.isEmpty
            }
            .drive(emptyProductsList.rx.isHidden)
        .disposed(by: disposeBag)
        
        viewModel.fetchData()
    }
}

extension ProductListingViewController: UITextFieldDelegate {
    // MARK: - UITextField: Editting Changed
    @IBAction func inputSearchChanged(_ sender: UITextField) {
        guard let searchText = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard !searchText.isEmpty else {
            viewModel.products.accept(viewModel.allProducts)
            return
        }
        
        let smartSearchMatcher = SmartSearchMatcher(searchString: searchText)
        viewModel.products.accept(
            viewModel.allProducts.filter({
                return smartSearchMatcher.matches($0.name)
            })
        )
    }
}
