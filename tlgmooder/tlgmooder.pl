#!/usr/bin/perl -Ilib
########################################
# catches telegram bot message and write it into sqlite for producing d3js graph
#
########################################
use warnings;
use strict;
use TelegramParser;
use Db1;
use Tsv1;
use Utili::Dbgcmdt;
Utili::Dbgcmdt::prnwo("############start...##########################");

my %cfg;
my $cfgFilename = "../../cfg/cfg.pl";
my $cfgTmp = do($cfgFilename);
%cfg = (%cfg, %$cfgTmp);

Utili::Dbgcmdt::prnwo("get messages fromId to array...");
my @array = TelegramParser::getDateTextForId($cfg{apiBase}, $cfg{token}, $cfg{fromId});  #array of hashes
# Utili::Dbgcmdt::dumper(@array);

Utili::Dbgcmdt::prnwo("write into db...");
Db1::main($cfg{db1}, @array);

Utili::Dbgcmdt::prnwo("write tsv...");
Tsv1::main($cfg{tsvFilename});

# rsync tsv on html place
system('rsync', '-rvzuP', '--delete', $cfg{tsvFilename}, $cfg{tsvWWWFile});
Utili::Dbgcmdt::prnwo("tsv rsynced to $cfg{tsvWWWFile}");
Utili::Dbgcmdt::prnwo("############...end##########################");
1;
