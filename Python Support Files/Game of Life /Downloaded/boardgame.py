
def indexing(blocks, squares_x):
    check = []
    objects = squares_x ** 2

    for index in range(0, len(blocks)):

        step = index - squares_x -1

        for num in range(0, 3):

            count = 0

            while count < 3:

                current = count + step

                if current != index and current >= 0 and current < objects:

                    check.append(current)

                count += 1

            step += squares_x

        cleaning(blocks, squares_x, check, index)

        check = []

def cleaning(blocks, squares_x, check, index):

    if (index % squares_x) == 0:
        num = len(check)

        while num > 0:
            num -= 1

            if (check[num] +1) % squares_x == 0 :

                del(check[num])

    elif ((index +1) % squares_x) == 0:
        num = len(check)

        while num > 0:
            num -= 1

            if (check[num]) % squares_x == 0 :

                del(check[num])
  
    blocks[index].append(check)
        
    check = []


                
