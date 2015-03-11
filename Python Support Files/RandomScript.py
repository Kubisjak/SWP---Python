# Import Packages
from Tkinter import *

# Create root window
root = Tk()

# Modify root window
root.title("Game of Life - GUI")
root.geometry("200x100")

# Create Labels
app = Frame(root)
app.grid()

label = Label(app, text="This is Label")
label.grid()

button = Button(app, text="This is a button")
button.grid()

button2 = Button(app)
button2.grid()
button2.configure(text="This is also a button")

# Start the event loop
root.mainloop()
