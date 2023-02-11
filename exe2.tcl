set ns [new Simulator]
set tf [open exe2.tr w]
$ns trace-all $tf


set nf [open exe2.nam w]
$ns namtrace-all $nf

#creating the node

set s [$ns node]
set c [$ns node]

$ns color 1 Blue

$s label "server"
$c label "client"


$ns duplex-link $s $c 10Mb 22ms DropTail
$ns duplex-link-op $s $c orient right

set tcp [new Agent/TCP]
$ns attach-agent $s $tcp
$tcp set packetSize_ 1500

set sink [new Agent/TCPSink]
$ns attach-agent $c $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$tcp set fid_ 1




proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam exe2.nam &
	exec awk -f exectranfr.awk exe2.tr &
	exec awk -f exe2convert.awk exe2.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes _received_at_client" -x "time_in_secs" -y "bytes_in_bps" &
	exit 0
	}
$ns at 0.01 "$ftp start"

$ns at 15.0 "$ftp stop"
$ns at 15.1 "finish"

$ns run
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
