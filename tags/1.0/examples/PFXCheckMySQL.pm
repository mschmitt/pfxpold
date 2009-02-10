package PFXCheck;
use strict;
use warnings;
use Data::Dumper;
use DBI;

our $VERSION = '0.01';

sub new(){
	my $class = shift;
	my $self  = {};
	&main::dolog("debug", "PFXCheck instantiated.");
	$self->{'db_name'} = 'martin_test';
	$self->{'db_user'} = 'smtpusr';
	$self->{'db_pass'} = '';
	$self->{'dbh'} = undef;
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

	$self->{'dbh'} = DBI->connect_cached("DBI:mysql:$self->{'db_name'}", 
		$self->{'db_user'}, $self->{'db_pass'}, { RaiseError => 0, PrintError => 0 });
	if ($DBI::err){
		&main::dolog("error", "Error connecting to database: $DBI::errstr");
		return "DEFER Transient internal error. Please try again later.";
	}
	&main::dolog("debug", "Database connection established.");

	# Query the database for all possible combinations:
	# 1) client_address / sender
	# 2) client_address / domain
	# 3) client_name    / sender
	# 4) client_name    / domain
	my $sth = $self->{'dbh'}->prepare("SELECT * FROM smtpfoo WHERE origin=? AND address=?");
	foreach my $origin ($client_address, $client_name){
		$sth->bind_param(1, $origin);
		foreach my $address ($sender, "\@$domain"){
			$sth->bind_param(2, $address);
			$sth->execute or die $sth->errstr;
			my @results = @{$sth->fetchall_arrayref};
			$sth->finish;
			my $cnt = @results;
			&main::dolog("debug", "origin=$origin address=$address found_rows=$cnt");
			if ($cnt > 0){
				&main::dolog("info", "PFX-PERMIT: client_name=$client_name client_address=$client_address sender=$sender");
				return "OK";
			}
		}
	}
	&main::dolog("info", "PFX-REJECT: client_name=$client_name client_address=$client_address sender=$sender");
	return "REJECT Sorry, this combination of sender and originating system does not match any of my policies.";
}
1;
