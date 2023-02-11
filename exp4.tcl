set ns [new Simulator]

set tf [open prg4.tr w]
$ns trace-all $tf

set nf [open prg4.nam w]
$ns namtrace-all $nf

set cwind [open win4.tr w]

$ns color 1 Blue
$ns color 2 Red

$ns rtproto DV
                        
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.3Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.3Mb 10ms DropTail
$ns duplex-link $n4 $n6 0.3Mb 10ms DropTail
$ns duplex-link $n4 $n6 0.3Mb 10ms DropTail

$ns duplex-link-op $n1 $n3 orient right-down
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n6 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


$ns at 1.2 "$ftp0 start"

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1

set telnet [new Application/Telnet]
$telnet attach-agent $tcp1
$ns at 1.5  "$telnet start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 2.0 "plotWindow $tcp0 $cwind"
$ns at 2.0 "plotWindow $tcp1 $cwind"

proc finish {} {
	global ns tf nf cwind
	$ns flush-trace
	close $tf
	close $nf
	puts "running nam.."
	puts "FTP PACKETS..."
	puts "Telnet PACKETS.."
	
	exec nam prg4.nam &
	exec xgraph win4.tr &
	exit 0
}
$ns run
