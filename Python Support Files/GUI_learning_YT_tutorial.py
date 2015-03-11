# -*- coding: utf-8 -*-
"""
Created on Tue Dec 30 09:37:29 2014

@author: Kubisjak
"""

# GUI learning part II
# tutorial : https://www.youtube.com/watch?v=A0gaXfM1UN0&index=2&list=PLQVvvaa0QuDclKx-QpC9wntnURXVJqLyk

import Tkinter as tk
import ttk

# matplotlib import
import matplotlib
# Back end of matplotlib ?
matplotlib.use("TkAgg")
# Module used for printing graphs to canvas
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
# To use style - update matplotlib to 1.4
# from matplotlib import style as style
import matplotlib.animation as animation

# Fonts and styles
LARGE_FONT = ("Verdana", 12)
# style.use("ggplot")
class SeaOfBTCapp(tk.Tk):
    
    # *args - passing through variables
    # *kwargs - passing through dictionaries
    def __init__(self, *args, **kwargs):
        
        tk.Tk.__init__(self, *args, **kwargs)
        
        tk.Tk.wm_title(self, "Sea of BTC Client")        
        
        container = tk.Frame(self)
        # .pack similar to .grid()
        container.pack(side="top", fill="both", expand=True)
        container.grid_rowconfigure(0, weight =1)
        container.grid_columnconfigure(0, weight =1)
        
        # Empty dictionary, where we keep frames
        self.frames = {} 
        
        for F in (StartPage, PageOne, PageTwo, PageThree):
        
            frame = F(container, self)
            self.frames[F] = frame
            # sticky - alighnment + stretch
            frame.grid(row=0,column=0, sticky = "nsew")
        
        self.show_frame(StartPage)
        
    def show_frame(self,controller):
        
        frame = self.frames[controller]
        # Raise the controler frame into the front
        frame.tkraise()

        
class StartPage(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        label = tk.Label(self, text="Start Page", font =LARGE_FONT)
        label.pack(pady=10,padx=10)
        
        # lambda - calls function when needed only ? 
        button1 = ttk.Button(self, text = "Go To Page 1", 
                            command = lambda: controller.show_frame(PageOne))
        button1.pack()
        
        button2 = ttk.Button(self, text = "Go To Page 2", 
                            command = lambda: controller.show_frame(PageTwo))
        button2.pack()
        
        button3 = ttk.Button(self, text = "Go To Page 3", 
                            command = lambda: controller.show_frame(PageThree))
        button3.pack()
        
class PageOne(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        
        label = tk.Label(self, text="Page One", font =LARGE_FONT)
        label.pack(pady=10,padx=10)
        
        button1 = ttk.Button(self, text = "Back To Home", 
                            command = lambda: controller.show_frame(StartPage))
        button1.pack()
        button2 = ttk.Button(self, text = "Go To Page 2", 
                            command = lambda: controller.show_frame(PageTwo))
        button2.pack()
        
        button3 = ttk.Button(self, text = "Go To Page 3", 
                            command = lambda: controller.show_frame(PageThree))
        button3.pack()
                
class PageTwo(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        
        label = tk.Label(self, text="Page Two", font =LARGE_FONT)
        label.pack(pady=10,padx=10)
        
        button1 = ttk.Button(self, text = "Back To Home", 
                            command = lambda: controller.show_frame(StartPage))
        button1.pack()
        
        button2 = ttk.Button(self, text = "Back To Page 1", 
                            command = lambda: controller.show_frame(PageOne))
        button2.pack()
        
        button3 = ttk.Button(self, text = "Go To Page 3", 
                            command = lambda: controller.show_frame(PageThree))
        button3.pack()    
        
class PageThree(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        
        label = tk.Label(self, text="Graph Page", font =LARGE_FONT)
        label.pack(pady=10,padx=10)
        
        button1 = ttk.Button(self, text = "Back To Home", 
                            command = lambda: controller.show_frame(StartPage))
        button1.pack()
        
        button2 = ttk.Button(self, text = "Back To Page 1", 
                            command = lambda: controller.show_frame(PageOne))
        button2.pack()
        
        button3 = ttk.Button(self, text = "Back To Page 2", 
                            command = lambda: controller.show_frame(PageTwo))
        button3.pack()
        
        f = Figure(figsize=(5,5), dpi = 100)
        a = f.add_subplot(111)
        a.plot([1,2,3,4,5,6,7],[4,2,1,5,7,6,3])
        
        # alternativa pre plt.show() - chceme to plotit na canvas
        # pridavame aj toolbar
        
        canvas = FigureCanvasTkAgg(f, self)
        canvas.show()       
        toolbar = NavigationToolbar2TkAgg(canvas, self)
        toolbar.update()
        canvas._tkcanvas.pack(side = tk.TOP, fill = tk.BOTH, expand = True)
        canvas.get_tk_widget().pack(side = tk.TOP, fill = tk.BOTH, expand = True)
                
                
app = SeaOfBTCapp()
app.mainloop()