//
//  SearchHeaderView.swift
//  Tracker
//
//  Created by Михаил Бобылев on 04.09.2025.
//

import UIKit
import SnapKit

final class SearchHeaderView: UIView {
    private struct Constants {
        static var searchText = NSLocalizedString("search", comment: "placeholder text")
        static var cancelText = NSLocalizedString("cancel", comment: "cancel button text")
    }
    
    private lazy var searchTextField: UISearchTextField = {
        let tf = UISearchTextField()
        tf.delegate = self
        tf.placeholder = Constants.searchText
        tf.font = UIFont.systemFont(ofSize: 17.dfs, weight: .regular)
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 10
        tf.clearButtonMode = .whileEditing
        tf.autocorrectionType = .no
        tf.leftView = setupTextFieldLeftView()
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.cancelText, for: .normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return btn
    }()

    private var searchTrailingConstraint: Constraint?
    private var debounceWorkItem: DispatchWorkItem?
    
    var onTextChanged: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension SearchHeaderView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateCancelButtonVisibility(show: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text?.isEmpty ?? true {
            updateCancelButtonVisibility(show: false)
        }
    }
}

private extension SearchHeaderView {
    @objc func textDidChange() {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            onTextChanged?(searchTextField.text ?? "")
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    @objc func cancelTapped() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
        updateCancelButtonVisibility(show: false)
        onTextChanged?(searchTextField.text ?? "")
    }
}

private extension SearchHeaderView {
    func setupUI() {
        addSubview(searchTextField)
        addSubview(cancelButton)

        searchTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            searchTrailingConstraint = make.trailing.equalToSuperview().constraint
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.leading.equalTo(searchTextField.snp.trailing).offset(8.dhs)
            make.trailing.equalToSuperview()
        }
    }
    
    func setupTextFieldLeftView() -> UIView {
        let imageView = UIImageView(image: UIImage(resource: .icMangnifyingglass))
        imageView.contentMode = .scaleAspectFit
        
        let container = UIView()
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16.dvs)
        }
        container.snp.makeConstraints { make in
            make.width.equalTo(30.dhs)
            make.height.equalTo(36.dvs)
        }
        
        return container
    }
    
    func updateCancelButtonVisibility(show: Bool) {
        cancelButton.isHidden = !show

        searchTrailingConstraint?.update(offset: show ? -8.dhs - cancelButton.intrinsicContentSize.width - 16.dhs : 0)

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
