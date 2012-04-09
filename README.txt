----------------------------------------------------------------------
	INSTALLATION
----------------------------------------------------------------------
ESProNa only supports SWI Prolog as the contribution Thea2 requires the semweb library.

Download and install SWI-Prolog Development Release (5.11.x) from http://www.swi-prolog.org
Download and install Logtalk from http://logtalk.org

Add location of ESProNa source files as environment variable. Something like

export ESProNa=/Users/mike/ESProNa


----------------------------------------------------------------------
	RUNNING
----------------------------------------------------------------------
Go to the ESProNa folder and load it through:

swilgt -g "{loader_debug}" 	which enables debugging through SWI's gtrace

or

swilgt -g "{loader}"


----------------------------------------------------------------------
	LOADING EXAMPLE PROCESS MODEL
----------------------------------------------------------------------
After ESProNa has successfully loaded (no errors or warnings) then load
a process model (e.g. set_up_surgery_plan_extended) through:

process_model::load(set_up_surgery_plan_extended(loader)).

The EXAMPLE_QUERIES.lgt in the corresponding process model folder gives you 
more details on queires you can perform.


----------------------------------------------------------------------
	JSON/REST INTERFACE
----------------------------------------------------------------------
ESProNa is running on port 2600 after starting it.

library/REST contains some JSON examples.
... more to come here....