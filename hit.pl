#!/usr/bin/perl

#älä ole tarkka
use strict;
use warnings;

#Put all to 0
my $timeout=0;
my $local_hit=0;
my $local_miss=0;
my $udp_hit=0;
my $udp_miss=0;
my $tcp_hit=0;
my $tcp_miss=0;
my $direct=0;
my $other=0;
my $ims_hit=0;
my $mem_hit=0;
my $aborted_hit=0;
my $aborted_miss=0;
my $modified=0;
my $unmodified=0;
my $sibling_hit=0;
my $negative=0;
my $tcp=0;
my $udp=0;

#Cut parsers
my @F;
my $F;
my $L;
my $H;
my $N;

#chop Data to pieces
while (<>) {
                chop;
                @F = split;                 # Split Access.log data
                $L = $F[3];                 # local cache result code
                $H = $F[8];                 # hierarchy code
                
#add one per line
                $N++;
                
#We want also UDP for icp and htcp
#               next unless ($L =~ /TCP_/);     # skip UDP and errors
                if ($L =~ /UDP/) {
                $udp++; }
                if ($L =~ /TCP/) {
                $tcp++; }
                if ($H =~ /TIMEOUT_HIER/) {
                $timeout++; }

#For UDP HIT/MISS
                if ($L =~ /UDP_HIT/) {
                $udp_hit++;
                } if ($L =~ /UDP_MISS/) {
                $udp_miss++; }
                
#$L 3 Poikki
#$H 8 Leikkaus  ( yleensä Tcp tai Udp vastaus Yleensä Sibling tai onnistunut haku) 
#Added TCP HIT/MISS
                if ($L =~ /TCP_HIT/) {
                $tcp_hit++;
                } if ($L =~ /TCP_MISS/) {
                $tcp_miss++; }

#Lot of If
                if ($L =~ /IMS_HIT/) {
                        $ims_hit++;
                } elsif ($L =~ /MEM_HIT/) {
                        $mem_hit++; 
                } elsif ($L =~ /TCP_HIT_ABORTED/) {
                        $aborted_hit++;
                } elsif ($L =~ /TCP_MISS_ABORTED/) {
                        $aborted_miss++;
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
                } elsif ($H =~ /HIER_DIRECT/) {
                        $direct++;
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
        printf "REMOTE-HIT %% %f\n", 100*$udp_hit/$udp;
        printf "REMOTE-HIT %d\n", $udp_hit;
        printf "REMOTE-MISS %% %f\n", 100*$udp_miss/$udp;
        printf "REMOTE-MISS %d\n", $udp_miss;
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
        printf "ABORTED_HIT %d\n", $aborted_miss;
        printf "SIBLING_HIT %% %f\n", 100*$sibling_hit/$tcp;
        printf "SIBLING_HIT %d\n", $sibling_hit;
        printf "DIRECT %% %f\n", 100*$direct/$tcp;
        printf "DIRECT %d\n", $direct;
        printf "OTHER %% %f\n", 100*$other/$tcp;
        printf "OTHER %d\n", $other;
        printf "ALL_TCP %f\n", ($local_hit+$local_miss+$ims_hit+$mem_hit+$unmodified+$modified+$negative+$aborted_hit+$direct+$other+$sibling_hit)/$N*100;
        printf "ALL_UDP %f\n", ($udp_hit/$udp+$udp_miss/$udp)*100;
        printf "Version 0.12 29.11.2016";
