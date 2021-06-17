n = 500
print("Iniciando teste em PYTHON")
x = n
z = 0
for i in range(n):
    for j in range(n):
        for k in range(n):
            y = x
            x *= x
            x = x / y
            z += 1

print(x, "\nEm", z, "ciclos")
input("pausado")
