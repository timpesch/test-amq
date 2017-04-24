use strict;
package etc::config_amq;

sub amqhost { return "localhost"; }

sub stompport { return 61617; }

sub amquser { return "admin";  }
sub amqpass { return "admin"; }
sub queuename { return "super.fancy.queue"; }

sub msgdest { return "/queue/"; }	# /queue/ oder /topic/
sub msgcount { return 5; }		# Anzahl der Nachrichten pro Durchlauf (persistent|non-persistent)


# Stomp Frame Header Config
sub headerttl { return 60; }		# Time To Live In Seconds
sub headerprio { return 5; }		# JMSPriority (0..9)
sub headerpers { return "true"; }	# Persitence (true|false)


1;


