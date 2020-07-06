% hello world program
-module(helloworld).
-export([start/0]).
-record(rule, {name, from, to, port, action, proto="tcp"}).

printRule(Rule) -> 
   io:fwrite("iptables -A INPUT -s ~s -d ~s --dport ~p -j ~s\n", [Rule#rule.from, Rule#rule.to, Rule#rule.port, Rule#rule.action]).

printGCP(Rules) ->
   lists:foreach( fun(Rule) ->
      if Rule#rule.action == "DROP" -> 
         Action = "deny";
      true ->
         Action = "allow"
      end,

      io:fwrite("gcloud compute firewall-rules create ~s \
         --network NETWORK \
         --action ~s \
         --source-ranges ~s \
         --destination-ranges ~s \
         --rules ~s:~p\n", [Rule#rule.name, Action, Rule#rule.from, Rule#rule.to, Rule#rule.proto, Rule#rule.port])
      end, Rules).

printRules(Rules) -> 
   lists:foreach(fun(Rule) -> printRule(Rule) end, Rules).

start() -> 
   Rules = [
      #rule{name="allow-home-1", from="127.0.0.1/24", to="127.0.0.2/24", port=3773, action="ACCEPT"},
      #rule{name="deny-home-1", from="127.0.0.3/24", to="127.0.0.4/24", port=3774, action="DROP"}
   ],
   printRules(Rules),
   printGCP(Rules).