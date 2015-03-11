# -*- coding: utf-8 -*-
"""
Created on Sun Dec 28 23:16:46 2014

@author: Kubisjak
"""

# OOP GUI Python
from Tkinter import *

class Application(Frame):
    button_clicks = 0

    def __init__(self,master):
        Frame.__init__(self,master)
        self.grid()
        self.create_widgets()
        
    def create_widgets(self):
        self.button = Button(self)
        self.button.grid()
        self.button["text"] = "Total clics: 0"
        self.button["command"] = self.update_count
        
    def update_count(self):
        self.button_clicks += 1
        self.button.configure(text="Total clics: " + str(self.button_clicks))
        
# Set Frame
root = Tk()
root.title("GUI Learning Process")
root.geometry("200x200")

app = Application(root)

root.mainloop()