#!/usr/bin/perl
package Tsv1;
use warnings;
use strict;

sub main{
  my ($file) = @_;

  open my $fh, '>', $file or die "Could not open $file: $!\n"; # ohne utf-8!!!!!!!
  print $fh "date\tclose\n"; ###header
  my $sth = Db1::getDateText();
	while (my $result = $sth->fetchrow_hashref() ) {
  	my $datum = @$result{'hdatum'};
  	my $text = @$result{'text'};
# Utili::Dbgcmdt::prnwo("date=$datum\ttext=$text");
  	print $fh "$datum\t$text\n";
  }
  Utili::Dbgcmdt::prnwo("tsv written\t$file");
  close $fh;
}

1;
