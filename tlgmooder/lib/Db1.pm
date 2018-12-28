#!/usr/bin/perl
package Db1;
use warnings;
use strict;
use DBI;
use SQL::Abstract;
use Utili::Dbgcmdt;
my $dbf;
my $dbh;

sub main {
  my ($db1, @array) = @_;
  $dbf = $db1;
  dbOpen();
  # dbList();
  dbWriter(@array);

}

sub dbWriter{
  my (@array) = @_;
  my $size = @array;
  # Utili::Dbgcmdt::prnwo("arraysize= $size");
  # Utili::Dbgcmdt::dumper( @array );
  for (my $i = 0; $i < @array; $i++) {
    # Utili::Dbgcmdt::dumper( $array[$i][0] );

    my %fieldvals;
    %fieldvals = (%fieldvals, %{$array[$i][0]} );
    if (existTimestamp($fieldvals{date})) {
      Utili::Dbgcmdt::prnwo("existing>updating $fieldvals{date}");
      updatetblMood($fieldvals{date}, %fieldvals);
    } else {
      Utili::Dbgcmdt::prnwo("adding $fieldvals{date}");
      insertHash("tblMood", %fieldvals);
    }
  } #for
}

sub existTimestamp {
  	my ($id) = @_;
  	my $sth = $dbh->prepare("SELECT * FROM tblMood WHERE date = '$id'");
  	$sth->execute();
  	my $result = $sth->fetchrow_hashref();
  	if ($result) {
  		return $result;
  	} else {
  		return 0;
  	}
}


sub insertHash {
	my ($tbl, %fieldvals) = @_;
	my $sql = SQL::Abstract->new;
	my($stmt, @bind) = $sql->insert($tbl, \%fieldvals );
	my $sth = $dbh->prepare($stmt);
	$sth->execute(@bind);
	return;
}

sub updatetblMood {
	my ($id, %fields) = @_;
	my $stmt = "UPDATE tblMood SET";
	while ( my ($key, $value) = each(%fields) ) {
        $stmt .= " $key = '$value',";
    }
	chop $stmt;
	$stmt .= " WHERE date = '$id'";
	my	$sth = $dbh->prepare($stmt);
	$sth->execute();
	return;
}







sub dbOpen {
  $dbh =
  		  DBI->connect( "dbi:SQLite:dbname=$dbf", "", "",
  			{ RaiseError => 1, AutoCommit => 1 } )
  		  || die "Could not connect to database: $DBI::errstr";
}



sub getDateText{
  my $sth = $dbh->prepare("SELECT strftime('%d-%m-%YT%H:%M', date, 'unixepoch') as hdatum, text FROM tblMood");
  $sth->execute();
  return $sth;
}

sub dbList {
  my $sth = $dbh->prepare("SELECT * FROM tblMood");
  $sth->execute();
  while ( my @row = $sth->fetchrow_array ) {
    print "@row\n";
  }


}

1;
