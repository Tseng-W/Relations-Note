<p align="center">
<img src="https://i.imgur.com/ngPbeRe.png" width="200" height="200"/>
</p>

<p align="center" href="default.asp">
<img src="https://i.imgur.com/Qggkk9z.png" width="200" height="120"/>
</p>

<p align="center">
<img src="https://i.imgur.com/X9tPvTS.png" width="120" height="40"/>
</p>


<p align="center">
<img src="https://img.shields.io/github/v/release/Tseng-W/Relations-Note?style=for-the-badge"/>
<img src="https://img.shields.io/github/license/Tseng-W/Relations-Note?style=for-the-badge"/>
</center>

> 每一次與人相會，都像在閱讀一本新書，感到好奇、驚奇與歡愉</br>
> 記人本就像一張書籤，讓你回到那書中的世界，回憶相處時的美好


## 功能

### Sign In with Apple

透過 `Firestore AuthCredential` 串連 `Sign In with Apple` 實做用戶登入並確保安全性

<!-- <p>
<img src="https://imgur.com/coTM11c.png" width="200" height="400"/>
<img src="https://imgur.com/0PqiF5r.png" width="200" height="400"/>
</p> -->

### 紀錄互動事件

#### 畫面跳轉
點擊主畫面下方中央按鈕可進入新增事件頁面

<!-- <img src="https://imgur.com/beilAjE.gif" width="200" height="400"/> -->

以 `ImageView` 配合 `tapGesture` 實作客製化按鈕

```swift
private func lobbyButtonInit() {
  var center = tabBar.center
  center.y -= iconImageButton.frame.height / 2
  iconImageButton.center = center
  view.addSubview(iconImageButton)
  
  let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(onLobbyButtonTap(tapGestureRecognizer:))
  )
  iconImageButton.addGestureRecognizer(tapGesture)
}
```

#### 新增事件詳情

##### 選擇互動對象
互動對象區分為`主分類`、`子分類`與`實際對象`三層結構，

若對象不在清單中，在子類別下點擊新增按鈕可顯示`新增圖示`彈窗，

`新增圖示`彈窗支援`自定義分類`，可自相簿、拍照上傳圖片，或選擇本地圖示並設置個人化配色

<p>
<!-- <img src="https://imgur.com/cWyMqHp.gif" width="200" height="400"/>
<img src="https://imgur.com/dCpyCfa.gif" width="200" height="400"/>
<img src="https://imgur.com/lrVQMfE.gif" width="200" height="400"/> -->
</p>

##### 設置互動主題與添加對象資訊

設置本次互動事件的主要類型，諸如閒聊、會議或聚會等，操作方式與`選擇互動對象`雷同，亦支援添加`自定義分類`

可在事件中添加交流中得知的對方個人特徵、興趣與過往經歷等資訊，用戶可自定義新增分類，添加後可在個人詳情中查看所有過往紀錄

<p>
<img src="https://imgur.com/lSqy37O.gif" width="200" height="400"/>
<img src="https://imgur.com/ykAsiaP.gif" width="200" height="400"/>
</p>

#### 滑動多層選單實作
程式內所有標籤滑動選單皆共用自定義的 FilterView，為區別各來源差異以 `Enum` 初始化選單類型
```swift
class FilterView: UIView {
  func setUp(type: CategoryType, isMainOnly: Bool = false) {
    ...
    userViewModel.user.bind { [weak self] user in
      guard let user = user else { return }

      self?.filterSource = user.getFilter(type: type)

      if let categoryViews = self?.categoryViews,
         categoryViews.isEmpty {
        self?.initialFilterView()
      }
    }
    ...
  }

  private func initialFilterView() {
    layoutIfNeeded()
    addFilterBar()
    addScrollView()

    layoutIfNeeded()
    guard let type = type else { return }
    addCategoryCollectionViews(type: type)
  }
}
```

