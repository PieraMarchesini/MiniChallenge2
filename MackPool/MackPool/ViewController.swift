//
//  ViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 01/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PageViewControllerDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let pageViewController = segue.destination as? PageViewController {
            pageViewController.delegatePageViewController = self
        }
    }
    
    func pageViewController(_ pageViewController: PageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }

}
