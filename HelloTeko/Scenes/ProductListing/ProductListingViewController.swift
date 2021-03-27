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

class ProductListingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearchInput: UITextField!
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
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
        setupCollectionView()
        setupViewModel()
    }

    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(R.nib.productListingCollectionViewCell)
    }
    
    private func setupViewModel() {
        viewModel.products
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                                    cellIdentifier: R.reuseIdentifier.productListingCollectionViewCell.identifier,
                                    cellType: ProductListingCollectionViewCell.self)
                ){ (item: Int, data: Product, cell: ProductListingCollectionViewCell) in
                cell.bindUI(model: data)
        }.disposed(by: disposeBag)
        
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
            viewModel.products.onNext(viewModel.allProducts)
            return
        }
        
        let smartSearchMatcher = SmartSearchMatcher(searchString: searchText)
        viewModel.products.onNext(
            viewModel.allProducts.filter({
                return smartSearchMatcher.matches($0.name)
            })
        )
    }
}
