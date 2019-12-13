#!/usr/bin/ruby

<<HERED

WHAT:
-] Cecks if port 9200 is acrive is listening in localhost
-] If its not forward port 9200 from elavi to here.

HERED

out = `netstat -nlt4`
if out.match(/127.0.0.1:9200/) == nil 
  system("logger 'Restarting forward port 9200 for Elasticsearch.'")
  system('ssh -N -L 9200:localhost:9200 p@elavi &')
end
