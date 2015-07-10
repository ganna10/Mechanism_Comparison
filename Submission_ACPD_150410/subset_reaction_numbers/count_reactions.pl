#! /usr/bin/env perl
# Count subset of reactions used in gas.eqn files
# Version 0: Jane Coates 9/7/15

use strict;
use diagnostics;

my @files = qw( cb05 cbm4 cbm4_orig cri mcm3_1 mcm3_2 mozart racm2 racm radm2 );
my %data;
foreach my $name (@files) {
    my $file = $name . ".eqn";
    open my $in, '<:encoding(utf-8)', $file or die "Can't open $file : $!";
    my @lines = <$in>;
    close $in;
    my %count;
    foreach my $line (@lines) {
        next unless ($line =~ /^{#R/);
        next if ($line =~ /_VD|_EMIS/);
        my ($number, $rest) = split /} /, $line;
        $number =~ s/_(.*?)\b//;
        $count{$number} += 1;
    }
    $data{$name} = scalar keys %count;
}

$data{$_} -= 48 foreach keys %data;
print "$_ : $data{$_}\n" foreach sort keys %data;
