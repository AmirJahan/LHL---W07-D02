import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var tileWidth: CGFloat!
    
    // to store both tiles and centers
    var tilesArr: NSMutableArray = []
    var centersArr: NSMutableArray = []
    
    var curTime: Int = 0
    var gameTimer: Timer = Timer()
    
    
    
    
    var compareState : Bool = false
    var firstTile : MyLabel!
    var secondTile : MyLabel!
    
    
    @IBAction func testFunc(_ sender: Any) 
    {
        UIView.beginAnimations(nil, context: nil);
        UIView.setAnimationDuration(2);
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut);
        (tilesArr.object(at: 0) as! MyLabel).center = self.view.center;
        UIView.commitAnimations();
        
        
        
        UIView.animate(withDuration: 4, animations:
            {
                (self.tilesArr.object(at: 3) as! MyLabel).center = self.view.center;

        }) { (true) in
            print("not done")
        }
        
    }
    
    @IBAction func resetAction(_ sender: Any)
    {
        for anyView in gameView.subviews
        {
            anyView.removeFromSuperview()
        }
        
        tilesArr = []
        centersArr = []
        blockMakerAction()
        randomizeAction()
        
        for anyTile in tilesArr
        {
            (anyTile as! MyLabel).text = "?"
        }
        
        
        curTime = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerFunc),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func timerFunc ()
    {
        curTime += 1
        
        let timeMins: Int = curTime / 60
        let timeSecs: Int = curTime % 60
        
        let timeStr : String = NSString(format: "%02d\' : %02d\"", timeMins, timeSecs) as String
        timerLabel.text = timeStr
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetAction(Any.self)
    }
    
    func randomizeAction ()
        
    {
        // go through the blocks in order and give them a random canter
        for tile in tilesArr
        {
            let randIndex: Int = Int ( arc4random() ) % centersArr.count
            
            let randCen: CGPoint = centersArr[randIndex] as! CGPoint
            
            (tile as! MyLabel).center = randCen
            centersArr.removeObject(at: randIndex)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        


    }
    
    func blockMakerAction ()
    {
//        tileWidth = gameView.frame.size.width / 4
       
        gameView.layoutIfNeeded()
        tileWidth = gameView.frame.size.width / 4
        
        
        var xCen: CGFloat = tileWidth / 2
        var yCen: CGFloat = tileWidth / 2
        

        let tileFrame: CGRect = CGRect(x: 0,
                                       y: 0,
                                       width: tileWidth - 4,
                                       height: tileWidth - 4 )
        
        var counter: Int = 1
        
        for _ in 0..<4
        {
            for _ in 0..<4
            {
                let tile: MyLabel = MyLabel(frame: tileFrame)
                
                if ( counter > 8)
                {
                    counter = 1
                }
                
                tile.text = String( counter )
                tile.tagNumber = counter
                
                tile.textAlignment = NSTextAlignment.center
                tile.font = UIFont.boldSystemFont(ofSize: 30)
                
                
                let cen: CGPoint = CGPoint(x: xCen, y: yCen)
                
                tile.isUserInteractionEnabled = true
                
                tile.center = cen
                tile.backgroundColor = UIColor.darkGray
                gameView.addSubview(tile)
                
                tilesArr.add(tile)
                centersArr.add(cen)
                
                
                xCen = xCen + tileWidth
                counter += 1
            }
            yCen = yCen + tileWidth
            xCen = tileWidth / 2
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let myTouch: UITouch = touches.first!
        
        if (tilesArr.contains(myTouch.view as Any))
        {
            let thisTile : MyLabel = myTouch.view as! MyLabel
            
            UIView.transition(with: thisTile,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionFlipFromRight,
                              animations: {
                                thisTile.text = String ( thisTile.tagNumber )
                                thisTile.backgroundColor = UIColor.purple
            },
                              completion: { (true) in
                                if ( self.compareState)
                                {
                                    // let's compare
                                    self.compareState = false
                                    self.secondTile = thisTile
                                    self.compareAction ()
                                    // now we are ready for comparison
                                }
                                else
                                {
                                 // only flip
                                    self.firstTile = thisTile
                                    self.compareState = true
                                }
            })
        }
    }
    
    
    
    func flipThemBack (anyInp:Array<Any>)
    {
        for anyObj in anyInp
        {
            let thisTile = anyObj as! MyLabel
            
            UIView.transition(with: thisTile,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionFlipFromRight,
                              animations: {
                                thisTile.text = "😀"
                                thisTile.backgroundColor = UIColor.green
            }, completion: nil)
        }
    }
    
    func compareAction()
    {
        if ( firstTile.tagNumber == secondTile.tagNumber)
        {
            self.flipThemBack(anyInp: [firstTile, secondTile])
        }
        else
        {
            // they are different
            UIView.transition(with: self.view,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                self.firstTile.text = "?"
                                self.secondTile.text = "?"
                                self.firstTile.backgroundColor = UIColor.darkGray
                                self.secondTile.backgroundColor = UIColor.darkGray
            }, completion: nil)
        }
        
    }
}




class MyLabel: UILabel {
    var tagNumber: Int!
}







