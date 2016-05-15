## Development dairy of Whooing app

### Day 1(18 April 2016)
 * I start to develop application.
 * I create github repository.

### Day 14(01 May 2016)
 * Today's purpose(my thought when I start today's job) is appling strechy heading in my tableview.
 * But before I do that, I encounter trouble.
 * My table view cell's layout is terrible.
 * In small screen, right labels pass the right screen, in large screen, they is positioned near center.
 * The reason is auto layout in XCode. It's so difficult... Shit.
 * Okay. I solve this problem. The way that I solve the problem is follow.
  1. I set all components(labels)'s width and height.
  2. And I set constraints about top, bottom, right(trailing), left(leading)
    - Each label have different constraints(top, left / top, right / bottom, left / bottom, right)
  3. Two bottom labels have more constraint about top space.
  4. Two left labels and two right labels have one more constraint about space between labels.
 * The strechy heading is not necessary in my application. Oh... What the...
 * I just apply heading image in top of table view. It'll be used Balance Sheet.
 * I'm faced with another problem. I'm designing balance sheet, so I have to control graph(imageview) size. But... It's some difficult. I cannot resize that when I try to code in viewDidLoad function.
```
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let asset_g = UIImageView(image: UIImage(contentsOfFile:"asset_graph.png"));
    let liabilites_g = UIImageView(image: UIImage(contentsOfFile:"asset_graph.png"));
    asset_g.frame = CGRect(x: 20,y: 57,width: screenSize.width * 0.5 - 10, height: 10)
    liabilites_g.frame = CGRect(x: screenSize.width * 0.5,y: 57,width: screenSize.width * 0.5 - 10, height: 10)
```

### Day 15(02 May 2016)
 * I solve the complication to be faced in yesterday!
 * I use UIView instead of UIImageView, and I resize UIView and set background by image.
 * If I want to change UIView's size and offset, the code is positioned in ViewDidAppear. Although you just change one item, you have to change others is related changed one.
 * Now, I confused about asset labels. I want to set label text of three item of assets and liabilites. But, I don't know how to do that. And I don't have idea that I pick the account name in my bs_assets and bs_liabilities array.
 * I can solve previous problem. I use variables for count, and I check that variable's value in loop.
 * I want to present in balance sheet in top of my table three lastest accounts of assets and liabilities. But lastest entries's assets and liabilities can be duplicated. So I need to check that new account(in loop) is used before.

### Day 17(04 May 2016)
 * First thing I do today is appling number format. At the first time, I try to apply number format by currency formatter. However I don't like it's presenting style about Korean Won. So, I just apply number format by demical style(only commas), and I append Korean word.
 * I Also setting labels in balance sheet. I set top 3 assets and liabilites name and value(money).
 * My design ability is terrible..... I don't like my design and I hate setting constraints, even I have to set offset of label by screen size. So, I decide to skip considering about design.
 * ... holy shit... Why I cannot multiply int and double? Double! and double, too.... It's... OMG...


### Day 18(05 May 2016)
 * I solve the exception about multiply. I create new variable for multiply. However I don't understand why I do that....
 * I make total money about assets and liabilities.
 * And now, It's time to make new function at last!! Design for me is horrible.
 * I create new button, and its shape is round. I can do this as I use following code:
>plus_btn.layer.cornerRadius = 0.5 * plus_btn.bounds.size.width
 * And I can be floated button over the view, the button is positioned bottom of view in left panel.
 * Okay. At this point, I summarize about making modal popup view.
    1. You make two view controller. One is main view, seconde is popup view.
    2. In main view controller, you have to inherit **'Dimmable'** class
    3. In main view controller, you declare two variable about dimmed view. One is 'dimLevel', another is 'dimSpeed'. 'dimLevel' is that how much dim outside of popup view, and 'dimSpeed' is animation speed that popup appear.
    4. And you declare two method, one is 'prepareForSugue'. You type the following code in this method:
> dim(.In, alpha: dimLevel, speed: dimSpeed)
    5. Another method is unwindFromWeb, it is used when you close the popup view. The code is following
