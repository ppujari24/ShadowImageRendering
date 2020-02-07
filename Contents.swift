
import PlaygroundSupport
import CoreGraphics
import UIKit

// MARK: - MyViewController -

class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Shadow image rendering"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.any, barMetrics: .default)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        let shadowMetric = ShadowMetric(offset: CGSize(width: 0, height: 1),
                                        blur: 10,
                                        spread: 1,
                                        strokeColor: .blue,
                                        shadowColor: .blue)
        let image = shadowMetric.renderedImage(for: .bottom)
        navigationController?.navigationBar.shadowImage = image
    }
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        // The top edge
        let topMetric = ShadowMetric(offset: CGSize(width: 0, height: 1),
                                     blur: 8,
                                     spread: 1,
                                     strokeColor: .blue,
                                     shadowColor: .blue)
        let topImage = topMetric.renderedImage(for: .top)
        let topImageView = UIImageView(image: topImage)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        // The bottom edge
        let bottomMetric = ShadowMetric(offset: CGSize(width: 0, height: 1),
                                        blur: 8,
                                        spread: 1,
                                        strokeColor: .blue,
                                        shadowColor: .blue)
        let bottomImage = bottomMetric.renderedImage(for: .bottom)
        let bottomImageView = UIImageView(image: bottomImage)
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // All edges
        let allEdgeMetric = ShadowMetric(offset: CGSize(width: 0, height: 1),
                                        blur: 12,
                                        spread: 1,
                                        strokeColor: .blue,
                                        shadowColor: .blue)
        let allEgdeImage = allEdgeMetric.renderedImage(for: .all)
        let allEdgeImageView = UIImageView(image: allEgdeImage)
        allEdgeImageView.translatesAutoresizingMaskIntoConstraints = false
        allEdgeImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        allEdgeImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // The stack
        let stack = UIStackView(arrangedSubviews: [topImageView, bottomImageView, allEdgeImageView])
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view = view
    }
}


// MARK: - MyNavigationController -

class MyNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [MyViewController()]
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyNavigationController()
