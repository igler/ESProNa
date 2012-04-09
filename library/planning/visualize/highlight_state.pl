#!/usr/bin/perl

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%
#%  ESProNa - 	Modeling, Execution and Navigation of Declarative Business Processes
#%  Release 0.8
#%  
#%  Copyright (c) 2007-2012 Michael Igler.       All Rights Reserved.
#%  ESProNa is free software.  You can redistribute it and/or modify it under the terms 
#%  of the "Artistic License 2.0" as published by The Perl Foundation. 
#%  Consult the "LICENSE.txt" file for details.
#%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (scalar(@ARGV) < 2)
{
	print "\nUSAGE: ./highlight_state.pl <DOTFILE> <STATE_TO_HIGHLIGHT_AS_STRING> <COLOR>\n\n";
	exit
}

$dot_file = $ARGV[0];
$state = $ARGV[1];
$color = $ARGV[2];

open(FILE, "+<$dot_file") or die 'Cannot open file for reading\n';
my(@lines) = <FILE>;
close(FILE);

#print($state);
#print("\n\n");

# Replace a few things first:
$state =~ s/'//g;

$state =~ s/\)\],1\)$/\\nModelDoneCode: 1/g;
$state =~ s/\)\],0\)$/\\nModelDoneCode: 0/g;

$state =~ s/^model_state\(\[//g;
$state =~ s/process_state\(//g;	

$state =~ s/,\[/: \[/g;
$state =~ s/,pid_/\\npid_/g;

# Delete rounded brackets
$state =~ s/\)//g;

# Escape rectengular brackets
$state =~ s/\[/\\[/g;
$state =~ s/\]/\\]/g;

# Escape \n
$state =~ s/\\n/\\\\n/g;

#print($state);

$box_color_old = "shape=box color=\"#666666\"";
$box_color_new = "shape=box color=\"$color\"";

$linewidth_pattern_old = "0.75";
$linewidth_pattern_new = "1.25";

open(OUTFILE, ">$dot_file") or die 'Cannot open file for writing\n';

my($line);
foreach $line (@lines) 
{
	if($line =~ /$state/)
	{
	    $line =~ s/$box_color_old/$box_color_new/g;
		$line =~ s/$linewidth_pattern_old/$linewidth_pattern_new/g;
	}
	
	print OUTFILE $line;
}

close(OUTFILE);