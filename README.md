![editdistancelogo](https://user-images.githubusercontent.com/18320004/31609649-04d95c24-b2b0-11e7-96a9-6c8dc3989377.png)

[![Platform](https://img.shields.io/cocoapods/p/EditDistance.svg?style=flat)](http://cocoapods.org/pods/EditDistance)
[![Platform](https://img.shields.io/badge/platform-tvos-lightgrey.svg)](http://cocoapods.org/pods/EditDistance)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)
![Swift 3.2](https://img.shields.io/badge/Swift-3.2-orange.svg)
[![License](https://img.shields.io/cocoapods/l/EditDistance.svg?style=flat)](http://cocoapods.org/pods/EditDistance)
[![Version](https://img.shields.io/cocoapods/v/EditDistance.svg?style=flat)](http://cocoapods.org/pods/EditDistance)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

EditDistance is one of the incremental update tool for UITableView and UICollectionView. 

The followings show how this library update UI. They generate the random items and update their UI incrementally.

| UITableView | UICollectionView |
|---|---|
| ![tableview](https://cloud.githubusercontent.com/assets/18320004/23104148/adbfb22c-f70b-11e6-80bc-97fb1bac7bbc.gif)  | ![collectionview 1](https://cloud.githubusercontent.com/assets/18320004/23104147/ab1a6d00-f70b-11e6-921b-e328153306fd.gif)  |

# What's this?
This library pipelines the process to update UITableView and UICollectionView. It is so difficult to update them incrementally, because iOS app developers need to manage differences between the two DataSources.

If you update items for DataSource:
```swift
// dataSource has ["Francis Elton", "Stanton Denholm", "Arledge Camden", "Farland Ridley", "Alex Helton"]
var nextDataSource = dataSource

// insertion and deletion to data source
nextDataSource.remove(at: 2)
nextDataSource.insert("Woodruff Chester", at: 1)
nextDataSource.insert("Eduard Colby", at: 3)
```

Typical code:

```swift
// You have to update UITableView according to array's diff.
dataSource = nextDataSource
tableView.beginUpdates()
tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
tableView.insertRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .fade)
tableView.endUpdates()
```

EditDistance takes on that task:

```swift
// You don't need to write insertion and deletion.
let container = dataSource.diff.compare(to: nextDataSource)
dataSource = nextDataSource
tableView.diff.reload(to: container) 
```

All you need is to make the updated array.

You don't have to manage how to update incrementally. That enables to pileline the process.

# How dose it work?
EditDistance calculates the difference and converts it into an incremental update of UITableView or UICollectionView.

The difference is based on [**Edit Distance Algorithm**](https://en.wikipedia.org/wiki/Edit_distance). There are many ways to calculate it and almost all of them nearly run in linear time.

- Dynamic Programming (*O(NM)*)
- Mayer's Algorithm (*O(ND)*)
- Wu's Algorithm (*O(NP)*)
- etc.

*N* and *M* are sequence sizes of each array. *D* is edit distance and *P* is the number of deletion.

In our context, Wu's Algorithm seems to be the best algorithm. It has better performance than the others when your app has many items and adds (or deletes) a few items. (e.g. autopager, access history and notification)

# Pros and Cons
Calculation in this library is not always reasonable to update UI. I recommend that your app calculates edit distance in sub-thread and update UI in main-thread.

# Feature
- [x] You don't need to calculate diff manually.
- [x] You can choose any diff algorithm as you like.
- [x] You don't need to call [reloadRows(at:with:)](https://developer.apple.com/reference/uikit/uitableview/1614935-reloadrows) and [performBatchUpdates(_:completion:)](https://developer.apple.com/reference/uikit/uicollectionview/1618045-performbatchupdates) anymore.
- [x] minimum implimentation for incremental update

# Requirements
- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+

# Installation

### Carthage

+ Install Carthage from Homebrew
```
> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> brew update
> brew install carthage
```
+ Move your project dir and create Cartfile
```
> touch Cartfile
```
+ add the following line to Cartfile
```
github "kazuhiro4949/EditDistance"
```
+ Create framework
```
> carthage update --platform iOS
```

+ In Xcode, move to "Genera > Build Phase > Linked Frameworks and Library"
+ Add the framework to your project
+ Add a new run script and put the following code
```
/usr/local/bin/carthage copy-frameworks
```
+ Click "+" at Input file and Add the framework path
```
$(SRCROOT)/Carthage/Build/iOS/EditDistance.framework
```
+ Write Import statement on your source file
```
Import EditDistance
```

### CocoaPods
+ Install CocoaPods
```
> gem install cocoapods
> pod setup
```
+ Create Podfile
```
> pod init
```
+ Edit Podfile
```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '8.0'  # add
use_framework!  # add

target 'MyAppName' do
  pod 'EditDistance' # add
end

target 'MyAppTests' do

end

target 'MyAppUITests'
```

+ Install

```
> pod install
```
open .xcworkspace

# Usage
## Calculation of differences between two arrays
### One dimentional array
#### 1. prepare two arrays.
```swift
let current = ["Francis", "Woodruff", "Stanton"]
let next = ["Francis", "Woodruff", "Stanton", "Eduards"]
```

#### 2. calling diff from Array makes EditDistanceProxy\<T> instance.

```swift
let proxy = current.diff // => EditDistanceProxy<String>
```

#### 3. the instance has compare(to:) to calculate diff with next array.
```swift
let container = proxy.compare(to: next) // => EditDistanceContainer<String>
```

### Two dimentional array
#### 1. prepare two arrays.
```swift
let current = [["Francis", "Woodruff"], ["Stanton"]]
let next = [["Francis", "Woodruff"], ["Stanton", "Eduard"]]
```

#### 2. instantiate EditDistance object

```swift
let editDistance = EditDistance(from: current, to: next) // => EditDistance<String>
```

#### 3. the instance has compare(to:) to calculate diff with next array.
```swift
let container = editDistance.calculate() // => EditDistanceContainer<String>
```

### customizing algorithm

#### to preset algorithm objcts
```swift
let container = current.diff.compare(to: next, with: DynamicAlgorithm())
```
#### to closure
```swift
// implement algorithm
let algorithm = AnyEditDistanceAlgorithm { (from, to) -> EditDistanceContainer<String> in
    //...
    //...
}

let container = current.diff.compare(to: next, with: algorithm)
```
#### make a new algorithm class.
```swift
//implements protocol
public struct Wu<T: Equatable>: EditDistanceAlgorithm {
    public typealias Element = T
    
    public func calculate(from: [[T]], to: [[T]]) -> EditDistanceContainer<T> {
      //...
      //...
    }
}

```

## Incremental Update to UITableView

### 1. Calculate Diff between two arrays
```swift
let nextDataSource = ["Francis Elton", "Woodruff Chester", "Stanton Denholm", "Eduard Colby", "Farland Ridley", "Alex Helton"]
let container = dataSource.diff.compare(to: nextDataSource)
```

### 2. update DataSource and UI
```swift
dataSource = nextDataSource
tableView.diff.reload(with: container) 
```

## If you won't use this library anymore
```swift
ataSource = nextDataSource
// tableView.diff.reload(with: container) 
tableView.reloadData()
```

That's it! :wink:

# Performance
Wu's algorithm is recommended in this library. The actual speed depends on the number of differences between two arrays and the cost of "==" the elements have. The followings are some avarage speeds for reference. They were executed on iPhone7, iOS 10.2 Simulator and build with "whole module optimization option" setting. The sample arrays are composed of random UUID Strings.

- from 100 items to 120 items (20 addition), avg: 0.001 sec
- from 100 items to 100 items (10 addition and 10 deletion), avg: 0.001 sec
- from 100 items to 200 items (100 addition), avg: 0.001 ms
- from 100 items to 100 items (50 addition and 50 deletion), avg: 0.001 sec
- from 1000 items to 1050 items (50 addition), avg: 0.003 sec
- from 1000 items to 1000 items (25 addition and 25 deletion), avg: 0.003 sec
- from 1000 items to 1200 items (200 addition), avg: 0.003 sec
- from 1000 items to 1000 items (100 addition and 100 deletion), avg: 0.008 sec
- from 10000 items to 10100 items (100 addition), avg: 0.031 sec
- from 10000 items to 10000 items (50 addition and 50 deletion), avg: 0.032 sec
- from 10000 items to 12000 items (2000 addition), avg: 0.033 sec
- from 10000 items to 10000 items (1000 addition and 1000 deletion), avg: 0.055 sec

Test Case is [here](https://github.com/kazuhiro4949/EditDistance/blob/master/EditDistanceTests/WuTests.swift). You can take reexamination with them.

# Class Design

![editdistance](https://cloud.githubusercontent.com/assets/18320004/23338894/a77d63d4-fc59-11e6-852b-b1036e215eaf.png)

- **EditDistance** is a director to calculate **EditDistanceAlgorithm** with two input Array.
- **AnyEditDistanceAlgorithm** is a type-erased structure to **EditDistanceAlgorithm**.
- **EditDistanceContainer** is a container to bridge result of algorithm and view's update.
- **EditScriptConverter** is a kind of namespace to use some extensions to UIKit classes.
- **EditScriptConverterProxy** is a proxy for UITableView and UICollectionView. It has method to update the items.


# License

Copyright (c) 2017 Kazuhiro Hayashi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
