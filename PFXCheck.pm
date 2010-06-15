package PFXCheck;
use strict;
use warnings;

our $VERSION = '0.01';

# Sample check plugin that randomly accepts or denies requests

sub new(){
	my $class = shift;
	my $self  = {};
	&main::dolog("debug", "$class instantiated.");
	bless $self;
}

sub do_check($){
	&main::dolog("debug", "Entering do_check routine.");
	my $self      = shift @_;
	my $querydata = shift @_;
	unless ($querydata->{'client_address'} 
		and $querydata->{'client_name'} 
		and $querydata->{'sender'}){
		&main::dolog("warning", "Rejecting malformed request.");
		return "REJECT Malformed request. Need more input.";
	}
	my $client_address = "$querydata->{'client_address'}";
	my $client_name    = "$querydata->{'client_name'}";
	my $sender         = "$querydata->{'sender'}";
	my $domain         = (split /@/, $sender)[-1];

	&main::dolog("debug", "Checking for: client_address=$client_address client_name=$client_name sender=$sender domain=$domain");

	# Randomly accept the request
	if (rand(0) > 0.5){
		&main::dolog("info", "PFX-PERMIT: client_name=$client_name client_address=$client_address sender=$sender");
		return "OK (you win!)";
	}

	&main::dolog("info", "PFX-REJECT: client_name=$client_name client_address=$client_address sender=$sender");
	return "DUNNO (you lose!)";
}
1;
