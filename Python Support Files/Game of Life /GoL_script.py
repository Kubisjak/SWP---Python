# -*- coding: utf-8 -*-
"""
Created on Tue Dec 30 19:25:14 2014

@author: Kubisjak
"""
# Game of Life 

# Rules (source: Wikipedia) :
# 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# 2. Any live cell with two or three live neighbours lives on to the next generation.
# 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


import time
import math
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import convolve2d

class Game(object):
    
    def __init__(self,size):
        
        self.size = size
        if self.size <= 10 :
            print "Size of the board must be greater than 10"
            pass
        if self.size % 2 != 0:
            self.size += 1
        
        self.board = np.zeros(shape=(self.size, self.size))
        self.create_buffer()
        
    def random_start(self):

        r = np.random.random((self.size-10, self.size-10))
        r[r>=0.75] = 1
        r[r<0.75] = 0
        self.board[5:self.size-5, 5:self.size-5] = r
        
        self.display_board()
                
    def display_board(self):
        
        board_image = np.zeros((self.size,self.size,3))
        board_image[:,:,0] = self.board[:,:] 
        board_image[:,:,1] = self.board[:,:] 
        board_image[:,:,2] = self.board[:,:]

        fig = plt.figure()
        current_board = plt.imshow(board_image)
        current_board.set_interpolation("nearest")      
        plt.show()       
        raw_input("Press Enter to continue")
        
    # Static figures
        
    def create_buffer(self):
        self.static1 = np.ones((2,2))
        
        self.static2 = np.array([[0, 1, 1, 0], [1, 0, 0, 1], [0, 1, 1, 0]])
        
        self.static3 = np.array([[0, 1, 1, 0],[1, 0, 0, 1],[0, 1, 0, 1],[0, 0, 1, 0]])
        
        self.static4 = np.array([[1, 1, 0], [1, 0, 1], [0, 1, 0]])
    
    # Oscilators
    
        self.blinker = np.array([[1, 1, 1]])
        
        self.toad = np.array([[1, 1, 1, 0], [0, 1, 1, 1]])
        
        self.glider =  np.array([[1, 0, 0], [0, 1, 1], [1, 1, 0]])
        
    # Others        
        
        self.diehard = np.array([
        [0, 0, 0, 0, 0, 0, 1, 0],
        [1, 1, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 1, 1, 1]])

        self.boat = np.array([
        [1, 1, 0],
        [1, 0, 1],
        [0, 1, 0]])

        self.r_pentomino = np.array([
        [0, 1, 1],
        [1, 1, 0],
        [0, 1, 0]])

        self.beacon = np.array([
        [0, 0, 1, 1],
        [0, 0, 1, 1],
        [1, 1, 0, 0],
        [1, 1, 0, 0]])

        self.acorn = np.array([
        [0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [1, 1, 0, 0, 1, 1, 1]])

        self.spaceship = np.array([
        [0, 0, 1, 1, 0],
        [1, 1, 0, 1, 1],
        [1, 1, 1, 1, 0],
        [0, 1, 1, 0, 0]])

        self.block_switch_engine = np.array([
        [0, 0, 0, 0, 0, 0, 1, 0], 
        [0, 0, 0, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 1, 0, 1, 0], 
        [0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0],
        [1, 0, 1, 0, 0, 0, 0, 0]])
 

    def put_in_center(self, cell):
        coordinate1 = math.floor((self.size - cell.shape[0])/2)
        coordinate2 = math.floor((self.size - cell.shape[1])/2)
        
        coordinate1end = self.size - coordinate1
        coordinate2end = self.size - coordinate2
                
        if cell.shape[0] % 2 != 0:
            coordinate1end -= 1                     
        if cell.shape[1] % 2 != 0:
            coordinate2end -= 1

        self.board[coordinate1:coordinate1end, coordinate2:coordinate2end] = cell
        
    def count_neighbours(self):
        
        # Great cheat - calculate the number of neighbours using convolution 
        # matrix, substract self.board = we do not want to count all cells, but only
        # the neighbours
        Ncount = convolve2d(self.board, np.ones((3, 3)), 
                                      mode='same', boundary='wrap') - self.board
                                      
        self.neighbours_count = np.array(Ncount)   
        # print self.neighbours_count
        
        # return (neighbours_count == 3) | (self.board & (neighbours_count == 2))    
        
    def make_step(self):
        # We want to check the actual board and not the board that exists after eg. step 2.
        self.board_new = np.zeros(shape=(self.size, self.size))
        
        # 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        mask = (self.board == 1) & (self.neighbours_count < 2)
        self.board_new[mask] = 0
    
        # 2. Any live cell with two or three live neighbours lives on to the next generation.
        mask1 = (self.board == 1) & (self.neighbours_count == 2)
        self.board_new[mask1] = 1
        mask2 = (self.board == 1) & (self.neighbours_count == 3)
        self.board_new[mask2] = 1        
        
        # 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
        mask = (self.board == 1) & (self.neighbours_count > 3)
        self.board_new[mask] = 0

        # 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        mask = (self.board == 0) & (self.neighbours_count == 3)
        self.board_new[mask] = 1

        self.board = self.board_new


# Set Parameters:

ticks = 5
size = 20
fps = 0.5

             
my_game = Game(size)
my_game.put_in_center(my_game.glider)
my_game.display_board()

for i in range(0,ticks):
    
    #
    time.sleep(fps) # delays for 5 seconds             
    my_game.count_neighbours()    
    my_game.make_step()
    my_game.display_board()


