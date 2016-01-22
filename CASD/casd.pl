#!/bin/perl
#############################################################
# CA Service Desk 
# =========================
# Copyright (C) 2011-2013
# =========================
# Description: 
# The program gathers webengine statistics from CA Service Desk 
# =========================
# Usage: perl sd.pl my/qualified/casd/homedir
#
# NOTE: Even for Windows users, please use "/" as separators.
# If there are spaces in the directory names, use the 8.3
# format by opening a command prompt and type 'dir /x' to
# see the truncated name.
# e.g. C:\Program Files becomes C:\Progra~1
# e.g. C:\Program Files (x86) becomes C:\Progra~2
#############################################################
use FindBin;
use lib ("$FindBin::Bin", "$FindBin::Bin/lib/perl", "$FindBin::Bin/../lib/perl");
use Wily::PrintMetric;
use Getopt::Long;

use strict;


# subroutine to get local server name
sub getServer {
    my $serverName;
    if ($^O eq 'aix' || $^O eq 'solaris' || $^O eq 'linux') {
        $serverName=`uname -n`;
    } else {
        # must be a windows device; use env variable %COMPUTERNAME%
        $serverName=$ENV{'COMPUTERNAME'};
    }
    return $serverName;
}

# subroutine to show program usage
sub usage {
    print "Unknown option: @_\n" if ( @_ );
    print "usage: $0 <CASDInstallDir> [--debug] [--help|-?]\n";
    exit;
}

my ($debug, $help, $progDir);

# get commandline parameters or display help
&usage if ( @ARGV < 1 or
    not GetOptions( 'progDir=s' => \$progDir,
                    'help|?'    => \$help,
                    'debug!'    => \$debug,
                  )
    or defined $help );

my @webstatResults;

# run debug if called; else execute 'webstat -d'
if ( $debug ) {
    # use single quotes around here-doc to keep Perl
    # from interpolating "@" in the user data
    @webstatResults = <<'SAMPLE' =~ m/(^.*\n)/mg;
PDM_Webstat: Invoked at 11/12/2013 15:26:21

=========================================
Report from Webengine: web:SERVER1:1
=========================================
Cumulative sessions so far = 3
Most sessions at a time    = 2
Currently active sessions  = 1
  user1@192.168.1.2               

=========================================
Report from Webengine: web:local
=========================================
Cumulative sessions so far = 12
Most sessions at a time    = 4
Currently active sessions  = 2
  user2@192.168.2.2          
  user3@192.168.2.3               

=========================================
Report from Webengine: web:wsp
=========================================
Cumulative sessions so far = 0
Most sessions at a time    = 0
Currently active sessions  = 0
SAMPLE
} else {
    my $webstatCommand = "webstat -d";
    # execute command; place results into array
    @webstatResults = `$progDir/$webstatCommand`;
}


#### begin parsing results ####
my $webEngine;
foreach my $isline (@webstatResults) {
    chomp $isline; # remove trailing new line
    # skip the '=' separator row
    if ($isline =~ /^\=+$/){ next; }
    # look for the reported Webengine
    elsif ($isline =~ /^Report.*/) {
        # parse the host name
        (undef,undef,$webEngine,undef) = split (/:/, $isline);
        # determine if is server is 'local'
        if ($webEngine eq 'local') {
            $webEngine = getServer;
        }
        # next line
        next;
    } elsif (defined($webEngine) && $isline =~ /^Cumulative.*/) {
        # parse server metrics
        my($metric, $value) = split(/=/,$isline,2);
        # remove leading and trailing spaces
        $metric =~ s/^\s+//; $metric =~ s/\s+$//;
        $value =~ s/^\s+//; $value =~ s/\s+$//;
        # print metrics
        Wily::PrintMetric::printMetric( type        => 'IntCounter',
                                        resource    => 'CAServiceDesk',
                                        subresource => $webEngine,
                                        name        => $metric,
                                        value       => int($value)
                                        );
        # next line
        next;
    } elsif (defined($webEngine) && $isline =~ /^Most.*/) {
        # parse server metrics
        my($metric, $value) = split(/=/,$isline,2);
        # remove leading and trailing spaces
        $metric =~ s/^\s+//; $metric =~ s/\s+$//;
        $value =~ s/^\s+//; $value =~ s/\s+$//;
        # print metrics
        Wily::PrintMetric::printMetric( type        => 'IntCounter',
                                        resource    => 'CAServiceDesk',
                                        subresource => $webEngine,
                                        name        => $metric,
                                        value       => int($value)
                                        );
        # next line
        next;
    } elsif (defined($webEngine) && $isline =~ /^Currently.*/) {
        # parse server metrics
        my($metric, $value) = split(/=/,$isline,2);
        # remove leading and trailing spaces
        $metric =~ s/^\s+//; $metric =~ s/\s+$//;
        $value =~ s/^\s+//; $value =~ s/\s+$//;
        # print metrics
        Wily::PrintMetric::printMetric( type        => 'IntCounter',
                                        resource    => 'CAServiceDesk',
                                        subresource => $webEngine,
                                        name        => $metric,
                                        value       => int($value)
                                        );
       # clear $webEngine
       undef $webEngine;
    }
}