```
@IBAction func unwindFromWeb(segue: UIStoryboardSegue) {
	dim(.Out, speed: dimSpeed)
}
```
    6. If you are finished to type above codes, you will connect sugue from main view to popup view. At this time, action sugue is 'Present Modally'.
    7. Last thing is that you make second view. You add new view component and view's size is smaller than whole view controller.(It's modal. Why you set full size?)
    8. In storyboard, you have to check second view's background color. The second view's background color is 'Clear Color' in order to make outside is transparent.
 * I make new popup view because I want to insert new entry. Insert view has five input, date, item, amount of money, one of assets, one of liabilities.
 * I want that when date input touch, call the date picker. But I wonder that I have to make new view for picker when I make this function. So I search about that.
 * Oh. I realize something about delegate in Youtube clip. My thought that delegate is some of super class about component. So, I inherit UITextFieldDelegate in my class(i.e UIViewController), I can use various fuctions about UITextField. It's so cool!
 * UITextFieldDelegate has some method about UITextField. Some of them is following:
    1. textFieldShouldReturn: It defines when user click the return key, what do application? Normally, application hide keyboard. In order to hide keyboard you'll type the codes as following:
    >textField.resignFirstResponder()
    2. textfieldDidEditing: It defines when user click the text field. When user touch(click) the text field, so user can start to edit, this function run.

 * I learned something new one. It's touch events. View controller has functions about touch event. One of them is 'touchesBegan'. It operates when user touch the screen. For example, we use that function in order to hide keyboard when user touch blank place in screen.
 * When we touch(click) the text field, we can show keyboard botoom of scrren. This keyboard is some kind of view. So we can change this keyboard type through various way. Fisrt, property view in text field(you can see in right panel) has property about keyboard type. The property has some of popular keyboard type(i.e number pad, email pad, phone pad). Second way is code. When user start to edit, 'textFieldDidEditing' method is run. So, we can change keyboard type in this method. As I told you before, keyboard of text field is some kind of view. That means that we can define text field's input view, even the view is not defined in swfit.
 * DatePicker has various mode of visualization. Modes are following:
>UIDatePickerModeTime
UIDatePickerModeDate
UIDatePickerModeDateAndTime
UIDatePickerModeCountDownTimer
 * Okay. I do as far as here. At the next time, I try to seperate two or more textfield has different delegate action, and create custom keyboard type.


### Day 23(09 May 2016)
 * Okay. My condition was terrible in recent.
 * In today, I tried to create and connect custom inputview.
 * At first, I was fail. I was in the habit of thinking difficultly. I thought connecting custom inputview to textfield is so simple.
 * First, we need custom inputview. We can create that in Menu > New File > View! Then we can find new xib file. It's inputview file, so we can design in it.
 * Second, we have to type code following:
```
	var assetKeyboardView: UIView!

	if let objects = NSBundle.mainBundle().loadNibNamed("AssetKeyboardView", owner: self, options: nil) {
       assetKeyboardView = objects[0] as! UIView
    }
```
 * And next, we need to declare some functions to do inputview, when we press the buttons.
 * Today's work is done. And I commit this codes in github today.

### Day 29(15 May 2016)
 * Today's mission is connecting viewcontroller to UIInputView that I made before.
 * I create new viewcontroller, and I type the code to change button label. But I'm faced with below error.
>Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<whooing_ios_app.insertVC 0x7fc8c7401550> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key test.'
 * I don't know that why do this error occur.
 * I solve the previous problem, but I don't know reason yet.
 * I make uiview instead of making viewcontroller. And I add protocol and some of functions. Especially, initializeSubviews function act loading xib and adding components of view. At last I modify my insertVC code. In insertVC, I declare new uiview and set textfield's uiview.
 * Next is constructing buttons in keyboard view.
 * Now, I can add button as much as number of accounts. I also can control button size(fit to text), background color, and position. But I can't control fontsize yet.
 * I change font of my buttons and labels by information of label and button that already exist.
 * But I don't know how do I change inputview frame size and label width.