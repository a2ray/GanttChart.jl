using PyPlot, Revise, GanttChart, Dates
thisday = Dates.DateTime("22/01/2021", "dd/mm/yyyy")
g = Gantt(;tasknames    = ["foo", "bar"],
           startdate    = [thisday - Dates.Month(1),
                           thisday + Dates.Month(1)],
           timeunits    = "Month",
           timereq      = [2.5, 1],
           completefrac = [0.5, 0.2])
Gantt(g)
