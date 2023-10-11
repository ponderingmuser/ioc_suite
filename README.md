# ioc_suite
These are scripts I am writing to check for indicators on compromise on Linux and Windows Systems.
As I have been studying for the CySA+, various IoCs (Indicators of Compromise) come up across the study material.
In windows, many of these revolve around changes to services, the registry, and to expected running processes. 
In Linux, many of these are unexpected files appearing, changes to system configurations, and changes to user accounts.
Basically, to detect an IoC, the trick is to try to find something anomalous; and to do that, you need to determine what is "normal" system behavior.
Thus, all of the windows scripts will include a "whitelist" function where normal system behavior can be removed from the scans. 
Each script will have its own instructions/readme as I build this suite, bit by bit. I know that there are enterprise-grade tools that do these functions better than my little scripts could, but I want to see what I can accomplish with the tools I have available. 
