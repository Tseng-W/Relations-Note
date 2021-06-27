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

![Imgur](https://imgur.com/coTM11c.png "AppleSignIn" =200x400)
![Imgur](https://imgur.com/0PqiF5r.png "AppleSignIn" =200x400)

### 紀錄互動事件

#### 畫面跳轉
點擊主畫面下方中央按鈕可進入新增事件頁面

![Imgur](https://imgur.com/beilAjE.gif "新增關係" =200x400)

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

![Imgur](https://imgur.com/cWyMqHp.gif "關係篩選" =200x400)
![Imgur](https://imgur.com/cNqRDmP.gif "新增關係" =200x400)
![Imgur](https://imgur.com/TOP1HY6.gif "新增關係" =200x400)

##### 設置互動主題

設置本次互動事件的主要類型，諸如閒聊、會議或聚會等

操作方式與`選擇互動對象`雷同，亦支援添加`自定義分類`

![Imgur](https://imgur.com/lSqy37O.gif "選擇事件" =200x400)
![Imgur](https://imgur.com/OuTxDgU.gif "新增事件" =200x400)

##### 設置互動地點

可選擇當前定位位置，或搜尋地標位置進行定位，此一位置將紀錄並顯示於事件詳情

![Imgur](https://imgur.com/23nDs2L.gif "設置地點" =200x400)

##### 新增互動對象資訊

可在事件中添加交流中得知的對方個人特徵、興趣與過往經歷等資訊，用戶可自定義新增分類，

添加後可在個人詳情中查看所有過往紀錄

![Imgur](https://imgur.com/ykAsiaP.gif "新增特徵" =200x400)

##### 情緒設定

紀錄互動過程的情緒，可從顏色與圖示進行區分，並會在事件清單與詳情中顯示

![Imgur](https://imgur.com/bGs0vZc.gif "情緒設定" =200x400)

##### 設置事件主題圖片

從相簿或相機設置事件專屬照片，添加後會於事件詳情內顯示

![Imgur](https://imgur.com/i7EVJr6.gif "事件照片" =200x400)
![Imgur](https://imgur.com/JTT70UV.png "事件照片" =200x400)

##### 操作教學

因應操作的複雜度設計教學提示

點擊欄位右側的？圖示便會顯示引導訊息

![Imgur](https://imgur.com/H6MxZTu.gif "操作教學" =200x400)

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

![Imgur](https://imgur.com/tGezMKg.png "詳情查閱" =200x400)

### 個人資訊

主畫面左側可查閱所有關係分類與對象詳情，包含歷史事件、個人特徵分類清單等

![Imgur](https://imgur.com/xmiwfon.png "詳情查閱" =200x400)
![Imgur](https://imgur.com/i1q2MtR.png "詳情查閱" =200x400)
![Imgur](https://imgur.com/Ix6gAmF.gif "詳情查閱" =200x400)

### 分類編輯

設置頁可瀏覽當前所有標籤，並可編輯名稱、圖示與顏色等，變更結果將套用於過往事件。

![Imgur](https://imgur.com/IG5dOuf.png "分類編輯" =200x400)
![Imgur](https://imgur.com/1zDSY7m.gif "分類編輯" =200x400)

### 深色模式

可於設置頁切換白模式／深色模式，並紀錄設置於下次開啟時套用

![Imgur](https://imgur.com/yZgidAL.gif "深色模式切換" =200x400)

---

## 開發架構

---

## 第三方套件

*  SwiftLint
*  MJRefresh
*  IQKeyboardManagerSwift
*  Kingfisher
*  JGProgressHUD'
*  FSCalendar
*  TagListView
*  Firebase
*  Firebase/Core
*  Firebase/Auth
*  Firebase/Messaging
*  Firebase/Firestore
*  Firebase/Storage
*  FirebaseFirestoreSwift
*  FirebaseStorageSwift
*  AMPopTip
*  GoogleMaps
*  FlexColorPicker
*  SCLAlertView
*  GooglePlaces
*  lottie-ios
*  CropViewController
*  Firebase/Crashlytics

---

## 開發環境版本

---