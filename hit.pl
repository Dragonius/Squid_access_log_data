#!/usr/bin/perl

#use strict;

#Put all to 0 
$other=0;
$timeout=0;
$local_hit=0;
$local_miss=0;
$remote_hit=0;
$remote_miss=0;
$tpc_hit=0;
$tcp_miss=0;
$direct=0;
$other=0;
$ims_hit=0;
$mem_hit=0;
$aborted_hit=0;
$modified=0;
$unmodified=0;
$sibling_hit=0;
$negative=0;
$tcp=0;
$udp=0;
use warnings;


while (<>) {
                chop;
                @F = split;
                $L = $F[3];                  # local cache result code
                $H = $F[8];                  # hierarchy code
#We want also UDP for icp and htcp
#               next unless ($L =~ /TCP_/);     # skip UDP and errors
                if ($L =~ /UDP/) {
                $udp++; }
                if ($L =~ /TCP/) {
                $tcp++; }
                $N++;

#For UDP HIT/MISS
                if ($L =~ /UDP_HIT/) {
                $remote_hit++;
                } if ($L =~ /UDP_MISS/) {
                $remote_miss++; }
                
#Added TCP HIT/MISS
                if ($L =~ /TCP_HIT/) {
                $tcp_hit++;
                } if ($L =~ /TCP_MISS/) {
                $tcp_miss++; }

#Moved to Direct out of elsif				
		if ($H =~ /HIER_DIRECT/) {
                $direct++; } 
				
#moved Time out of  top of this /mostly in TCP_MISS 
                if ($H =~ /TIMEOUT_HIER/) {
                $timeout++; }
                
                
                if ($L =~ /IMS_HIT/) {
                        $ims_hit++;
                } elsif ($L =~ /MEM_HIT/) {
                        $mem_hit++;
                } elsif ($L =~ /ABORTED/) {
                        $aborted_hit++;
                } elsif ($L =~ /REFRESH_UNMODIFIED/) {
                        $unmodified++;
                } elsif ($L =~ /REFRESH_MODIFIED/) {
                        $modified++;
                } elsif ($L =~ /NEGATIVE_HIT/) {
                        $negative++;
                } elsif ($H =~ /HIT/) {
                        $sibling_hit++;
                } elsif ($L =~ /SIBLING_HIT/) {
                        $local_hit++;
                } elsif ($L =~ /MISS/) {
                        $local_miss++;
                } else {
                        $other++;
                }
        }
        
#if log files empty then tcp and udp is 1
        if ($tcp == 0) { $tcp=1};
        if ($udp == 0) { $udp=1};
        printf "ALL-REQUESTS %d\n", $N;
        printf "TCP-REQUESTS %d\n", $tcp;
        printf "UDP-REQUESTS %d\n", $udp;
        printf "TIMEOUTS %d\n", $timeout;
        printf "TIMEOUT %% %f\n", 100*$timeout/$N;
        printf "REMOTE-HIT %% %f\n", 100*$remote_hit/$udp;
        printf "REMOTE-HIT %d\n", $remote_hit;
        printf "REMOTE-MISS %% %f\n", 100*$remote_miss/$udp;
        printf "REMOTE-MISS %d\n", $remote_miss;
        printf "LOCAL-HIT %% %f\n", 100*$local_hit/$tcp;
        printf "LOCAL-HIT %d\n", $local_hit;
  #someting wrong Here so i Changed Local miss TCP to N
        printf "LOCAL-MISS %% %f\n", 100*$local_miss/$N;
        printf "LOCAL-MISS %d\n", $local_miss;
        printf "IMS_HIT %% %f\n", 100*$ims_hit/$tcp;
        printf "IMS_HIT %d\n", $ims_hit;
        printf "MEM_HIT %% %f\n", 100*$mem_hit/$tcp;
        printf "MEM_HIT %d\n", $mem_hit;
        printf "REFRESH_UNMODIFIED %% %f\n", 100*$unmodified/$tcp;
        printf "REFRESH_UNMODIFIED %d\n", $unmodified;
        printf "REFRESH_MODIFIED %% %f\n", 100*$modified/$tcp;
        printf "REFRESH_MODIFIED %d\n", $modified;
        printf "NEGATIVE_HIT %% %f\n", 100*$negative/$tcp;
        printf "NEGATIVE_HIT %d\n", $negative;
        printf "ABORTED_HIT %% %f\n", 100*$aborted_hit/$tcp;
        printf "ABORTED_HIT %d\n", $aborted_hit;
        printf "SIBLING_HIT %% %f\n", 100*$sibling_hit/$tcp;
        printf "SIBLING_HIT %d\n", $sibling_hit;
        printf "DIRECT %% %f\n", 100*$direct/$tcp;
        printf "DIRECT %d\n", $direct;
        printf "OTHER %% %f\n", 100*$other/$tcp;
        printf "OTHER %d\n", $other;
        printf "ALL_Data %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$direct+$other+$sibling_hit+$remote_hit+$remote_miss)/$N*100;
        printf "ALL_TCP %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$direct+$other+$sibling_hit)/$tcp*100;
        printf "ALL_UDP %f\n", ($remote_hit/$udp+$remote_miss/$udp)*100;
