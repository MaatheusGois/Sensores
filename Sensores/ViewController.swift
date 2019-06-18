//
//  ViewController.swift
//  Sensores
//
//  Created by Matheus Gois on 18/06/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var espada: UIView!
    
    var referenceAttitude:CMAttitude?
    
    let motion = CMMotionManager()
    
    var lastXUpdate = 0
    var lastYUpdate = 0
    var lastZUpdate = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            //Frequencia de atualização dos sensores definida em segundos - no caso, 60 vezes por segundo
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            //A partir da chamada desta função, o objeto motion passa a conter valores atualizados dos sensores; o parâmetro representa a referência para cálculo de orientação do dispositivo
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            //Um Timer é configurado para executar um bloco de código 60 vezes por segundo - a mesma frequência das atualizações dos dados de sensores. Neste bloco manipulamos as informações mais recentes para atualizar a interface.
            let timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    let relativeAttitude = data.attitude
                                    if let ref = self.referenceAttitude{
                                        //Esta função faz a orientação do dispositivo ser calculado com relação à orientação de referência passada
                                        relativeAttitude.multiply(byInverseOf: ref)
                                    }
                                    
                                   
                
                                    let gravity = data.gravity
                                    //Um pouco de matemágica para rotacionar o background de acordo com a orientação do dispositivo - neste caso, usando o vetor da gravidade para este cálculo
                                    self.espada.transform = CGAffineTransform(rotationAngle: CGFloat(atan2(gravity.x, gravity.y) - .pi))
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
    //Ao tocar na tela, a orientação atual do dispositivo passa a ser considerada a de referência com relação à qual os dados serão calculados
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let att = motion.deviceMotion?.attitude {
            referenceAttitude = att
        }
    }
    
    
    
    
}
