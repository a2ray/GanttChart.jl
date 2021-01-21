using PyPlot, Revise, GanttChart

fig, ax = plt.subplots()
ax.broken_barh([(110, 30), (150, 10)], (10, 9), facecolors="tab:blue")
ax.broken_barh([(10, 50), (100, 20), (130, 10)], (20, 9),
               facecolors=("tab:orange", "tab:green", "tab:red"))
ax.set_ylim(5, 35)
ax.set_xlim(0, 200)
ax.set_xlabel("seconds since start")
ax.set_yticks([15, 25])
ax.set_yticklabels(["Bill", "Jim"])
ax.grid(true)

plt.show()
