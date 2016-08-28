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

.lights.changeScene:{
  info"Changing scene to ",x;
  sc:.lights.getScenes[];
  id:string exec id from first `locked`lastupdated xdesc 0!select from sc where name like (x,"*");
  if[""~id;info s:"no such scene: ",x;:s];
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
