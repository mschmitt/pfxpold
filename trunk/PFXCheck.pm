package PFXCheck;
use strict;
use warnings;

use Data::Dumper;

our $VERSION = '0.01';

sub new(){
	my $class = shift;
	my $self  = {};
	&main::dolog("debug", "PFXCheck instantiated.");
	bless $self;
}

sub do_check($){
	&main::dolog("debug", "Entering do_check routine.");
	my $self      = shift @_;
	my $querydata = shift @_;
	print Dumper(\$querydata);
	my $response = "REJECT Sorry, this combination of sender and originating system does not match any of my policies.";
	if ($querydata->{'foo'} eq "bar"){
		$response = "OK";
	}
	return $response;
}
1;
