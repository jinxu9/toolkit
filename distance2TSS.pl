#!/usr/bin/perl 
use warnings;
use strict;

if(@ARGV<1)
{
	print "Usage perl $0 <TSS start> <peaks region>\n";
	print "<TSS start formate>\n";
	print "chr start_position	end_position \n";
	print "<peaks regions formate>\n";
	print "chr start_position end_position other_inform\n";
	exit;
}


my %hash_peaks;
my @Tss;
open IN, "$ARGV[0]" or die "can not open $ARGV[0]\n";

while(<IN>)
{
	chomp;
	push @Tss, $_;
}


close IN;


open P,"$ARGV[1]" or die "can not open $ARGV[1]\n";
while(<P>)
{
	chomp;
	my @a=split; 
	my $peak_s=$a[1];
	my $peak_e=$a[2];
	my ($distan_s,$gene_s)=&min_dist($peak_s,@Tss);
	my ($distan_e,$gene_e)=&min_dist($peak_e,@Tss);

	if($distan_s<$distan_e)
	{
		print $_,"\t",$distan_s,"\t",$gene_s,"\n";
	}
	else
	{
		print $_,"\t",$distan_e,"\t",$gene_e,"\n";	
	}
	

}

1;
sub min_dist {
  my $peak=shift;
  my @tss=@_;
  my $min_dis_c=10000000000;
  my $gene="";
for (my $i=0;$i<=$#tss;$i++)
	{
		my @a=split(/\t/,$tss[$i]);
		my $distanc=abs($a[1]-$peak);
		if($distanc<$min_dis_c)
		{
			$min_dis_c=$distanc;
			$gene=$a[2];		
		}		
		else
		{
			next;
		}

	
	}

return($min_dis_c,$gene);
}
