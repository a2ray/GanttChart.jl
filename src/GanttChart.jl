module GanttChart

using PyPlot, Dates

export Gantt

mutable struct Gantt
    tasknames
    startdate
    timeunits
    timereq
    completed
end

function Gantt(;
               tasknames    = ["foo", "bar"],
               startdate    = [Dates.today() - Dates.Month(1),
                              Dates.today() + Dates.Month(1)],
               timeunits    = "Month",
               timereq      = [2.5, 1],
               completefrac = [0.5, 0.2]
              )

      @assert length(tasknames) == length(startdate)
      @assert length(tasknames) == length(timereq)
      @assert length(tasknames) == length(completefrac)
      @assert all(0 .<completefrac .<1)

      if timeunits == "Day"
          dt = Day(1)
      elseif timeunits == "Week"
          dt = Day(7)
      elseif timeunits == "Month"
          dt = Day(30)
      elseif timeunits == "Year"
          dt = Day(365)
      else
          @assert 1 == 0 "invalid time, so stopping"
      end
      println("here")
      timereq = convert.(Dates.Day, timereq*dt)
      completed = convert.(Dates.Day, round(completefrac.*timereq))
      Gantt(tasknames, startdate, dt, timereq, completed)
end

function Gantt(g::Gantt; figsize=(8,4))
    f, ax = plt.subplots(figsize=figsize)
    datemin, datemax = extrema(reduce(vcat, cumsum([g.startdate, g.timereq])))
    ax.barh(1:length(g.tasknames), sum([g.startdate, g.timereq]), color="red", label="remaining")
    ax.barh(1:length(g.tasknames), sum([g.startdate, g.completed]), color="green", label="completed")
    ax.barh(1:length(g.tasknames), g.startdate, color="white")
    ax.set_xlim(datemin, datemax)
    ax.set_yticks(1:length(g.tasknames))
    ax.set_yticklabels(g.tasknames)
    majorformatter = matplotlib.dates.DateFormatter("%m.%Y")
    ax.xaxis.set_major_formatter(majorformatter)
    ax.grid(axis="x")
    ax.invert_yaxis()
    ax.legend()
    f.tight_layout()
end

end
