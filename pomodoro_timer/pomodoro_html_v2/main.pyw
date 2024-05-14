import sys
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtCore import QUrl, QObject, pyqtSlot
from PyQt5.QtWebChannel import QWebChannel

class Backend(QObject):
    def __init__(self):
        super().__init__()
        self.work_time = 25 * 60
        self.short_break_time = 5 * 60
        self.long_break_time = 15 * 60

    @pyqtSlot(int, int, int)
    def updateTimes(self, work_time, short_break_time, long_break_time):
        self.work_time = work_time
        self.short_break_time = short_break_time
        self.long_break_time = long_break_time
        print(f"Updated times: Work: {work_time // 60} min, Short Break: {short_break_time // 60} min, Long Break: {long_break_time // 60} min")

class PomodoroApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Pomodoro Timer")
        self.setGeometry(100, 100, 800, 600)

        self.backend = Backend()

        self.browser = QWebEngineView()
        self.browser.setUrl(QUrl("file:///pomodoro.html"))
        self.setCentralWidget(self.browser)

        self.channel = QWebChannel()
        self.channel.registerObject('backend', self.backend)
        self.browser.page().setWebChannel(self.channel)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PomodoroApp()
    window.show()
    sys.exit(app.exec_())
