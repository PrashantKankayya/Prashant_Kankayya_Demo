//
//  Prashant_Kankayya_DemoTests.swift
//  Prashant_Kankayya_DemoTests
//
// 
//

import XCTest
@testable import Prashant_Kankayya_Demo

final class Prashant_Kankayya_DemoTests: XCTestCase {
    
    var viewController: PortfolioViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = PortfolioViewControllerRouter.createPortfolioViewControllerModule() as? PortfolioViewController
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }

    func testRegisterCollectionViewCells() {
        viewController.registerCollectionViewCells()

        let tabMenuCell = viewController.portfolioTabMenuCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TabMenuCollectionViewCell.self), for: IndexPath(row: 0, section: 0))
        XCTAssertTrue(tabMenuCell is TabMenuCollectionViewCell, "TabMenuCollectionViewCell should be registered.")

        let positionsCell = viewController.portfolioSectionCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostionsCollectionViewCell.self), for: IndexPath(row: 0, section: 0))
        XCTAssertTrue(positionsCell is PostionsCollectionViewCell, "PostionsCollectionViewCell should be registered.")

        let holdingsCell = viewController.portfolioSectionCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HoldingsCollectionViewCell.self), for: IndexPath(row: 1, section: 0))
        XCTAssertTrue(holdingsCell is HoldingsCollectionViewCell, "HoldingsCollectionViewCell should be registered.")
    }

    func testScrollViewDidScroll() {
        viewController.scrollViewDidScroll(viewController.portfolioSectionCollectionView)
        XCTAssertEqual(viewController.menuIndicatorLeadingConstraint.constant, 0, "menuIndicatorLeadingConstraint should be updated when scrolling.")
    }

    func testCollectionViewNumberOfItemsInSection() {
        let count = viewController.collectionView(viewController.portfolioTabMenuCollectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, viewController.menuBarTitles.count, "Number of items in section should match menuBarTitles count.")
    }

    func testCollectionViewDidSelectItemAt() {
        let indexPath = IndexPath(row: 1, section: 0)
        viewController.collectionView(viewController.portfolioTabMenuCollectionView, didSelectItemAt: indexPath)
        XCTAssertEqual(viewController.portfolioSectionCollectionView.contentOffset.x, viewController.view.frame.width, "portfolioSectionCollectionView should scroll to the correct item.")
    }

    func testReloadDataOf() {
        let userHoldings = [UserHolding(symbol: "AAPL", quantity: 10, ltp: 150.0, avgPrice: 120, close : 150)]
        let portfolioSummary = PortfolioSummary(currentValue: 1000, totalInvestment: 800, totalPNL: 200, todaysPNL: 50, percentage: 25.0)

        viewController.reloadDataOf(userHoldings: userHoldings, portfolioSummary: portfolioSummary)

        if let cell = viewController.portfolioSectionCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? HoldingsCollectionViewCell {
            XCTAssertEqual(cell.userHoldingList?.first?.symbol, "AAPL", "Holdings data should be reloaded correctly.")
        }
    }
}