上方滑動按鈕選單以自定義 Selection View 實作，透過 Delegate 與 FilterView 連動按鈕內容與點擊事件
```swift
protocol SelectionViewDatasource: AnyObject {
  func numberOfButton(_ selectionView: SelectionView) -> Int

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String
  ...
}

protocol SelectionViewDelegate: AnyObject {
  func didSelectedButton(_ selectionView: SelectionView, at index: Int)

  func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool
}
```

下方清單則以 ScrollView 動態生成自定義 CollectionView 後定位，以實作滑動效果
```swift
private func addCategoryCollectionViews(type: CategoryType) {
  ...
  let viewWidth = categoryScrollView.frame.width
  let viewHeight = categoryScrollView.frame.height
  var x: CGFloat = 0

  for index in 0..<filterSource.count {
    let collectionView = CategoryCollectionView(
      frame: CGRect(x: x, y: 0, width: viewWidth, height: viewHeight))
    ...
    collectionView.setUp(index: index, type: type, isMainOnly: isMainOnly)

    categoryScrollView.addSubview(collectionView)
    categoryViews.append(collectionView)
    x = collectionView.frame.origin.x + viewWidth

    collectionView.selectionDelegate = delegate
  }
  ...
}
```

封裝的 FilterView 即可快速初始化，實作接口後可取得觸發事件參數進行後續處理
```swift
filterView.setUp(type: .relation)
filterView.delegate = self
...

protocol CategorySelectionDelegate: AnyObject {
  func initialTarget() -> (mainCategory: Category, subCategory: Category)?

  func didSelectedCategory(category: Category)

  func didStartEdit(pageIndex: Int)

  func addCategory(type: CategoryType, hierarchy: CategoryHierarchy, superIndex: Int, categoryColor: UIColor)
}
```

##### 設置互動地點

可選擇當前定位位置，或搜尋地標位置進行定位，此一位置將紀錄並顯示於事件詳情

<img src="https://imgur.com/23nDs2L.gif" width="200" height="400"/>

##### 設置事件主題圖片與情緒

從相簿或相機設置事件專屬照片，添加後會於事件詳情內顯示

紀錄互動過程的情緒，可從顏色與圖示進行區分，並會在事件清單與詳情中顯示

<p>
<img src="https://imgur.com/JTT70UV.gif" width="200" height="400"/>
<img src="https://imgur.com/bGs0vZc.gif" width="200" height="400"/>
</p>

##### 操作教學

因應操作的複雜度設計教學提示

點擊欄位右側的？圖示便會顯示引導訊息

<!-- <img src="https://imgur.com/H6MxZTu.gif" width="200" height="400"/> -->

實作方式為封裝`AMPopTip`，達成腳本化撰寫減少維護與開發成本

```swift=
class PopTipManager() {
func addPopTip(at target: UIView, text: String, direction: PopTipDirection, duration: TimeInterval? = nil, style: Style = .normal) -> PopTipManager
}
...

class addEventViewController() {
  relationHeader.tips = {
    PopTipManager.shared
      .addPopTip(at: self.filterView, text: "在此處選擇互動的對象", direction: .up)
      .addPopTip(at: self.filterView, text: "可以點擊分類頁或滑動切換類型",   direction: .up)
      .addPopTip(at: self.filterView, text: "新的關係人可在分類下點擊新增添加",   direction: .down)
      .show()
  }
}
```

並可依照彈窗類型以`enum`屬性選擇替換樣式
```swift
enum Style {
  ...
  func getAttribute() -> [Attribute] {
    switch self {
    case .normal:
      return [.bubbleColor(.button), .textColor(.background)]
    case .alert:
      return [.bubbleColor(.color9), .textColor(.background)]
    }
  }
}
```

### 查看歷史事件

在首頁行事曆中依照當日是否有互動事件高亮日期，點擊可查看當日互動列表

<img src="https://imgur.com/tGezMKg.gif" width="200" height="400"/>

### 個人資訊

主畫面左側可查閱所有關係分類與對象詳情，包含歷史事件、個人特徵分類清單等

