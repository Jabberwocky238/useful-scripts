import pyautogui

```
Python基础之鼠标操作
文章目录
Python基础之鼠标操作
1. GUI 控制功能
1.1 自动 防故障功能
1.2 停顿功能
2. 鼠标操作
2.1 控制鼠标移动
2.2 控制鼠标点击
2.3 控制鼠标拖动
2.4 控制鼠标滚动
3. 屏幕处理
3.1 获取屏幕截图
3.2 识别图像
4. 键盘输入
4.1 键盘输入函数
4.2 键盘特殊按键
4.3 快捷键
5. 提示信息框
5.1 提示框/警告框
5.2 选择框
5.3 密码输入
5.4 普通输入
6. 实例
6.1 鼠标控制 鼠标画一个正方形
6.2 获取鼠标的实时位置
6.3 获取鼠标位置 与 所在位置的颜色
6.4 自动点赞程序
```


# 1. GUI 控制功能
# 1.1 自动 防故障功能
pyautogui.FAILSAFE =False  
# 默认这项功能为True, 这项功能意味着：当鼠标的指针在屏幕的最坐上方，程序会报错；目的是为了防止程序无法停止；

# 1.2 停顿功能
pyautogui.PAUSE = 1    
# 意味着所有pyautogui的指令都要暂停一秒；其他指令不会停顿；这样做，可以防止键盘鼠标操作太快；

# 2. 鼠标操作
# 2.1 控制鼠标移动
# 1. 获得屏幕分辨率
print(pyautogui.size())   # 返回所用显示器的分辨率； 输出：Size(width=1920, height=1080)
width,height = pyautogui.size()
print(width,height)  # 1920 1080

# 2. 移动鼠标
# 移动到指定位置
pyautogui.moveTo(100,300,duration=1)   
# 将鼠标移动到指定的坐标；duration 的作用是设置移动时间，所有的gui函数都有这个参数，而且都是可选参数；

# 按方向移动
pyautogui.moveRel(100,500,duration=4)   # 第一个参数是左右移动像素值，第二个是上下，
# 向右移动100px，向下移动500px, 这个过程持续 1 秒钟；

# 3. 获取鼠标位置
print(pyautogui.position())   # 得到当前鼠标位置；输出：Point(x=200, y=800)

# 2.2 控制鼠标点击
# 单击鼠标
pyautogui.click(10,10)   # 鼠标点击指定位置，默认左键
pyautogui.click(10,10,button='left')  # 单击左键
pyautogui.click(1000,300,button='right')  # 单击右键
pyautogui.click(1000,300,button='middle')  # 单击中间

# 双击鼠标
pyautogui.doubleClick(10,10)  # 指定位置，双击左键
pyautogui.rightClick(10,10)   # 指定位置，双击右键
pyautogui.middleClick(10,10)  # 指定位置，双击中键

# 点击 & 释放
pyautogui.mouseDown()   # 鼠标按下
pyautogui.mouseUp()    # 鼠标释放
1
2
# 2.3 控制鼠标拖动
# 拖动到指定位置
pyautogui.dragTo(100,300,duration=1)   
1
# 将鼠标拖动到指定的坐标；duration 的作用是设置移动时间，所有的gui函数都有这个参数，而且都是可选参数；

# 按方向拖动
pyautogui.dragRel(100,500,duration=4)   # 第一个参数是左右移动像素值，第二个是上下，
1
# 向右拖动100px，向下拖动500px, 这个过程持续 1 秒钟；

# 2.4 控制鼠标滚动
# 控制鼠标滚动的函数是scroll()， 传入一个整数的参数，说明向上或向下滚动多少个单位；单位根据操作系统不同而不同；

pyautogui.scroll(300)  # 向上滚动300个单位；
1
# 3. 屏幕处理
# 3.1 获取屏幕截图
# 我们控制鼠标的操作，不能盲目的进行，所以我们需要监控屏幕上的内容，从而决定要不要进行对应的操作， 
# pyautogui 提供了一个方法screenshot()，可以返回一个Pillow的image对象；

# 这里有三个常用函数：
im = pyautogui.screenshot()# 返回屏幕的截图，是一个Pillow的image对象
im.getpixel((500, 500))# 返回im对象上，（500，500）这一点像素的颜色，是一个RGB元组
pyautogui.pixelMatchesColor(500,500,(12,120,400)) # 是一个对比函数，对比的是屏幕上（500，500）这一点像素的颜色，与所给的元素是否相同；
im.save('屏幕截图.png')

# 3.2 识别图像
# 首先，我们需要先获得一个屏幕快照，例如我们想要点赞，我们就先把大拇指的图片保存下来；
# 然后使用函数：locateOnScreen(‘zan.png’) ，如果可以找到图片，则返回图片的位置，
# 如：Box(left=25, top=703, width=22, height=22)；如果找不到图片，则返回None;
# 如果，屏幕上有多处图片可以匹配，则需要使用locateAllOnScreen(‘zan.png’) ，如果匹配到多个值，则返回一个list，参考如下：

import pyautogui
pyautogui.PAUSE = 1

# 图像识别（一个）
btm = pyautogui.locateOnScreen('zan.png')
print(btm)  # Box(left=1280, top=344, width=22, height=22)

# 图像识别（多个）
btm = pyautogui.locateAllOnScreen('zan.png')
print(list(btm))  # [Box(left=1280, top=344, width=22, height=22), Box(left=25, top=594, width=22, height=22)]

left=1280
top=344
width=22
height=22
pyautogui.center((left, top, width, height)) 
# 返回指定位置的中心点；这样，我们就可以再配合鼠标操作点击找到图片的中心；参考实例：《4.4 自动点赞程序》

