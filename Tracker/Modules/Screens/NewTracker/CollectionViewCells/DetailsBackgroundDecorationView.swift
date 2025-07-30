import UIKit

final class DetailsBackgroundDecorationView: UICollectionReusableView {
    static var identifier: String {
        String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailsBackgroundDecorationView {
    func setupAppearance() {
        backgroundColor = .grayLightBlue
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
