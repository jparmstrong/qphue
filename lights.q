/ KDB+/Q based Philip's Hue lights controller
/ Copyright (c) 2016 J.P. Armstrong
/ MIT License

/ start application with:
/ q lights.q -p 8090
/ to use, point browser to:
/ http://user:pass@localhost:8090/?.lights.turnOff[]

/ sets console size
\c 50 180

/ sets bridge apikey, bridge hostname and username/password for kdb web api
.config:()!();
{.config[x`name]:x`val}each("S*";1#csv) 0:`config.csv;

/ loads auth, logging, GET, PUT, & DELETE functions
\l phue.q
\l sunset.q

.lights.getBridgeInfo:{
  :GET"config";
 }

.lights.getLightsInfo:{
  d:GET"lights";
  .lights.info:1!{d:(1#`id)!(1#y);d,`state _x[y]}[d] each key d;
  .lights.state:1!{d:(`id`bri`hue`sat`effect`xy)!y,0n&til 5;d,x[y]`state}[d] each key d;
  :.lights.info lj .lights.state;
 }

.lights.getScenes:{
  d:GET"scenes";
  :1!{d:(1#`id)!(1#y);d,x[y]}[d] each key d;
 }

.lights.getScene:{[x]
  sc:.lights.getScenes[];
  id:string exec id from first `lastupdated xdesc 0!select from sc where name like (x,"*");
  if[""~id;info s:"no such scene: ",x;:0b];
  :id;
 }

.lights.changeScene:{
  info"Changing scene to ",x;
  id:.lights.getScene[x];
  if[0b~id;:()];
  PUT["groups/0/action";enlist[`scene]!enlist[id]];
 }

.lights.deleteScene:{
  info"Deleting scene ",x;
  DELETE["scenes/",x];
 }

.lights.turnOff:{
  info"Turning OFF lights";
  PUT["groups/0/action";(enlist`on)!(enlist 0b)];
 }

.lights.turnOn:{
  info"Turning ON lights";
  PUT["groups/0/action";(enlist`on)!(enlist 1b)];
 }

.lights.setSchedule:{[name;des;dt;scene]
  c:(`address`method`body)!("/api/",.config.apikey,"/groups/0/action";"PUT";(`body;`scene)!(1b;scene));
  p:(`name`description`command`localtime)!(name;des;c;-10_ .h.iso8601 dt);
  POST["schedules";p];
 }

.lights.getSchedule:{
  d:GET"schedules";
  :1!{d:(`id`autodelete)!(y;0n);d,x[y]}[d] each key d;
 }

.lights.setSunsetSchedule:{
  sc:.lights.getSchedule[];
  if[count lt:exec first localtime from sc where name like "QSunset";
    info"Sunset schedule already set for ",lt,". Try again tomorrow!";:()];
  ns:.sunset.getSunset[.z.d]+twilightTime;                                        / plus twilightTime, some people like the lights on before/after sunset
  if[.z.Z>ns;ns:.sunset.getSunset[.z.d+1]+twilightTime];                          / if today's sunset past, get tomorrows
  info"Lights set to turn on ",string[`int$twilightTime]," mins before sunset.";
  scid:.lights.getScene["Entrance"];
  .lights.setSchedule["QSunset";"QPhue Sunset";ns;scid];
 }

info"qphue started!";
.lights.setSunsetSchedule[];

.z.exit:{info"qphue exiting!"}
