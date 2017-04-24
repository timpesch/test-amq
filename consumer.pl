#!/usr/bin/perl -w


use strict;

use lib '.';
use lib 'lib';

use etc::config_amq;
use Net::Stomp;
use Data::Dumper;

# Verbinde zu AMQ via Stomp
my $stomp = Net::Stomp->new( {
        hostname		=> etc::config_amq::amqhost(),
        port			=> etc::config_amq::stompport()
        } );

$stomp->connect( {
        login			=> etc::config_amq::amquser(),
        passcode		=> etc::config_amq::amqpass()
        } );


print "\nLese stomp://".etc::config_amq::amqhost().":".etc::config_amq::stompport().etc::config_amq::msgdest().etc::config_amq::queuename()."\n\n";

# Auslesen der Queue

$stomp->subscribe( {   
	destination		=> etc::config_amq::msgdest().etc::config_amq::queuename(),
	'ack'			=> 'client',
	'activemq.prefetchSize' => 1
	} );

while (1) 
	{
	my $frame = $stomp->receive_frame;
	if (!defined $frame) {
		next; # will reconnect automatically
	}

	# Zum anzeigen der Message Header, z.B. zum pruefen der Persistenz
	#print Dumper($frame->headers);

	print $frame->body."\n"; # do something here
	$stomp->ack( { frame => $frame } );
	}

$stomp->disconnect;
