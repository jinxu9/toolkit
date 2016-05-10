#!/usr/bin/perl 
use strict;
use warnings;

#Scripts to get seqeunce length and GC %
# 2015-11-09
# xujin937@gmail.com
if(@ARGV<2)
{
	print "Usage perl $0<input file> < 0: fastq; >0: column in file, index from 1>\n";
	exit;
}



if($ARGV[1] ==0)
{
	#print "processing fasta file , to be added\n";
	my $seq="";
	my $id="";
	my $count=0;
	my $len=0;

	open IN,"$ARGV[0]" or die "can not open $ARGV[0]\n";
	while(<IN>)
	{
			chomp;
			if(/^>/)
			{	#print $_,"\n";
				if($id ne "")
				{
					my $gc=sprintf("%f",$count*100/$len);
					$id=~s/>//;
					print $id,"\t",$len,"\t",$gc,"\n";
					$seq="";
					my @a=split;
					$id=$a[0];
					$count=0;
					$len=0;
				
				} 	
				else
				{
					my @a=split;
					$id=$a[0];
				}	
				
			}
			else
			{
				$seq=$_;
				#print $seq,"\n";
				my $len_c=length($seq);
				$len+=length($seq);
				for (my $i = 0; $i < $len_c; $i++) {
                        		my $sub = substr($seq,$i,1);
                        		if ($sub =~ /G|C/i) { $count++; }
				}
				#exit;
				
			}
	}

	my $gc=sprintf("%f",$count*100/$len);
	$id=~s/>//;
	 print $id,"\t",$len,"\t",$gc,"\n";	
	
}
else
{
	my $column =$ARGV[1];
	open IN,"$ARGV[0]" or die "can not open $ARGV[0]\n";
	while(<IN>)
	{
		chomp;
		my @a=split;
		my $seq=$a[$column-1];
		my $len=length($seq);
		my $count=0;
		for (my $i = 0; $i < $len; $i++) {
			my $sub = substr($seq,$i,1);
			if ($sub =~ /G|C/i) {
	    			$count++;
			}
    		}
		my $gc=sprintf("%f",$count*100/$len);
	print $_,"\t",$len,"\t",$gc,"\n";
	
	}

}	
