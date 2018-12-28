#!/usr/bin/perl
package TelegramParser;
use warnings;
use strict;

use LWP::Simple qw(get);
use JSON        qw(from_json);

my @data;

sub loadMessages{
  my ($apiBase, $token) = @_;
  Utili::Dbgcmdt::prnwo("catch telegram messages...");
  my $url     = $apiBase . $token . "/getUpdates";
  my $decoded = from_json(get($url));
  @data = $decoded->{"result"}; #$decoded->{"result"}[0] = 1 message
}

sub getDateTextForId{ #array of hashes 
  my ($apiBase, $token, $fromId) = @_;
  loadMessages($apiBase, $token);
  my @array;
  my $idx=0;
  while ($data[0][$idx]) {
    my %hash;
    $hash{"fromId"} = $data[0][$idx]{"message"}{"from"}{"id"};
    if ($hash{"fromId"} eq $fromId) {
      $hash{"date"} = $data[0][$idx]{"message"}{"date"};
      $hash{"text"} = $data[0][$idx]{"message"}{"text"};
      push (@array, \%hash);
    }
     ++$idx;
  }
  return \@array;
}


1;
