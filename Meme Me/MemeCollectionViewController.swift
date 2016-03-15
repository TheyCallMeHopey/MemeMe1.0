//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Hope on 3/8/16.
//  Copyright © 2016 Hope Elizabeth. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController
{
    var memes: [Meme]!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let space: CGFloat = 5.0
        let dimension = (view.frame.size.width - (5.0 * space)) / 5.0
        //TODO: add the height for when it's landscape mode
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        updateMemes()
        
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        if (editing)
        {
            cell.deleteButton.hidden = false
        }
        else
        {
            cell.deleteButton.hidden = true
        }
        
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }

    @IBAction func editButton(sender: AnyObject)
    {
        edit()
    }
    
    //Selecting
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        if (editing)
        {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes.removeAtIndex(indexPath.row)
            
            applicationDelegate.memes = memes
            collectionView.deleteItemsAtIndexPaths([indexPath])
            self.collectionView?.reloadData()
        }
        else
        {
            let memeViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
            memeViewController.meme = memes[indexPath.row]
            navigationController!.pushViewController(memeViewController, animated: true)
        }
    }

    func edit()
    {
        editing = !editing
        collectionView?.reloadData()
    }
    
    func updateMemes()
    {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
}
