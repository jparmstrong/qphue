/ to be loaded by lights.q, .config needs to be set prior

info:{-1"[",string[.z.Z],"][info] ",x;};

debug:{if[system"e";-1"[",string[.z.Z],"][debug] ",x];};

.z.pw:{(.config.user~string x)&.config.pass~y};

GET:{[x]
	r:(`$":http://",.config.host) p:"GET /api/",.config.apikey,"/",x,"\r\n\r\n";
	debug p,r;
	:.j.k ("\r\n\r\n" vs r)[1];
 }

PUT:{[x;y]
	p:"PUT /api/",.config.apikey,"/",x,"\r\n",
	"Content-Length: ",string[count s],"\r\n",
	"Host: ",.config.host,"\r\n\r\n",s:.j.j y;
	r:(`$":http://",.config.host) p;
	debug p,"\r\n",r;
	:r;
 }

DELETE:{[x]
	p:"DELETE /api/",.config.apikey,"/",x,"\r\n";
	r:(`$":http://",.config.host) p;
	debug p,r;
	:r;
 }
