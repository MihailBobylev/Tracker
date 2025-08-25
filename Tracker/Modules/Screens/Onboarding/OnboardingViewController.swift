//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIPageViewController {
    private struct Constants {
        static var firstPageText = "Отслеживайте только то, что хотите"
        static var secondPageText = "Даже если это не литры воды и йога"
        static var doneButtonText = "Вот это технологии!"
    }
    
    private lazy var pages: [UIViewController] = {
        let firstPage = OnboardingBackgroundViewController(backImage: .background1, text: Constants.firstPageText)
        let secondPage = OnboardingBackgroundViewController(backImage: .background2, text: Constants.secondPageText)
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .veryDark
        pageControl.pageIndicatorTintColor = .veryDark.withAlphaComponent(0.3)
        return pageControl
    }()

    private lazy var doneButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle(Constants.doneButtonText, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    var didTapDone: (() -> Void)?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsManager.appWasShown = true
        setupAppearance()
        setupUI()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages.last
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return pages.first
        }

        return pages[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

private extension OnboardingViewController {
    func setupAppearance() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(doneButton)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(doneButton.snp.top).inset(-24.dvs)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
            make.leading.trailing.equalToSuperview().inset(20.dhs)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50.dvs)
        }
    }
    
    @objc func doneButtonTapped() {
        didTapDone?()
    }
}