<p>
<!-- <img src="https://imgur.com/xmiwfon.gif" width="200" height="400"/>
<img src="https://imgur.com/i1q2MtR.gif" width="200" height="400"/>
<img src="https://imgur.com/Ix6gAmF.gif" width="200" height="400"/> -->
</p>
  
### 分類編輯

設置頁可瀏覽當前所有標籤，並可編輯名稱、圖示與顏色等，變更結果將套用於過往事件。

<p>
<img src="https://imgur.com/IG5dOuf.gif" width="200" height="400"/>
<img src="https://imgur.com/bkHedux.gif" width="200" height="400"/>
</p>
  
### 深色模式

可於設置頁切換白模式／深色模式，並紀錄設置於下次開啟時套用

<img src="https://imgur.com/oKMPoB4.gif" width="200" height="400"/>

---

## 技術亮點

* 使用 `MVVM` 架構開發，各區塊職責分工明確
* 大部分 View 皆以 `Nibs` 開發，易於共用並減少重複代碼
* 靈活運用 `Extension` 減少冗餘代碼同時將參數改為強型別，強化可讀與穩定性
* 針對 `SCLAlertView`、`Lottie`、`AMPopTip` 等三方套件進行封裝，減少冗贅代碼同時將變數轉為強型別，加強程式碼可讀性
* 使用 `Firestore`、`Storage` 以存取用戶個人數據與照片
* 使用 `Auto Layout` (`Interface Builder`、`programmatically`) 匹配各式 iOS 裝置尺寸比例
* 透過 `Sign In with Apple` 與 `Firebase Authentication` 實作用戶登入並確保帳戶安全性
* 客製化 `FSCalendar` 以更符合中文使用者使用習慣 
* 導入 `Crashlytics` 以取得用戶異常反饋並予以優化

---

## 第三方套件

*  [SwiftLint](https://github.com/realm/SwiftLint) - 程式碼規範檢查
*  [MJRefresh](https://github.com/CoderMJLee/MJRefresh) - TableView 手動刷新客製化
*  [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager) - 鍵盤收放體驗優化
*  [Kingfisher](https://github.com/onevcat/Kingfisher) - 圖片下載與快取
*  [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD) - 讀取中、成功、失敗提示彈窗
*  [FSCalendar](https://github.com/WenchaoD/FSCalendar) - 行事曆顯示與日期篩選
*  [TagListView](https://github.com/ElaWorkshop/TagListView) - 顯示事件分類 Tag 標記
*  [AMPopTip](https://github.com/andreamazz/AMPopTip) - 顯示指定位置浮窗提示，用於新手教學功能
*  [GooglePlaces](https://cocoapods.org/pods/GooglePlaces) - 用於搜索地標並取得座標
*  [GoogleMaps](https://cocoapods.org/pods/GoogleMaps) - 用於取得指定座標周邊地圖數據
*  [FlexColorPicker](https://github.com/RastislavMirek/FlexColorPicker) - 自定義圖標時顏色修改操作
*  [SCLAlertView](https://github.com/vikmeup/SCLAlertView-Swift) - 於新增分類時提供自定義多功能浮窗
*  [lottie-ios](https://github.com/airbnb/lottie-ios) - 提供顯示 Lottie 動畫，用於開啟 App 長時間讀取與圖標照片讀取時使用
*  [CropViewController](https://github.com/TimOliver/TOCropViewController) - 將照片裁切成圓形
*  [Firebase](https://firebase.google.com/docs/ios/setup)
    *  Auth: 用於 Sign In with Apple
    *  Firesotre: 用於存儲用戶數據如事件與關係人
    *  Storage: 用於存儲用戶上傳個人照片
    *  Crashlytics: 用於收集用戶崩潰數據
---

## 環境需求
* Xcode 12.4 
* iOS 13.4

---

## 聯繫資訊

Wun Tseng / twayne0618@gmail.com