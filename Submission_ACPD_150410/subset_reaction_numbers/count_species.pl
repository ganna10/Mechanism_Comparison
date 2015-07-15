#! /usr/bin/env perl
# Count subset of organic species used in gas.eqn files
# Version 0: Jane Coates 14/7/15
# Version 1: Jane Coates 15/7/2015 including reactions from tagged and original

use strict;
use diagnostics;
use KPP;

#my @files = qw( cb05 );
my @files = qw( cb05 cbm4 cri mcm3_1 mcm3_2 mozart racm2 racm radm2 );
my (%spc, %reactions, %full_rxns);
my @inorganic = qw( N2 O2 H2O O O1D O3 OH HO2 NO NO2 NO3 N2O5 HNO3 H2O2 SO3 SO2 NA UNITY CO CO2 HSO3 H2 HONO HO2NO2 hv PAROP OHOP NULL );

foreach my $name (@files) {
    my $file = $name . ".eqn";
    my $kpp = KPP->new($file);
    my (%count_species, %count_reactions, %orig_reactions);
    my $all_reactions = $kpp->all_reactions();
    foreach my $reaction (@$all_reactions) {
        my ($number, $rest) = split /_/, $reaction;
        $number =~ s/R(.*?)/$1/;
        next if ($number < 49);
        $count_reactions{$number}++;
        my $reactants = $kpp->reactants($reaction);
        my $products = $kpp->products($reaction);
        if (@$reactants == 1) { #remove emissions
            last if ($reactants->[0] eq "UNITY");
        }
        if (@$products == 1) { #remove deposition
            last if ($products->[0] eq "UNITY");
        }
        foreach (@$reactants) {
            $_ =~ s/_(.*?)$//;
            next if ($_ ~~ @inorganic);
            $count_species{$_}++;
        }
        foreach (@$products) {
            $_ =~ s/_(.*?)$//;
            next if ($_ ~~ @inorganic);
            $count_species{$_}++;
        }
    }
    #print "$_\n" foreach keys %count_species;
    $spc{$name} = scalar keys %count_species;
    $reactions{$name} = scalar keys %count_reactions;
}

print "Organic species\n";
print "$_ : $spc{$_}\n" foreach sort keys %spc;
print "Subset Organic reactions\n";
print "$_ : $reactions{$_}\n" foreach sort keys %reactions;
