
import Foundation
import UIKit

protocol BottomSheetViewControllerDelegate: AnyObject {
    func didSelectOption(atIndex index: Int)
}

final class BottomSheetViewController: UIViewController {
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        
        return stackView
    }()
    private var buttons = [UIButton]()

    weak var delegate: BottomSheetViewControllerDelegate?
    private let margin: CGFloat = 20
    private let viewModel: BottomSheetViewModel
    
    init(viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        setupHeaderView()
        setupButtons()
        view.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupHeaderView() {
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImageForAllStates(UIImage(named: "close-black") ?? UIImage())
        closeButton.setTitleForAllStates("")
        closeButton.addTarget(self, action: #selector(closeBottomSheet), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont(resource: R.font.promptSemiBold, size: 16)
        titleLabel.font = UIFont.init(name: "Verdana Bold", size: 16.0)
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.title ?? "Currency"
        
        wrapperView.addSubviews([closeButton, titleLabel])
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        
        containerStackView.addArrangedSubviews([wrapperView, separatorView])
        NSLayoutConstraint.activate([
            wrapperView.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: margin),
            closeButton.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -(40 + margin)),
            titleLabel.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    private func closeBottomSheet() {
        dismiss(animated: true)
    }
    
    private func setupButtons() {
        for index in 0..<viewModel.numberOfOptions() {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            if viewModel.isOptionSelected(atIndex: index) {
                button.setImageForAllStates(UIImage(named: "radio_button_checked") ?? UIImage())
            } else {
                button.setImageForAllStates(UIImage(named: "radio_button_unchecked") ?? UIImage())
            }
            button.setTitleForAllStates(viewModel.displayedText(atIndex: index))
            button.setTitleColorForAllStates( .black)
//            button.titleLabel?.font = UIFont(resource: R.font.promptMedium, size: 14)
            button.titleLabel?.font = UIFont.init(name: "Verdana Medium", size: 14.0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
            button.contentHorizontalAlignment = .left
            button.tag = index
            button.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            self.buttons.append(button)
            containerStackView.addArrangedSubview(button)
            
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    @objc
    func didSelectItem(_ sender: UIButton) {
        let index = sender.tag
        buttons.forEach {
            $0.setImageForAllStates(UIImage(named: "radio_button_unchecked") ?? UIImage())
        }
        buttons[index].setImageForAllStates(UIImage(named: "radio_button_checked") ?? UIImage())

        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelectOption(atIndex: index)
        }
    }
}
