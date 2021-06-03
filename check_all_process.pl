#!/usr/bin/perl
# Created by Leonardo Berbert Gomes
# E-mail: leo4berbert@gmail.com
# Version: 1.0
# Date: 07-Oct-2013
# Description: Verifying that all system processes are running.


## Loading Config

open CONFIG, "/home/oracle/Config" or die $!; ## Change by the file containing the name all the processes to be monitored.

while (my $line = <CONFIG>) {
        chomp $line;

if ($line =~ /^#/) {next}
                $process_all = $line;
                $hash_process{"$process_all"}++;
        }


close CONFIG;

system ("clear");

check_proc();

my $parse_currentdate = get_date();
my @t_date = $parse_currentdate =~ /([0-9]{4})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})/;
my $ncols = `tput cols`;
my @text = ('System Process Status Report','Process Status');
print "=" x $ncols; print "\n";
print " " x int(($ncols - length $text[0])/2),$text[0]; print "\n";
print "=" x $ncols; print "\n";
printf "%-10s: %4s-%02s-%02s - %02s:%02s:%02s\n",'DATE',$t_date[0],$t_date[1],$t_date[2],$t_date[3],$t_date[4],$t_date[5];
printf "%-10s: %05s\n",'HOSTNAME',$host;
printf "%-10s: %5s - %7s\n",'OS Version',$osname,$osrel;
print "=" x $ncols; print "\n";
print " " x int(($ncols - length $text[1])/2),$text[1]; print "\n";
print "=" x $ncols; print "\n";
print "-" x $ncols; print "\n";

sub get_date {

    my ($opt) = shift;
    my ($current_date);
    my ($sec,$min,$hour,$day,$month,$year) = (localtime(time))[0,1,2,3,4,5]; $month +=1;$year +=1900;
    if ($day =~ /^\d$/) { $day = "0" . $day;}
    if ($min =~ /^\d$/) { $min = "0" . $min;}
    if ($sec =~ /^\d$/) { $sec = "0" . $sec;}
    if ($hour =~ /^\d$/) { $hour = "0" . $hour;}
    if ($month =~ /^\d$/) { $month = "0" . $month;}

    if ($opt) {
        if ($opt eq 1) {
            $current_date = "$day$month $hour$min$sec";
            return $current_date;
        }
        elsif ($opt eq 2) {
            $current_date = "$day$month$year";
            return $current_date;
        }
        elsif ($opt eq 3) {
            $current_date = "$year$month$day";
            return $current_date;
        }
        elsif ($opt eq 4) {
            $day--;
            $current_date = "$year$month$day";
            return $current_date;
        }

    } else {
        my $date = "$year$month$day$hour$min$sec";
        return $date;
    }
}

sub check_proc {
    $host = `hostname`;
    chomp($host);
    $osname = `uname -s`;
    $osrel = `uname -r`;
    chomp($osname); chomp($osrel);
}


foreach my $key ( sort keys %hash_process) {
        my $ps = `ps -ef \| grep \"$key\" \| grep -v \"grep" \| wc -l`;
        chomp $ps;
                if ($ps eq 1){
                printf("Process: %-23.25s | Running: %4s | %4s Status: [OK]\n", $key, $ps);
                } else {
                printf("Process: %-23.25s | Running: %4s | %4s Status: [FAILED]\n", $key, $ps);
                }

}