# 4. 键盘输入
# 4.1 键盘输入函数
pyautogui.keyDown() # 模拟按键按下；
pyautogui.keyUp() # 模拟按键释放；
pyautogui.press() # 就是调用keyDown() & keyUp(),模拟一次按键；
pyautogui.typewrite('this', 0.5) # 第一参数是输入内容，第二个参数是每个字符间的间隔时间；
pyautogui.typewrite(['T','h','i','s'])# typewrite 还可以传入单字母的列表；

# 举例：
pyautogui.keyDown('shift')    # 按下shift
pyautogui.press('4')    # 按下 4
pyautogui.keyUp('shift')   # 释放 shift
# 输出# $ ；

pyautogui.typewrite('$$$$', 0.5)

# 缓慢的输出：
# 4.2 键盘特殊按键
# 有时我们需要输入一些特殊的按键，比如向左的箭头，这些有相对应的键盘字符串表示，例如：

pyautogui.typewrite(['T','i','s','left','left','h',])   # 输出：This
# 解释：这里的left就是向左的箭头；诸如此类的键盘字符串，还有很多，参考下表：

# 键盘字符串
# 说明
# enter(或return 或 \n)
# 回车
# esc
# ESC键
# shiftleft, shiftright
# 左右SHIFT键
# altleft, altright
# 左右ALT键
# ctrlleft, ctrlright
# 左右CTRL键
# tab (\t)
# TAB键
# backspace, delete
# BACKSPACE 、DELETE键
# pageup, pagedown
# PAGE UP 和 PAGE DOWN键
# home, end
# HOME 和 END键
# up, down, left,right
# 箭头键
# f1, f2, f3…. f12
# F1…….F12键
# volumemute, volumedown,volumeup
# 声音变大变小静音（有些键盘没有）
# pause
# PAUSE键，暂停键
# capslock
# CAPS LOCK 键
# numlock
# NUM LOCK 键
# scrolllock
# SCROLLLOCK 键
# insert
# INSERT键
# printscreen
# PRINT SCREEN键
# winleft, winright
# Win键（windows ）
# command
# command键（Mac OS X ）
# option
# option（Mac OS X）
# 4.3 快捷键
# 如果我们需要模拟复制的快捷键 ctrl + c ，如果用前面的方法，则代码为：

pyautogui.keyDown('ctrl')
pyautogui.keyDown('c')
pyautogui.keyUp('c')
pyautogui.keyUp('ctrl')

# 快捷键的按键与释放顺序非常关键，这时我们可以使用 pyautogui.hotkey()，
# 这个函数可以接受多个参数，按传入顺序按下，再按照相反顺序释放。
# 上述快捷键 ctrl + c ，可以将代码变为：
# pyautogui.hotkey('ctrl','c')

# 5. 提示信息框
# 5.1 提示框/警告框
import pyautogui
a = pyautogui.alert(text='This is an alert box.', title='Test')
print(a)
# 输出如下图：点击确定，返回值为‘OK’


# 5.2 选择框
import pyautogui
a = pyautogui.confirm('选择一项', buttons=['A', 'B', 'C'])
print(a)
# 输出如下图：点击B选项，返回值为‘B’

# 5.3 密码输入
import pyautogui
a = pyautogui.password('Enter password (text will be hidden)')
print(a)
# 输出如下图：输入密码，显示为密文，点击OK，返回值为刚刚输入的值；


# 5.4 普通输入
import pyautogui
a = pyautogui.prompt('请输入一个数字：')
print(a)
# 输出如下图：显示为明文，点击OK，返回值为刚刚输入的值；

# 6. 实例
# 6.1 鼠标控制 鼠标画一个正方形
for i in range(2):   # 画正方形
    pyautogui.moveTo(200,200,duration=1)
    pyautogui.moveTo(200,400,duration=1)
    pyautogui.moveTo(400,400,duration=0.5)
    pyautogui.moveTo(400,200,duration=2)

# 6.2 获取鼠标的实时位置
import pyautogui
import time

try:
    while True:
        x,y = pyautogui.position()
        posi = 'x:' + str(x).rjust(4) + ' y:' + str(y).rjust(4)
        print('\r',posi,end='')
        time.sleep(0.5)

except KeyboardInterrupt:
    print('已退出！')


# 6.3 获取鼠标位置 与 所在位置的颜色
import pyautogui
import time

try:
    while True:
        x,y = pyautogui.position()
        rgb = pyautogui.screenshot().getpixel((x,y))
        posi = 'x:' + str(x).rjust(4) + ' y:' + str(y).rjust(4) + '  RGB:' + str(rgb)
        print('\r',posi,end='')
        time.sleep(0.5)

except KeyboardInterrupt:
    print('已退出！')


# 6.4 自动点赞程序
# 我们需要将所有的文章点赞，本页上的点赞完成后，就滚动鼠标，把新加载的文章也全部点赞；

import pyautogui
import time

def zan():
    time.sleep(0.5)    # 等待 0.5 秒
    left, top, width, height = pyautogui.locateOnScreen('zan.png')   # 寻找 点赞图片；
    center = pyautogui.center((left, top, width, height))    # 寻找 图片的中心
    pyautogui.click(center)    # 点击
    print('点赞成功！')


while True:
    if pyautogui.locateOnScreen('zan.png'):
        zan()   # 调用点赞函数
    else:
        pyautogui.scroll(-500)    # 本页没有图片后，滚动鼠标；
        print('没有找到目标，屏幕下滚~')
