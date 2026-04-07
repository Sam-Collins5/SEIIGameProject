import sys
import random
import datetime
from threading import Timer
from PyQt6.QtCore import *
from PyQt6.QtGui import *
from PyQt6.QtWidgets import *

global questions; questions: dict
global filePath; filePath: str
global fileSaved; fileSaved = True
QUESTION_STRIDE = 8

global setPathTab
global addQuestionTab
global viewQuestionsTab
global saveQuestionsTab

class Question:
    Id: str
    Type: str
    Text: str
    ChoiceA: str
    ChoiceB: str
    ChoiceC: str
    ChoiceD: str

    def to_text(self) -> str:
        content = f"{self.Id}\n"
        content += f"{self.Type}\n"
        content += f"{self.Text}\n"
        content += f"{self.ChoiceA}\n"
        content += f"{self.ChoiceB}\n"
        content += f"{self.ChoiceC}\n"
        content += f"{self.ChoiceD}\n"
        content += "----\n"
        return content


class SetPathTab(QWidget):
    def __init__(self):
        super().__init__()

        fileDialogButton = QPushButton()
        fileDialogButton.setText("Select Question File")
        fileDialogButton.clicked.connect(self.open_dialog)

        self.pathLabel = QLabel(f"Path: {filePath}")

        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.pathLabel)
        mainLayout.addWidget(fileDialogButton)
        self.setLayout(mainLayout)
    

    @pyqtSlot()
    def open_dialog(self):
        global filePath
        f = QFileDialog.getOpenFileName(
            self,
            "Open File",
            "${HOME}",
            "All Files (*)"
        )
        filePath = f[0]
        self.pathLabel.setText(f"Path: {filePath}")
        read_questions(filePath)
        viewQuestionsTab.refresh()


class AddQuestionTab(QWidget):
    def __init__(self):
        super().__init__()
        global questions
        
        pixmapi = QStyle.StandardPixmap.SP_DialogApplyButton
        icon = self.style().standardIcon(pixmapi)

        self.infoButton = QPushButton("Question added!")
        self.infoButton.setIcon(icon)
        self.infoButton.hide()

        infoLabel = QLabel("Choice A is the correct choice")

        typeLabel = QLabel("Enter Question Type (All, CS, IT, etc.):")
        self.typeEdit = QPlainTextEdit()

        questionLabel = QLabel("Enter Question Text:")
        self.questionEdit = QPlainTextEdit()

        choiceALabel = QLabel("Enter Choice A:")
        self.choiceAEdit = QPlainTextEdit()

        choiceBLabel = QLabel("Enter Choice B:")
        self.choiceBEdit = QPlainTextEdit()

        choiceCLabel = QLabel("Enter Choice C:")
        self.choiceCEdit = QPlainTextEdit()

        choiceDLabel = QLabel("Enter Choice D:")
        self.choiceDEdit = QPlainTextEdit()

        self.addButton = QPushButton("Add Question")
        self.addButton.clicked.connect(self.submit_question)

        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.infoButton)
        mainLayout.addWidget(infoLabel)
        mainLayout.addWidget(typeLabel)
        mainLayout.addWidget(self.typeEdit)
        mainLayout.addWidget(questionLabel)
        mainLayout.addWidget(self.questionEdit)
        mainLayout.addWidget(choiceALabel)
        mainLayout.addWidget(self.choiceAEdit)
        mainLayout.addWidget(choiceBLabel)
        mainLayout.addWidget(self.choiceBEdit)
        mainLayout.addWidget(choiceCLabel)
        mainLayout.addWidget(self.choiceCEdit)
        mainLayout.addWidget(choiceDLabel)
        mainLayout.addWidget(self.choiceDEdit)
        mainLayout.addWidget(self.addButton)
        self.setLayout(mainLayout)
    

    def submit_question(self):
        global fileSaved
        question = Question()
        question.Type = self.typeEdit.toPlainText()

        question.Text = self.questionEdit.toPlainText()

        question.ChoiceA = self.choiceAEdit.toPlainText()
        question.ChoiceB = self.choiceBEdit.toPlainText()
        question.ChoiceC = self.choiceCEdit.toPlainText()
        question.ChoiceD = self.choiceDEdit.toPlainText()
        
        question.Id = random.getrandbits(32)
        questions[question.Id] = question

        self.typeEdit.clear()
        self.questionEdit.clear()
        self.choiceAEdit.clear()
        self.choiceBEdit.clear()
        self.choiceCEdit.clear()
        self.choiceDEdit.clear()

        self.infoButton.show()
        t = Timer(2.4, self.hide_notification)
        t.start()
        
        viewQuestionsTab.refresh()
        fileSaved = False
    

    def hide_notification(self):
        self.infoButton.hide()


