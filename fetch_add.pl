#!/usr/bin/perl
use strict;
use warnings;
if (@ARGV<6)
{
	print "perl $0 <file1> <key filed> <file2> <key filed of 1 > <filed of file2 added to file1[1,2,3|a]> <Number of \"-\" add for formating>\n";
	print "Index from 0 \n";
	print "a shoule be all value of the filed 2\n";
	print "Add info from file2 to file1 \n\n";
	exit;
}

open IN,"$ARGV[2]"or die "can not open file\n"; 
my %key_hash;
my $v_2=$ARGV[4];
my $num_N=$ARGV[5];
#my $case=$ARGV[5];
while(<IN>)
{
    if(!/^#/)
    {
	chomp;
	my @info=split(/\t/);
	if($v_2 ne "a")
	{
     		my @a_colum=split(/,/,$v_2);
     		my $add_info;
     		foreach my $item (@a_colum)
     		{
        		$add_info.=$info[$item]."\t";
     		}

     		if(!exists $key_hash{$info[$ARGV[3]]})
     		{
       			 $key_hash{$info[$ARGV[3]]}=$add_info;
     		}

	}
	else
	{$key_hash{$info[$ARGV[3]]}=$_;}
    	#print $info[$ARGV[3]],"\t",$info[$ARGV[4]],"\n";
	}
}
close IN;
open IN ,"$ARGV[0]" or die "can  not open file\n\n";
while(<IN>)
{
 	chomp;
	my @info=split;
    #print $info[$ARGV[1]],"\n";

#    print $key_hash{$info[$ARGV[1]]},"\n";
	if(exists($key_hash{$info[$ARGV[1]]}))
	{	
		print $_,"\t",$key_hash{$info[$ARGV[1]]},"\n";
		
	}
	else
	{
		
		print $_;	
		if($num_N)
		{
			for (my $i=1;$i<=$num_N;$i++)
			{	
				print "\t", "-";
			}
		}
		print "\n";
	}
}
close IN;
