//
//  ViewController.swift
//  CatsMeow
//
//  Created by Coleman, Ray on 1/15/23.
//
import SwiftUI
import UIKit

let SERVER_PATH =  "https://cataas.com/cat/"
var catObjectArray:Array<Cat> = [Cat]()

class ViewController: UIPageViewController, UIPageViewControllerDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Let's get the data from the API
        catAPI()
        
        // set our intitial content view for the page view controller
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    // MARK: PageView Controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // initialize variables
        let pageContent: PageContentWebViewController = viewController as! PageContentWebViewController
        var index = pageContent.pageIndex
        
        // check to see if we are at the first index
        if ((index == 0) || (index == NSNotFound))
        {
            let alertController = UIAlertController(title:nil,message:"This is the first kitty",preferredStyle:.alert)
            self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 3, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            
            return nil
        }
        
        // decrement our index
        index -= 1
        return getViewControllerAtIndex(index:index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        // initialize variables
        let pageContent: PageContentWebViewController = viewController as! PageContentWebViewController
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        // increment our index
        index+=1;
        
        // check to see if we are at the last index
        if (index == catObjectArray.count)
        {
            let alertController = UIAlertController(title:nil,message:"Sorry, that was the last kitty!",preferredStyle:.alert)
            self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 3, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            
            return nil;
        }
        return getViewControllerAtIndex(index:index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentWebViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentWebViewController") as! PageContentWebViewController
        
        // update the index and url for the next container view
        pageContentViewController.catURL = SERVER_PATH + catObjectArray[index]._id
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
    
    // MARK: API
    func catAPI()
    {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "https://cataas.com/api/cats?limit=20&skip=0")
        else
        {
            return
        }
        
        // create the data task
        let task = URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            let decoder = JSONDecoder()
            
            // consume JSON data
            if let data = data{
                do
                {
                    let tasks = try decoder.decode([Cat].self, from: data)
                    tasks.forEach{ cat in
                        catObjectArray.append(cat)
                    }
                }
                catch
                {
                    print(error)
                }
            }
            if error != nil
            {
                print("Yikes!")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return
    }
}

