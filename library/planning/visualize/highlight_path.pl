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
	print "\nUSAGE: ./highlight_path.pl <DOTFILE> <PATH_TO_HIGHLIGHT_AS_STRING> <COLOR>\n\n";
	exit
}


$dot_file = $ARGV[0];
$path = $ARGV[1];
$color = $ARGV[2];

open(FILE, "+<$dot_file") or die 'Cannot open file for reading\n';
my(@lines) = <FILE>;
close(FILE);

#print "\n$path\n";

# Replace a few things first:
$path =~ s/'//g;

$path =~ s/\)\],1\)/\\nModelDoneCode: 1/g;
$path =~ s/\)\],0\)/\\nModelDoneCode: 0/g;

$path =~ s/model_state\(\[//g;
$path =~ s/process_state\(//g;	

$path =~ s/,\[/: \[/g;
$path =~ s/,pid_/\\npid_/g;

# Delete rounded brackets
$path =~ s/\)//g;

$path =~ s/ -> /" -> "/g;

# Escape rectengular brackets
$path =~ s/\[/\\[/g;
$path =~ s/\]/\\]/g;

# Escape \n
$path =~ s/\\n/\\\\n/g;

#print "\n$path\n";

$color_pattern_old = "color=\"#666666\"";
$color_pattern_new = "color=\"$color\" fontcolor=\"$color\"";

$linewidth_pattern_old = "0.75";
$linewidth_pattern_new = "2.25";


open(OUTFILE, ">$dot_file") or die 'Cannot open file for writing\n';

my($line);
foreach $line (@lines) 
{	
	if($line =~ /$path/)
	{
	    $line =~ s/$color_pattern_old/$color_pattern_new/g;
		$line =~ s/$linewidth_pattern_old/$linewidth_pattern_new/g;
	}
	
	print OUTFILE $line;
}

close(OUTFILE);