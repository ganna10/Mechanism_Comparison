#! /usr/bin/env perl
# Count subset of organic species used in gas.eqn files
# Version 0: Jane Coates 14/7/15

use strict;
use diagnostics;

#my @files = qw( cb05 );
my @files = qw( cb05 cbm4 cri mcm3_1 mcm3_2 mozart racm2 racm radm2 );
my %data;
my @inorganic = qw( N2 O2 H2O O O1D O3 OH HO2 NO NO2 NO3 N2O5 HNO3 H2O2 SO3 SO2 NA UNITY CO CO2 HSO3 H2 HONO HO2NO2 );

foreach my $name (@files) {
    my $file = $name . ".spc";
    open my $in, '<:encoding(utf-8)', $file or die "Can't open $file : $!";
    my @lines = <$in>;
    close $in;
    my %count;
    foreach my $line (@lines) {
        next unless ($line =~ /IGNORE/);
        my ($spc, $rest) = split / = /, $line;
        next if ($spc ~~ @inorganic);
        $spc =~ s/_(.*?)\b//;
        $count{$spc} += 1;
    }
    $data{$name} = scalar keys %count;
}

print "$_ : $data{$_}\n" foreach sort keys %data;
