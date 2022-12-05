import random
import subprocess
import sys

# define the constants ROWS, COLUMNS and TYPES with default values
ROWS, COLUMNS, TYPES = [int(x) for x in sys.argv[1:]]

# generate a random SameGame board with ROWS rows and COLUMNS columns
board = [[random.randint(0, TYPES - 1) for _ in range(COLUMNS)] for _ in range(ROWS)]

# find a group of blocks in the board
group = None
for r in range(ROWS):
    for c in range(COLUMNS):
        # check if there is a block at position (r, c)
        if board[r][c] != -1:
            # check if the block belongs to a group having at least two elements
            if group is None or group[0] != board[r][c]:
                # if the block is not in a group, start a new group with this block
                group = [board[r][c], [(r, c)]]
            else:
                # if the block is already in a group, add it to the group
                group[1].append((r, c))
        # if the group has at least two elements, stop searching
        if group is not None and len(group[1]) >= 2:
            break
    # if the group has at least two elements, stop searching
    if group is not None and len(group[1]) >= 2:
        break

# if a group was found, randomly replace the column where the selected point is with the group's symbol
if group is not None:
    # choose a random number between 0 and 100
    n = random.randint(0, 100)
    # if the random number is less than or equal to 45, replace the column with the group's symbol
    if n <= 45:
        # get the column where the selected point is
        col = group[1][0][1]
        # replace the column with the group's symbol
        for r in range(ROWS):
            board[r][col] = group[0]

# write the board to the input of the program
input_str = '\n'.join(''.join(str(x) for x in row) for row in board) + '\n'
input_str = input_str.encode("utf-8")
# run the program and get the output
cmd = f"valgrind --leak-check=full -q --error-exitcode=1 ./program {group[1][0][0]} {group[1][0][1]}"
output_str = subprocess.check_output(cmd.split(" "), input=input_str)
print(output_str.decode('utf-8'))
