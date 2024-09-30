from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
# 我操感觉贼牛逼
# https://github.com/kivy/kivy
# https://kivy.org/doc/stable/gettingstarted/installation.html
class CounterApp(App):
    def build(self):
        self.count = 0
        self.label = Button(text=str(self.count))
        self.label.bind(on_press=self.increment_count)
        layout = BoxLayout()
        layout.add_widget(self.label)
        return layout

    def increment_count(self, instance):
        self.count += 1
        self.label.text = str(self.count)

if __name__ == '__main__':
    CounterApp().run()