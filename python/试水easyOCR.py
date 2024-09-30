import easyocr
reader = easyocr.Reader(['ch_sim','en']) # this needs to run only once to load the model into memory
result = reader.readtext('chinese.png')
print(result)
reader.readtext('chinese.png', detail = 0)
print(result)
# 傻逼不好使，又要torch又要opencv，最后没有libiomp5md.dll没法启动