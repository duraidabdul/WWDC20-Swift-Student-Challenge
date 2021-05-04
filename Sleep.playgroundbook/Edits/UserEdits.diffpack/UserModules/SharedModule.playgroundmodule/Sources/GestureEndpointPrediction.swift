import UIKit

/// Distance traveled after decelerating to zero velocity at a constant rate.
public func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
    return (initialVelocity / 1000.0) * decelerationRate / (1.0 - decelerationRate)
}

extension CGPoint {
    /// Returns the scalar length of a vector.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
}

// Calculate the nearest point in an array of points.
public func nearestTargetTo(_ point: CGPoint, possibleEndpoints candidatePoints: [CGPoint]) -> CGPoint {
    
    var currentShortestDistance = CGFloat.greatestFiniteMagnitude
    var nearestEndpoint = CGPoint.zero
    for endpoint in candidatePoints {
        let distance = point.distance(to: endpoint)
        if distance < currentShortestDistance {
            nearestEndpoint = endpoint
            currentShortestDistance = distance
        }
    }
    return nearestEndpoint
}

extension UISpringTimingParameters {
    
    /**
     Simplified spring animation timing parameters.
     
     - Parameters:
     - damping: ζ (damping ratio)
     - frequency: T (frequency response)
     - initialVelocity: [See Here](https://developer.apple.com/documentation/uikit/uispringtimingparameters/1649909-initialvelocity)
     */
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        // Stiffness represents the spring constant, k
        let stiffness = pow(2 * .pi / response, 2)
        let dampingCoefficient = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: dampingCoefficient, initialVelocity: initialVelocity)
    }
}

/**
 Calculates a unit vector for the initial velocity of a spring animation.
 
 - Parameters:
 - currentPosition: The current location of the view that will be animated.
 - finalPosition: The position that the view will be animated to.
 - velocity: The current velocity of the moving view. For more information, see [initialVelocity](https://developer.apple.com/documentation/uikit/uispringtimingparameters/1649909-initialvelocity).
 - Returns:
 A unit vector representing the initial velocity of the view
 
 This function is used in this Playground to form a CGVector to be used with UISpringTimingParameters.
 For more information, see [UISpringTimingParameters](https://developer.apple.com/documentation/uikit/uispringtimingparameters).
 */
public func initialAnimationVelocity(for velocity: CGPoint, from currentPosition: CGPoint, to finalPosition: CGPoint) -> CGVector {
    let xDistance = finalPosition.x - currentPosition.x
    let yDistance = finalPosition.y - currentPosition.y
    return CGVector(dx: xDistance != 0 ? velocity.x / xDistance : 0, 
                    dy: yDistance != 0 ? velocity.y / yDistance : 0
    )
}
