import cv2
from vidgear.gears import CamGear
# 我操，牛逼
# 初始化CamGear对象
cam = CamGear(source=0).start() 
# 创建窗口用来显示
cv2.namedWindow("camera", cv2.WINDOW_AUTOSIZE)
while True:
    # 读取一帧
    frame = cam.read()
    # 将图片数据转换为BGR格式
    frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR) 
    # 将图片显示在窗口中
    cv2.imshow("camera", frame)
    # 按q退出
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
# 释放资源        
cam.stop()
cv2.destroyAllWindows()