
/ from http://code.kx.com/wiki/Cookbook/Timezones
tzinfo:get`:tzinfo;
lg:{[tz;z] exec gmtDateTime+adjustment from aj[`timezoneID`gmtDateTime;([]timezoneID:tz;gmtDateTime:z);tzinfo]};
gl:{[tz;z] exec localDateTime-adjustment from aj[`timezoneID`localDateTime;([]timezoneID:tz;localDateTime:z);tzinfo]};
ttz:{[d;s;z]lg[d;gl[s;z]]};

/ data from http://sunrise-sunset.org/
host:"api.sunrise-sunset.org"
lat:40.6944
lon:-73.9906
tz:`$"America/New_York"
et:`minute$30

/ returns sunset in local time
.sunset.getSunset:{[x]
  dt:ssr[string x;".";"-"];
  p :"GET /json?lat=",string[lat],"&lng=",string[lon],"&date=",dt,"&formatted=0 HTTP/1.1","\r\n";
  p,:"Host: api.sunrise-sunset.org","\r\n\r\n";

  r:(`$":http://",host) p;
  r:.j.k ("\r\n\r\n" vs r)[1];
  r:r`results;
  r:first lg[(),tz;(),"P"$-6 _r`sunset];

  info "Sunset is at ",string[r];
  :r
 }

/ if it's past 8:30pm, get tomorrows sunset
.sunset.nextSunset:.sunset.getSunset[.z.d+$[.z.T>20:30;1;0]];

.z.ts:{
  if[.z.P>.sunset.nextSunset-et;
    info"Sunset! ",string[.sunset.nextSunset];
    / if lights already on, don't change scene
    if[not max (0!.lights.getLightsInfo[])`on;
      .lights.changeScene["Entrance"];
    ];
    .sunset.nextSunset:.sunset.getSunset[.z.d+1];
  ];
 };

\t 100

