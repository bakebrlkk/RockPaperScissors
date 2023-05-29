import UIKit

class ViewController: UIViewController {
    var winner: RPS = .rock
    
    private let blockWidth: CGFloat = 50
    private let blockHeight: CGFloat = 50
    var blockDirections: [CGVector] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setup()
    }
    
    var rockCount = 5
    var scissorsCount = 2
    var paperCount = 3
    
    private func setup() {
        view.backgroundColor = .white
        
        
        
        for _ in 0..<rockCount {
            let rockView = createRockView()
            view.addSubview(rockView)
        }
        
        for _ in 0..<scissorsCount {
            let scissorsView = createScissorsView()
            view.addSubview(scissorsView)
        }
        
        for _ in 0..<paperCount {
            let paperView = createPaperView()
            view.addSubview(paperView)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blockTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        startAnimation()
    }
    
    @objc private func blockTapped(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        
        for subview in view.subviews {
            if subview is UIImageView {
                let blockView = subview as! UIImageView
                
                if blockView.frame.contains(touchLocation) {
                    let index = getBlockIndex(for: blockView)
                    if index != -1 {
                        let newDirection = randomDirection()
                        blockDirections[index] = newDirection
                    }
                }
            }
        }
    }
    
    private func getBlockIndex(for blockView: UIImageView) -> Int {
        if let rockIndex = rockViews.firstIndex(of: blockView) {
            return rockIndex
        } else if let paperIndex = paperViews.firstIndex(of: blockView) {
            return paperIndex
        } else if let scissorsIndex = scissorsViews.firstIndex(of: blockView) {
            return scissorsIndex
        }
        
        return -1
    }
    
    private func randomDirection() -> CGVector {
        let dx = CGFloat.random(in: -1...1)
        let dy = CGFloat.random(in: -1...1)
        return CGVector(dx: dx, dy: dy)
    }
    
    private func moveBlock(_ view: UIView, with direction: CGVector, delta: TimeInterval) {
        let dx = direction.dx * CGFloat(delta * 100)
        let dy = direction.dy * CGFloat(delta * 100)
        view.transform = view.transform.translatedBy(x: dx, y: dy)
    }
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: TimeInterval = 0
    
    private func startAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updatePositions))
        displayLink?.add(to: .current, forMode: .common)
    }

    private func stopAnimation(winner: RPS) {
        displayLink?.invalidate()
        displayLink = nil
        
        navigationController?.pushViewController(FinishView(), animated: true)
    }
    
    @objc private func updatePositions(_ displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        let dt = displayLink.timestamp - lastTimestamp
        
        for subview in view.subviews {
            if subview is UIImageView {
                let blockView = subview as! UIImageView
                
                let index = getBlockIndex(for: blockView)
                if index != -1 {
                    let direction = blockDirections[index]
                    moveBlock(blockView, with: direction, delta: dt)
                }
            }
        }
        
        checkBlockCollision()
        checkBlockBounds()
        
        lastTimestamp = displayLink.timestamp
        
        print("\(paperCount) + \(scissorsCount) + \(rockCount)")
        if(paperCount == 0 && scissorsCount == 0){
            print("Rock")
            stopAnimation(winner: .rock)
        }else if(paperCount == 0 && rockCount == 0){
            print("Scissors")
            stopAnimation(winner: .scissors)
        }else if(rockCount == 0 && scissorsCount == 0) {
            print("Paper")
            stopAnimation(winner: .paper)
        }
    }
    
    private func checkBlockCollision() {
        for rockView in rockViews {
            
            for rockView2 in rockViews{
                if rockView.frame.intersects(rockView2.frame){
                    let rockIndex1 = getBlockIndex(for: rockView)
                    let rockIndex2 = getBlockIndex(for: rockView2)
                    
                    if rockIndex1 != -1 && rockIndex2 != -1 {
                        
                        let tempDirection = blockDirections[rockIndex1]
                        blockDirections[rockIndex1] = blockDirections[rockIndex2]
                        blockDirections[rockIndex2] = tempDirection
                    }
                }
            }
            
            for paperView in paperViews {
                if rockView.frame.intersects(paperView.frame) {
                    let rockIndex = getBlockIndex(for: rockView)
                    let paperIndex = getBlockIndex(for: paperView)
                    
                    rockView.image = paperView.image
                    let new = rockView
                    new.image = paperView.image
                    paperViews.append(new)
                    
                    rockCount -= 1
                    paperCount += 1
                    
                    if rockIndex != -1 && paperIndex != -1 {
                        
                        rockViews.remove(at: rockIndex)

                        let tempDirection = blockDirections[rockIndex]
                        blockDirections[rockIndex] = blockDirections[paperIndex]
                        blockDirections[paperIndex] = tempDirection
                    }
                }
            }
            
            for scissorsView in scissorsViews {
                
                for scissorsView2 in scissorsViews{
                    if(scissorsView.frame.intersects(scissorsView2.frame)){
                        let scissorsIndex1 = getBlockIndex(for: scissorsView)
                        let scissorsIndex2 = getBlockIndex(for: scissorsView2)
                        
                        if scissorsIndex1 != -1 && scissorsIndex2 != -1 {
                            
                            let tempDirection = blockDirections[scissorsIndex1]
                            blockDirections[scissorsIndex1] = blockDirections[scissorsIndex2]
                            blockDirections[scissorsIndex2] = tempDirection
                        }
                    }
                }
                
                
                if rockView.frame.intersects(scissorsView.frame) {
                    let rockIndex = getBlockIndex(for: rockView)
                    let scissorsIndex = getBlockIndex(for: scissorsView)
                    
                    let new = scissorsView
                    new.image = rockView.image
                    rockViews.append(new)
        
                    
                    scissorsCount -= 1
                    rockCount += 1
                    
                    if rockIndex != -1 && scissorsIndex != -1 {
                        scissorsViews.remove(at: scissorsIndex)

                        let tempDirection = blockDirections[rockIndex]
                        blockDirections[rockIndex] = blockDirections[scissorsIndex]
                        blockDirections[scissorsIndex] = tempDirection
                    }
                }
            }
        }
        
        for paperView in paperViews {
            
            for paperView2 in paperViews{
                if(paperView.frame.intersects(paperView2.frame)){
                    let paperIndex1 = getBlockIndex(for: paperView)
                    let paperIndex2 = getBlockIndex(for: paperView2)
                    
                    if paperIndex1 != -1 && paperIndex2 != -1 {
                        let tempDirection = blockDirections[paperIndex1]
                        blockDirections[paperIndex1] = blockDirections[paperIndex2]
                        blockDirections[paperIndex2] = tempDirection
                    }
                }
            }
            
            
            for scissorsView in scissorsViews {
                if paperView.frame.intersects(scissorsView.frame) {
                    
                    
                    let paperIndex = getBlockIndex(for: paperView)
                    let scissorsIndex = getBlockIndex(for: scissorsView)
                    
                    let new = paperView
                    new.image = scissorsView.image
                    scissorsViews.append(new)
                    
                    paperCount -= 1
                    scissorsCount += 1
                    
                    if paperIndex != -1 && scissorsIndex != -1 {
                        paperViews.remove(at: paperIndex)

                        let tempDirection = blockDirections[paperIndex]
                        blockDirections[paperIndex] = blockDirections[scissorsIndex]
                        blockDirections[scissorsIndex] = tempDirection
                    }
                }
            }
        }
    }
    
    private func checkBlockBounds() {
        let screenBounds = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 50))
        
        for rockView in rockViews {
            if !screenBounds.contains(rockView.frame.origin) {
                let rockIndex = getBlockIndex(for: rockView)
                
                if rockIndex != -1 {
                    if (rockView.frame.origin.x > 340 || rockView.frame.origin.x < 5) {
                        blockDirections[rockIndex] = CGVector(dx: -blockDirections[rockIndex].dx, dy: blockDirections[rockIndex].dy)
                    } else {
                        blockDirections[rockIndex] = CGVector(dx: blockDirections[rockIndex].dx, dy: -blockDirections[rockIndex].dy)
                    }
                }
            }
        }
        
        for paperView in paperViews {
            if !screenBounds.contains(paperView.frame.origin) {
                let paperIndex = getBlockIndex(for: paperView)
                
                if paperIndex != -1 {
                    if (paperView.frame.origin.x > 340 || paperView.frame.origin.x < 5) {
                        blockDirections[paperIndex] = CGVector(dx: -blockDirections[paperIndex].dx, dy: blockDirections[paperIndex].dy)
                    } else {
                        blockDirections[paperIndex] = CGVector(dx: blockDirections[paperIndex].dx, dy: -blockDirections[paperIndex].dy)
                    }
                }
            }
        }
        
        for scissorsView in scissorsViews {
            if !screenBounds.contains(scissorsView.frame.origin) {
                let scissorsIndex = getBlockIndex(for: scissorsView)
                
                if scissorsIndex != -1 {
                    if (scissorsView.frame.origin.x > 340 || scissorsView.frame.origin.x < 5) {
                        blockDirections[scissorsIndex] = CGVector(dx: -blockDirections[scissorsIndex].dx, dy: blockDirections[scissorsIndex].dy)
                    } else {
                        blockDirections[scissorsIndex] = CGVector(dx: blockDirections[scissorsIndex].dx, dy: -blockDirections[scissorsIndex].dy)
                    }
                }
            }
        }
    }
    
    private var rockViews = [UIImageView]()
    private var paperViews = [UIImageView]()
    private var scissorsViews = [UIImageView]()
    
    private func createRockView() -> UIImageView {
        let rockView = UIImageView(image: UIImage(named: "rock"))
        rockView.frame = CGRect(x: CGFloat.random(in: 50...(view.bounds.width - blockWidth)), y: CGFloat.random(in: 130...(view.bounds.height - blockHeight)), width: blockWidth, height: blockHeight)
        rockViews.append(rockView)
        blockDirections.append(randomDirection())
        return rockView
    }
    
    private func createPaperView() -> UIImageView {
        let paperView = UIImageView(image: UIImage(named: "paper"))
        paperView.frame = CGRect(x: CGFloat.random(in: 50...(view.bounds.width - blockWidth)), y: CGFloat.random(in: 130...(view.bounds.height - blockHeight)), width: blockWidth, height: blockHeight)
        paperViews.append(paperView)
        blockDirections.append(randomDirection())
        return paperView
    }
    
    private func createScissorsView() -> UIImageView {
        let scissorsView = UIImageView(image: UIImage(named: "scissors"))
        scissorsView.frame = CGRect(x: CGFloat.random(in: 50...(view.bounds.width - blockWidth)), y: CGFloat.random(in: 130...(view.bounds.height - blockHeight)), width: blockWidth, height: blockHeight)
        scissorsViews.append(scissorsView)
        blockDirections.append(randomDirection())
        return scissorsView
    }
}
