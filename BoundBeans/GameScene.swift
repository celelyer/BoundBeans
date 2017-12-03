//
//  GameScene.swift
//  BoundBeans
//
//  Created by セロラー on 2017/11/27.
//  Copyright © 2017年 mikiya.tadano. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mame:SKSpriteNode!
    var backScreenNode:SKSpriteNode!
    var Leaf:SKSpriteNode!
    var ki:SKSpriteNode!
    
    //衝突判定カテゴリー
    let mameCategory: UInt32 = 1 << 0
    let leafCategory: UInt32 = 1 << 1
    
    
    //SKView上にシーンが表示された時に呼ばれるメソッド
    override func didMove(to view: SKView) {
        print("Start")
        //重力を設定
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
        physicsWorld.contactDelegate = self
        
        backScreenNode = SKSpriteNode()
        backScreenNode.physicsBody = SKPhysicsBody()
        addChild(backScreenNode)
        
        //背景色を設定
        //backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        setupLeaf()
        setupBean()
        setupKi()
    }
    
    //画面をタップした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Tap")
        mameJump()
        
        
        
         //複数本の指でタッチした場合も想定されるので、その中から指一本分の座標データを取得
        if let touch = touches.first{
            //スクリーン上の座標データをlocationNodeメソッドでシーン上での座標に変換
            let location = touch.location(in: self)
            let action = SKAction.moveTo(x: location.x, duration:1.0)
            mame.run(action)
        }
        
    }
    
     //ドラッグ時
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            let action = SKAction.moveTo(x: location.x, duration: 1.0)
            self.mame?.run(action)
        }
    }
    
    
    
    func setupBean(){
        //まめくんの画像を読み込む
        let mameTexture = SKTexture(imageNamed: "Bean")
        mameTexture.filteringMode = SKTextureFilteringMode.linear
        
        
        //スプライトを作成
        mame = SKSpriteNode(texture: mameTexture)
        mame.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.7)
        
        //物理演算を設定
        mame.physicsBody = SKPhysicsBody(circleOfRadius: mame.size.height / 2.0)
        
        //衝突した時に回転させない
        mame.physicsBody?.allowsRotation = true
        //衝突した時に動かさない
        mame.physicsBody?.isDynamic = false
        
        //衝突のカテゴリー設定
        mame.physicsBody?.categoryBitMask = mameCategory
        mame.physicsBody?.collisionBitMask = leafCategory //当たった時に跳ね返る相手
        mame.physicsBody?.contactTestBitMask = leafCategory //当たった時にdidBeginContactを呼び出す
        
        
        
        //スプライトを追加する
        addChild(mame)
        
    }
    
    func setupLeaf(){
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_1")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        Leaf = SKSpriteNode(texture: leafTexture)
        
        //スプライトの位置を指定する
        Leaf.position = CGPoint(x: size.width / 2, y: size.height / 3)
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = true
        //質量を１に設定(木と同じ)
        Leaf.physicsBody?.mass = 0.07
        
        //スプライトを追加する
        
        backScreenNode.addChild(Leaf)
    }
    
    func setupKi(){
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //スプライトを作成
        ki = SKSpriteNode(texture: kiTexture)
        
        
        //スプライトの位置を指定する
        ki.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ki.zPosition = -100
        
        //物理演算を設定
        ki.physicsBody = SKPhysicsBody(rectangleOf: kiTexture.size(), center: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height))
        //質量を設定(葉と同じ)
        ki.physicsBody?.mass = 0.07
        
        //シーンにスプライトを追加
        backScreenNode.addChild(ki)
        
    }
    
    func mameJump(){
        //木の面積
        //let size_ki = ki.size.width * ki.size.height
        //葉の面積
        //let size_leaf = Leaf.size.width * (Leaf.size.height / 10.0)
        //木と葉の相対面積
        //let size_ki_leaf = size_ki / size_leaf
        
        //スクロールの速度をゼロにする
        Leaf.physicsBody?.velocity = CGVector.zero
        ki.physicsBody?.velocity = CGVector.zero
        //スクロールに縦方向の力を与える
        Leaf.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -25.0))
        ki.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -25.0/* * size_ki_leaf*/))
    }
    
    
    //SKPhysicsContactDelegateのメソッド。衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        
        if (contact.bodyA.categoryBitMask & leafCategory) == leafCategory || (contact.bodyB.categoryBitMask & leafCategory) == leafCategory {
            mameJump()
        }
            
            
            
    }
    
}
