import pyautogui
import time

# 6.3 获取鼠标位置 与 所在位置的颜色
try:
    while True:
        x,y = pyautogui.position()
        rgb = pyautogui.screenshot().getpixel((x,y))
        posi = 'x:' + str(x).rjust(4) + ' y:' + str(y).rjust(4) + '  RGB:' + str(rgb)
        print(posi)
        time.sleep(0.02)

except KeyboardInterrupt:
    print('已退出！')

a, b = 716, 303
c, d = 1406, 481
e, f = 897, 601
print(c-a, d-b, e-a, f-b)