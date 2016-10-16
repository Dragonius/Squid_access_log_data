#!/usr/bin/perl

#use strict;
use warnings;

#Put all to 0
$other=0;
$timeout=0;
$local_hit=0;
$local_miss=0;
$udp_hit=0;
$udp_miss=0;
$tcp_hit=0;
$tcp_miss=0;
$direct=0;
$other=0;
$ims_hit=0;
$mem_hit=0;
$aborted_hit=0;
$aborted_miss=0;
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

#$L 3 Poikki 3  ( yleensä tcp_hit/miss udp_hit/miss) 
#$H 8 Leikkaus  ( yleensä Tcp tai Udp vastaus Yleensä Sibling tai onnistunut haku) 

#Count all Lines
                $N++;

#We want also UDP for icp and htcp
                if ($L =~ /UDP/) {
                $udp++; }
                if ($L =~ /TCP/) {
                $tcp++; }

#For UDP HIT/MISS
                if ($L =~ /UDP_HIT/) {
                        $udp_hit++;
                }
                if ($L =~ /UDP_MISS/) {
                        $udp_miss++; }

#Added TCP HIT/MISS
                if ($L =~ /TCP_HIT/) {
                        $tcp_hit++;
                } 
                if ($L =~ /TCP_MISS/) {
                        $tcp_miss++; }

                elsif ($L =~ /IMS_HIT/) {
                        $ims_hit++;
                } 
                elsif ($L =~ /MEM_HIT/) {
                        $mem_hit++;
                }
                
#Must add TCP_HIT_ABORTED , TCP_MISS_ABORTED
                elsif ($L =~ /TCP_HIT_ABORTED/) {
                        $aborted_hit++;
                } 
                elsif ($L =~ /TCP_MISS_ABORTED/) {
                        $aborted_miss++;
                } 

# Is it Refresh or not
                elsif ($L =~ /REFRESH_UNMODelsifIED/) {
                        $unmodifiedd++;
                } 
                elsif ($L =~ /REFRESH_MODelsifIED/) {
                        $modified++;
                }
 
#Negative HIT
                elsif ($L =~ /NEGATIVE_HIT/) {
                        $negative++;
                } 
  #Sibling hit here. Must do more code so we want know it is a upd or tcp hit.
  #time       0 192.168.XX.XX UDP_HIT/000 0 HTCP_TST http://website.com/7.jpg - HIER_NONE/- -
  #time       2 192.168.XX.XX TCP_HIT/504 5105 GET http://website.com/7.jpg - HIER_NONE/- text/html
                elsif ($H =~ /SIBLING_HIT/) {
                        $sibling_hit++;
                }

#Hier Return Code
                elsif ($H =~ /HIER_DIRECT/) {
                        $direct++;
                }
                elsif ($H =~ /TIMEOUT_HIER/) {
                        $timeout++; 
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
        printf "TIMEOUT %% %f\n", 100*$timeout/$N;
        printf "UDP-HIT %% %f\n", 100*$udp_hit/$udp;
        printf "UDP-HIT %d\n", $udp_hit;
        printf "UDP-MISS %% %f\n", 100*$udp_miss/$udp;
        printf "UDP-MISS %d\n", $udp_miss;
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
        printf "ABORTED_MISS %% %f\n", 100*$aborted_miss/$tcp;
        printf "ABORTED_MISS %d\n", $aborted_miss;
        printf "SIBLING_HIT %% %f\n", 100*$sibling_hit/$tcp;
        printf "SIBLING_HIT %d\n", $sibling_hit;
        printf "DIRECT %% %f\n", 100*$direct/$tcp;
        printf "DIRECT %d\n", $direct;
        printf "TIMEOUTS %% %f\n", 100*$timeout/$tcp;
        printf "TIMEOUTS %d\n", $timeout;
        printf "OTHER %% %f\n", 100*$other/$N;
        printf "OTHER %d\n", $other;
  #Here maybe problem to count hit on all tcp and udp plus other?
        printf "ALL_TCP %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$aborted_miss+$direct+$other+$sibling_hit)/$N*100;
        printf "ALL_TCP %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$aborted_miss+$direct)/$tcp*100;
        printf "ALL_UDP %f\n", ($udp_hit/$udp+$udp_miss/$udp)*100;
        printf "Dev 0.1";
