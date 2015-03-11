# -*- coding: utf-8 -*-
"""
Created on Tue Dec 30 19:25:14 2014

@author: Kubisjak
"""
import numpy as np
import matplotlib.pyplot as plt

class Game(object):
    
    def __init__(self,size):
        self.size = size
        
    def random_start(self):
        if self.size <= 10 :
            print "Size of the board must be greater than 10"
            pass
        
        self.board = np.zeros(shape=(self.size, self.size), dtype="int8")
        r = np.random.random((self.size-10, self.size-10))
        r[r>0.75] = 1
        self.board[5:self.size-5, 5:self.size-5] = r
        
        self.display_board(self.board)
                
    def display_board(self, board):
        board_image = np.zeros((self.size,self.size,3))
        board_image[:,:,0] = board[:,:] 
        board_image[:,:,1] = board[:,:] 
        board_image[:,:,2] = board[:,:]
        
        self.current_board = plt.imshow(board_image)
        self.current_board.set_interpolation("nearest")        
        
    # Static figures
        
    def create_static1(self):
        self.static1 = np.ones((2,2))
        
    def create_static2(self):
        self.static2 = [[0, 1, 1, 0], [1, 0, 0, 1], [0, 1, 1, 0]]
        
    def create_static3(self):
        self.static3 = [[0, 1, 1, 0],[1, 0, 0, 1],[0, 1, 0, 1],[0, 0, 1, 0]]
        
    def create_static4(self):
        self.static4 = [[1, 1, 0], [1, 0, 1], [0, 1, 0]]
    
    # Oscilators
    
    def create_blinker(self):
        self.oscilator1 = [1, 1, 1]
        
    def create_toad(self):
        self.oscilator2 = [[1, 1, 1, 0], [0, 1, 1, 1]]               
        
    def create_glider(self):
        self.glider =  [[1, 0, 0], [0, 1, 1], [1, 1, 0]]

        
my_game = Game(20)
my_game.random_start()