//
//  ViewController.swift
//  Project27
//
//  Created by Victor Rolando Sanchez Jara on 4/2/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    var currentDrawType = 0

    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    // MARK: Other Methods
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
            case 0:
                drawRectangle()
            case 1:
                drawCircle()
            case 2:
                drawCheckerboard()
            case 3:
                drawRotatedSquares()
            case 4:
                drawLines()
            case 5:
                drawImagesAndText()
            case 6:
                drawEmojiSmile()
            case 7:
                drawTwinInLines()
            default:
                break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // awesome drawing code
            // This works also, but could be confusing:
//            let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)

            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            // 4
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            // 5
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            // 5
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        // 6
        imageView.image = img
    }
    
    func drawEmojiSmile() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let eye1 = CGRect(x: 150, y: 150, width: 50, height: 50)
            let eye2 = CGRect(x: 300, y: 150, width: 50, height: 50)

            let mouth = CGRect(x: 200, y: 300, width: 100, height: 100)
            
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.addEllipse(in: eye1)
            ctx.cgContext.addEllipse(in: eye2)
            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img

    }
    
    func drawTwinInLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //
            // 512*512 Space
            // 512 for 4 letters -> 100 for each letter, 10 spacing
            ctx.cgContext.setLineWidth(5)
            let inset = 10
            let letterSpacing = 15
            // Drawing T
            ctx.cgContext.move(to: CGPoint(x: 0, y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: inset))
            ctx.cgContext.move(to: CGPoint(x: 50, y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 50, y: 100+inset))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            // Drawing W
            ctx.cgContext.move(to: CGPoint(x: 100+letterSpacing, y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 100+letterSpacing+25, y: 100+inset))
            ctx.cgContext.addLine(to: CGPoint(x: 100+letterSpacing+50, y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 100+letterSpacing+75, y: 100+inset))
            ctx.cgContext.addLine(to: CGPoint(x: 100+letterSpacing+100, y: inset))
            
            // Drawing I
            ctx.cgContext.move(to: CGPoint(x: 200+(letterSpacing*2)+50, y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 200+(letterSpacing*2)+50, y: 100+inset))

            // Drawing N
            ctx.cgContext.move(to: CGPoint(x: 300+(letterSpacing*3), y: 100+inset))
            ctx.cgContext.addLine(to: CGPoint(x: 300+(letterSpacing*3), y: inset))
            ctx.cgContext.addLine(to: CGPoint(x: 300+(letterSpacing*3)+100, y: 100+inset))
            ctx.cgContext.addLine(to: CGPoint(x: 300+(letterSpacing*3)+100, y: inset))
            
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }

    
}

