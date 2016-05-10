#!/usr/bin/perl -w
#
use strict;
if(@ARGV<2)
{
    print "Usage perl $0  <chr dir ><refGene.txt>  \n";
    print "refene formate :\n";
    print "id   NM_id   chr strand  TSS TSE CDSs    CDSe    # of exon   Starts  ENDs\n";
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
    #my $utr3_star=$ends[-1];
    $tabs[4] ; # Transcrit start 
	$tabs[6] ; # CDS start
	for(my $i=0;$i<$tabs[8];$i++){# $starts[$i]++ ;#
		}
	$tabs[9]  = join(",", @starts);
	$tabs[10] = join(",", @ends);
	my $gene = '';
	my $UTR5;
    my $UTR3;
    for(my $i=0;$i<$tabs[8];$i++){
		my $s = $starts[$i];
		my $e = $ends[$i];
       
        if($s<$tabs[6] && $e<$tabs[6])
        {
            $UTR5.=substr($seq,$s,$e-$s);
        }
        elsif($s<$tabs[6] && $e>$tabs[6])
        {
            $e=$tabs[6];
            $UTR5.=substr($seq,$s,$e-$s);
        }
        elsif($e>$tabs[7] && $s<$tabs[7])
        {
            $s=$tabs[7];
            $UTR3.=substr($seq,$s,$e-$s);
        }
        elsif($e>$tabs[7] && $s>$tabs[7])
        {
            $UTR3.=substr($seq,$s,$e-$s);
        }

#my $tmp.= substr($seq, $s - 1, $e - $s +1 );
#print $s,"\t",$e,"\t",length($tmp),"\t", $tmp,"\n";

	}
	$UTR5 = uc($UTR5);
    $UTR3 = uc($UTR3);
	next unless($UTR5)||($UTR3);
	if($tabs[3] eq '-'){
		$UTR5 =~tr/ACGT/TGCA/;
		$UTR5 = reverse $UTR5;
		$UTR3 =~tr/ACGT/TGCA/;
		$UTR3 = reverse $UTR3;
	    my $tmp=$UTR5;
        $UTR5=$UTR3;
        $UTR3=$tmp;
    }
    $UTR5=$UTR5||"-";
    $UTR3=$UTR3||"-";
#	print length($gene),"\t",length($gene)%3,"\n";
	my $name =$tabs[1];
	print
    qq{$name\t$tabs[12]\t$tabs[2]\t$tabs[3]\t$tabs[4]\t$tabs[7]\t$UTR5\t$UTR3\n};
}
close IN;
