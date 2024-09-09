#!/usr/bin/env perl
use warnings;

$f = $ARGV[0] //= 'make.texi';
open $fh, '<', $f or die $!;
mkdir 'makefiles' or die $1 unless -d 'makefiles';

LINE:
while (<$fh>) {
    if (/\@(?:\w)*example/) {
        while (<$fh>) {
            next LINE if /\@end .*example/;  # no `@group`s found
            if (/\@group/) {
                open $makefh, '>', sprintf("makefiles/%05d.mk", $.);
                print $makefh "\n## example $.\n";
                GROUP:
                while (<$fh>) {
                    # next if /^#/;
                    next GROUP if /\@(end )?group/;
                    next LINE if /\@end .*example/;
                    s/@@/@/g;  # texinfo directives
                    print $makefh $_;
                }
            }
        }
    }
}
