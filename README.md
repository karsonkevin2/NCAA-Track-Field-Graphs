# NCAA-Track-Field-Graphs

In the year 2020 several new models of running spikes released which featured new technologies and 
improvements upon existing technologies. Due to the unprecedented circumstances of the COVID-19 outbreak,
many runners did not have the opportunity to compete in the 2020 track and field or cross country seasons.
Come the indoor and outdoor 2021 seasons, the NCAA Division I saw many record breaking performances.

Some people have speculated that these "super-shoes" are directly responsible for these improved performances.
Others have noted special circumstances. The NCAA allowed athletes to compete an additional season outside of 
the normal eligibility period. This led to an influx of 5th and 6th years returning who would not have otherwise.
Since there was no 2020 season, athletes had the opportunity to devote more time to training and improvement.
Initially, the regional qualifying fields were reduced to 32 people per event, down from 48. This increased pressure
on top performers to notch a good time. 

The actual charts show somewhat of a compelling story. In the 100m, 200m, 400m, and 800m the performances this year were roughly uneffected. 
It is typical for times to drop slightly year to year as materials and equipment advance and training becomes smarter.
But, the 1500, 5000m, and 10000m show a clear outlier. 2021 is clearly better than any prior year. There are more people running much faster. 
These graphs corroborate to show consistent improvements of approximately 2-5 seconds. The new Nike Dragonfly
spikes are advertisted as intended for the 1500m-10000m, so these performances could possibly be attributed 
directly to the spikes.

## Graphs
![100m](/Images/100.svg)
![200m](/Images/200.svg)
![400m](/Images/400.svg)
![800m](/Images/800.svg)
![1500m](/Images/1500.svg)
![5000m](/Images/5000.svg)
![10000m](/Images/10000.svg)

## Other notes
These charts have a few other noteworthy features. The first thing to notice is the characteristic shape. At the fastest extreme, there is a region
of sharp slope, where the athletes are much better than other athletes. Logically, this doesn't make sense to me. I would expect the fastest times to be 
somewhat crowded as people approach their physical limitations. This may show that these athletes are closer to hitting their limits, while the 
homogenous appearance in the saturation is due to a variety of athletes who try their hardest, those who somewhat try, and those who waste their potential.

In the 10,000m graph, we can observe a region at the tail end where the slope starts to increase again. This is because
the region is no longer saturated. Not everyone runs a track 10k in the NCAA and their are only a limited number of competitors. 
Someone has to be last place. What this means is that we would expect the tail of the graph to increase slope significantly to account
for outliers who raced one time and had a bad race.

I did not perform any analysis for women's time, field events, or hurdles. The code would need to be slightly adjusted for field events. 
I expect women's times to follow roughly the same trend, but will have a taller unsaturation region at the front, since the best women
are much better than average women. I would also expect the slope of the saturation region to be steeper, as there is a wider variance in 
women's abilities than men's.

For field events I think the front end marks will be less consistent than the running events. Many field events have athletes that could
also perform well in other sports. For the throws, these athletes may also be well suited to football. Jumpers may be well suited for basketball.
Since these sports have more prestige for many people, they may pursue those sports rather than track and field. This means that some of the best
athletes do not end up in the NCAA system. Because of this, one year there may be a great mark and the next year, the outlier might be on the football team.
