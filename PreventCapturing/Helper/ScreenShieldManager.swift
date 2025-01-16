//
//  ScreenShieldManager.swift
//  PreventCapturing
//
//  Created by ToTo on 16/1/25.
//
import UIKit

// Global Secure Screen Manager
class SecureScreenManager {
    
    static let shared = SecureScreenManager()
  
    private var isAppCaptured: Bool = false {
        didSet {
            UserDefaults.standard.set(isAppCaptured, forKey: "isScreenBeingCaptured")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - UI INITALIZATION
    private lazy var screenshotLabel: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let cameraImageView = UIImageView()
        cameraImageView.image = UIImage(named: "noCamera")
        cameraImageView.tintColor = .systemBlue
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.translatesAutoresizingMaskIntoConstraints = false

        let recordImageView = UIImageView()
        recordImageView.image = UIImage(named: "noRecord")
        recordImageView.tintColor = .systemRed
        recordImageView.contentMode = .scaleAspectFit
        recordImageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Due to security policy, the screenshot or screen recording is restricted"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        // Horizontal stack for the images
        let imageStackView = UIStackView(arrangedSubviews: [cameraImageView, recordImageView])
        imageStackView.axis = .horizontal
        imageStackView.alignment = .center
        imageStackView.spacing = 16
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        // Vertical stack for the images and label
        let stackView = UIStackView(arrangedSubviews: [imageStackView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)
        backgroundView.addSubview(containerView)

        NSLayoutConstraint.activate([
            // Constraints for the image stack
            imageStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for the main stack
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            // Center the popup
            containerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 380),
            containerView.heightAnchor.constraint(equalToConstant: 200),
        ])

        return backgroundView
    }()
    
    private init(){
        isAppCaptured = UserDefaults.standard.bool(forKey: "isScreenBeingCaptured")
        self.setupScreenProtection()
        self.checkAndHandleRecordingStatus()
    }
    
    // Secure container that will hold the content
    class SecureContainer: UITextField {
        override init(frame: CGRect) {
            super.init(frame: .zero)
            self.isSecureTextEntry = true
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        weak var secureView: UIView? {
            let secureView = self.subviews.filter { subview in
                type(of: subview).description().contains("CanvasView")
            }.first
            secureView?.translatesAutoresizingMaskIntoConstraints = false
            secureView?.isUserInteractionEnabled = true
            return secureView
        }
        
        override var canBecomeFirstResponder: Bool { false }
        override func becomeFirstResponder() -> Bool { false }
    }
    
    // Method to secure any view controller
    func secureViewController(_ viewController: UIViewController, contentView: UIView? = nil) {
        // Add screenshot label
        viewController.view.addSubview(screenshotLabel)
        screenshotLabel.pinEdges()
        
        // Create secure container
        let secureField = SecureContainer()
        guard let secureView = secureField.secureView else { return }
        
        // If there's a specific content view to secure
        if let contentView = contentView {
            secureView.addSubview(contentView)
            contentView.pinEdges()
        }
        
        viewController.view.addSubview(secureView)
        secureView.pinEdges()
        
    
        self.setupScreenProtection()
    }
    
    // MARK: - NOTIFICATION CENTER
    func setupScreenProtection(){
        // Setup screenshot notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenshotDetected),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenCaptureChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
  
    private func checkAndHandleRecordingStatus() {
        if isAppCaptured || UIScreen.main.isCaptured {
            showRecordScreenShield()
        }
    }
    
   
 
    
    // MARK: - SCREENSHOT SECTION
    func showScreenShield() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let cameraImageView = UIImageView()
        cameraImageView.image = UIImage(named: "noCamera")
        cameraImageView.tintColor = .systemBlue
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.translatesAutoresizingMaskIntoConstraints = false

        let recordImageView = UIImageView()
        recordImageView.image = UIImage(named: "noRecord")
        recordImageView.tintColor = .systemRed
        recordImageView.contentMode = .scaleAspectFit
        recordImageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Due to security policy, the screenshot or screen recording is restricted"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        // Horizontal stack for the images
        let imageStackView = UIStackView(arrangedSubviews: [cameraImageView, recordImageView])
        imageStackView.axis = .horizontal
        imageStackView.alignment = .center
        imageStackView.spacing = 16
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        // Vertical stack for the images and label
        let stackView = UIStackView(arrangedSubviews: [imageStackView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)
        backgroundView.addSubview(containerView)

        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(backgroundView)

        NSLayoutConstraint.activate([
            // Constraints for the image stack
            imageStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for the main stack
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            // Center the popup
            containerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 380),
            containerView.heightAnchor.constraint(equalToConstant: 200),

            // Fullscreen backgroundView
            backgroundView.topAnchor.constraint(equalTo: window.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.3) { backgroundView.alpha = 1 } // Hide the screen shield after 2 seconds with fade-out animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { UIView.animate(withDuration: 0.3, animations: { backgroundView.alpha = 0 }) { _ in backgroundView.removeFromSuperview() } }
      
    }
    
    
    // MARK: -RECORING SECTION
    
    private func showRecordScreenShield() {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() else { return }
    
        let shieldVC = topViewController.popupVcFullScreen(storyboard: "Main", identifier: "PopUpVC")
        if let shieldVC = shieldVC as? PopUpVC {
            shieldVC.modalPresentationStyle = .overFullScreen
            shieldVC.modalTransitionStyle = .crossDissolve
            topViewController.navigationController?.present(shieldVC, animated: false)
        }
        
    }

    private func hideScreenShield() {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() else { return }
        topViewController.dismiss(animated: true)
    }

 
    
    
    // MARK: -OBJC
    @objc private func handleScreenCaptureChange(_ notification: Notification) {
        let isCaptured = UIScreen.main.isCaptured
        isAppCaptured = isCaptured
        if isCaptured {
            showRecordScreenShield()
        } else {
            let savedState = UserDefaults.standard.bool(forKey: "isScreenBeingCaptured")
            if !savedState {
                hideScreenShield()
                
            }
        }
    }
    @objc private func handleAppDidBecomeActive() {
        checkAndHandleRecordingStatus()
    }
    @objc private func screenshotDetected() {
        showScreenShield()
        // Show warning label
        screenshotLabel.isHidden = false
   
        // Optional: Add haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    
    // MARK: - SOME HELPER
    
     func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    func observeAppSharingOrRecording() {
           if #available(iOS 17.0, *) {
               let appWindow = getKeyWindow()
               let isCaptured = appWindow?.traitCollection.sceneCaptureState == .active
               isAppCaptured = isCaptured
               appWindow?.observeSceneCaptureStateChange(completion: { [weak self] isCaptured in
                   self?.isAppCaptured = isCaptured
               })
           } else {
               isAppCaptured = UIScreen.main.isCaptured
               NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(self.handleScreenCaptureChange),
                   name: UIScreen.capturedDidChangeNotification,
                   object: nil
               )
           }
       }
}
@available(iOS 17.0, *)
extension UIWindow {
    func observeSceneCaptureStateChange(completion: @escaping (Bool) -> Void) {
        NotificationCenter.default.addObserver(
            forName: UIScene.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let isCaptured = self.windowScene?.traitCollection.sceneCaptureState == .active
            completion(isCaptured)
        }
    }
}



