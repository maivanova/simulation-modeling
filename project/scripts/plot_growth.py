import csv
import matplotlib.pyplot as plt

t = []
u = []

with open("data/exponential_growth.csv", newline="") as f:
    reader = csv.DictReader(f)
    for row in reader:
        t.append(float(row["t"]))
        u.append(float(row["u"]))

plt.plot(t, u, label="u(t)")
plt.xlabel("Время t")
plt.ylabel("u(t)")
plt.title("Экспоненциальный рост, α = 0.3")
plt.legend()
plt.grid(True)

plt.savefig("plots/exponential_growth.png", dpi=150)
print("График сохранён: plots/exponential_growth.png")
