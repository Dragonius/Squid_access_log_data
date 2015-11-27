#!/usr/bin/perl

#use strict;
use warnings;

#Put all to 0
$other=0;
$timeout=0;
$local_hit=0;
$local_miss=0;
$remote_hit=0;
$remote_miss=0;
$tcp_hit=0;
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

                if ($H =~ /TIMEOUT_HIER/) {
                $timeout++; }

#For UDP HIT/MISS
                if ($L =~ /UDP_HIT/) {
                $remote_hit++;
                } if ($L =~ /UDP_MISS/) {
                $remote_miss++; }
                
#$L 3 Poikki
#$H 8 Leikkaus  ( yleensä Tcp tai Udp vastaus Yleensä Sibling tai onnistunut haku) 
#Added TCP HIT/MISS
                if ($L =~ /TCP_HIT/) {
                $tcp_hit++;
                } if ($L =~ /TCP_MISS/) {
                $tcp_miss++; }

                if ($L =~ /IMS_HIT/) {
                        $ims_hit++;
                } 
                if ($L =~ /MEM_HIT/) {
                        $mem_hit++;
                } 
                if ($L =~ /ABORTED/) {
                        $aborted_hit++;
                } 
                if ($L =~ /REFRESH_UNMODIFIED/) {
                        $unmodified++;
                } 
                if ($L =~ /REFRESH_MODIFIED/) {
                        $modified++;
                } 
                if ($L =~ /NEGATIVE_HIT/) {
                        $negative++;
                } 
  #Sibling hit here. Must do more code so we want know it is a upd od tcp hit.
  #time       0 192.168.XX.XX UDP_HIT/000 0 HTCP_TST http://website.com/7.jpg - HIER_NONE/- -
  #time       2 192.168.XX.XX TCP_HIT/504 5105 GET http://website.com/7.jpg - HIER_NONE/- text/html
                  if ($H =~ /HIT/) {
                        $sibling_hit++;
                }
  #Why we add localhit if we have sibling hit?
                  if ($L =~ /SIBLING_HIT/) {
                        $local_hit++;
                } 
                if ($H =~ /HIER_DIRECT/) {
                        $direct++;
                } 
                if ($L =~ /MISS/) {
                        $local_miss++;
                } 
  #We need all others here for better hit accusary
                        else {
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
        printf "TCP-HIT %% %f\n", 100*$tcp_hit/$tcp;
        printf "TCP-HIT %d\n", $tcp_hit;
        printf "TCP-MISS %% %f\n", 100*$tcp_miss/$tcp;
        printf "TCP-MISS %d\n", $tcp_miss;
        printf "LOCAL-HIT %% %f\n", 100*$local_hit/$tcp;
        printf "LOCAL-HIT %d\n", $local_hit;
        printf "LOCAL-MISS %% %f\n", 100*$local_miss/$tcp;
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
  #Here maybe problem to count hit on all tcp and udp plus other?
        printf "ALL_TCP %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$direct+$other+$sibling_hit)/$N*100;
        printf "ALL_UDP %f\n", ($remote_hit/$udp+$remote_miss/$udp)*100;
