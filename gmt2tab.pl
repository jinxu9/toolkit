# !/usr/bin/perl

=head

# this script is mainly used to change gmt file format to tab format for Genomica

=cut


#@files = ("c1.all.v2.5.symbols.gmt.txt", "c2.genmapp.v2.5.symbols.gmt.txt", "c4.all.v2.5.symbols.gmt.txt", "c5.cc.v2.5.symbols.gmt.txt", "c2.all.v2.5.symbols.gmt.txt", "c2.kegg.v2.5.symbols.gmt.txt", "c4.cgn.v2.5.symbols.gmt.txt", "c5.mf.v2.5.symbols.gmt.txt", "c2.biocarta.v2.5.symbols.gmt.txt", "c3.all.v2.5.symbols.gmt.txt", "c4.cm.v2.5.symbols.gmt.txt", "msigdb.v2.5.symbols.gmt.txt", "c2.cgp.v2.5.symbols.gmt.txt", "c3.mir.v2.5.symbols.gmt.txt", "c5.all.v2.5.symbols.gmt.txt", "c2.cp.v2.5.symbols.gmt.txt", "c3.tft.v2.5.symbols.gmt.txt", "c5.bp.v2.5.symbols.gmt.txt");

#@files = ("new.gmt");
@files = ("c5.all.v3.0.symbols.gmt.txt");
$outfile = "c5.all.v3.0.symbols.gmt.tab";

foreach $file (@files) {
  open (in, "<$file");
  while ($line=<in>) {
    chomp $line;
    @data = split /\t/, $line;
    $geneset = uc($data[0]);
    push (@genesets, $geneset);
    for ($j=2; $j<=$#data; $j++) {
      $data[$j]=uc($data[$j]);
      $flag{$geneset}{$data[$j]} = 1;
      push (@genes, $data[$j]);
    }
  }
  close in;
}



undef %saw;
@unique_genesets = grep (!$saw{$_}++, @genesets);

undef %saw;
@unique_genes = grep (!$saw{$_}++, @genes);

open (out, ">$outfile");
print out "Gene";
foreach $geneset (@unique_genesets) {
  print out "\t$geneset";
}
print out "\n";

foreach $gene (@unique_genes) {
  print out "$gene";
  foreach $geneset (@unique_genesets) {
    if ($flag{$geneset}{$gene}) {
      print out "\t1";
    }
    else {
      print out "\t0";
    }
  }
  print out "\n";
}

close out;


