#!/usr/bin/perl 
sub usage (){
	die qq(
#===============================================================================
#
#        USAGE:  ./sel_sam.pl <Input File> <Field number> <Prefix_out> <List_file> 
# 
#  DESCRIPTION:  Split sam file according chromosome [for too large to sort\]
#		Field number start from 1 
#		If your file for split is too large,it is suggested to give a file containing all list
#		File format are: chr1\\nchr2\\nchr3 chr4 chr5 etc
#			
#       Input_file and field_number is required. Prefix default "x"			
#
#       AUTHOR:  Wang yu , wangyu.big\@gmail.com
#      COMPANY:  BIG.CAS
#      CREATED:  08/28/2009 03:52:35 PM
#===============================================================================

		  )
}
use strict;
use warnings;
$ARGV[1]|| &usage();
$ARGV[2]||($ARGV[2]="x");
use FileHandle;
my %handle;
my @name;

if ($ARGV[3]){
	open IN, $ARGV[3];
	while(my $line=<IN>){
		chomp $line;
		my @a = split/\s+/,$line;
		push (@name,@a);
	}
	close IN;
}

else {
@name=`cut -f$ARGV[1] $ARGV[0]|/share/disk6-4/wuzhy/wangy/bin/statis_uniq.pl|cut -f1`;
}
chomp @name;

for my $n (@name){  # open file handle
	my $a;
	$ARGV[2] ? ($a.=$ARGV[2]."_".$n) : ($a=$n);
	my $fh = FileHandle->new(">$a");
	$handle{$n}= $fh;
}
#print Dumper(%handle);
open IN2,$ARGV[0];
while(<IN2>){
	chomp;
	my @a=split(/\t/,$_);
	#print $_,"\n";
	#print $_[0],"\n";	
	#print $_[1],"\n";
    my $fh = $handle{$a[$ARGV[1]-1]};
    if($fh)
    {
    #print $_,"\n";
    #print $a[$ARGV[1]-1],"\n";
    print $fh ($_,"\n");
    }
    else
    {
        print $a[$ARGV[1]-1],"\n";
    }


}

