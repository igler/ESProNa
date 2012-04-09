%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ESProNa - 	Modeling, Execution and Navigation of Declarative Business Processes
%  Release 0.8
%  
%  Copyright (c) 2007-2012 Michael Igler.       All Rights Reserved.
%  ESProNa is free software.  You can redistribute it and/or modify it under the terms 
%  of the "Artistic License 2.0" as published by The Perl Foundation. 
%  Consult the "LICENSE.txt" file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  To make Logtalk startup and compilation less verbose uncomment the
%  following lines:
/*
:- initialization((
	set_logtalk_flag(startup_message, banner),
	set_logtalk_flag(report, warnings)
)).
*/

%  To collect all XML documenting files in the same place for generating 
%  (X)HTML or PDF documentation of your project uncomment the following
%  lines:
:- initialization((
	set_logtalk_flag(altdirs, on),
	set_logtalk_flag(xmldocs, off),
	set_logtalk_flag(xmldir, '$ESProNa/doc/')
)).

%  To make Logtalk completely silent for batch processing uncomment the
%  following lines:
:- initialization((
	set_logtalk_flag(startup_message, none),
	set_logtalk_flag(report, off)
)).

%  To prevent using the <</2 control construct to bypass object
%  encapsulation rules uncomment the following lines:
/*
:- initialization((
	set_logtalk_flag(context_switching_calls, deny)
)).
*/
