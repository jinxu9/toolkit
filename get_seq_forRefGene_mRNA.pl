#!/usr/bin/perl -w
#
use strict;
if(@ARGV<2)
{
    print "Usage perl $0  <chr dir ><refGene.txt>  \n";
    exit;
}

my $path     = shift;
my $map_file = shift;


my $chr = '';
my $seq = '';

open(IN, "$map_file") or die;
while(<IN>){
	my @tabs = split;
	if($tabs[2] ne $chr){
		next unless($tabs[2] =~/^chr[0-9XYM]+$/);
		$chr = $tabs[2];
		open(FA, "$path/$chr\.fa") or die("$path/$chr\.fa");
		$seq = '';
		while(<FA>){
			next if(/^>/);
			chomp;
			$seq .= $_;
		}
		close FA;
	}
	my @starts = split /,/, $tabs[9];
	my @ends   = split /,/, $tabs[10];
	$tabs[4] ++;
	$tabs[6] ++;
	for(my $i=0;$i<$tabs[8];$i++){ $starts[$i]++ ;#
		}
	$tabs[9]  = join(",", @starts);
	$tabs[10] = join(",", @ends);
	my $gene = '';
	for(my $i=0;$i<$tabs[8];$i++){
		my $s = $starts[$i];
		my $e = $ends[$i];
#		next if($e < $tabs[6]);
#		last if($s > $tabs[7]);
#		$s = $tabs[6] if($s < $tabs[6]);
#		$e = $tabs[7] if($e >= $tabs[7]);

my $tmp.= substr($seq, $s - 1, $e - $s +1 );
#print $s,"\t",$e,"\t",length($tmp),"\t", $tmp,"\n";
$gene .= $tmp;
	}
	$gene = uc($gene);
	next unless($gene);
	if($tabs[3] eq '-'){
		$gene =~tr/ACGT/TGCA/;
		$gene = reverse $gene;
	}
#	print length($gene),"\t",length($gene)%3,"\n";
	my $name =$tabs[12]||$tabs[1];
	print
    qq{$name\t$tabs[2]\t$tabs[3]\t$tabs[4]\t$tabs[5]\t$tabs[6]\t$tabs[7]\t$tabs[8]\t$tabs[9]\t$tabs[10]\t$gene\n};
}
close IN;
