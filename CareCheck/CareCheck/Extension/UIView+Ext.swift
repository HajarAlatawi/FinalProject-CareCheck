

import UIKit


extension HomeViewController{
  
   func configureButton(){
    
    medsButton.frame = CGRect(x: 40,
                              y: 400,
                              width: 120,
                              height: 120)
    
    medsButton.layer.cornerRadius
    = 0.5 * medsButton.bounds.size.width
    medsButton.layer.masksToBounds = true
    
    mealsButton.frame = CGRect(x: 220,
                               y: 400,
                               width: 120,
                               height: 120)
    mealsButton.layer.cornerRadius
    = 0.5 * mealsButton.bounds.size.width
    mealsButton.layer.masksToBounds = true
    
    showerButton.frame = CGRect(x: 40,
                                y: 550,
                                width: 120,
                                height: 120)
    showerButton.layer.cornerRadius
    = 0.5 * showerButton.bounds.size.width
    showerButton.layer.masksToBounds = true
    
    photoButton.frame = CGRect(x: 220,
                               y: 550,
                               width: 120,
                               height: 120)
    photoButton.layer.cornerRadius
    = 0.5 * photoButton.bounds.size.width
    photoButton.layer.masksToBounds = true
    
  }
  
  
  func configureProgressBar(){
    let medsCirclePath = UIBezierPath(arcCenter: medsButton.center,
                                  radius: 60,
                                  startAngle: -(.pi / 2),
                                  endAngle: .pi * 2,
                                  clockwise: true)
    
    let mealsCcirclePath = UIBezierPath(arcCenter: mealsButton.center,
                                  radius: 60,
                                  startAngle: -(.pi / 2),
                                  endAngle: .pi * 2,
                                  clockwise: true)
    
    let showerCirclePath = UIBezierPath(arcCenter: showerButton.center,
                                  radius: 60,
                                  startAngle: -(.pi / 2),
                                  endAngle: .pi * 2,
                                  clockwise: true)
    
    let photoCirclePath = UIBezierPath(arcCenter: photoButton.center,
                                  radius: 60,
                                  startAngle: -(.pi / 2),
                                  endAngle: .pi * 2,
                                  clockwise: true)
    
    medsTrackShape.path = medsCirclePath.cgPath
    medsTrackShape.lineWidth = 2
    medsTrackShape.strokeColor = UIColor.systemPink.cgColor
    medsTrackShape.fillColor = UIColor.clear.cgColor
    
    medsShape.path = medsCirclePath.cgPath
    medsShape.lineWidth = 2
    medsShape.strokeColor = UIColor.gray.cgColor
    medsShape.strokeEnd = 0
    medsShape.fillColor = UIColor.clear.cgColor
    
    
    
    mealsTrackShape.path = mealsCcirclePath.cgPath
    mealsTrackShape.lineWidth = 2
    mealsTrackShape.strokeColor = UIColor.systemPink.cgColor
    mealsTrackShape.fillColor = UIColor.clear.cgColor
    
    mealsShape.path = mealsCcirclePath.cgPath
    mealsShape.lineWidth = 2
    mealsShape.strokeColor = UIColor.gray.cgColor
    mealsShape.strokeEnd = 0
    mealsShape.fillColor = UIColor.clear.cgColor
    
    
    
    showerTrackShape.path = showerCirclePath.cgPath
    showerTrackShape.lineWidth = 2
    showerTrackShape.strokeColor = UIColor.systemPink.cgColor
    showerTrackShape.fillColor = UIColor.clear.cgColor
    
    showerShape.path = showerCirclePath.cgPath
    showerShape.lineWidth = 2
    showerShape.strokeColor = UIColor.gray.cgColor
    showerShape.strokeEnd = 0
    showerShape.fillColor = UIColor.clear.cgColor
    
    
    
    photoTrackShape.path = photoCirclePath.cgPath
    photoTrackShape.lineWidth = 2
    photoTrackShape.strokeColor = UIColor.systemPink.cgColor
    photoTrackShape.fillColor = UIColor.clear.cgColor
    
    photoShape.path = photoCirclePath.cgPath
    photoShape.lineWidth = 2
    photoShape.strokeColor = UIColor.gray.cgColor
    photoShape.strokeEnd = 0
    photoShape.fillColor = UIColor.clear.cgColor
    
  }
}
