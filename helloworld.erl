% hello world program
-module(helloworld).
-export([start/0]).
-record(rule, {from, to, port, action}).

printRule(Rule) -> 
   io:fwrite("iptables -A INPUT -s ~s -d ~s --dport ~p -j ~s\n", [Rule#rule.from, Rule#rule.to, Rule#rule.port, Rule#rule.action]).

printRules(Rules) -> 
   lists:foreach(fun(Rule) -> printRule(Rule) end, Rules).

start() -> 
   Rules = [
      #rule{from="127.0.0.1/24", to="127.0.0.2/24", port=3773, action="ACCEPT"},
      #rule{from="127.0.0.3/24", to="127.0.0.4/24", port=3774, action="DROP"}
   ],
   printRules(Rules).