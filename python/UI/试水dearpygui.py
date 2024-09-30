# 纯cpp自己实现的，感觉nb的
import dearpygui.dearpygui as dpg
import dearpygui.demo as demo
# 我操牛逼https://github.com/hoffstadt/DearPyGui
dpg.create_context()
dpg.create_viewport(title='Custom Title', width=600, height=600)

demo.show_demo()

dpg.setup_dearpygui()
dpg.show_viewport()
dpg.start_dearpygui()
dpg.destroy_context()