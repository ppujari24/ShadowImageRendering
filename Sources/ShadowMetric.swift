import Foundation
import UIKit


public enum Edge {
    case top
    case bottom
    case all
}



public struct ShadowMetric {
    let offset: CGSize
    let blur: CGFloat
    let spread: CGFloat
    let strokeColor: UIColor
    let shadowColor: UIColor
    
    public init(offset: CGSize, blur: CGFloat, spread: CGFloat, strokeColor: UIColor, shadowColor: UIColor) {
        self.offset = offset
        self.blur = blur
        self.spread = spread
        self.strokeColor = strokeColor
        self.shadowColor = shadowColor
    }
    
    // MARK: - Rendering Dimension as an image
    /// Returns a `UIImage` representing the dimension metric, rendered along the specified edge.
    ///
    /// - Parameter edge: The `DimensionMetric.Edge` to which the shadow is applied.
    public func renderedImage(for edge: Edge) -> UIImage {
        // To draw an image with the specified shadow metrics, a rectangular path of size `innerRectDrawingSize` is
        // drawn in the image's cgContext by applying a shadow to it created with the metrics offset, blur and color.
        //
        // In the `.all` edge case, the whole rectangle is drawn.
        // In the `.top` and `.bottom` case, only the required edge is drawn.
        let innerRectDrawingSize = CGSize(width: 5, height: 5)
        
        let image: UIImage
        // Drawing a size 5 rect inside which will be capped to strech the image on all sides, or the
        // sides if .top or .bottom edges.
        // Count in the blur and spread space on all four edges
        let maxSize = innerRectDrawingSize.width + 2 * blur + 2 * spread
        let drawingSize = CGSize(width: maxSize, height: maxSize)
        let renderer = UIGraphicsImageRenderer(size: drawingSize)
        
        switch edge {
        case .all:
            image = renderer.image { imageContext in
                let context = imageContext.cgContext
                context.setBlendMode(.multiply)
                context.setLineWidth(spread)
                context.setStrokeColor(strokeColor.cgColor)
                context.setShadow(offset: offset, blur: blur / 2, color: shadowColor.cgColor)
                context.move(to: CGPoint(x: blur, y: blur))
                let drawRect = CGRect(x: blur + spread / 2,
                                      y: blur+spread / 2,
                                      width: innerRectDrawingSize.width,
                                      height: innerRectDrawingSize.height)
                context.addRect(drawRect)
                context.strokePath()
                let clearRect = CGRect(origin: CGPoint(x: blur + spread / 2, y: blur + spread / 2),
                                       size: innerRectDrawingSize)
                context.clear(clearRect)
            }
            
        case .top:
            image = renderer.image { imageContext in
                let context = imageContext.cgContext
                context.setBlendMode(.multiply)
                context.setLineWidth(spread)
                context.setStrokeColor(strokeColor.cgColor)
                context.setShadow(offset: offset, blur: blur / 2, color: shadowColor.cgColor)
                let drawRect = CGRect(x: 0 - spread - blur,
                                      y: maxSize,
                                      width: renderer.format.bounds.width + 2 * spread + 2 * blur,
                                      height: renderer.format.bounds.height)
                context.stroke(drawRect)
            }
            
        case .bottom:
            image = renderer.image { imageContext in
                let context = imageContext.cgContext
                context.setBlendMode(.multiply)
                context.setLineWidth(spread)
                context.setStrokeColor(strokeColor.cgColor)
                context.setShadow(offset: offset, blur: blur / 2, color: shadowColor.cgColor)
                let drawRect = CGRect(x: 0 - spread - blur,
                                      y: 0  - maxSize,
                                      width: renderer.format.bounds.width + 2 * spread + 2 * blur,
                                      height: renderer.format.bounds.height)
                context.stroke(drawRect)
            }
        }
        
        let capInsetTop = edge == .all ? blur + spread : 0
        let capInsetBottom = edge == .all ? blur + spread + innerRectDrawingSize.height : blur + spread
        let capInsetRight = edge == .all ? blur + spread + innerRectDrawingSize.width : innerRectDrawingSize.width - 1
        let capInsetLeft = edge == .all ? blur + spread : 1
        let capInsets = UIEdgeInsets(top: capInsetTop, left: capInsetLeft, bottom: capInsetBottom, right: capInsetRight)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
    
    
    /// Returns the maximum `CGSize` comparing them according to their heights.
    /// - Parameter offset1: CGSize 1 to compare
    /// - Parameter offset2: CGSize 2 to compare
    private func maxHeight(_ offset1: CGSize, _ offset2: CGSize) -> CGSize {
        return offset1.height > offset2.height ? offset1 : offset2
    }
}