class ViewQuestionsTab(QWidget):
    def __init__(self):
        super().__init__()
        global questions

        self.scroll = QScrollArea()
        self.scroll.setVerticalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOn)
        self.scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOff)
        self.scroll.setWidgetResizable(True)

        self.mainLayout = QVBoxLayout()

        self.textLabel = QLabel("No questions loaded")
        self.scroll.setWidget(self.textLabel)

        self.mainLayout.addWidget(self.scroll)
        self.setLayout(self.mainLayout)
    

    def refresh(self):
        content = ""
        for k in questions.keys():
            question = questions[k]
            content += f"ID:\t\t{question.Id}\n"
            content += f"Type:\t\t{question.Type}\n"
            content += f"Text:\t\t{question.Text}\n"
            content += f"ChoiceA:\t{question.ChoiceA}\n"
            content += f"ChoiceB:\t{question.ChoiceB}\n"
            content += f"ChoiceC:\t{question.ChoiceC}\n"
            content += f"ChoiceD:\t{question.ChoiceD}\n"
            content += "----------\n"
        self.textLabel.setText(content)


class SaveQuestionsTab(QWidget):
    def __init__(self):
        super().__init__()
        global questions

        self.mainLayout = QVBoxLayout()

        self.infoLabel = QLabel("")
        self.saveButton = QPushButton("Save Questions")

        self.saveButton.clicked.connect(self.press_save)
        self.mainLayout.addWidget(self.infoLabel)
        self.mainLayout.addWidget(self.saveButton)
        self.setLayout(self.mainLayout)
    

    def press_save(self):
        global fileSaved
        if save_questions(filePath):
            self.infoLabel.setText(f"Questions saved to {filePath} at {datetime.datetime.now()}")
            fileSaved = True
        else:
            self.infoLabel.setText(f"Questions not saved, something went wrong.")


class SaveDialog(QDialog):
    def __init__(self):
        super().__init__()

        self.finished = False

        self.setWindowTitle("File not saved")

        QBtn = (
            QDialogButtonBox.StandardButton.Save | QDialogButtonBox.StandardButton.Cancel
        )

        self.buttonBox = QDialogButtonBox(QBtn)

        self.buttonBox.accepted.connect(self.accept)
        self.buttonBox.rejected.connect(self.reject)

        self.mainLayout = QVBoxLayout()
        self.mainLayout.addWidget(QLabel("The question file has not been saved. Would you like to save it before exiting?"))
        self.mainLayout.addWidget(self.buttonBox)
        self.setLayout(self.mainLayout)

    
    def accept(self):
        save_questions(filePath)
        self.finished = True
        self.hide()
    

    def reject(self):
        self.finished = True
        self.hide()


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Question Maker")

        tabs = QTabWidget()
        tabs.setTabPosition(QTabWidget.TabPosition.North)
        tabs.setMovable(True)

        tabs.addTab(setPathTab, "Set Path")
        tabs.addTab(addQuestionTab, "Add Question")
        tabs.addTab(viewQuestionsTab, "View Questions")
        tabs.addTab(saveQuestionsTab, "Save Questions")

        self.saveDLG = SaveDialog()

        self.setCentralWidget(tabs)


    def closeEvent(self, event):
        if not fileSaved:
            self.saveDLG.exec()
        if self.saveDLG.finished:
            event.accept()


def save_questions(filepath: str) -> bool:
    global questions
    file = open(filepath, "w")
    content = ""
    for k in questions.keys():
        content += questions[k].to_text()
    if content == "":
        print("Something went wrong. File not saved.")
        return False
    file.write(content)
    return True


def read_questions(filepath: str):
    global questions
    file = open(filepath)
    lines = file.readlines()
    for i, l in enumerate(lines):
        lines[i] = lines[i].strip()

        if i % QUESTION_STRIDE != 0:
            continue
        if lines[i] == "----":
            continue
        if i == len(lines) - 1 and lines[i] == "":
            break

        q = Question()
        q.Id = lines[i]
        q.Type = lines[i+1].strip()

        q.Text = lines[i+2].strip()

        q.ChoiceA = lines[i+3].strip()
        q.ChoiceB = lines[i+4].strip()
        q.ChoiceC = lines[i+5].strip()
        q.ChoiceD = lines[i+6].strip()

        questions[lines[i]] = q


def main():
    global questions
    global filePath

    global setPathTab
    global addQuestionTab
    global viewQuestionsTab
    global saveQuestionsTab
    questions = dict()
    filePath = "Questions.txt"

    app = QApplication(sys.argv)

    read_questions(filePath)
    setPathTab = SetPathTab()
    addQuestionTab = AddQuestionTab()
    viewQuestionsTab = ViewQuestionsTab()
    saveQuestionsTab = SaveQuestionsTab()

    viewQuestionsTab.refresh()

    window = MainWindow()
    window.show()

    window.resize(640, 360)

    app.exec()


main()
