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
               timereq      = [2., 1],
               completefrac = [0.5, 0.1]
              )

      @assert length(tasknames) == length(startdate)
      @assert length(tasknames) == length(timereq)
      @assert length(tasknames) == length(completefrac)
      @assert all(0 .<completefrac .<1)

      if timeunits == "Day"
          dt = Day(1)
      elseif timeunits == "Week"
          dt = Week(1)
      elseif timeunits == "Month"
          dt = Day(30)
      elseif timeunits == "Year"
          dt = Day(365)
      else
          @assert 1 == 0 "invalid time, so stopping"
      end
      println("here")
      Gantt(tasknames, startdate, dt, convert.(Dates.Day, timereq*dt), convert.(Dates.Day, round.(completefrac.*timereq)*dt))
end

function Gantt(g::Gantt)
    figure()
    datemin, datemax = extrema(reduce(vcat, cumsum([g.startdate, g.timereq])))
    barh(1:length(g.tasknames), sum([g.startdate, g.timereq]))
    barh(1:length(g.tasknames), sum([g.startdate, g.completed]))
    barh(1:length(g.tasknames), g.startdate, color="white")
    xlim(datemin, datemax)
end

end
