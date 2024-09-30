from skimage import io, transform

# 读取图片
image = io.imread('pic1.jpg')

# 改变图片大小
resized_image = transform.resize(image, (100, 100))  # 将图片大小改为100x100

# 显示原图和修改后的图
io.imshow(resized_image)
io.show()

from skimage import io, filters

# 读取图片
image = io.imread('pic1.jpg', as_gray=True)

# 使用Sobel算法检测边缘
edges = filters.sobel(image)

# 显示原图和边缘检测后的图
io.imshow(edges)
io.show()
# 有点恐怖