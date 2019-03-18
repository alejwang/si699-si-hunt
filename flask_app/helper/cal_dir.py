import math

def c(dis_x, dis_y):
  if (dis_y == 0) and (dis_x > 0):
    return 90
  elif (dis_y == 0) and (dis_x < 0):
    return 270
  else:
    dir_180 = math.atan(dis_x / dis_y) / math.pi * 180
    direction_2d = int(dir_180)
    if (dis_y < 0):
        direction_2d += 180
    if direction_2d < 0:
        direction_2d += 360
    return direction_2d
  
print(c(0,1), c(0.1,1), c(1,1), c(1,0.5), c(1,0), c(1,-0.1), c(1,-1), c(0,-1), c(-1,-1), c(-1,0), c(-1, 1))
