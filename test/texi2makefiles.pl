#!/usr/bin/env perl
use warnings;

$f = $ARGV[0] //= 'make.texi';
$d = $ARGV[1] //= 'makefiles';
open $fh, '<', $f or die $!;
mkdir $d or die $1 unless -d $d;

LINE:
while (<$fh>) {
    if (/\@(?:\w)*example/) {
        while (<$fh>) {
            next LINE if /\@end .*example/;  # no `@group`s found
            if (/\@group/) {
                open $makefh, '>', sprintf("makefiles/%05d.mk", $.);
                print $makefh "## $f line $.\n";
                GROUP:
                while (<$fh>) {
                    next LINE if /\@end .*example/;
                    next GROUP if /\@(end )?group/;
                    next GROUP if /.*\@(var|dots)/;  # texinfo directives
                    # next if /^#/;
                    s/@@/@/g;                        # escaped @'s
                    s/^ {8}/\t/;                     # hopefully make valid
                    print $makefh $_;
                }
            }
        }
    }
}
