package PFXCheck;
use strict;
use warnings;
use Data::Dumper;
use DBI;

our $VERSION = '0.01';

sub new(){
	my $class = shift;
	my $self  = {};
	our $log_debug;
	&main::dolog("debug", "PFXCheck instantiated.") if ($log_debug);
	my $db_host = 'localhost';
	my $db_name = 'martin_test';
	my $db_user = 'smtpusr';
	my $db_pass = '';
	$self->{'dbh'} = DBI->connect_cached("DBI:mysql:$db_name", 
		$db_user, $db_pass, { RaiseError => 0, PrintError => 0 });
	if ($DBI::err){
		&main::dolog("error", "Error connecting to database: $DBI::errstr");
		exit 1;
	}
	&main::dolog("debug", "Database connection established.") if ($log_debug);
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
