#! /usr/bin/perl -w
 
use strict;

use lib '.';
use lib 'lib';

use etc::config_amq;
use Data::Dumper; 
use Net::Stomp;          
 
my $stomp;               
my $key;
my $value;

{
    local $@;
    print "INFO Creating a stomp instance for hostname: ".etc::config_amq::amqhost().", port: ".etc::config_amq::stompport()."\n";
    eval { 
		$stomp = Net::Stomp->new( {
			hostname => etc::config_amq::amqhost(), 
			port => etc::config_amq::stompport()
			}) 
	};
    while ( ($key,$value) = each %{$stomp} ) {
    	print "$key => $value\n";
    }
    print ("Unable to create a stomp instance\n")  if $@;
}    
 
if( $stomp ) {
    print "INFO Connecting to stomp using login:'".etc::config_amq::amquser()."' passcode:'".etc::config_amq::amqpass()."'\n";
    my $conn = $stomp->connect( { login => etc::config_amq::amquser(), passcode => etc::config_amq::amqpass() } );
 
    # Lets print the headers to see what is returned
    #my $headers = ${$conn}{headers};

    #print "------------------   Gebe Header aus\n";
    #while ( ($k,$v) = each %{$headers} ) {
    #  print "$k => $v\n";
    #}
 
    if( ${$conn}{command} ne "CONNECTED") {
      print  "Error: Cannot connect to stomp server.\n";
    }
    else {
      print( "INFO Connected to stomp server.\n");
	print "---------------- Sende\n";


for my $counter (1..etc::config_amq::msgcount())
        {

	
	my $TNOW=time();
	my $TSTTL=$TNOW + etc::config_amq::headerttl();
	my $EXPIRES=$TSTTL."000";

	print "-> Sende Nachrichti $counter\n";

	$stomp->send_transactional( 
		{ 
			expires=>$EXPIRES, 
			persistent=>etc::config_amq::headerpers, 
			priority=>etc::config_amq::headerprio,  
			destination=>etc::config_amq::queuename(), 
			body=>"Testnachricht $counter"
		});
}

    }
}
