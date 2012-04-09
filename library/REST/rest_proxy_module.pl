:- module(rest_proxy_module, [distributor/1]).

	distributor(Request) :- 
		rest::distributor(Request).
		