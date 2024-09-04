from shapely.geometry import Polygon

def calculate_inertia_x(points):
    n = len(points)
    inertia_x = 0
    for i in range(n):
        x0, y0 = points[i]
        x1, y1 = points[(i + 1) % n]  # Connect the last point to the first

        inertia_x += (y0**2 + y0 * y1 + y1**2) * (x0 * y1 - x1 * y0)

    inertia_x = abs(inertia_x) / 12
    return inertia_x

def SolveAndPrint( points, N, M ):

    print(" SOLVE FOR POLIGON: ")
    for point in points:
        print(f"X: {point[0]}, Y: {point[1]}")
    print(f"\n\n M:{M}kN.m \n N:{N}kN\n\n")

    polygon = Polygon(points)
    area = polygon.area
    centroid = polygon.centroid

    print( f"\n Area {area} cm² \n CgX: {centroid.x} cm \n CgY: {centroid.y} cm \n")

    min_x, min_y, max_x, max_y = polygon.bounds
    width = max_x - min_x
    height = max_y - min_y
    Ys = height - centroid.y
    Yi = centroid.y

    print( f"\n Ys {Ys}cm \n Yi: {Yi}cm \n")

    points = [(x - centroid.x, y - centroid.y) for x, y in points] #Move to CG
    I = calculate_inertia_x(points)

    print( f"\n I {I} cm^4 \n")
    
    Ws = I/Ys
    Wi = I/Yi
    
    Tn = - N/area
    Tms = - (M*100)/Ws
    Tmi = (M*100)/Wi

    print( f"\n Tn {Tn} kN/cm² \n Tms {Tms} kN/cm² \n Tmi {Tmi} kN/cm² \n")

    Tfs = Tn + Tms
    Tfi = Tn + Tmi

    print( f"\n Tfs {Tfs} kN/cm² \n Tfi {Tfi} kN/cm² \n")


Tarefa1 = [
    (0, 0),
    (45, 0),
    (45, 10),
    (31, 15),
    (31, 45),
    (41, 50),
    (41, 65),
    (4, 65),
    (4, 50),
    (14, 45),
    (14, 15),
    (0, 10)
]

SolveAndPrint(Tarefa1, 945, 320)
