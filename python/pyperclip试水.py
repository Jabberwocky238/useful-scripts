import pyperclip
# 将文本复制到剪贴板
pyperclip.copy('哈喽')
# 剪贴板上有非空字符串时返回字符串
a = pyperclip.waitForPaste(5)
print(a)
# 从剪贴板粘贴文本
pyperclip.paste()
# 剪贴板上有文本被更改时传返回值
pyperclip.copy('original text')
a = pyperclip.waitForNewPaste(5)
print(a)
pyperclip.waitForPaste
pyperclip.waitForNewPaste
pyperclip.set_clipboard
pyperclip.determine_clipboard

