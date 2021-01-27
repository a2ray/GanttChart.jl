module GanttChart

using PyPlot, Dates

export Gantt

mutable struct Gantt
    tasknames
    startdate
    timeunits
    timereq
    completed
    people
end

function Gantt(;
               tasknames    = ["foo", "bar"],
               startdate    = [Dates.today() - Dates.Month(1),
                              Dates.today() + Dates.Month(1)],
               timeunits    = "Month",
               timereq      = [2.5, 1],
               completefrac = [0.5, 0.2],
               people       = ["me, you", "she, they"]
              )

      @assert length(tasknames) == length(startdate)
      @assert length(tasknames) == length(timereq)
      @assert length(tasknames) == length(completefrac)
      @assert length(tasknames) == length(people)
      @assert all(0 .<=completefrac .<=1)

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
      timereq = convert.(Dates.Day, timereq*dt)
      Gantt(tasknames, startdate, dt, timereq, Dates.Day.(round.(Int, completefrac.*Dates.value.(timereq))), people)
end

function Gantt(g::Gantt; figsize=(20,4))
    f, ax = plt.subplots(figsize=figsize)
    datemin, datemax = extrema(reduce(vcat, cumsum([g.startdate, g.timereq])))
    ax.barh(1:length(g.tasknames), sum([g.startdate, g.timereq]), color="salmon", label="remaining")
    ax.barh(1:length(g.tasknames), sum([g.startdate, g.completed]), color="limegreen", label="completed")
    ax.barh(1:length(g.tasknames), g.startdate, color="white")
    [ax.annotate(g.people[i], xy=[g.startdate[i],i], color="blue") for i in 1:length(g.startdate)]
    ax.set_xlim(datemin, datemax)
    ax.set_yticks(1:length(g.tasknames))
    ax.set_yticklabels(g.tasknames)
    majorformatter = matplotlib.dates.DateFormatter("%m.%Y")
    minorformatter = matplotlib.dates.DateFormatter("%M")
    minorlocator = matplotlib.dates.MonthLocator(interval=1)
    ax.xaxis.set_major_formatter(majorformatter)
    ax.xaxis.set_minor_locator(minorlocator)
    ax.xaxis.set_minor_locator(minorlocator)
    ax.grid()
    ax.plot([Dates.now(), Dates.now()], [0, length(g.tasknames)+1], "--k")
    ax.set_ylim(0, length(g.tasknames)+1)
    ax.invert_yaxis()
    ax.legend()
    f.tight_layout()
end

end
